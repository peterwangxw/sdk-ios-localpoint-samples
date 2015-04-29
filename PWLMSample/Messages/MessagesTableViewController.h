//
//  MessagesTableViewController.h
//  PWLPSample
//
//  Created by Xiangwei Wang on 4/7/15.
//  Copyright (c) 2015 Phunware Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Identifiers
static NSString *MessageTableViewCellIdentifier = @"MessageTableViewCellIdentifier";
static NSString *MessageDetailIdentifier = @"MessageDetailSegueIdentifier";

@interface MessagesTableViewController : UITableViewController

#pragma mark - Properties

/**
The messages
 */
@property (nonatomic) NSArray *messages;

/**
 Segment control for filter messages
 */
@property (nonatomic) IBOutlet UISegmentedControl *segment;

@end
