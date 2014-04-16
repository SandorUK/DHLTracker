//
//  Record.h
//  Postakocsi
//
//  Created by Sandor Kolotenko on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//Object that hold the tracking step data.
@interface Record : NSObject <NSCoding>
{
    NSString* Date;         //The date and/or time of the step, e.g. 2012-10-23 14:55 format.
    NSString* Place;        //Where the package is located, e.g. Sydney, NSW
    NSString* ItemInfo;     //Additional item info.
    NSString* MoreInfo;     //Additional item info.
    
    BOOL HasLocation;       //Indicates whether item has location info or just status.
    
    // Contact me if you want to get this data too (I use Google Maps API for this purpose)
    double Longitude;       //NOT SUPPORTED HERE.
    double Latitude;        //NOT SUPPORTED HERE.
}
@property (nonatomic, retain) NSString* Date;
@property (nonatomic, retain) NSString* Place;
@property (nonatomic, retain) NSString* ItemInfo;
@property (nonatomic, retain) NSString* MoreInfo;

@property (nonatomic, readwrite) BOOL HasLocation;
@property (nonatomic, readwrite) double Longitude;
@property (nonatomic, readwrite) double Latitude;
@end
