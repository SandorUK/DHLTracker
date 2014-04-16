//
//  Parcel.h
//  Postakocsi
//
//  Created by Sandor Kolotenko on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Record.h"
#import <Foundation/Foundation.h>


//This is an object model that represent one parcel.
@interface Parcel : NSObject <NSCoding>
{
    NSString*       Name;               //e.g. "Birthday Present"
    NSString*       TrackingNumber;     //e.g. 211111111
    NSMutableArray* TrackingRecords;    //Array with object of type "Record"
    NSString*       LastKnownStatus;    //e.g. "Delivered"
    NSDate*         LastUpdate;         //e.g. 2012-10-01 14:55 in DateTime object
    NSInteger       Service;            //e.g. Internal ID for the service being tracked, e.g. 1
    BOOL IsDelivered;                   
    BOOL IsTracked;
    
}

@property (nonatomic, readwrite) BOOL IsTracked;
@property (nonatomic, readwrite) BOOL IsDelivered;
@property (nonatomic, readwrite) NSInteger Service;
@property (nonatomic, retain) NSString* Name;
@property (nonatomic, retain) NSString* TrackingNumber;
@property (nonatomic, retain) NSString* LastKnownStatus;
@property (nonatomic, retain) NSDate* LastUpdate;
@property (nonatomic, retain) NSMutableArray* TrackingRecords;
@end
