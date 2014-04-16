//
//  Parcel.m
//  Postakocsi
//
//  Created by Sandor Kolotenko on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Parcel.h"

@implementation Parcel
@synthesize Service, TrackingNumber, TrackingRecords, IsDelivered, IsTracked, LastKnownStatus, LastUpdate, Name;

static NSString *TrackingNumberArchiveKey = @"TrackingNumber";
static NSString *TrackingRecordsArchiveKey = @"TrackingRecords";
static NSString *IsDeliveredArchiveKey = @"IsDelivered";
static NSString *IsTrackedArchiveKey = @"IsTracked";
static NSString *LastKnownStatusArchiveKey = @"LastKnownStatus";
static NSString *LastUpdateArchiveKey = @"LastUpdate";
static NSString *ServiceArchiveKey = @"Service";
static NSString *NameArchiveKey = @"Name";


- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self != nil) {
        TrackingNumber = [decoder decodeObjectForKey:TrackingNumberArchiveKey];
        TrackingRecords = [decoder decodeObjectForKey:TrackingRecordsArchiveKey];
        IsDelivered = [decoder decodeBoolForKey:IsDeliveredArchiveKey];
        IsTracked = [decoder decodeBoolForKey:IsTrackedArchiveKey];
        LastKnownStatus = [decoder decodeObjectForKey:LastKnownStatusArchiveKey];
        LastUpdate = [decoder decodeObjectForKey:LastUpdateArchiveKey];
        Service = [decoder decodeIntForKey:ServiceArchiveKey];
        Name = [decoder decodeObjectForKey:NameArchiveKey];
    }
    return self;
}   

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:TrackingNumber forKey:TrackingNumberArchiveKey];
    [encoder encodeObject:TrackingRecords forKey:TrackingRecordsArchiveKey];
    [encoder encodeBool:IsDelivered forKey:IsDeliveredArchiveKey];
    [encoder encodeBool:IsTracked forKey:IsTrackedArchiveKey];
    [encoder encodeObject:LastKnownStatus forKey:LastKnownStatusArchiveKey];
    [encoder encodeObject:LastUpdate forKey:LastUpdateArchiveKey];
    [encoder encodeInt:Service forKey:ServiceArchiveKey];
    [encoder encodeObject:Name forKey:NameArchiveKey];
}


@end
