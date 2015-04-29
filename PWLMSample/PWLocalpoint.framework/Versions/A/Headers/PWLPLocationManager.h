//
//  PWLPLocationManager.h
//  PWLocalpoint
//
//  Created by Alejandro Mendez on 3/9/15.
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PWLPGeozone.h"

/**
 * Provides the Location Marketing service with information about the locations stored in the device. 
 */
@interface PWLPLocationManager : NSObject

/**
 *  @discussion Returns the list of locations stored in the device.
 *  @return An array of locations stored in the device.
 */
@property (nonatomic, readonly) NSArray *locations;

/**
 *  @discussion
 *      Fetches the complete set of locations from the Location Marketing server and calls the given completion handler.
 *  @param completionHandler Block that will be executed when the fectch is complete. The fetch result paramter can have the following values: 
 *
 *      UIBackgroundFetchResultNewData if a successful call to Location Marketing was made.
 *      UIBackgroundFetchResultNoData if locations are not out of sync.
 *      UIBackgroundFetchResultFailed if there is a problem.
 */
- (void)fetchLocationsWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

/**
 *  Indicates if the list of locations stored in the device is out of sync.
 *  @discussion
 *      This can be due to time since last sync or distance traveled.
 *  @return
 *      Returns `YES` if we should ask Location Marketing for an updated set of locations. `NO` otherwise.
 */
- (BOOL)locationsOutOfSync;


/**
 * Gets a location from the device database.
 * @param identifier The identifier of the location to get.
 */
- (PWLPGeozone*)getLocationWithIdentifier:(NSString*)identifier;

@end
