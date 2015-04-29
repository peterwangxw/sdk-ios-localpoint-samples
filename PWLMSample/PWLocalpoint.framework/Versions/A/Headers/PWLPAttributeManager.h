//
//  PWAttributeManager.h
//  PWLocalpoint
//
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

@import Foundation;

/**
 * A block that will be called after the attributes are updated in the server.
 * @param error If the update completed successfully, this parameter is `nil`; otherwise, this parameter holds an error object that describes the error.
 */
typedef void (^PWUpdateAttributesBlock)(NSError *error);
/**
 * A block that will be called after the attribute metadata is fetched from the server.
 * @param attributes The attributes with their metadata.
 * @param error If the fetch completed successfully, this parameter is `nil`; otherwise, this parameter holds an error object that describes the error.
 */
typedef void (^PWFetchAttributeMetadataBlock)(NSArray *attributes, NSError *error);
/**
 * A block that will be called after the attributes are fetched from the server.
 * @param attributes The attributes associated with the device.
 * @param error If the fetch completed successfully, this parameter is `nil`; otherwise, this parameter holds an error object that describes the error.
 */
typedef void (^PWFetchAttributesBlock)(NSDictionary *attributes, NSError *error);
/**
 * A block that will be called after the custom identifier is fetched from the server.
 * @param identifer User identifier.
 * @param error If the fetch completed successfully, this parameter is `nil`; otherwise, this parameter holds an error object that describes the error.
 */
typedef void (^PWFetchCustomIdentifierBlock)(NSString *identifier, NSError *error);

@protocol PWLPAttributeManagerDelegate;

/**
 The `PWAttributeManager` class is the central point for fetching and updating attributes associated with the device or user. You use an instance of this class to fetch and update profile and user attributes.
 */

@interface PWLPAttributeManager : NSObject

/**
 Returns the shared instance of the `PWAttributeManager` class.
 @return The shared instance of the `PWAttributeManager` class.
 */
+ (instancetype)sharedManager;

/**
 Retrieves all profile attribute Metadata.
 @param completion A block that will be executed when the fetch is complete.
 */
- (void)fetchProfileAttributeMetadataWithCompletion:(PWFetchAttributeMetadataBlock)completion;

/**
 Retrieves all profile attributes associated with this device.
 @param completion A block that will be executed after the fetch is compete.
 */
- (void)fetchProfileAttributesWithCompletion:(PWFetchAttributesBlock)completion;

/**
 Update profile attributes to be associated with the device.
 @param attributes The attributes that you would like to associate with the device. This parameter cannot be `nil`.
 @param completion A block that will be executed after the update is complete.
 @discussion All attributes that you wish to be associated with this device must be in the `attributes` dictionary. Any items omitted will be removed.
 */
- (void)updateProfileAttributes:(NSDictionary *)attributes completion:(PWUpdateAttributesBlock)completion;


/**
 Retrieves the custom identifier associated with this device.
 @param completion A block that is executed after the custom identifier is fetched.
 */
- (void)fetchCustomIdentifierWithCompletion:(PWFetchCustomIdentifierBlock)completion;

/**

 Updates the custom identifier.
 @discussion Currently, only one user attribute named "ID1" is supported and its value must be a string. Any other attributes are ignored.
 @param identifier The identifier that you would like to associate with the user. This parameter cannot be `nil`.
 @param completion A block that will be executed after the update is comlpete.
 */
- (void)updateCustomIdentifier:(NSString *)identifier completion:(PWUpdateAttributesBlock)completion;

@end

