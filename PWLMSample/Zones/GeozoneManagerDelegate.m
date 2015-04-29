//
//  GeozoneManagerDelegate.m
//  PWLocalpoint
//
//  Created by Alejandro Mendez on 3/26/15.
//  Copyright (c) 2015 Phunware Inc. All rights reserved.
//

#import "GeozoneManagerDelegate.h"
#import "PubUtils.h"

@implementation GeozoneManagerDelegate

-(void)zoneManager:(id<PWLPZoneManager>)zoneManager didEnterZone:(id<PWLPZone>)zone
{
    if([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
    {
        [PubUtils toast:[NSString stringWithFormat:@"Entered: %@",zone]];
    }
}

-(void)zoneManager:(id<PWLPZoneManager>)zoneManager didExitZone:(id<PWLPZone>)zone
{
    if([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
    {
        [PubUtils toast:[NSString stringWithFormat:@"Exited: %@",zone]];
    }
}

@end
