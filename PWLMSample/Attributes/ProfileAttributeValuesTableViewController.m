//
//  ProfileAttributeValuesTableViewController.m
//  PWLocalpoint
//
//  Created by Xiangwei Wang on 4/24/15.
//  Copyright (c) 2015 Phunware Inc. All rights reserved.
//

#import "ProfileAttributeValuesTableViewController.h"

@interface ProfileAttributeValuesTableViewController ()

@property (nonatomic) NSArray *allowedValues;
@property (nonatomic) NSString *selectedValue;

@end

@implementation ProfileAttributeValuesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Convenience

- (void)setContentForName:(NSString*)name withValues:(NSArray*)values withSelection:(NSString*)selection {
    self.navigationItem.title = name;
    self.allowedValues = values;
    self.selectedValue = selection;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.allowedValues count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileAttributeValuesTableViewControllerCellIdentifier forIndexPath:indexPath];
    NSString *value = self.allowedValues[indexPath.row];
    cell.textLabel.text = value;
    
    if ([value isEqualToString:self.selectedValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

@end
