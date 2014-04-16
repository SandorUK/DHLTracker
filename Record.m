//
//  Record.m
//  Postakocsi
//
//  Created by Sandor Kolotenko on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Record.h"

@implementation Record
@synthesize Date, Place, ItemInfo, MoreInfo, HasLocation, Longitude, Latitude;

static NSString *ItemInfoArchiveKey = @"ItemInfo";
static NSString *MoreInfoArchiveKey = @"MoreInfo";
static NSString *DateArchiveKey = @"Date";
static NSString *PlaceArchiveKey = @"Place";

static NSString *HasLocationArchiveKey = @"HasLocation";
static NSString *LongitudeArchiveKey = @"Longitude";
static NSString *LatitudeArchiveKey = @"Latitude";

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self != nil) {
        ItemInfo = [decoder decodeObjectForKey:ItemInfoArchiveKey];
        MoreInfo = [decoder decodeObjectForKey:MoreInfoArchiveKey];
        Date = [decoder decodeObjectForKey:DateArchiveKey];
        Place = [decoder decodeObjectForKey:PlaceArchiveKey];
        
        HasLocation = [decoder decodeBoolForKey:HasLocationArchiveKey];
        Longitude = [decoder decodeDoubleForKey:LongitudeArchiveKey];
        Latitude = [decoder decodeDoubleForKey:LatitudeArchiveKey];
    }
    return self;
}   

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:ItemInfo forKey:ItemInfoArchiveKey];
    [encoder encodeObject:MoreInfo forKey:MoreInfoArchiveKey];
    [encoder encodeObject:Date forKey:DateArchiveKey];
    [encoder encodeObject:Place forKey:PlaceArchiveKey];
    
    [encoder encodeBool:HasLocation forKey:HasLocationArchiveKey];
    [encoder encodeDouble:Longitude forKey:LongitudeArchiveKey];
    [encoder encodeDouble:Latitude forKey:LatitudeArchiveKey];
}

@end
