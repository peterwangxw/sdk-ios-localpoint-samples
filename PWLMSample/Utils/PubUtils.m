//
//  PubUtils.m
//  PWLocalpoint
//
//  Created by Xiangwei Wang on 3/31/15.
//  Copyright (c) 2015 Phunware Inc. All rights reserved.
//

#import "PubUtils.h"
#import "MBProgressHUD.h"
#import "SampleDefines.h"

@implementation PubUtils {
    UIView *topMostView;
}

+ (id)getUserDefaultsFor:(NSString*)key
{
    @synchronized(self){
        return [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
}

+ (void)setUserDefaultsWithValue:(NSObject*)value for:(NSString*)key
{
    @synchronized(self){
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (void)toast:(NSString*)message {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[PubUtils getTopMostView] animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.alpha = 0.6;
    hud.opaque = NO;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:1];
}

+ (void)showLoading {
    [MBProgressHUD showHUDAddedTo:[PubUtils getTopMostView] animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // Just in case it can't be dismissed properly
        [PubUtils dismissLoading];
    });
}

+ (void)dismissLoading {
    [MBProgressHUD hideHUDForView:[PubUtils getTopMostView] animated:YES];
}

+ (void)displayError:(NSError*)error {
    NSString *title = [NSString stringWithFormat:@"%@ %ld", error.domain, (long)error.code];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:[error description]
                                                   delegate:nil
                                          cancelButtonTitle:AlertOKButtonName
                                          otherButtonTitles:nil, nil];
    [alert show];
}

+ (void)displayWarning:(NSString*)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AlertViewTitleWarning
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:AlertOKButtonName
                                          otherButtonTitles:nil, nil];
    [alert show];
}

+ (UIView*)getTopMostView {
    UIView *topmostView = [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
    return topmostView;
}

@end
