//
//  DismissSeque.m
//  PWLocalpoint
//
//  Created by Illya Busigin on 4/29/15.
//  Copyright (c) 2015 Phunware Inc. All rights reserved.
//

#import "DismissSegue.h"

@implementation DismissSegue

- (void)perform {
    [self.sourceViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
