//
//  PWLPConfiguration.h
//  PWLocalpoint
//
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

@import Foundation;

/**
 * Determines how the Location Marketing SDK is configured.
 */
@interface PWLPConfiguration : NSObject <NSSecureCoding, NSCopying>

/**
 * The name of the brand or organization.
 */
@property (nonatomic, readonly) NSString *brand;

/**
 * The environment where the SDK will execute. (sandbox,api,etc.)
 */
@property (nonatomic, readonly) NSString *environment;

/**
 * The identifier string that corresponds to the brand and environment.
 */
@property (nonatomic, readonly) NSString *identifier;

/**
 * Unavailable initializer.
 * @return
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 * Indicates the Location Marketing SDK that a new configuration should be used.
 * @param configuration The new configuration to use.
 */
+ (void)useConfiguration:(PWLPConfiguration *)configuration;

/**
 * The configuration currently used by the Location Marketing SDK.
 * @return The currently used configuration object.
 */
+ (instancetype)currentConfiguration;

/**
 * Convenience constructor for a configuration object that pulls the configuration information from the Info.plist file.
 * @return An initialized configuration object.
 */
+ (instancetype)defaultConfiguration;

/**
 * Convenience constructor that creates and initializes a configuration object with a brand, enviroment and identifier.
 * @param brand The brand or organization name
 * @param environment The environment where the SDK will execute.
 * @param identifier A identifier string that corresponds to the brand and environment.
 * @return An initialized configuration object.
 */
+ (instancetype)configurationWithBrand:(NSString *)brand
                           environment:(NSString *)environment
                            identifier:(NSString *)identifier;

@end
