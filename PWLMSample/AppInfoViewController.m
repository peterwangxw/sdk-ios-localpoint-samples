//
//  DetailsViewController.m
//  LocalpointTester_iOS
//
//  Created by Jason Schmitt on 2/21/13.
//  Copyright (c) 2013 Jason Schmitt. All rights reserved.
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
    
    [self updateUI:nil];
}

#pragma mark - Internal

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([object conformsToProtocol:@protocol(PWLPZoneManager)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateUI:nil];
        });
    }
}

- (void)updateUI:(NSNotification*)notification{
    
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
