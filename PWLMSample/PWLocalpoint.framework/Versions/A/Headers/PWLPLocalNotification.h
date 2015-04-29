//
//  PWLPLocalNotification.h
//  PWLocalpoint
//
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PWLPZoneMessage.h"

extern NSString *const PWLPLocalNotificationSendNotification;

// UserInfo dictionary keys
extern NSString *const PWLPLocalNotificationUserInfoMessageIdentifierKey;
extern NSString *const PWLPLocalNotificationUserInfoCampaignTypeKey;

/**
 * A PWLPLocalNotification object holds the information related to a local notification that will be shown to the user. The PWLPLocalNotification object allows the alert title and alert body to be modified if needed.
 */
@interface PWLPLocalNotification : NSObject

/**
 Returns the title of the local notification.
 @discussion This method should never return `nil`.
 @return The title of this local notification.
 */
@property (copy) NSString *alertTitle;

/**
 Returns the alert body of the local notification.
 @discussion This method should never return `nil`.
 @return The message of this local notification.
 */
@property (copy) NSString *alertBody;

/**
 The zone message associated with the local notification.
 @return The zone message associated with the local notification.
 */
@property (readonly) PWLPZoneMessage *message;

@end
