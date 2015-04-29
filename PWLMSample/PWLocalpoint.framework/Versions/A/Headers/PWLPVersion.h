//
//  PWLPVersion.h
//  PWLocalpoint
//
//  Created by Illya Busigin on 1/22/15.
//  Copyright (c) 2015 Phunware, Inc. All rights reserved.
//

@import Foundation;

extern NSString* const PWLocalpointVersion;

/**
 * Class used to retrieve the localpoint sdk version information.
 */
@interface PWLPVersion : NSObject

/**
 The major number of the SDK version.
 */
+ (NSInteger)major;

/**
 The minor number of SDK version.
 */
+ (NSInteger)minor;

/**
 The revision number of SDK version.
 */
+ (NSInteger)revision;

/**
 The version of SDK version.
 */
+ (NSString*)version;

@end
