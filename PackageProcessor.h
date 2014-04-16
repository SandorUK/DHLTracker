//
//  PackageProcessor.h
//  Postakocsi
//
//  Created by Sandor Kolotenko on 02/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Parcel.h"
#import "Record.h"
#import <Foundation/Foundation.h>

//This is a generic protocol in case you'd like to develop several more
//tracking processors (e.g. for UPS, USPS, FedEx, etc).

@protocol PackageProcessor <NSObject>
@required
- (void)getParcelBy:(NSString*)TrackingNumber;
- (BOOL)isServiceAvailable;

@property (nonatomic, copy) void (^completeBlock)(BOOL isSuccess, NSString *message, Parcel *parcel);
@end
