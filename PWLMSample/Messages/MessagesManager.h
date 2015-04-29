//
//  MessagesManager.h
//  PWLPSample
//
//  Created by Xiangwei Wang on 4/7/15.
//  Copyright (c) 2015 Phunware Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessagesManager : NSObject

+ (MessagesManager*)sharedManager;

/**
 Refresh the badge counter on app icon and message tab in Tabbar
 */
- (void)refreshBadgeCounter;

/**
 Get the 'read' messages only from a list of messages
 @param messages The message to filter from
 */
- (NSArray*)getReadMessagesFrom:(NSArray*)messages;

/**
 Get the 'unread' messages only from a list of messages
 @param messages The message to filter from
 */
- (NSArray*)getUnreadMessagesFrom:(NSArray*)messages;

/**
 Get the 'unexpired' messages only from a list of messages
 @param messages The message to filter from
 */
- (NSArray*)getUnexpiredMessagesFrom:(NSArray*)messages;

/**
 Get the 'expired' messages only from a list of messages
 @param messages The message to filter from
 */
- (NSArray*)getExpiredMessagesFrom:(NSArray*)messages;

@end
