//
//  ProfileAttributeViewController.h
//  PWLocalpoint
//
//  Created by Xiangwei Wang on 4/8/15.
//  Copyright (c) 2015 Phunware Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString *const ProfileAttributeTableViewTextfieldCellIdentifier = @"ProfileAttributeTableViewTextfieldCellIdentifier";
static NSString *const ProfileAttributeTableViewSegmentCellIdentifier = @"ProfileAttributeTableViewSegmentCellIdentifier";

@interface ProfileAttributeViewController : UITableViewController

#pragma mark - Properties

/**
 All the profile attributes with metadata
 */
@property (nonatomic) NSArray *attributes;

/**
 The profile attribute/value pairs related to the device
 */
@property (nonatomic) NSDictionary *userAttributes;

#pragma mark - Interface action

/**
 Save profile attributes
 */
- (IBAction)save:(id)sender;

@end
