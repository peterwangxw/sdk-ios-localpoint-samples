//
//  AppInfoViewController.h
//  PWLPSample
//
//  Created by Xiangwei Wang 1/26/15.
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppInfoViewController : UITableViewController

@property(nonatomic, weak) IBOutlet UILabel *deviceID;
@property(nonatomic, weak) IBOutlet UILabel *deviceOS;

@property(nonatomic, weak) IBOutlet UILabel *sdkVersion;
@property(nonatomic, weak) IBOutlet UILabel *brand;
@property(nonatomic, weak) IBOutlet UILabel *appId;
@property(nonatomic, weak) IBOutlet UILabel *server;
@property(nonatomic, weak) IBOutlet UILabel *searchRadius;

@property(nonatomic, weak) IBOutlet UILabel *numberOfMonitoredZones;
@property(nonatomic, weak) IBOutlet UILabel *numberOfZones;
@property(nonatomic, weak) IBOutlet UILabel *numberOfInsideZones;
@property(nonatomic, weak) IBOutlet UILabel *numberOfcheckInZones;
@property(nonatomic, weak) IBOutlet UILabel *numberOfMessages;

- (void)updateUI;

@end
