Location Marketing Sample Application for iOS
==================

Version 3.0

This is Phunware's iOS SDK for the Location Marketing module. Visit http://maas.phunware.com/ for more details and to sign up.


Requirements
------------

- MaaSCore v1.3.0 or greater
- iOS 6.0 or greater
- Xcode 5 or greater



Installation
------------

The recommended way to use PWLocalpoint is via [CocoaPods](http://cocoapods.org). Add the following pod to your `Podfile` to use PWLocalpoint:
````
pod 'PWLocalpoint', '~>3.0'
````

Documentation
------------
TODO....

Application Setup
-----------------
At the top of your application delegate (.m) file, add the following:

````objective-c
#import <PWLocalpoint/PWLocalpoint.h>
````

Inside your application delegate, you will need to initialize MaaSCore in the application:didFinishLaunchingWithOptions: method. 

````objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Start Localpoint service
    [PWLocalpoint start];
    
    // Notify Localpoint the app finishes launching
    [PWLocalpoint didFinishLaunchingWithOptions:launchOptions];
    
    return YES;
}
````

Since PWLocalpoint v3.0, the *application developer* is not responsible with registering for remote notifications with Apple. Apple has three primary methods for handling remote notifications. You will need to implement these in your application delegate, forwarding the results to PWAlerts:

````objective-c
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken
{
    [PWLocalpoint didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    ...
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    [PWLocalpoint didFailToRegisterForRemoteNotificationsWithError:error];
    ...
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [PWLocalpoint didReceiveRemoteNotification:userInfo];
    ...
}
````




Custom Local Notification 
--------------

The PWLocalpoint provides the ability to custom the local notification. There is a SDK methods that facilitate this: *localpointShouldDisplayLocalNotification:*.

````objective-c
// Custom 'ENTRY' campaign local notification
- (BOOL)localpointShouldDisplayLocalNotification:(PWLPLocalNotification *)notification {
    // Here is an example to customize entry campaign message to add a string 'Welcome. ' at the front of notification title.
    if ([notification.message.campaignType.lowercaseString isEqualToString:PWLPZoneMessageGeofenceEntryCampaignType.lowercaseString]) {
        // Here we only custom the entry campaign
        notification.alertTitle = [LocalNotificationCustomString stringByAppendingString:notification.alertTitle];
    }
    
    // *Important*, this notification will be sent only when it returns 'YES', it will be ingore if it returns 'NO'.
    return YES;
}
````
