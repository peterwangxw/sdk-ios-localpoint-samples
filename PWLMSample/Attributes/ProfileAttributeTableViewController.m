//
//  ProfileAttributeTableViewController.m
//  PWLPSample
//
//  Created by Xiangwei Wang on 4/24/15.
//  Copyright (c) 2015 Phunware Inc. All rights reserved.
//

#import <PWLocalpoint/PWLocalpoint.h>

#import "ProfileAttributeTableViewController.h"
#import "ProfileAttributeValuesTableViewController.h"
#import "AttributeTableViewCell.h"
#import "SampleDefines.h"
#import "PubUtils.h"

static NSString *const ProfileAttributeNameJSONKey = @"name";
static NSString *const ProfileAttributeValueJSONKey = @"allowedValues";

@interface ProfileAttributeTableViewController ()

/**
 All the profile attributes with metadata
 */
@property (nonatomic, strong) NSArray *attributes;

/**
 The profile attribute/value pairs related to the device
 */
@property (nonatomic, strong) NSMutableDictionary *userAttributes;

@end

#pragma mark - UIViewController

@implementation ProfileAttributeTableViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchProfileAttrbuteMetadata];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]];
    
    ProfileAttributeValuesTableViewController *nextViewController = segue.destinationViewController;
    NSDictionary *attribute = self.attributes[[self.tableView indexPathForSelectedRow].row];
    
    [nextViewController setContentForName:attribute[ProfileAttributeNameJSONKey]
                               withValues:attribute[ProfileAttributeValueJSONKey]
                            withSelection:selectedCell.detailTextLabel.text];
}

#pragma mark - Convenience

/**
 Fetch all profile attribute metadata
 */
- (void)fetchProfileAttrbuteMetadata {
    // Show loading indicator when start to fetch
    [PubUtils showLoading];
    [[PWLPAttributeManager sharedManager] fetchProfileAttributeMetadataWithCompletion:^(NSArray *attributes, NSError *error) {
        if (error) {
            [PubUtils displayError:error];
        } else {
            self.attributes = attributes;
            [self fetchProfileAttributesForDevice];
        }
    }];
}

/**
 Fetch the profile attributes for device
 */
- (void)fetchProfileAttributesForDevice {
    [[PWLPAttributeManager sharedManager] fetchProfileAttributesWithCompletion:^(NSDictionary *attributes, NSError *error) {
        if (error) {
            [PubUtils displayError:error];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                // Hide loading indicator after attributes are completely fetched.
                [PubUtils dismissLoading];
                self.userAttributes = [NSMutableDictionary dictionaryWithDictionary:attributes];
                [self.tableView reloadData];
            });
        }
    }];
}

#pragma mark - Actions

- (IBAction)saveProfileAttribute:(id)sender {
    // Save them
    [PubUtils showLoading];
    [[PWLPAttributeManager sharedManager] updateProfileAttributes:self.userAttributes completion:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [PubUtils displayError:error];
            } else {
                [PubUtils dismissLoading];
            }
        });
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.attributes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileAttributeTableViewControllerCellIdentifier forIndexPath:indexPath];
    NSDictionary *attribute = self.attributes[indexPath.row];
    NSString *name = attribute[ProfileAttributeNameJSONKey];
    NSString *value = self.userAttributes[name]?:@"";
    
    cell.textLabel.text = name;
    if (value) {
        cell.detailTextLabel.text = value;
    }
    
    return cell;
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
    dispatch_async(dispatch_get_main_queue(), ^{
        ProfileAttributeValuesTableViewController *sourceViewController = segue.sourceViewController;
        UITableViewCell *cell = [sourceViewController.tableView cellForRowAtIndexPath:[sourceViewController.tableView indexPathForSelectedRow]];
        NSString *attributeName = sourceViewController.navigationItem.title;
        NSString *attributeValue = cell.textLabel.text;
        [self.userAttributes setValue:attributeValue forKey:attributeName];
        
        [self.tableView reloadData];
    });
}

@end
