//
//  LPMessageListener.m
//  PWLPSample
//
//  Created by Xiangwei Wang on 4/20/15.
//  Copyright (c) 2015 Phunware Inc. All rights reserved.
//

#import <PWLocalpoint/PWLocalpoint.h>

#import "LPMessageListener.h"
#import "AppInfoViewController.h"
#import "MessagesManager.h"
#import "PubUtils.h"

@interface LPMessageListener()

@end

@implementation LPMessageListener

#pragma mark - Public methods

- (void)startListening {
    // Register for event notification of adding message
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMessageNotification:) name:PWLPZoneMessageManagerDidReceiveMessageNotification object:nil];
    
    // Register for event notification of updating message
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didModifyMessageNotification:) name:PWLPZoneMessageManagerDidModifyMessageNotification object:nil];
    
    // Register for event notification of deleting message
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDeleteMessageNotification:) name:PWLPZoneMessageManagerDidDeleteMessageNotification object:nil];
    
    // Register for event notification of reading message
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReadMessageNotification:) name:PWLPZoneMessageManagerDidReadMessageNotification object:nil];
}

- (void)stopListening {
    // Unregister for event notification of adding message
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWLPZoneMessageManagerDidReceiveMessageNotification object:nil];
    
    // Unregister for event notification of updating message
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWLPZoneMessageManagerDidModifyMessageNotification object:nil];
    
    // Unregister for event notification of deleting message
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWLPZoneMessageManagerDidDeleteMessageNotification object:nil];
    
    // Unregister for event notification of reading message
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWLPZoneMessageManagerDidReadMessageNotification object:nil];
}

#pragma mark - Private methods

/**
 The selector to handle notification when a new message is added
 @param notification A object of `NSNotification`
 */
- (void)didReceiveMessageNotification:(NSNotification*)notification {
    NSString *messageId = [[PWLPZoneMessageManager sharedManager] parseMessageIdentifier:notification.userInfo];
    [[PWLPZoneMessageManager sharedManager] fetchMessageWithIdentifier:messageId completion:^(PWLPZoneMessage *message, NSError *error) {
        if (message) {
            // Update the info view controller
            [self refreshAppInfo];
            [[MessagesManager sharedManager] refreshBadgeCounter];
            // New adding message is fetched
            [PubUtils toast:[NSString stringWithFormat:@"Received message(ID: %@, title: %@)", message.identifier, message.title]];
        }
    }];
}

/**
 The selector to handle notification when a message is modified
 @param notification A object of `NSNotification`
 */
- (void)didModifyMessageNotification:(NSNotification*)notification {
    NSString *messageId = [[PWLPZoneMessageManager sharedManager] parseMessageIdentifier:notification.userInfo];
    [[PWLPZoneMessageManager sharedManager] fetchMessageWithIdentifier:messageId completion:^(PWLPZoneMessage *message, NSError *error) {
        if (message) {
            // Update the info view controller
            [self refreshAppInfo];
            [[MessagesManager sharedManager] refreshBadgeCounter];
            // Modified message is fetched
            [PubUtils toast:[NSString stringWithFormat:@"Modified message(ID: %@, title: %@)", message.identifier, message.title]];
        }
    }];
}

/**
 The selector to handle notification when a message is removed
 @param notification A object of `NSNotification`
 */
- (void)didDeleteMessageNotification:(NSNotification*)notification {
    // Update the info view controller
    [self refreshAppInfo];
    // Deleted message identifier
    [[MessagesManager sharedManager] refreshBadgeCounter];
    NSString *messageId = [[PWLPZoneMessageManager sharedManager] parseMessageIdentifier:notification.userInfo];
    [PubUtils toast:[@"Removed messageId: " stringByAppendingString:messageId]];
}

/**
 The selector to handle notification when a message is removed
 @param notification A object of `NSNotification`
 */
- (void)didReadMessageNotification:(NSNotification*)notification {
    NSString *messageId = [[PWLPZoneMessageManager sharedManager] parseMessageIdentifier:notification.userInfo];
    [[PWLPZoneMessageManager sharedManager] fetchMessageWithIdentifier:messageId completion:^(PWLPZoneMessage *message, NSError *error) {
        if (message) {
            [[MessagesManager sharedManager] refreshBadgeCounter];
            // Modified message is fetched
            [PubUtils toast:[NSString stringWithFormat:@"Read message(ID: %@, title: %@)", message.identifier, message.title]];
        }
    }];
}

/**
 Refresh app infor view controller
 */
- (void)refreshAppInfo {
    dispatch_async(dispatch_get_main_queue(), ^{
        // Set for tabbar item
        UIWindow *currentWindow = [[UIApplication sharedApplication].windows firstObject];
        UITabBarController *tabBarController = (UITabBarController *)currentWindow.rootViewController;
        [tabBarController.viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIViewController *controller = obj;
            UIViewController *tabRootController = nil;
            if ([controller isKindOfClass:[UINavigationController class]]) {
                tabRootController = [(UINavigationController*)controller viewControllers].firstObject;
            } else {
                tabRootController = controller;
            }
            
            // Check every visible view controller to find message list/detail view controller
            if ([tabRootController isKindOfClass:[AppInfoViewController class]]) {
                [(AppInfoViewController*)tabRootController updateUI];
            }
        }];
    });
}

- (void)dealloc {
    [self stopListening];
}

@end
