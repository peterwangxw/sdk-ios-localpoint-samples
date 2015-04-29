//
//  PWGeoZoneManager.h
//  PWLocalpoint
//
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

@import Foundation;

#import "PWLPZoneManagerProtocol.h"
#import "PWLPGeozone.h"

/**
 * The geozone manager is in charge of monitoring geozones and informing about geozone related events by posting notifications and sending messages to its delegate.
 */
@interface PWLPGeoZoneManager : NSObject <PWLPZoneManager>

/**
 * The available geozones handled by the zone manager.
 * @discussion The zones will be of type `PWLPGeozone`.
 */
@property (nonatomic, readonly) NSArray *availableZones;

/**
 * The zones currently being monitored by the zone manager.
 * @discussion The zones will be of type `PWLPGeozone`.
 */
@property (nonatomic, readonly) NSArray *monitoredZones;

/**
 * The maximum amonunt of monitored regions.
 * @discussion The default value is 20. There is a maximum limit of 20 regions per application, so if your application needs to monitor some regions, decrease this value as appropiate.
 */
@property (nonatomic, assign) NSInteger maximumRegionsMonitored;

/**
 * The delegate object that will receive the callbacks defined in the PWLPZoneManagerDelegate protocol.
 */
@property (nonatomic, weak) id<PWLPZoneManagerDelegate> delegate;


/**
 *  Initializes a 'PWLPGeoZoneManager' object.
 *  @return A 'PWLPGeoZoneManager' instance.
 */
- (instancetype)init NS_DESIGNATED_INITIALIZER;

/**
 * Starts the zone manager.
 */
- (void)start;

/**
 * Stops the zone manager.
 */
- (void)stop;


@end
