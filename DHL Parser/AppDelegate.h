//
//  AppDelegate.h
//  DHL Parser
//
//  Created by Sandor Kolotenko on 2012.10.03..
//  Copyright (c) 2012 Sandor Kolotenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    NSMutableArray* _parcels;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) NSMutableArray *Parcels;

//Demo callback method to notify user about parsing/tracking issue.
- (void)parcelErrorOccured:(NSString*)message;

@end
