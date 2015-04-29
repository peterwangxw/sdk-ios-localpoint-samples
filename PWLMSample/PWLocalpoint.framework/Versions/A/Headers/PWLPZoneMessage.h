//
//  PWLPMessage.h
//  PWLocation
//
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

@import Foundation;

/**
 * Campaign type string value for push callback campaigns.
 */
static NSString *const PWLPZoneMessagePushCallbackCampaignType    = @"PUSH_CALLBACK";
/**
 * Campaign type string value for geofence entry campaigns.
 */
static NSString *const PWLPZoneMessageGeofenceEntryCampaignType   = @"GEOFENCE_ENTRY";
/**
 * Campaign type string value for geofence exit campaigns.
 */
static NSString *const PWLPZoneMessageGeofenceExitCampaignType    = @"GEOFENCE_EXIT";
/**
 * Campaign type string value for check-in campaigns.
 */
static NSString *const PWLPZoneMessageCheckinCampaignType         = @"CHECK_IN";


/**
 A `PWZoneMessage` is a communication (generally marketing-related) sent from the server.
 */
@interface PWLPZoneMessage : NSObject <NSSecureCoding, NSCopying>


/**
 Returns the title of this message. This property will never return a `nil` value.
 @return The title of this message.
 */
@property (readonly) NSString *title;

/**
 Returns the body of this message. The value returned by this method is usually HTML. This property will never return a `nil` value.
 @discussion  To mark this message as read, pass this message to the `PWLPZoneMessageManager` `readMessage:` method.
 @return The body of this message.
 */
@property (readonly) NSString *body;

/**
 Returns the metadata associated with the message.
 @discussion This property will never return a `nil` value.. It will return an empty `NSDictionary` object if there is no metadata associated with the message.
 
 @return Returns the metadata of this message.
 */
@property (readonly) NSDictionary *metaData;

/**
 Returns the expiration date of this message. An application may wish to display messages differently based on their expiration dates. This property will never return a `nil` value.
 @return The expiration date of this message.
 */
@property (readonly) NSDate *expirationDate;

/**
 Returns the internal unique identifier of the message. This identifier also idenfities the campaign this message was sent for.
 @discussion There can be at most one message associated with a campaign at any given time. This property will never return a `nil` value.
 @return The internal unique identifier message.
 */
@property (readonly) NSString *identifier;

/**
 A Boolean value indicating whether or not the entry is read.
 @discussion A message is only considered read if it has been marked as such by the application. To mark this message as read, pass this message to the `PWLPZoneMessageManager` `readMessage:` method.
 @return A Boolean value indicating whether or not the message has been read.
 */
@property (readonly) BOOL isRead;

/**
 A string containing the campaign type of the message.
 @return A string containing the campaign type of the message.
 */
@property (readonly) NSString *campaignType;


@end
