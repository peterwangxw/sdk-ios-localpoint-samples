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
#import "MessagesTableViewController.h"
#import "MessageDetailViewController.h"
#import "MessagesManager.h"
#import "LPMessageListener.h"
#import "LPZoneEventListener.h"
#import "SampleDefines.h"
#import "LPUIAlertView.h"
#import "PubUtils.h"

static NSString *const LocalNotificationCustomString = @"Welcome. ";

@interface AppDelegate ()

@end

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
    
    // Handle message deep link
    [self handleMessageDeepLink:launchOptions];
    
    // Refresh badge on app icon and tabbar
    [[MessagesManager sharedManager] refreshBadgeCounter];
    
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

#pragma mark - Message Deep Link

- (void)handleMessageDeepLink:(NSDictionary*)userInfo {
    // Get message identifier from the userInfo dictionary
    NSString *messageId = [[PWLPZoneMessageManager sharedManager] parseMessageIdentifier:userInfo];
    
    if (!messageId) {
        // No message to deep link
        return;
    }
    
    // Start to display loading indicator
    [PubUtils showLoading];
    
    [[PWLPZoneMessageManager sharedManager] fetchMessageWithIdentifier:messageId completion:^(PWLPZoneMessage *message, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // Stop displaying loading indicator
            [PubUtils dismissLoading];
            
            if (message) {
                // Go to display the specific message in message detail view controller
                [self pushMessageDetailViewControllerWithMessage:message];
            } else if (error) {
                // To do something to handle the error.
                [PubUtils displayError:error];
            }
        });
    }];
}

- (void)pushMessageDetailViewControllerWithMessage:(PWLPZoneMessage*)message {
    // Try to get message detail view controller from story board
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:PWMainStoryBoardName bundle:nil];
    MessageDetailViewController *messageDetailController = [storyboard instantiateViewControllerWithIdentifier:MessageDetailViewControllerIdentifier];
    // Set the message to display in the message detail view controller
    messageDetailController.message = message;
    
    // Find the message list view controller in the tabbar
    UITabBarController *tabBar = (UITabBarController *)self.window.rootViewController;
    NSInteger indexOfController = 0;
    for (UIViewController *controller in tabBar.viewControllers) {
        UIViewController *tabRootController = nil;
        UIViewController *tabVisibleController = nil;
        if ([controller isKindOfClass:[UINavigationController class]]) {
            tabRootController = [(UINavigationController*)controller viewControllers].firstObject;
            tabVisibleController = [(UINavigationController*)controller visibleViewController];
        } else {
            tabRootController = controller;
            tabVisibleController = controller;
        }
        
        // Check every visible view controller to find message list/detail view controller
        if ([tabRootController isKindOfClass:[MessagesTableViewController class]]) {
            if ([tabVisibleController isKindOfClass:[MessageDetailViewController class]]) {
                // It's message detail view controller, it's to reload it with the current message
                tabBar.selectedIndex = indexOfController;
                ((MessageDetailViewController*)tabVisibleController).message = message;
                [tabVisibleController viewDidLoad];
            } else {
                // It's message list view controller, it's to `push` a message detail view controller
                tabBar.selectedIndex = indexOfController;
                [(UINavigationController *)tabBar.selectedViewController pushViewController:messageDetailController animated:YES];
            }
        }
        
        indexOfController ++;
    }
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

#pragma mark - Handle & Display notification(UIAlertViewDelegate)

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView isKindOfClass:[LPUIAlertView class]]) {
        // It's only handle the customized 'LPUIAlertView'
        if (buttonIndex == 1) {
            [[PWLPZoneMessageManager sharedManager] fetchMessageWithIdentifier:((LPUIAlertView*)alertView).messageId completion:^(PWLPZoneMessage *message, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (message) {
                        // Show message detail in message detail view controller
                        [self pushMessageDetailViewControllerWithMessage:message];
                    } else if (error) {
                        // Hand the error by youself
                        [PubUtils displayError:error];
                    }
                });
            }];
        }
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
