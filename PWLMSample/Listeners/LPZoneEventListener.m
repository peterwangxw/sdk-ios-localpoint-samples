//
//  LPZoneEventListener.m
//  PWLocalpoint
//
//  Created by Xiangwei Wang on 4/20/15.
//  Copyright (c) 2015 Phunware Inc. All rights reserved.
//

#import <PWLocalpoint/PWLocalpoint.h>

#import "LPZoneEventListener.h"
#import "ZoneManagerCoordinator.h"
#import "PubUtils.h"

@implementation LPZoneEventListener

#pragma mark - Public methods

- (void)startListening {
    // Register for event notification of entering zone
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterZoneNotification:) name:PWLPZoneManagerDidEnterZoneNotification object:nil];
    
    // Register for event notification of exiting zone
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didExitZoneNotification:) name:PWLPZoneManagerDidExitZoneNotification object:nil];
    
    // Register for event notification of adding new zones
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAddZonesNotification:) name:PWLPZoneManagerDidAddZonesNotification object:nil];
    
    // Register for event notification of removing zones
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDeleteZonesNotification:) name:PWLPZoneManagerDidDeleteZonesNotification object:nil];
    
    // Register for event notification of updating zones
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didModifyZonesNotification:) name:PWLPZoneManagerDidModifyZonesNotification object:nil];
    
    // Register for event notification of checkin zone
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCheckInForZoneNotification:) name:PWLPZoneManagerDidCheckInForZoneNotification object:nil];
    
    // Register for event notification of fail checkin zone
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFailCheckInForZoneNotification:) name:PWLPZoneManagerDidFailCheckInForZoneNotification object:nil];
}

- (void)stopListening {
    // Unegister for event notification of entering zone
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWLPZoneManagerDidEnterZoneNotification object:nil];
    
    // Unegister for event notification of exiting zone
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWLPZoneManagerDidExitZoneNotification object:nil];
    
    // Unegister for event notification of adding new zone
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWLPZoneManagerDidAddZonesNotification object:nil];
    
    // Unegister for event notification of deleting zone
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWLPZoneManagerDidDeleteZonesNotification object:nil];
    
    // Unegister for event notification of updating zone
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWLPZoneManagerDidModifyZonesNotification object:nil];
    
    // Unegister for event notification of checkin zone
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWLPZoneManagerDidCheckInForZoneNotification object:nil];
    
    // Unegister for event notification of fail checkin zone
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWLPZoneManagerDidFailCheckInForZoneNotification object:nil];
}

#pragma mark - Private methods

/**
 The selector to handle notification when entering a zone
 @param notification A object of `NSNotification`
 */
- (void)didEnterZoneNotification:(NSNotification*)notification {
    id<PWLPZone> zone = [self getZoneFromNotification:notification];
    if (zone) {
        // You shoud customize the code here to do what you need to do.
        [PubUtils toast:[NSString stringWithFormat:@"Enter (ID: %@, name: %@)", zone.identifier, zone.name]];
    }
}

/**
 The selector to handle notification when exiting a zone
 @param notification A object of `NSNotification`
 */
- (void)didExitZoneNotification:(NSNotification*)notification {
    id<PWLPZone> zone = [self getZoneFromNotification:notification];
    if (zone) {
        // You shoud customize the code here to do what you need to do.
        [PubUtils toast:[NSString stringWithFormat:@"Exit (ID: %@, name: %@)", zone.identifier, zone.name]];
    }
}

/**
 The selector to handle notification when it succeed to checkin
 @param notification A object of `NSNotification`
 */
- (void)didCheckInForZoneNotification:(NSNotification*)notification {
    id<PWLPZone> zone = [self getZoneFromNotification:notification];
    if (zone) {
        // You shoud customize the code here to do what you need to do.
        [PubUtils toast:[NSString stringWithFormat:@"Checkin (ID: %@, name: %@)", zone.identifier, zone.name]];
    }
}

/**
 The selector to handle notification when it's failed to check in
 @param notification A object of `NSNotification`
 */
- (void)didFailCheckInForZoneNotification:(NSNotification*)notification {
    id<PWLPZone> zone = [self getZoneFromNotification:notification];
    NSError *error = notification.userInfo[PWLPZoneManagerNotificationErrorKey];
    if (zone) {
        // You shoud customize the code here to do what you need to do.
        [PubUtils toast:[NSString stringWithFormat:@"Failed checkin (ID: %@, name: %@) with error: %@", zone.identifier, zone.name, [error description]]];
    }
}

/**
 The selector to handle notification when new zones are added due to your location has changed
 @param notification A object of `NSNotification`
 */
- (void)didAddZonesNotification:(NSNotification*)notification {
    NSArray *identifierArray =  notification.userInfo[PWLPZoneManagerNotificationZoneIdentifiersArrayKey];
    if (identifierArray.count > 0) {
        // You shoud customize the code here to do what you need to do.
        [PubUtils toast:[NSString stringWithFormat:@"Add zones: %@", [identifierArray description]]];
    }
}

/**
 The selector to handle notification when zones are removed due to your location has significant changed or the zone are not available any more
 @param notification A object of `NSNotification`
 */
- (void)didDeleteZonesNotification:(NSNotification*)notification {
    NSArray *identifierArray =  notification.userInfo[PWLPZoneManagerNotificationZoneIdentifiersArrayKey];
    if (identifierArray.count > 0) {
        // You shoud customize the code here to do what you need to do.
        [PubUtils toast:[NSString stringWithFormat:@"Remove zones: %@", [identifierArray description]]];
    }
}

/**
 The selector to handle notification when it's failed to check in
 @param notification A object of `NSNotification`
 */
- (void)didModifyZonesNotification:(NSNotification*)notification {
    NSArray *identifierArray =  notification.userInfo[PWLPZoneManagerNotificationZoneIdentifiersArrayKey];
    if (identifierArray.count > 0) {
        // You shoud customize the code here to do what you need to do.
        [PubUtils toast:[NSString stringWithFormat:@"Modify zones: %@", [identifierArray description]]];
    }
}

#pragma mark - Helper metheds

/**
 Get the specific `PWLPZone` from notification
 @param notification A NSNotification which has the zone identifier in its userInfo.
 */
- (id<PWLPZone>)getZoneFromNotification:(NSNotification*)notification {
    NSString *identifier =  notification.userInfo[PWLPZoneManagerNotificationZoneIdentifierKey];
    if (identifier) {
        for (id<PWLPZone> zone in [self getPWLPGeoZoneManager].availableZones) {
            if ([zone.identifier isEqualToString:identifier]) {
                return zone;
            }
        }
    }
    return nil;
}

/**
 Get a list of `PWLPZone` from notification
 @param notification A NSNotification which has a list of zone identifier in its userInfo.
 */
- (NSArray*)getZoneListFromNotification:(NSNotification*)notification {
    NSArray *identifierArray =  notification.userInfo[PWLPZoneManagerNotificationZoneIdentifiersArrayKey];
    NSMutableArray *zoneArray = [NSMutableArray array];
    
    for (id<PWLPZone> zone in [self getPWLPGeoZoneManager].availableZones) {
        if ([identifierArray containsObject:zone.identifier]) {
            [zoneArray addObject:zone];
        }
    }
    
    return [zoneArray copy];
}

/**
 Get the geo zone manager
 */
- (id<PWLPZoneManager>)getPWLPGeoZoneManager {
    return [ZoneManagerCoordinator getManagerWithClass:[PWLPGeoZoneManager class]];
}

- (void)dealloc {
    [self stopListening];
}

@end
