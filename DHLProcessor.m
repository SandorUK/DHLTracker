//
//  DPDProcessor.m
//  
//
//  Created by Sandor Kolotenko on 03/03/2012.
//  Copyright (c) 2012 Sandor Kolotenko. All rights reserved.
//

#import "Record.h"
#import "Parcel.h"
#import "HTMLParser.h"
#import "DHLProcessor.h"

@implementation DHLProcessor

- (id) init
{
    // For internal reference only. Use as you wish.
    // Originally this DHLProcessor class was a part of a larger app (including
    // FedEx and Hungarian Post), these ID's required for compatibility reasons
    // You may remove them.
    name = @"DHL";
    serviceID = 2;
    return self;
}


//Flag for your internal reference.
- (BOOL)isServiceAvailable
{
    return YES;
}

//Actual result parsing is done here. Call this method in background.
- (Parcel*)getDetails:(NSMutableData*)data
{
    NSError *error = nil;
    Parcel* consigment = [[Parcel alloc] init];
    
    HTMLParser *parser = [[HTMLParser alloc] initWithData:data error:&error];
    
    consigment.TrackingRecords = [[NSMutableArray alloc] init];
    if (error) {
        NSLog(@"Error: %@", error);
        //Add additional error processing here.
        return nil;
    }
    
    HTMLNode *bodyNode = [parser body];
    
    HTMLNode* baseNode = [bodyNode findChildOfClass:@"shipmenttracking"];
    HTMLNode* baseTable = [baseNode findChildTag:@"table"];
    NSArray *rowNodes = [baseTable findChildTags:@"tr"];
    
    //Parsing tracking number
    HTMLNode* airWaybillSpan = [bodyNode findChildOfClass:@"air_waybill"];
    if (airWaybillSpan != nil) {
        NSRange semicolon = [[airWaybillSpan contents] rangeOfString:@":"];
        if (semicolon.location != NSNotFound) {
            NSString* parsedAirwayBill = [[[airWaybillSpan contents] substringFromIndex:(semicolon.location+1)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            consigment.TrackingNumber = parsedAirwayBill;
        }
    }
    
    NSString* sectionDate = @"";
    
    //Parsing the tracking reply
    BOOL nodeFound = NO;
    for (HTMLNode *inputNode in rowNodes) {
        
        int itemCounter = 0;
        NSArray *cellNodes = [inputNode findChildTags:@"td"];
        NSArray *cellDateNodes = [inputNode findChildTags:@"th"];
        
        //Parse current section date
        if ([cellDateNodes count]>0) {
            NSString* tempSecDate = [[cellDateNodes objectAtIndex:0] contents];
            if (tempSecDate != NULL) {
                sectionDate = tempSecDate;
            }
        }
        
        int counter = 0;
        Record* trackingRecord = [[Record alloc] init];
        
        //Extracting cells
        for (HTMLNode *cellRealItem in cellNodes) {
            
            if ([cellNodes count]> 2 ) {
                nodeFound = YES;
                switch (counter) {
                    case 1:
                        [trackingRecord setItemInfo:[self processCellText:[cellRealItem allContents]]];
                        break;
                    case 2:
                        [trackingRecord setPlace:[self processCellText:[cellRealItem allContents]]];
                        break;
                    case 3:
                        [trackingRecord setDate:[sectionDate stringByAppendingFormat:@", %@",[self processCellText:[cellRealItem allContents]]]];
                        break;
                    default:
                        break;
                }
                
            }
            
            counter++;
        }
        
        //Processing location.
        if (trackingRecord.Date != NULL) {
            [trackingRecord setHasLocation:NO];
            
            if (!trackingRecord.HasLocation) {
                if (trackingRecord.Place != nil) {
                    NSRange comaRange = [trackingRecord.Place rangeOfString:@","];
                    if (comaRange.location != NSNotFound) {
                        
                        NSString* trimmedLocation = [trackingRecord.Place substringFromIndex:comaRange.location + 1];
                        NSString* originalLocation = trackingRecord.Place;
                        
                        trackingRecord.Place = trimmedLocation;
                        
                        if (!trackingRecord.HasLocation) {
                            trackingRecord.Place = [originalLocation stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                        }
                        
                    }
                }
            }
            
            //Add record (record is one step your package had taken on its way)
            [consigment.TrackingRecords addObject:trackingRecord];
            
        }
        itemCounter++;
        
    }
    
    if (!nodeFound) {
        return nil;
    }
    
    consigment.LastUpdate = [NSDate date];
    
    
    //look through the tracking records and decide whether the package has been delivered
    if([consigment.TrackingRecords count] > 0)
    {
        //Reverse the order of tracking steps
        consigment.TrackingRecords = [[NSMutableArray alloc] initWithArray:[[consigment.TrackingRecords reverseObjectEnumerator] allObjects]];
        Record* lastRecord = [consigment.TrackingRecords lastObject];
        consigment.LastKnownStatus = lastRecord.ItemInfo;
        consigment.IsTracked   = YES;
        
        NSRange deliveredENG = [consigment.LastKnownStatus rangeOfString:DeliveredFlag];
        
        if (deliveredENG.location != NSNotFound) {
            //set delivered flags
            consigment.IsDelivered = YES;
        }
        
    }
    
    //In case of more parser (e.g. FedEx, UPS) implemented this flag indicates the service selected
    consigment.Service = serviceID;
    return consigment;
}


//Cleaning the cell text in the tracking table
- (NSString*)processCellText:(NSString*)rawText
{
    NSString *fullResult = @""; // Empty string just in case something went wrong while parsing the cell
    
    if ([rawText length] > 0) {
        @try {
            NSString* result = [rawText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            NSString* firstLetterCapital = [[result substringToIndex:1] uppercaseString];
            result = [result substringFromIndex:1];
            
            fullResult = [[firstLetterCapital stringByAppendingString:result] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
        @catch (NSException *exception) {
            NSLog(@"Cell Text Parsing error\nText to parse:%@\nParsing error %@", rawText, exception.debugDescription);
        }
    }
    return fullResult;
}

//Parsing the string for status message
- (NSString*)extractStatus:(NSString*)rawStatus
{
    NSString* message = NSLocalizedString(@"N/A", @"N/A");
    NSRange slashRange = [rawStatus rangeOfString:@"/"];
    
    if (slashRange.location != NSNotFound) {
        NSString* languageOne = [rawStatus substringToIndex:slashRange.location];
        NSString* languageTwo = [rawStatus substringFromIndex:slashRange.location + 1];
        
        NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
        
        if ([language isEqualToString:@"en"]) {
            message = [languageTwo stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
        else
        {
            message = [languageOne stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
        
    }
    else {
        message = [rawStatus stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    return message;
}


//Main method of this tracking processor. Starts the async request to the DHL server.
//Use 2111111111 waybill number for tracking.
- (void)getParcelBy:(NSString*)TrackingNumber
{
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    responseData = [NSMutableData data];
    
    //This is the official HTML based API link from the DHL.
    NSString* trackingString = [kDHLbaseURL stringByAppendingFormat:@"&AWB=%@", TrackingNumber];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:trackingString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    NSString *params = [[NSString alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setHTTPShouldHandleCookies:YES];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    [request addValue:kMIMETypeURLEncodedForm forHTTPHeaderField:kContentType];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [responseData setLength:0];
}

//Add data as it arrives.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}

//Data has arrived. Let's start parsing.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Response handling");
    NSLog(@"PACKAGE size %i ", [responseData length]);
    
    Parcel* package = [self getDetails:responseData];
    NSLog(@"Package records count %i", [package.TrackingRecords count]);
    NSLog(@"Last known status: %@", package.LastKnownStatus);
    
    
    if (package.IsTracked) {
        NSLog(@"DHL parcel %@", package.TrackingNumber);
        
        self.completeBlock(YES, [NSString stringWithFormat:@"DHL parcel %@", package.TrackingNumber], package);
    }
    else {
        //Callback so you can notify user if an exception occurs.
        self.completeBlock(NO, NSLocalizedString(@"DHLNoSuchParcel", @"DHLNoParcel"), Nil);
        
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error %@", error.debugDescription);
    self.completeBlock(NO, NSLocalizedString(@"DHLTimeout", @"Timeout"), Nil);
}

- (NSString*)parseLocation:(NSString *)place
{
    //This is a hook method, you may want to implement here Google Maps parsing or
    //any other kind of location related service.
    return place;
}

@end
