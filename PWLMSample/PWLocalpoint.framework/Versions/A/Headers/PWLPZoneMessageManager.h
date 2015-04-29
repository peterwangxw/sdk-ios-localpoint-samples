//
//  PWLocationMessageProvider.h
//  PWLocation
//
//  Created by Illya Busigin on 7/1/14.
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

@import Foundation;

@class PWLPZoneMessage;

@protocol PWLPZoneMessageManagerDelegate;

/**
 Post when there was new message arrived, and the identifer of the new message is included in the notification's userInfo dictionary.
 */
extern NSString *const PWLPZoneMessageManagerDidReceiveMessageNotification;

/**
 Post where there was a message removed, and the identifer of the removed message is included in the notification's userInfo dictionary.
 */
extern NSString *const PWLPZoneMessageManagerDidDeleteMessageNotification;

/**
 Post where there was a message modified, and the identifer of the modified message is included in the notification's userInfo dictionary.
 */
extern NSString *const PWLPZoneMessageManagerDidModifyMessageNotification;

/**
 Post where there was a message read, and the identifer of the read message is included in the notification's userInfo dictionary.
 */
extern NSString *const PWLPZoneMessageManagerDidReadMessageNotification;

/** 
 The associated message identifier key of user info of notification
 */
extern NSString *const PWLPZoneMessageManagerUserInfoIdentifierKey;

/**
 * A block that indicates when a message fetch is complete.
 * @param message The message that was fetched.
 * @param error An error object containing information about a problem that ocurred while fetching the message or `nil` if the results are retrieved successfully.
 */
typedef void (^PWLPFetchMessageBlock)(PWLPZoneMessage *message, NSError *error);

/**
 The `PWLPZoneMessageManager` class is the central point for managing messages delivered to your application. A zone message manager object provides support for the following message-related activities:
 
 - The manager can be queried for messages currently known to it.
 - The manager can notify its delegate or via notification when messages are added, deleted or modified.
 - The manager can mark a message as read.
 - The manager can delete a message.
 
 @discussion It's recommended to use the `sharedManager` instance.
 */
@interface PWLPZoneMessageManager : NSObject

/**
 Returns the shared instance of the `PWLPZoneMessageManager` class.
 @return The shared instance of the `PWLPZoneMessageManager` class.
 */
+ (instancetype)sharedManager;

/**
 All messages that currently reside on the device.
 @return All messages that currently reside on the device.
 
 @discussion Each message in this `NSArray` contains all the message information except the message body. To retrieve the message body, call `fetchMessageWithIdentifier:completion:`.
 */
@property (nonatomic, readonly) NSArray *messages;

/**
 The `PWLPZoneMessageManagerDelegate` protocol defines the methods used to receive message updates from a `PWLPZoneMessageManager` object.
 
 Upon receiving a successful location or heading update, use the result to update your user interface or perform other actions. If the location or heading could not be determined, you might want to stop updates for a short period of time and try again later. You can use the `stopUpdatingLocation`, `stopMonitoringSignificantLocationChanges`, `stopUpdatingHeading`, `stopMonitoringForRegion:` or `stopMonitoringVisits` methods of `CLLocationManager` to stop the various location services.
 
 The methods of your delegate object are called from the thread you started the corresponding location services from. That thread must itself have an active run loop like the one found in your application’s main thread.
 */
@property (nonatomic, weak) id<PWLPZoneMessageManagerDelegate> delegate;

/**
 Parses message identifiers from the dictionary of `launchOptions' or `userInfo'.
 @return A message identifier.
 @param dictionary A dictionary passed from `application:didFinishLaunchingWithOptions:`, `application:didReceiveLocalNotification:` or `application:didReceiveRemoteNotification:` of `UIApplicationDelegate`.
 */
- (NSString *)parseMessageIdentifier:(NSDictionary *)dictionary;

/**
 Fetches a message by message identifier.
 @discussion The block returns no value and takes the following parameters:
 @param identifier The identifier of the message to fetch.
 @param completion A block that will be executed when the fecth is complete.
 */
- (void)fetchMessageWithIdentifier:(NSString *)identifier completion:(PWLPFetchMessageBlock)completion;

/**
 Deletes a message by message identifier.
 @discussion The block returns no value and takes the following parameters:
 @param identifier The identifier of the message to delete.
 @param completion A block that will be executed when the deletion is complete.
 */
- (void)deleteMessage:(NSString *)identifier completion:(void (^)(NSError *error))completion;

/**
 Marks a message as read by message identifier.
 @discussion The block returns no value and takes the following parameters:
 @param identifier The identifier of the message to mark as read.
 @param completion A block that will be executed when the message is marked as read.
 */
- (void)readMessage:(NSString *)identifier completion:(void (^)(NSError *error))completion;

@end


/**
 The `PWLPZoneMessageManagerDelegate` protocol defines the methods used to receive message updates from a `PWLPZoneMessageManager` object.
 
 The methods of your delegate object are called from the main application thread.
 */
@protocol PWLPZoneMessageManagerDelegate <NSObject>

/**
 Tells the delegate that a new message is received.
 @param manager The message manager object that generated the receive event.
 @param message A message object with the new message information.
 @discussion Implementation of this method is optional but recommended.
 */
- (void)zoneMessageManager:(PWLPZoneMessageManager *)manager didReceiveMessage:(PWLPZoneMessage *)message;

/**
 Tells the delegate that a message is deleted.
 @param manager The message manager object that generated the delete event.
 @param message A message object with the deleted message information.
 @discussion Implementation of this method is optional but recommended.
 */
- (void)zoneMessageManager:(PWLPZoneMessageManager *)manager didDeleteMessage:(PWLPZoneMessage *)message;

/**
 Tells the delegate that a new message is modified.
 @param manager The message manager object that generated the modify event.
 @param message A message object with the modified message information.
 @discussion Implementation of this method is optional but recommended.
 */
- (void)zoneMessageManager:(PWLPZoneMessageManager *)manager didModifyMessage:(PWLPZoneMessage *)message;

@end
