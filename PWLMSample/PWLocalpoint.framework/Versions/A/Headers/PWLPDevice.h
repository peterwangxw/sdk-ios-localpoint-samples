//
//  PWLPDevice.h
//  PWLocalpoint
//
//  Created by Illya Busigin on 2/11/15.
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

@import Foundation;
@import CoreLocation;

/**
 * A 'PWLPDevice' is used to extract information about the user's device.
 */
@interface PWLPDevice : NSObject

/**
 The type of identifier.
 
 @discussion The value can be `IDFA` or `IDFV`.
 
 `IDFA` is the identifier for advertisers applied when `AdSupport.framework` is included in the project.
 `IDFV` is the identifier for vendors applied when `AdSupport.framework` is `NOT` included in the project.
 */
@property (nonatomic, readonly) NSString *identifierType;

/**
 The identifier the SDK uses.
 
 @discussion The type of identifier can be `IDFA` or `IDFV` and the format is similar to '00000000-0000-0000-0000-000000000000'.
 
 `IDFA` is applied when `AdSupport.framework` is included in the project and `IDFV` is applied when it is not.
 */
@property (nonatomic, readonly) NSString *identifier;

/**
 The type of device the user is using.
 
 @discussion The type of device can be either 'PHONE' or 'TABLET'.
 */
@property (nonatomic, readonly) NSString *deviceType;


/**
 Get a singleton instance of `PWLPDevice`.
 
 @return A singleton instance of `PWLPDevice`.
 */
+ (instancetype)sharedInstance;
    
@end
