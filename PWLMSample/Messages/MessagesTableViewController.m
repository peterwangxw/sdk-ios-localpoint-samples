//
//  MessagesTableViewController.m
//  PWLPSample
//
//  Created by Xiangwei Wang on 4/7/15.
//  Copyright (c) 2015 Phunware Inc. All rights reserved.
//

#import <PWLocalpoint/PWLocalpoint.h>

#import "MessagesTableViewController.h"
#import "MessageDetailViewController.h"
#import "MessagesManager.h"
#import "SampleDefines.h"
#import "PubUtils.h"

@interface MessagesTableViewController()

@end

@implementation MessagesTableViewController

#pragma mark - View controller

-(void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // Set up messages to display
    self.messages = [PWLPZoneMessageManager sharedManager].messages;
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Add message detail view controller to display message details
    MessageDetailViewController *nextViewController = segue.destinationViewController;
    nextViewController.message = self.messages[[self.tableView indexPathForSelectedRow].row];
}

#pragma mark - UITableView delegate / dataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MessageTableViewCellIdentifier forIndexPath:indexPath];
    PWLPZoneMessage *message = [self.messages objectAtIndex:indexPath.row];
    
    cell.textLabel.text = message.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"ID: %@", message.identifier];
    
    // Use different text color to distinguish message is expired or not
    if ([message.expirationDate timeIntervalSinceNow] < 0) {
        cell.textLabel.textColor = [UIColor lightGrayColor];
    } else {
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    // User different font size to distinguish message is read or not
    if (message.isRead) {
        cell.textLabel.font = [UIFont italicSystemFontOfSize:[UIFont systemFontSize]-1];
    } else {
        cell.textLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messages.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - Actions

/**
 Filter the messages
 */
- (IBAction)segmentSelector:(id)sender {
    UISegmentedControl *segment = sender;
    if(segment.selectedSegmentIndex == 0) {
        self.messages = [PWLPZoneMessageManager sharedManager].messages;
    } else if(segment.selectedSegmentIndex == 1) {
        self.messages = [[MessagesManager sharedManager] getUnreadMessagesFrom:[PWLPZoneMessageManager sharedManager].messages];
    } else if(segment.selectedSegmentIndex == 2) {
        self.messages = [[MessagesManager sharedManager] getReadMessagesFrom:[PWLPZoneMessageManager sharedManager].messages];
    } else if(segment.selectedSegmentIndex == 3) {
        self.messages = [[MessagesManager sharedManager] getUnexpiredMessagesFrom:[PWLPZoneMessageManager sharedManager].messages];
    } else if(segment.selectedSegmentIndex == 4) {
        self.messages = [[MessagesManager sharedManager] getExpiredMessagesFrom:[PWLPZoneMessageManager sharedManager].messages];
    }
    [self.tableView reloadData];
}

@end
