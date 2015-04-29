 //
//  PWLocation.h
//  PWLocation
//
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

@import Foundation;
@import UIKit;

#import <PWLocalpoint/PWLPZoneManagerProtocol.h>
#import <PWLocalpoint/PWLPZoneManagerDelegateProtocol.h>
#import <PWLocalpoint/PWLPZoneProtocol.h>
#import <PWLocalpoint/PWLPConfiguration.h>
#import <PWLocalpoint/PWLPGeoZone.h>
#import <PWLocalpoint/PWLPGeoZoneManager.h>
#import <PWLocalpoint/PWLPZoneMessage.h>
#import <PWLocalpoint/PWLPZoneMessageManager.h>
#import <PWLocalpoint/PWLPZoneEventManager.h>
#import <PWLocalpoint/PWLPZoneEventNotifications.h>
#import <PWLocalpoint/PWLPLocationManager.h>
#import <PWLocalpoint/PWLPLocalNotification.h>
#import <PWLocalpoint/PWLPAttributeManager.h>
#import <PWLocalpoint/PWLPVersion.h>
#import <PWLocalpoint/PWLPDevice.h>

@protocol PWLocalpointDelegate;

/**
 * The Location Marketing framework is a location and notification based system.
 *
 * The recommended way to start Location Marketing in your application is to place a call
 * to `+startWithZoneManagers:` in your `-application:didFinishLaunchingWithOptions:` method.
 *
 * This delay defaults to 1 second in order to generally give the application time to
 * fully finish launching.
 *
 * The framework needs you to forward the following methods from your application delegate:
 *
 * - 'didFinishLaunchingWithOptions:'
 * - 'didRegisterForRemoteNotificationsWithDeviceToken:'
 * - 'didFailToRegisterForRemoteNotificationsWithError:'
 * - 'didReceiveRemoteNotification:'
 *
 * You can optionally add a delegate to be informed about errors while initalizing the location marketing service and to control the display of local notifications to the user.
 **/
@interface PWLocalpoint : NSObject


/**
 * Sets the localpoint delegate object.
 * @param delegate An object that implements the PWLocalpointDelegate protocol.
 */
+ (void)setDelegate:(id<PWLocalpointDelegate>)delegate;

/**
 * Starts the localpoint service with a list of zone managers.
 * @param zoneManagers A list of zone managers, which should implement the PWLPZoneManager protocol.
 */
+ (void)startWithZoneManagers:(NSArray *)zoneManagers;

/**
 * Starts the localpoint service with the default zone manager (PWGeoZoneManager).
 */
+ (void)start;

/**
 * Stops the localpoint service and all the active zone managers.
 */
+ (void)stop;


/**
 * Lets the localpoint service know that launch process is almost done and the app is almost ready to run.(APNs).
 * @param launchOptions A dictionary indicating the reason the app was launched (if any). The contents of this dictionary may be empty in situations where the user launched the app directly. For information about the possible keys in this dictionary and how to handle them, see Launch Options Keys.
 */
+ (void)didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

/**
 * Lets the localpoint service know that the app successfully registered with Apple Push Notification service (APNs). 
 * @param deviceToken A token that identifies the device to APNs. The token is an opaque data type because that is the form that the provider needs to submit to the APNs servers when it sends a notification to a device. The APNs servers require a binary format for performance reasons. The size of a device token is 32 bytes. Note that the device token is different from the uniqueIdentifier property of UIDevice because, for security and privacy reasons, it must change when the device is wiped.
 */
+ (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

/**
 * Lets the localpoint service know that the Apple Push Notification service cannot successfully complete the registration process.
 * @param error An NSError object that encapsulates information why registration did not succeed. The app can choose to display this information to the user.
 */
+ (void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;

/**
 * Lets the localpoint service know that the app receives a remote notification, so that it can process it internally.
 * @param userInfo A dictionary that contains information related to the remote notification, potentially including a badge number for the app icon, an alert sound, an alert message to display to the user, a notification identifier, and custom data. The provider originates it as a JSON-defined dictionary that iOS converts to an NSDictionary object; the dictionary may contain only property-list objects plus NSNull.
 */
+ (void)didReceiveRemoteNotification:(NSDictionary *)userInfo;

/**
 * The name of the localpoint service.
 */
+ (NSString *)serviceName;

@end

/**
 * Notification posted when the localpoint service fails to start.
 */
extern NSString *const PWLocalpointFailedToStartNotification;

/**
 * Protocol that allows the localpoint delegate to be notified of errors when starting the localpoint service and to control the display of local notifications.
 */
@protocol PWLocalpointDelegate <NSObject>

@optional
/**
 * Indicates that the localpoint service failed to start.
 * @param error The error that caused the localpoint service to fail to start.
 */
- (void)localpointFailedToStartWithError:(NSError *)error;

/**
 * Asks the delegate if the local notification should be displayed.
 * @discussion The delegate is also able to change the title and body of the notification, if needed.
 * @param notification The notification that the localpoint service intends to post.
 */
- (BOOL)localpointShouldDisplayLocalNotification:(PWLPLocalNotification *)notification;

@end
