//
//  DetailsViewController.h
//  LocalpointTester_iOS
//
//  Created by Jason Schmitt on 2/21/13.
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

@end
