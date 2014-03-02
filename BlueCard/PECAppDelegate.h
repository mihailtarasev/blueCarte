//
//  PECAppDelegate.h
//  BlueCard
//
//  Created by Admin on 12/12/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "Foursquare2.h"

@class PECRegViewCtrl;

@interface PECAppDelegate : UIResponder <UIApplicationDelegate>


- (void)openFacebookSession;
- (void)closeFacebookSession;

@property (strong, nonatomic) UIWindow *window;

@end
