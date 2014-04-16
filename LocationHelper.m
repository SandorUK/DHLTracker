//
//  LocationHelper.m
//  Postakocsi
//
//  Created by Alexander Kolotenko on 03/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSON.h"
#import "Parcel.h"
#import "Record.h"
#import "LocationHelper.h"

@implementation LocationHelper
@synthesize HasLocation, Latitude, Longitude;

- (Record*)processRecord:(Record*)trackingRecord
{
    [self searchCoordinatesForAddressSynchronously:trackingRecord.Place];
    if (HasLocation) {
        trackingRecord.HasLocation = YES;
        trackingRecord.Longitude = Longitude;
        trackingRecord.Latitude = Latitude;
    }
    else {
        trackingRecord.HasLocation = NO;
    }
    
    return trackingRecord;
}

- (void) searchCoordinatesForAddressSynchronously:(NSString *)inAddress
{
    //Build the string to Query Google Maps.
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@?output=json",inAddress];
    
    //Replace Spaces with a '+' character.
    [urlString setString:[urlString stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    
    //Create NSURL string from a formate URL string.
    NSURL *url = [NSURL URLWithString:urlString];
    
    //Setup and start an async download.
    //Note that we should test for reachability!.
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    [self processData:data];
    
    [request release];
}

- (void) searchCoordinatesForAddress:(NSString *)inAddress
{
    //Build the string to Query Google Maps.
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@?output=json",inAddress];
    
    //Replace Spaces with a '+' character.
    [urlString setString:[urlString stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
    
    //Create NSURL string from a formate URL string.
    NSURL *url = [NSURL URLWithString:urlString];
    
    //Setup and start an async download.
    //Note that we should test for reachability!.
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [connection release];
    [request release];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{   
    [self processData:data];
}

- (void)processData:(NSData*)data
{
    //The string received from google's servers
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //JSON Framework magic to obtain a dictionary from the jsonString.
    NSDictionary *results = [jsonString JSONValue];
    
    //Now we need to obtain our coordinates
    NSArray *placemark  = [results objectForKey:@"Placemark"];
    if (placemark != nil) {
        
        NSArray *coordinates = [[placemark objectAtIndex:0] valueForKeyPath:@"Point.coordinates"];
        
        //I put my coordinates in my array.
        Longitude = [[coordinates objectAtIndex:0] doubleValue];
        Latitude = [[coordinates objectAtIndex:1] doubleValue];
        HasLocation = YES;
        //Debug.
        //NSLog(@"Latitude - Longitude: %f %f", latitude, longitude);
        
    }
    else {
        NSLog(@"Sorry, no location");
        HasLocation = NO;
    }
    
    [jsonString release];
}
@end
