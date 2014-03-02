//
//  PECWantPointFSCtrl.h
//  BlueCarte
//
//  Created by Admin on 2/24/14.
//  Copyright (c) 2014 Paladin-Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FSVenue;

@interface PECWantPointFSCtrl : UIViewController

- (IBAction)butBack:(UIButton *)sender;

@property (strong, nonatomic) FSVenue *venue;

@end
