//
//  MessagesManager.m
//  PWLPSample
//
//  Created by Xiangwei Wang on 4/7/15.
//  Copyright (c) 2015 Phunware Inc. All rights reserved.
//

#import <PWLocalpoint/PWLocalpoint.h>
#import "MessagesManager.h"
#import "MessagesTableViewController.h"

@implementation MessagesManager

+ (MessagesManager*)sharedManager {
    static MessagesManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [MessagesManager new];
    });
    
    return manager;
}

- (void)refreshBadgeCounter {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *messages = [PWLPZoneMessageManager sharedManager].messages;
        NSInteger unreadMessageCount = [[self getUnreadMessagesFrom:messages] count];
        // Set app icon
        [UIApplication sharedApplication].applicationIconBadgeNumber = unreadMessageCount;

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
            if ([tabRootController isKindOfClass:[MessagesTableViewController class]]) {
                // It's message list view controller, it's to `push` a message detail view controller
                UITabBarItem *barItem = tabBarController.tabBar.items[idx];
                if (unreadMessageCount == 0) {
                    barItem.badgeValue = nil;
                } else {
                    barItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)unreadMessageCount];
                }
            }
        }];
    });
}

- (NSArray*)getReadMessagesFrom:(NSArray*)messages {
    NSMutableArray *newMessages = [NSMutableArray new];
    if (!messages || messages.count == 0) {
        return newMessages;
    }
    
    for (PWLPZoneMessage *message in messages) {
        if (message.isRead) {
            [newMessages addObject:message];
        }
    }
    
    return newMessages;
}

- (NSArray*)getUnreadMessagesFrom:(NSArray*)messages {
    NSMutableArray *newMessages = [NSMutableArray new];
    if (!messages || messages.count == 0) {
        return newMessages;
    }
    
    for (PWLPZoneMessage *message in messages) {
        if (!message.isRead) {
            [newMessages addObject:message];
        }
    }
    
    return newMessages;
}

- (NSArray*)getUnexpiredMessagesFrom:(NSArray*)messages {
    NSMutableArray *newMessages = [NSMutableArray new];
    if (!messages || messages.count == 0) {
        return newMessages;
    }
    
    for (PWLPZoneMessage *message in messages) {
        if ([message.expirationDate timeIntervalSinceNow] > 0) {
            [newMessages addObject:message];
        }
    }
    
    return newMessages;
}

- (NSArray*)getExpiredMessagesFrom:(NSArray*)messages {
    NSMutableArray *newMessages = [NSMutableArray new];
    if (!messages || messages.count == 0) {
        return newMessages;
    }
    
    for (PWLPZoneMessage *message in messages) {
        if ([message.expirationDate timeIntervalSinceNow] < 0) {
            [newMessages addObject:message];
        }
    }
    
    return newMessages;
}

@end
