//
//  UserAttributeViewController.h
//  PWLocalpoint
//
//  Created by Xiangwei Wang on 4/8/15.
//  Copyright (c) 2015 Phunware Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString *const UserAttributeTableViewCellIdentifier = @"UserAttributeTableViewCellIdentifier";

@interface UserAttributeViewController : UITableViewController

#pragma mark - Properties

/**
 User attribute which has only user identifier
 */
@property (nonatomic) NSDictionary *attributes;

#pragma mark - Interface action

/**
 Save custom identifer
 */
- (IBAction)save:(id)sender;

@end
