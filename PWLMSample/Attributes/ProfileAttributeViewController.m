//
//  ProfileAttributeViewController.m
//  PWLPSample
//
//  Created by Xiangwei Wang on 4/8/15.
//  Copyright (c) 2015 Phunware Inc. All rights reserved.
//

#import <PWLocalpoint/PWLocalpoint.h>

#import "ProfileAttributeViewController.h"
#import "AttributeTableViewCell.h"
#import "SampleDefines.h"
#import "PubUtils.h"

// Nib name of table view cell
static NSString *const AttributeTableViewTextfieldCellNibName = @"AttributeTableViewTextFieldCell";
static NSString *const AttributeTableViewSegmentCellNibName = @"AttributeTableViewSegmentCell";

// JSON keys for attribute payload
static NSString *const AttributeNameJSONKey = @"name";
static NSString *const AttributeValueJSONKey = @"allowedValues";
static NSString *const AttributeValueTypeJSONKey = @"attributeType";
static NSString *const AttributeValueTypeEnum = @"enum";

@interface ProfileAttributeViewController()

@end

@implementation ProfileAttributeViewController

#pragma mark - View controller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register table view cell for reusable
    [self.tableView registerClass:[AttributeTableViewCell class] forCellReuseIdentifier:ProfileAttributeTableViewTextfieldCellIdentifier];
    [self.tableView registerClass:[AttributeTableViewCell class] forCellReuseIdentifier:ProfileAttributeTableViewSegmentCellIdentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:AttributeTableViewTextfieldCellNibName bundle:nil]
         forCellReuseIdentifier:ProfileAttributeTableViewTextfieldCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:AttributeTableViewSegmentCellNibName bundle:nil]
         forCellReuseIdentifier:ProfileAttributeTableViewSegmentCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Fetch attribute metadata
    [self fetchProfileAttrbuteMetadata];
}

#pragma mark - Convenience

/**
 Fetch all profile attribute metadata
 */
- (void)fetchProfileAttrbuteMetadata {
    __weak ProfileAttributeViewController *weakSelf = self;
    // Show loading indicator when start to fetch
    [PubUtils showLoading];
    [[PWLPAttributeManager sharedManager] fetchProfileAttributeMetadataWithCompletion:^(NSArray *attributes, NSError *error) {
        if (error) {
            [PubUtils displayError:error];
        } else {
            self.attributes = attributes;
            // To fetch the profile attributes after attribute metadata is completely fetched
            [weakSelf fetchProfileAttributesForDevice];
        }
    }];
}

/**
 Fetch the profile attributes for device
 */
- (void)fetchProfileAttributesForDevice {
    __weak ProfileAttributeViewController *weakSelf = self;
    [[PWLPAttributeManager sharedManager] fetchProfileAttributesWithCompletion:^(NSDictionary *attributes, NSError *error) {
        if (error) {
            [PubUtils displayError:error];
        } else {
            weakSelf.userAttributes = attributes;
            [weakSelf reloadTableViewForProfileAttributes:attributes];
        }
    }];
}

/**
 Reload table view for refreshing profile attributes
 */
- (void)reloadTableViewForProfileAttributes:(NSDictionary*)attributes {
    dispatch_async(dispatch_get_main_queue(), ^{
        // Hide loading indicator after attributes are completely fetched.
        [PubUtils dismissLoading];
        [self.tableView reloadData];
    });
}

#pragma mark - Interface action

/**
 Save the profile attrbutes for custom
 */
- (IBAction)save:(id)sender {
    NSMutableDictionary *updateAttributes = [NSMutableDictionary new];
    
    // Extract the attribute values from the textfield or segment control
    NSInteger row = 0;
    for (NSDictionary *attribute in self.attributes) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row++ inSection:0];
        AttributeTableViewCell *cell = (AttributeTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        NSString *value = cell.value.text;
        if ([self isEnumAttributeAtIndexPath:indexPath]) {
            NSArray *array = attribute[AttributeValueJSONKey];
            value = [array objectAtIndex:cell.segment.selectedSegmentIndex];
        }
        [updateAttributes addEntriesFromDictionary:@{attribute[AttributeNameJSONKey]:value}];
    }
    
    // Save them
    [PubUtils showLoading];
    [[PWLPAttributeManager sharedManager] updateProfileAttributes:updateAttributes completion:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [PubUtils displayError:error];
            } else {
                [PubUtils dismissLoading];
            }
        });
    }];
}

#pragma mark - UITableView delegate / datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AttributeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileAttributeTableViewTextfieldCellIdentifier];
    if ([self isEnumAttributeAtIndexPath:indexPath]) {
        cell = [tableView dequeueReusableCellWithIdentifier:ProfileAttributeTableViewSegmentCellIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *attribute = [self.attributes objectAtIndex:indexPath.row];
    NSString *attributeValue = self.userAttributes[attribute[AttributeNameJSONKey]];
    ((AttributeTableViewCell*)cell).name.text = attribute[AttributeNameJSONKey];
    
    if ([self isEnumAttributeAtIndexPath:indexPath]) {
        for (UIView *view in cell.subviews) {
            if ([view isKindOfClass:[UISegmentedControl class]]) {
                [view removeFromSuperview];
            }
        }
        
        AttributeTableViewCell *thisCell = (AttributeTableViewCell*)cell;
        UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:attribute[AttributeValueJSONKey]];
        [segment setTranslatesAutoresizingMaskIntoConstraints:NO];
        if (attributeValue) {
            segment.selectedSegmentIndex = [attribute[AttributeValueJSONKey] indexOfObject:attributeValue];
        }
        [thisCell addSubview:segment];
        NSLayoutConstraint *constraitCenterY = [NSLayoutConstraint constraintWithItem:segment
                                                                            attribute:NSLayoutAttributeCenterY
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:thisCell
                                                                            attribute:NSLayoutAttributeCenterY
                                                                           multiplier:1
                                                                             constant:10];
        NSLayoutConstraint *constraitCenterX = [NSLayoutConstraint constraintWithItem:segment
                                                                            attribute:NSLayoutAttributeLeading
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:thisCell
                                                                            attribute:NSLayoutAttributeLeading
                                                                           multiplier:1
                                                                             constant:2];
        
        NSArray *constraints = @[constraitCenterY, constraitCenterX];
        
        [thisCell addConstraints:constraints];
        
    } else {
        ((AttributeTableViewCell*)cell).value.text = attributeValue;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.attributes.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

#pragma mark - Helper methods

/**
 Check if the profile attribute has enum values
 */
- (BOOL)isEnumAttributeAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *attribute = [self.attributes objectAtIndex:indexPath.row];
    NSString *type = attribute[AttributeValueTypeJSONKey];
    if ([type.lowercaseString isEqualToString:AttributeValueTypeEnum]) {
        return YES;
    } else {
        return NO;
    }
}

@end
