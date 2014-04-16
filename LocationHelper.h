//
//  LocationHelper.h
//  Postakocsi
//
//  Created by Alexander Kolotenko on 03/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "Parcel.h"
#import <Foundation/Foundation.h>

@interface LocationHelper : NSObject
{
    BOOL HasLocation;
    double Longitude;
    double Latitude;
}
@property (nonatomic, readwrite) BOOL HasLocation;
@property (nonatomic, readwrite) double Longitude;
@property (nonatomic, readwrite) double Latitude;

- (void) searchCoordinatesForAddress:(NSString *)inAddress;
- (Record*)processRecord:(Record*)trackingRecord;
- (void) searchCoordinatesForAddressSynchronously:(NSString *)inAddress;
@end
