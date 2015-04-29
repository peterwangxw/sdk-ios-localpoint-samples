//
//  MessageDetailViewController.m
//  PWLocalpoint
//
//  Created by Xiangwei Wang on 4/7/15.
//  Copyright (c) 2015 Phunware Inc. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "PubUtils.h"

@interface MessageDetailViewController()

@end

@implementation MessageDetailViewController

#pragma mark - View controller

-(void)viewDidLoad {
    [super viewDidLoad];
    
    // Prepare message content to display on a UIWebView
    NSString *content = [NSString stringWithFormat:@"%@</br></br><hr>MessageID: %@</br>Title: %@</br>Expiration: %@</br>Type: %@</br>IsRead: %@</br>MetaData: %@",
                         self.message.body,
                         self.message.identifier,
                         self.message.title,
                         self.message.expirationDate,
                         self.message.campaignType,
                         self.message.isRead?@"YES":@"NO",
                         [self.message.metaData description]];
    
    [self.webView loadHTMLString:content baseURL:nil];
    
    // Check if it needs to send read message
    [self readMessage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - Actions

- (IBAction)deleteMessage:(UIBarButtonItem *)sender {
    // Delete message
    [[PWLPZoneMessageManager sharedManager] deleteMessage:self.message.identifier completion:^(NSError *error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (error) {
                [PubUtils displayError:error];
            } else {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }];
}

- (void)readMessage {
    // Don't do it again if it's already read
    if (!self.message.isRead) {
        // Tell message is read
        [[PWLPZoneMessageManager sharedManager] readMessage:self.message.identifier completion:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [PubUtils toast:@"Message read"];
                if (error) {
                    [PubUtils displayError:error];
                }
            });
        }];
    }
}

@end
