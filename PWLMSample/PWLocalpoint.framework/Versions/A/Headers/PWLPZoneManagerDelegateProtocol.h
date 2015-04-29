//
//  PWLPZoneManagerDelegateProtocol.h
//  PWLocalpoint
//
//  Copyright (c) 2015 Phunware Inc. All rights reserved.
//

@import Foundation;

@protocol PWLPZoneManager;
@protocol PWLPZone;

/**
 * The Zone Manager interface is the central point for configuring the delivery of zone-related events. You use an instance of this class to establish the parameters that determine when location and heading events should be delivered and to start and stop the actual delivery of those events. You can also use a zone manager object to retrieve the most recent location and heading data.
 */
@protocol PWLPZoneManagerDelegate <NSObject>

@optional

/**
 * Invoked when the device enters a zone
 * @discussion If multiple active zone managers are tracking the same zone, every active zone manager object delivers this message to its associated delegate. And if multiple zone managers share a delegate object, that delegate receives the message multiple times.
 * @param zoneManager The zone manager that generated the callback.
 * @param zone The zone that was entered.
 */
- (void)zoneManager:(id<PWLPZoneManager>)zoneManager didEnterZone:(id<PWLPZone>)zone;

/**
 * Invoked when the device exits a zone
 * @discussion If multiple active zone managers are tracking the same zone, every active zone manager object delivers this message to its associated delegate. And if multiple zone managers share a delegate object, that delegate receives the message multiple times.
 * @param zoneManager The zone manager that generated the callback.
 * @param zone The zone that was exited.
 */
- (void)zoneManager:(id<PWLPZoneManager>)zoneManager didExitZone:(id<PWLPZone>)zone;

/**
 * Invoked when one or more zones are added to the list of available zones
 * @discussion The zone array contains a list of object that conform to the PWLPZone protocol. If multiple active zone managers are tracking the same zone, every active zone manager object delivers this message to its associated delegate. And if multiple zone managers share a delegate object, that delegate receives the message multiple times.
 * @param zoneManager The zone manager that generated the callback.
 * @param zones An array containing the zones that were added.
 */
- (void)zoneManager:(id<PWLPZoneManager>)zoneManager didAddZones:(NSArray *)zones;

/**
 * Invoked when one or more zones are removed from the list of available zones
 * @discussion The zone identifier array contains a list of strings corresponding to the identifiers of the removed zones. If multiple active zone managers are tracking the same zone, every active zone manager object delivers this message to its associated delegate. And if multiple zone managers share a delegate object, that delegate receives the message multiple times.
 * @param zoneManager The zone manager that generated the callback.
 * @param zoneIdentifiers An array containing the zone identifiers of the zones that were deleted.
 */
- (void)zoneManager:(id<PWLPZoneManager>)zoneManager didDeleteZones:(NSArray *)zoneIdentifiers;

/**
 * Invoked when one or more zones are updated in the list of available zones
 * @discussion The zone array contains a list of object that conform to the PWLPZone protocol. If multiple active zone managers are tracking the same zone, every active zone manager object delivers this message to its associated delegate. And if multiple zone managers share a delegate object, that delegate receives the message multiple times.
 * @param zoneManager The zone manager that generated the callback.
 * @param zones An array containing the zones that were modified.
 */
- (void)zoneManager:(id<PWLPZoneManager>)zoneManager didModifyZones:(NSArray *)zones;

/**
 * Invoked when the a check-in operation is perfomed in a zone
 * @discussion If multiple active zone managers are tracking the same zone, every active zone manager object delivers this message to its associated delegate. And if multiple zone managers share a delegate object, that delegate receives the message multiple times.
 * @param zoneManager The zone manager that generated the callback.
 * @param zone The zone where the check-in was performed.
 */
- (void)zoneManager:(id<PWLPZoneManager>)zoneManager didCheckInForZone:(id<PWLPZone>)zone;

/**
 * Invoked when the a check-in operation fails
 * @discussion If multiple active zone managers are tracking the same zone, every active zone manager object delivers this message to its associated delegate. And if multiple zone managers share a delegate object, that delegate receives the message multiple times.
 * @param zoneManager The zone manager that generated the callback.
 * @param zone The zone where the check-in failed.
 * @param error The error that caused the check-in to fail.
 */
- (void)zoneManager:(id<PWLPZoneManager>)zoneManager failedCheckInForZone:(id<PWLPZone>)zone error:(NSError *)error;

@end