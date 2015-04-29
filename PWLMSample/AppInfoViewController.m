//
//  AppInfoViewController.m
//  PWLPSample
//
//  Created by Xiangwei Wang 1/26/15.
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

#import <PWLocalpoint/PWLocalpoint.h>

#import "AppInfoViewController.h"

static NSString *const MaxMonitorRegionRadius = @"50,000";

@interface AppInfoViewController ()

@end

@implementation AppInfoViewController

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    PWLPZoneMessageManager *messageManager = [PWLPZoneMessageManager sharedManager];
    [messageManager addObserver:self forKeyPath:@"messages" options:0 context:nil];
    
    [self updateUI];
}

#pragma mark - Internal

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([object conformsToProtocol:@protocol(PWLPZoneManager)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateUI];
        });
    }
}

- (void)updateUI{
    
    PWLPConfiguration *cfg = [PWLPConfiguration defaultConfiguration];
    self.brand.text = cfg.brand;
    self.appId.text = cfg.identifier;
    self.server.text = cfg.environment;
    self.sdkVersion.text = [PWLPVersion version];
    self.deviceID.text = [PWLPDevice sharedInstance].identifier;
    self.deviceOS.text = [[UIDevice currentDevice] systemVersion];
    self.searchRadius.text = MaxMonitorRegionRadius;
    self.numberOfMessages.text = [NSString stringWithFormat:@"%lu", (long)[[PWLPZoneMessageManager sharedManager].messages count]];
    
}

@end
