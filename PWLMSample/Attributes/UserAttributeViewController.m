//
//  UserAttributeViewController.m
//  PWLocalpoint
//
//  Created by Xiangwei Wang on 4/8/15.
//  Copyright (c) 2015 Phunware Inc. All rights reserved.
//

#import <PWLocalpoint/PWLocalpoint.h>

#import "UserAttributeViewController.h"
#import "AttributeTableViewCell.h"
#import "SampleDefines.h"
#import "PubUtils.h"

static NSString *const AttributeTableViewCellNibName = @"AttributeTableViewTextFieldCell";
static NSString *const CustomIdentifierName = @"ID1";

// Messages
static NSString *const CustomIDInvalid = @"Please make sure you have provided valid custom identifier";

@interface UserAttributeViewController()

@end

@implementation UserAttributeViewController

#pragma mark - View controller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:AttributeTableViewCellNibName bundle:nil]
         forCellReuseIdentifier:UserAttributeTableViewCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.attributes = @{CustomIdentifierName:EmptyString};
    [self.tableView reloadData];
    
    // Fetch custom identifer
    [PubUtils showLoading];
    [[PWLPAttributeManager sharedManager] fetchCustomIdentifierWithCompletion:^(NSString *identifier, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [PubUtils dismissLoading];
            if (error) {
                [PubUtils displayError:error];
            } else {
                // Set the custom identifier
                AttributeTableViewCell *cell = [self.tableView visibleCells].firstObject;
                cell.value.text = identifier?:EmptyString;
            }
        });
    }];
}

#pragma mark - Actions

/**
 Save custom identifier
 */
- (IBAction)save:(id)sender {
    AttributeTableViewCell *cell = [self.tableView visibleCells].firstObject;
    [cell.value resignFirstResponder];
    NSString *customId = cell.value.text;
    if (!customId || [customId stringByReplacingOccurrencesOfString:BlankString withString:EmptyString].length == 0) {
        // Save it only when it's valid
        [PubUtils displayWarning:CustomIDInvalid];
    } else {
        // Save custom identifier
        [PubUtils showLoading];
        [[PWLPAttributeManager sharedManager] updateCustomIdentifier:customId completion:^(NSError *error) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [PubUtils dismissLoading];
                if (error) {
                    [PubUtils displayError:error];
                }
            }];
        }];
    }
}

#pragma mark - UITableView delegate / datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:UserAttributeTableViewCellIdentifier];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    for (NSString *name in self.attributes.allKeys) {
        ((AttributeTableViewCell*)cell).name.text = name;
        ((AttributeTableViewCell*)cell).value.text = self.attributes[name];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.attributes.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

@end
