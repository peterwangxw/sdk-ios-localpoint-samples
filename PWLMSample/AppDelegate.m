//
//  AppDelegate.m
//  PWLPSample
//
//  Created by Xiangwei Wang on 1/26/15.
//  Copyright (c) 2015 Phunware Inc. All rights reserved.
//

#import <PWLocalpoint/PWLPConfiguration.h>
#import "AppDelegate.h"
#import "SampleDefines.h"
#import "PubUtils.h"
#import "LPUIAlertView.h"

static NSString *const LocalNotificationCustomString = @"Welcome. ";

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Start Localpoint service
    [PWLPConfiguration useConfiguration:[PWLPConfiguration defaultConfiguration]];
    [PWLocalpoint start];
    
    // Notify Localpoint the app finishes launching
    [PWLocalpoint didFinishLaunchingWithOptions:launchOptions];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Notify Localpoint the app succed to register for remote notification
    [PWLocalpoint didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    
    // Check push notification settings
    [self checkNotificationSetting];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    // Notify Localpoint the app fail to register for remote notification
    [PWLocalpoint didFailToRegisterForRemoteNotificationsWithError:error];
    
    // Check push notification settings
    [self checkNotificationSetting];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    // Handle the local notification by youself
    [self promptLocalNotification:notification];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Notify Localpoint the app receives a remote notificaiton
    [PWLocalpoint didReceiveRemoteNotification:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - PWLocalpointDelegate & Custom local notification

- (BOOL)localpointShouldDisplayLocalNotification:(PWLPLocalNotification *)notification {
    // Here is an example to customize entry campaign message to add a string 'Welcome. ' at the front of notification title.
    if ([notification.message.campaignType.lowercaseString isEqualToString:PWLPZoneMessageGeofenceEntryCampaignType.lowercaseString]) {
        // Here we only custom the entry campaign
        notification.alertTitle = [LocalNotificationCustomString stringByAppendingString:notification.alertTitle];
    }
    
    // *Important*, this notification will be sent only when it returns 'YES', it will be ingore if it returns 'NO'.
    return YES;
}

#pragma mark - Handle & Display notification

- (void)promptLocalNotification:(UILocalNotification *)notification {
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        NSString *title = nil;
        NSString *body = nil;
        if ([notification respondsToSelector:@selector(alertTitle)]) {
            // It's for iOS 8.2+
            title = notification.alertTitle;
            body = notification.alertBody;
        } else {
            body = notification.alertBody;
        }
        
        // Prepare the buttons on Alert view
        NSString *cancelButton = nil;
        NSString *viewButton = nil;
        NSString *messageId = [[PWLPZoneMessageManager sharedManager] parseMessageIdentifier:notification.userInfo];
        if (messageId) {
            // Display 'OK' and 'View' button on the alert view if there is message related
            cancelButton = AlertOKButtonName;
            viewButton = AlertViewButtonName;
        } else {
            // Or else just display an 'OK' button
            cancelButton = AlertOKButtonName;
            viewButton = nil;
        }
        
        // Use the customized 'UIAlertView' for passing the message ID
        LPUIAlertView *alert = [[LPUIAlertView alloc] initWithTitle:title
                                                            message:body
                                                           delegate:self
                                                  cancelButtonTitle:cancelButton
                                                  otherButtonTitles:viewButton, nil];
        alert.messageId = messageId;
        
        [alert show];
    }
}

#pragma mark - Private

- (void)checkNotificationSetting {
    NSString *enablePushNotificationSettings = @"To make sure you can receive notifications, please enable push notification setting by 'Setting > Notification'";
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(currentUserNotificationSettings)]) {
        if ([UIApplication sharedApplication].currentUserNotificationSettings.types == UIUserNotificationTypeNone) {
            [PubUtils displayWarning:enablePushNotificationSettings];
        }
    }
}
@end
