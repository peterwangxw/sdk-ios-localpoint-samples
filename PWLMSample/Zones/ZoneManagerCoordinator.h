//
//  ZoneManagerCoordinator.h
//  PWLocalpoint
//
//  Created by Alejandro Mendez on 4/13/15.
//  Copyright (c) 2015 Phunware Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PWLocalpoint/PWLocalpoint.h>

extern NSString *const GeozoneManagerMonitoredZonesChanged;

@interface ZoneManagerCoordinator : NSObject

+ (instancetype)sharedCoordinator;

- (void)startLocalpointWithEnabledZoneManagers;

+ (id<PWLPZoneManager>)getManagerWithClass:(Class)managerClass;

@end
