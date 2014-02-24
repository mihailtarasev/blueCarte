//
//  PECRegViewCtrl.h
//  BlueCarte
//
//  Created by Admin on 12/17/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <FacebookSDK/FacebookSDK.h>

@class TPKeyboardAvoidingScrollView;

@interface PECRegViewCtrl : UIViewController

- (IBAction)butReg:(UIButton *)sender;
- (IBAction)butBack:(UIButton *)sender;

- (IBAction)HideKeyboard:(id)sender;

@property (nonatomic, retain) IBOutlet TPKeyboardAvoidingScrollView *scrollView;


@end
