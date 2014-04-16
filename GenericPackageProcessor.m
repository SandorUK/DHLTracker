//
//  GenericPackageProcessor.m
//  Postakocsi
//
//  Created by Sandor Kolotenko on 03/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GenericPackageProcessor.h"

@implementation GenericPackageProcessor
@synthesize ServiceID = serviceID;
@synthesize Name = name;
@synthesize completeBlock = _completeBlock;

- (BOOL)isServiceAvailable
{
    return NO;
}

- (void)getParcelBy:(NSString*)TrackingNumber
{
    
}

- (NSString*)extractStatus:(NSString*)rawStatus
{
    return nil;
}

- (NSString*)parseLocation:(NSString*)place
{
    return nil;
}

@end
