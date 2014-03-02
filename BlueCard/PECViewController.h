//
//  PECViewController.h
//  BlueCard
//
//  Created by Admin on 12/12/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>


@class GPPSignInButton;

@class TPKeyboardAvoidingScrollView;

@interface PECViewController : UIViewController <UIWebViewDelegate>

- (IBAction)butGoogleAuth:(UIButton *)sender;
- (IBAction)butFacebookAuth:(UIButton *)sender;
- (IBAction)but4SQAuth:(UIButton *)sender;

- (IBAction)butLogIn:(UIButton *)sender;
- (IBAction)butReg:(UIButton *)sender;

- (IBAction)HideKeyboard:(id)sender;

@property (nonatomic, retain) IBOutlet TPKeyboardAvoidingScrollView *scrollView;

@end
