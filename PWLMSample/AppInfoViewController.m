//
//  DetailsViewController.m
//  PWLPSample
//
//  Created by Xiangwei Wang on 1/26/15.
//  Copyright (c) 2013 Xiangwei Wang. All rights reserved.
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
    
}

@end
