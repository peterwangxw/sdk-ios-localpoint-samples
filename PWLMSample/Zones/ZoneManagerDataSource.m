//
//  ZoneManagerDataSource.m
//  PWLocalpoint
//
//  Created by Alejandro Mendez on 4/13/15.
//  Copyright (c) 2015 Phunware Inc. All rights reserved.
//

#import "ZoneManagerDataSource.h"
#import <PWLocalpoint/PWLocalpoint.h>

static NSString *const PWLPGeoZoneManagerUserDefaultsEnabledKey = @"PWLPGeoZoneManagerUserDefaultsEnabledKey";
static NSString *const PWLPZoneEventManagerUserDefaultsEnabledKey = @"PWLPZoneEventManagerUserDefaultsEnabledKey";
static NSString *const PWLPProximityZoneManagerUserDefaultsEnabledKey = @"PWLPProximityZoneManagerUserDefaultsEnabledKey";


@implementation ZoneManagerDataSource

- (NSArray *)getZoneManagers
{
    return @[
             [ZoneManagerInformation zoneManagerInfoWithName:@"Geozone Manager" className:NSStringFromClass([PWLPGeoZoneManager class]) enabledKey:PWLPGeoZoneManagerUserDefaultsEnabledKey andEnabledDefaultValue:YES],
             [ZoneManagerInformation zoneManagerInfoWithName:@"Zone Event Manager" className:NSStringFromClass([PWLPZoneEventManager class]) enabledKey:PWLPZoneEventManagerUserDefaultsEnabledKey andEnabledDefaultValue:YES]
            ];
}

@end
