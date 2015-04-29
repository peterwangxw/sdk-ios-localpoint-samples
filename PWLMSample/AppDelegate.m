//
//  AppDelegate.m
//  PWLPSample
//
//  Created by Xiangwei Wang on 1/26/15.
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

#import <PWLocalpoint/PWLPConfiguration.h>
#import "AppDelegate.h"
#import "ZoneManagerCoordinator.h"
#import "GeozoneManagerDelegate.h"
#import "LPMessageListener.h"
#import "LPZoneEventListener.h"
#import "SampleDefines.h"
#import "PubUtils.h"

@implementation AppDelegate {
    __strong LPMessageListener *messageListener;
    __strong LPZoneEventListener *zoneEventListener;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Set the new configuration
    [PWLPConfiguration useConfiguration:[PWLPConfiguration defaultConfiguration]];
    
    [[ZoneManagerCoordinator sharedCoordinator] startLocalpointWithEnabledZoneManagers];
    
    // Notify Localpoint the app finishes launching
    [PWLocalpoint didFinishLaunchingWithOptions:launchOptions];
    
    // Start listen message events
    messageListener = [LPMessageListener new];
    [messageListener startListening];
    // Start listen zone events
    zoneEventListener = [LPZoneEventListener new];
    [zoneEventListener startListening];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Notify Localpoint the app succeed to register for remote notification
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
