//
//  DPDProcessor.h
//  Postakocsi
//
//  Created by Sandor Kolotenko on 03/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Parcel.h"
#import "Record.h"
#import "PackageProcessor.h"
#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "GenericPackageProcessor.h"

//This is a DHLProcessor, which implements the general parcel processing protocol.
@interface DHLProcessor : GenericPackageProcessor <PackageProcessor>

//Name and ID of the service for your internal reference. E.g. ServiceID = 1, Name = "DHL Happiness"
@property (nonatomic, readwrite) int ServiceID;
@property (nonatomic, retain) NSString* Name;

- (BOOL)isServiceAvailable;
- (void)getParcelBy:(NSString*)TrackingNumber;
- (NSString*)extractStatus:(NSString*)rawStatus;
- (NSString*)parseLocation:(NSString*)place;
@end
