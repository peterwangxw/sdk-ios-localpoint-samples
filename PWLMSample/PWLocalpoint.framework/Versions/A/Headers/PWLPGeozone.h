//
//  PWLPGeozone.h
//  PWLocalpoint
//
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

@import Foundation;
@import CoreLocation;

#import "PWLPZoneProtocol.h"

/**
 * A PWLPGeozone object represents a circular region in a map with some associated data 
 * for that region.
 */
@interface PWLPGeozone : NSObject <PWLPZone, NSSecureCoding, NSCopying>

/**
 The circular region represented by the PWLPGeozone object. (read-only)
 @discussion  When working with CLRegions, you should never perform pointer-level comparisons to determine equality. Instead, use the region’s identifier string to compare regions.
 */
@property (readonly, nonatomic) CLCircularRegion *region;

/**
 The geozone identifier. (read-only)
 */
@property (readonly, nonatomic) NSString * identifier;

/**
 The name given to the geozone object. (read-only)
 */
@property (readonly, nonatomic) NSString * name;

/**
 The code assigned to the geozone object. (read-only)
 */
@property (readonly, nonatomic) NSString * code;

/**
 The description assigned to the geozone object. (read-only)
 */
@property (readonly, nonatomic) NSString * zoneDescription;

/**
 A flag that indicates if a check-in can be performed in the geozone. (read-only)
 */
@property (readonly, nonatomic) BOOL canCheckIn;

/**
 A flag that indicates if the user is currently inside the geozone. (read-only)
 */
@property (readonly, nonatomic) BOOL inside;

/**
 A set of tags associated to the geozone. (read-only)
 */
@property (readonly, nonatomic) NSSet *tags;

/**
 * Unavailable initializer.
 * @return
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 Performs a check-in the zone, only if a check-in can be performed in the zone.
 */
- (void)checkIn;

@end
