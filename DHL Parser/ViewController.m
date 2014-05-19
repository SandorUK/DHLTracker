//
//  ViewController.m
//  DHL Parser
//
//  Created by Sandor Kolotenko on 2012.10.03..
//  Copyright (c) 2012 Sandor Kolotenko. All rights reserved.
//

#import "ViewController.h"
#import "Parcel.h"
#import "Record.h"
#import "AppDelegate.h"
#import "DHLProcessor.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize tableView = _tableView;
@synthesize txtTrackingNumber = _txtTrackingNumber;
@synthesize btnTrack = _btnTrack;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    dhl = [[DHLProcessor alloc] init];
    
}

- (void)viewWillUnload{
    [super viewWillUnload];
    
    //Remove notification observer.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //returns number of all tracked parcels
    return [delegate.Parcels count];
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //returns number of tracking steps for each package
    Parcel* parcel = [delegate.Parcels objectAtIndex:section];
    return [parcel.TrackingRecords count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    Parcel* parcel = [delegate.Parcels objectAtIndex:section];
    if ([parcel.TrackingNumber length] > 0) {
        return parcel.TrackingNumber;
    }
    else{
        return NSLocalizedString(@"N/A", @"N/A");
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
   
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Parcel* parcel = [delegate.Parcels objectAtIndex:indexPath.section];
    Record* record = [parcel.TrackingRecords objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:[NSString stringWithFormat:@"%@ %@ %@", record.Date, record.Place, record.ItemInfo]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:9.0f]];
    [cell.textLabel setNumberOfLines:2];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 39;
}

-(IBAction)trackParcel:(id)sender{
    [self.txtTrackingNumber resignFirstResponder];
    
    [dhl setCompleteBlock:^(Parcel *parcel, NSError **error) {
        // BOOL isSuccess represents whether communication with DHL server was successful
        // NSString *message containt a 
        if (!parcel) {
            [delegate.Parcels addObject:parcel];
            [self.tableView reloadData];
        }
        else{
            [delegate parcelErrorOccured:(*error).localizedDescription];
        }
    }];
    [dhl getParcelBy:self.txtTrackingNumber.text];
}


@end
