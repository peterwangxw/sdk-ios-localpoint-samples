//
//  ZoneManagerCoordinator.m
//  PWLocalpoint
//
//  Created by Alejandro Mendez on 4/13/15.
//  Copyright (c) 2015 Phunware Inc. All rights reserved.
//

#import "ZoneManagerCoordinator.h"
#import "PubUtils.h"
#import "ZoneManagerDataSource.h"
#import "GeozoneManagerDelegate.h"

NSString *const GeozoneManagerMonitoredZonesChanged = @"GeozoneManagerMonitoredZonesChanged";

@interface ZoneManagerCoordinator()

@property (nonatomic) NSArray *activeZoneManagers;
@property (nonatomic) GeozoneManagerDelegate * geozoneManagerDelegate;
@property (nonatomic) BOOL localpointStarted;

@end

@implementation ZoneManagerCoordinator

#pragma mark - Initialization

+ (instancetype)sharedCoordinator{
    static ZoneManagerCoordinator * sharedCoordinator;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCoordinator = [ZoneManagerCoordinator new];
    });
    return sharedCoordinator;
}

#pragma mark - Public methods

- (void)startLocalpointWithEnabledZoneManagers
{
    
    [self removeObserverIfNeeded];
    
    NSMutableArray *enabledZoneManagers = @[].mutableCopy;
    
    NSArray *zoneManagersInformation = [[ZoneManagerDataSource new] getZoneManagers];
    for (ZoneManagerInformation *zoneManagerInformation in zoneManagersInformation){
        if (zoneManagerInformation.enabled) {
            id<PWLPZoneManager>manager = [NSClassFromString(zoneManagerInformation.className) new];
            [enabledZoneManagers addObject:manager];
        }
    }
    self.activeZoneManagers = enabledZoneManagers.copy;
    
    if (self.localpointStarted) {
        [PWLocalpoint stop];
    }
    
    self.localpointStarted = YES;
    [PWLocalpoint startWithZoneManagers:self.activeZoneManagers];
    
    [self addObserverAndDelegatesIfNeeded];
    
}

#pragma mark - Private methods

- (void)addObserverAndDelegatesIfNeeded
{
    PWLPGeoZoneManager *geoZoneManager = [self getManagerWithClass:[PWLPGeoZoneManager class]];
    if (geoZoneManager)
    {
        [geoZoneManager addObserver:self forKeyPath:@"monitoredZones" options:0 context:nil];
        self.geozoneManagerDelegate = [GeozoneManagerDelegate new];
        geoZoneManager.delegate = self.geozoneManagerDelegate;
    }
    else
    {
        self.geozoneManagerDelegate = nil;
    }
}

- (void)removeObserverIfNeeded
{
    PWLPGeoZoneManager *geoZoneManager = [self getManagerWithClass:[PWLPGeoZoneManager class]];
    if (geoZoneManager) {
        [geoZoneManager removeObserver:self forKeyPath:@"monitoredZones"];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([object conformsToProtocol:@protocol(PWLPZoneManager)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[NSNotificationCenter defaultCenter] postNotificationName:GeozoneManagerMonitoredZonesChanged object:self userInfo:nil];
        });
    }
}

+ (id<PWLPZoneManager>)getManagerWithClass:(Class)managerClass{
    return [[ZoneManagerCoordinator sharedCoordinator] getManagerWithClass:managerClass];
}

- (id<PWLPZoneManager>)getManagerWithClass:(Class)managerClass{
    
    for (id<PWLPZoneManager> manager in self.activeZoneManagers) {
        if ([manager isKindOfClass:managerClass]) {
            return manager;
        }
    }
    return nil;
}

@end
