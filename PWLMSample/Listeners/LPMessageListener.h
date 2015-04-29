//
//  LPMessageListener.h
//  PWLPSample
//
//  Created by Xiangwei Wang on 4/20/15.
//  Copyright (c) 2015 Phunware Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPMessageListener : NSObject

/**
 Register for listening message events
 */
- (void)startListening;

/**
 Unregister for listening message events
 */
- (void)stopListening;

@end
