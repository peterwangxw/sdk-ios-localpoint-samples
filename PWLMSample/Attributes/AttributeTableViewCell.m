//
//  AttributeTableViewCell.m
//  PWLocalpoint
//
//  Created by Xiangwei Wang on 4/8/15.
//  Copyright (c) 2015 Phunware Inc. All rights reserved.
//

#import "AttributeTableViewCell.h"

@implementation AttributeTableViewCell

- (IBAction)doneEditing:(UITextField*)sender {
    [sender resignFirstResponder];
}

@end
