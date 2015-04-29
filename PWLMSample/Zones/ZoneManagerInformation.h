//
//  ZoneManagerInformation.h
//  PWLocalpoint
//
//  Created by Alejandro Mendez on 4/13/15.
//  Copyright (c) 2015 Phunware Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZoneManagerInformation : NSObject

@property (readonly,nonatomic) NSString *displayName;
@property (readonly,nonatomic) NSString *className;
@property (readonly,nonatomic) NSString *enabledUserPreferencesKey;
@property (nonatomic) BOOL enabled;

+ (instancetype)zoneManagerInfoWithName:(NSString*)displayName className:(NSString*)className enabledKey:(NSString*)enabledUserPreferencesKey andEnabledDefaultValue:(BOOL)enabledDefaultValue;

@end
