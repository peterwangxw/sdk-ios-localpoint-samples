//
//  LPZoneEventListener.h
//  PWLPSample
//
//  Created by Xiangwei Wang on 4/20/15.
//  Copyright (c) 2015 Phunware Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppInfoViewController.h"

@interface LPZoneEventListener : NSObject

/**
 Register for listening zone events
 */
- (void)startListening;

/**
 Unregister for listening zone events
 */
- (void)stopListening;

@end
