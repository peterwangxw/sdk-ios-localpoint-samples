//
//  ZoneManagerInformation.m
//  PWLocalpoint
//
//  Created by Alejandro Mendez on 4/13/15.
//  Copyright (c) 2015 Phunware Inc. All rights reserved.
//

#import "ZoneManagerInformation.h"
#import "PubUtils.h"

@interface ZoneManagerInformation()

@property (nonatomic) NSString *displayName;
@property (nonatomic) NSString *className;
@property (nonatomic) NSString *enabledUserPreferencesKey;

@end

@implementation ZoneManagerInformation

+ (instancetype)zoneManagerInfoWithName:(NSString*)displayName className:(NSString*)className enabledKey:(NSString*)enabledUserPreferencesKey andEnabledDefaultValue:(BOOL)enabledDefaultValue
{
    ZoneManagerInformation *zoneManager = [[ZoneManagerInformation alloc] init];
    zoneManager.displayName = displayName;
    zoneManager.className = className;
    zoneManager.enabledUserPreferencesKey = enabledUserPreferencesKey;
    if (![PubUtils getUserDefaultsFor:enabledUserPreferencesKey]) {
        [PubUtils setUserDefaultsWithValue:@(enabledDefaultValue) for:enabledUserPreferencesKey];
    }
    return zoneManager;
}

-(BOOL)enabled
{
    NSNumber *enabled = [PubUtils getUserDefaultsFor:self.enabledUserPreferencesKey];
    return [enabled boolValue];
}

-(void)setEnabled:(BOOL)enabled
{
    [self willChangeValueForKey:@"enabled"];
    [PubUtils setUserDefaultsWithValue:@(enabled) for:self.enabledUserPreferencesKey];
    [self didChangeValueForKey:@"enabled"];
}

@end
