//
//  GenericPackageProcessor.h
//  Postakocsi
//
//  Created by Sandor Kolotenko on 03/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "Parcel.h"
#import "Record.h"
#import "PackageProcessor.h"
#import <Foundation/Foundation.h>

@interface GenericPackageProcessor : NSObject <PackageProcessor>
{
    NSMutableData *responseData;
    NSString* name;
    int serviceID;
}

@property (nonatomic, readwrite) int ServiceID;
@property (nonatomic, retain) NSString* Name;
@property (nonatomic, copy) void (^completeBlock)(BOOL isSuccess, NSString *message, Parcel *parcel);

- (BOOL)isServiceAvailable;
- (void)getParcelBy:(NSString*)TrackingNumber;
- (NSString*)extractStatus:(NSString*)rawStatus;
- (NSString*)parseLocation:(NSString*)place;


@end
