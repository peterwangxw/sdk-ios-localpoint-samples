//
//  PWZoneManager.h
//  PWLocalpoint
//
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

@import Foundation;
#import "PWLPZoneProtocol.h"
#import "PWLPZoneManagerDelegateProtocol.h"

/**
 * Protocol that needs to be implemented by all zone managers in the Location Marketing service.
 */
@protocol PWLPZoneManager <NSObject>

/**
 * The available zones handled by the zone manager.
 * @discussion The type of zone will depend on the implementation of each manager.
 */
@property (nonatomic, readonly) NSArray *availableZones;

/**
 * The zones currently being monitored by the zone manager.
 * @discussion The type of zone will depend on the implementation of each manager.
 */
@property (nonatomic, readonly) NSArray *monitoredZones;

/**
 * The delegate object that will receive the callbacks defined in the `PWLPZoneManagerDelegate` protocol.
 */
@property (nonatomic, weak) id<PWLPZoneManagerDelegate> delegate;

/**
 * Starts the zone manager.
 */
- (void)start;

/**
 * Stops the zone manager.
 */
- (void)stop;


@end

/*
 `PWZoneManager` is responsible for:
 - Detecting zone entry and exit events.
 - Fetching and updating zones to monitor. 
 
 
 The Core SDK is responsible for:
 - Getting attributes.
 - Updating attributes.
 - Getting messages.
 - Local and remote notifications.
 - Remote notification registration.
 
 
 Zone is breached
 send event to server
 download geofences
 ?refresh beacons
 ?refresh third party zone
 check in
 read message
 get attributes
 update attributes
 */
