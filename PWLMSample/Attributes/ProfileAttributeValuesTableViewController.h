//
//  ProfileAttributeValuesTableViewController.h
//  PWLocalpoint
//
//  Created by Xiangwei Wang on 4/24/15.
//  Copyright (c) 2015 Phunware Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const ProfileAttributeValuesTableViewControllerCellIdentifier = @"ProfileAttributeValuesTableViewControllerCellIdentifier";

@interface ProfileAttributeValuesTableViewController : UITableViewController

- (void)setContentForName:(NSString*)name withValues:(NSArray*)values withSelection:(NSString*)selection;

@end
