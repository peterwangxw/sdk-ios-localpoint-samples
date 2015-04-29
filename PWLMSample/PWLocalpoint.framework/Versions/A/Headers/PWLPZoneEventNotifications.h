//
//  PWZoneManagerNotifications.h
//  PWLocalpoint
//
//  Copyright (c) 2015 Phunware Inc. All rights reserved.
//

@import Foundation;

/**
 * Posted when the zone manager determines that the device enters a zone. The zone identifer is included in the notification's userInfo dictionary with the PWLPZoneManagerNotificationZoneIdentifierKey key.
 */
extern NSString *const PWLPZoneManagerDidEnterZoneNotification;

/**
 * Posted when the zone manager determines that the device exits a zone. The zone identifer is included in the notification's userInfo dictionary with the PWLPZoneManagerNotificationZoneIdentifierKey key.
 */
extern NSString *const PWLPZoneManagerDidExitZoneNotification;

/**
 * Posted when new zones are added to the zone manager's list of available zones. The identifers of the new zones are included in the notification's userInfo dictionary with the 'PWLPZoneManagerNotificationZoneIdentifiersArrayKey' key.
 */
extern NSString *const PWLPZoneManagerDidAddZonesNotification;

/**
 * Posted when zones are removed from the zone manager's list of available zones. The identifers of the removed zones are included in the notification's userInfo dictionary with the 'PWLPZoneManagerNotificationZoneIdentifiersArrayKey' key.
 */
extern NSString *const PWLPZoneManagerDidDeleteZonesNotification;

/**
 * Posted when the information about one or more zones is modified. The identifers of the modified zones are included in the notification's userInfo dictionary with the 'PWLPZoneManagerNotificationZoneIdentifiersArrayKey' key.
 */
extern NSString *const PWLPZoneManagerDidModifyZonesNotification;

/**
 * Posted when the a check-in is successfully performed in a zone. The zone identifer is included in the notification's userInfo dictionary with the PWLPZoneManagerNotificationZoneIdentifierKey key.
 */
extern NSString *const PWLPZoneManagerDidCheckInForZoneNotification;

/**
 * Posted when the a check-in for a zone fails. The zone identifer is included in the notification's userInfo dictionary with the PWLPZoneManagerNotificationZoneIdentifierKey key and the error information can be accessed with the PWLPZoneManagerNotificationErrorKey key.
 */
extern NSString *const PWLPZoneManagerDidFailCheckInForZoneNotification;

/**
 * String that contains the key name used in local notifications to retrieve the zone identifier value.
 */
extern NSString *const PWLPZoneManagerNotificationZoneIdentifierKey;

/**
 * String that contains the key name used in local notifications to retrieve the zone identifiers array.
 */
extern NSString *const PWLPZoneManagerNotificationZoneIdentifiersArrayKey;

/**
 * String that contains the key name used in local notifications to retrieve the error information.
 */
extern NSString *const PWLPZoneManagerNotificationErrorKey;
