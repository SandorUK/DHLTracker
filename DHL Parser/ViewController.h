//
//  ViewController.h
//  DHL Parser
//
//  Created by Sandor Kolotenko on 2012.10.03..
//  Copyright (c) 2012 Sandor Kolotenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DHLProcessor.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    UITableView *_tableView;
    UITextField *_txtTrackingNumber;
    UIButton *_btnTrack;
    
    AppDelegate *delegate;
    
    DHLProcessor *dhl;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *txtTrackingNumber;
@property (strong, nonatomic) IBOutlet UIButton *btnTrack;

- (IBAction)trackParcel:(id)sender;
- (void)notificationReceived:(NSNotification *) notification;
@end
