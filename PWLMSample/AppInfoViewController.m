//
//  AppInfoViewController.m
//  PWLPSample
//
//  Created by Xiangwei Wang on 1/26/15.
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

#import <PWLocalpoint/PWLocalpoint.h>

#import "AppInfoViewController.h"
#import "ZoneManagerCoordinator.h"

static NSString *const MaxMonitorRegionRadius = @"50,000";

@interface AppInfoViewController ()

@end

@implementation AppInfoViewController

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    PWLPConfiguration *cfg = [PWLPConfiguration defaultConfiguration];
    self.brand.text = cfg.brand;
    self.appId.text = cfg.identifier;
    self.server.text = cfg.environment;
    self.sdkVersion.text = [PWLPVersion version];
    self.deviceID.text = [PWLPDevice sharedInstance].identifier;
    self.deviceOS.text = [[UIDevice currentDevice] systemVersion];
    self.searchRadius.text = MaxMonitorRegionRadius;
    
    [self updateUI];
}

#pragma mark - Public

- (void)updateUI {
    id <PWLPZoneManager> manager = [ZoneManagerCoordinator getManagerWithClass:[PWLPGeoZoneManager class]];
    NSArray *locations = [[NSArray alloc] initWithArray:[manager availableZones]];
    NSArray *monitoredZones = [[NSArray alloc] initWithArray:[manager monitoredZones]];
    NSInteger numberOfInsideZones = 0;
    NSInteger numberOfCheckinZones = 0;
    for (PWLPGeozone *zone in monitoredZones) {
        if ([zone inside]) {
            numberOfInsideZones ++;
        }
        if ([zone canCheckIn]) {
            numberOfCheckinZones ++;
        }
    }
    
    self.numberOfZones.text = [NSString stringWithFormat:@"%lu", (unsigned long)[locations count]];
    self.numberOfMonitoredZones.text = [NSString stringWithFormat:@"%lu", (unsigned long)[monitoredZones count]];
    self.numberOfInsideZones.text = [NSString stringWithFormat:@"%lu", (long)numberOfInsideZones];
    self.numberOfcheckInZones.text = [NSString stringWithFormat:@"%lu", (long)numberOfCheckinZones];
    self.numberOfMessages.text = [NSString stringWithFormat:@"%lu", (long)[[PWLPZoneMessageManager sharedManager].messages count]];
}

@end
