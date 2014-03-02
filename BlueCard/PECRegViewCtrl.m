//
//  PECRegViewCtrl.m
//  BlueCarte
//
//  Created by Admin on 12/17/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import "PECRegViewCtrl.h"
#import "PECPriceViewCtrl.h"
#import "PECMapViewController.h"
#import "Foursquare2.h"
#import "PECModelDataUser.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "PECNetworkDataCtrl.h"
#import "PECModelsData.h"


@interface PECRegViewCtrl ()

@property (strong, nonatomic) IBOutlet UITextField *tfNameInput;
@property (strong, nonatomic) IBOutlet UITextField *tfEMailInput;
@property (strong, nonatomic) IBOutlet UITextField *tfPassInput;

@end

@implementation PECRegViewCtrl

@synthesize scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Hidden Navigation bar
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    // White Status Bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

// Scroll Hidden Keyboard
- (IBAction)HideKeyboard:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)butReg:(UIButton *)sender
{
    
    NSString *login = [NSString stringWithFormat:@"email=%@",_tfEMailInput.text];
    
    NSString *params = nil;
   
    NSString *name = _tfNameInput.text;
    NSString *last_name = @"";
    NSString *password = _tfPassInput.text;
    NSString *address = @"";
    NSString *sex = @"";
    NSString *birthday = @"";
    NSString *email = _tfEMailInput.text;
    NSString *phone = @"";
    NSString *photo = @"";
    double rating = 0;
    
    
    params = [NSString stringWithFormat:@"{\"name\":\"%@\", \"password\":\"%@\", \"email\":\"%@\"}",name, password, email];
    
    PECNetworkDataCtrl *net = [[PECNetworkDataCtrl alloc]init];
    
    [net regUserDataServer:params callback:^(id sender){
       
        if([PECModelsData getModelUser].count!=0)
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                [self cellAlertMsg:@"Вы зарегестрированы"];
                NSLog(@"Вы зарегестрированы");

                PECMapViewController *viewCtrl = [self.storyboard instantiateViewControllerWithIdentifier:@"mapStoryID"];
                UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:viewCtrl] init];
                [self presentViewController:navController animated:YES completion:nil];

            
            });
        }else
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                [self cellAlertMsg:@"Регистрация не прошла"];
                NSLog(@"Регистрация не прошла");
            });
        }
        

        
        
    }];
    
    
}

- (IBAction)butBack:(UIButton *)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}

/*
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 */

-(void)viewWillAppear:(BOOL)animated{
    
    //if (FBSession.activeSession.isOpen)
      //  [self populateUserDetailsFacebook];
    
    if([Foursquare2 isAuthorized])
        [self populateUserDetails4SQ];
    
    [super viewWillAppear:animated];
}

- (void)populateUserDetailsFacebook
{
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 NSLog(@"user.name %@", user.name);
                 NSLog(@"user %@", [user objectForKey:@"email"]);
                 
                 _tfNameInput.text = user.name;
                 _tfEMailInput.text = [user objectForKey:@"email"];
                 
             }
         }];
    }
}

// ~ СИСТЕМНЫЕ

// Сообщения
-(void)cellAlertMsg:(NSString*)msg
{
    UIAlertView *autoAlertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:msg
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:nil];
    
    autoAlertView.transform = CGAffineTransformMake(1.0f, 0.5f, 0.0f, 1.0f, 0.0f, 0.0f);
    [autoAlertView performSelector:@selector(dismissWithClickedButtonIndex:animated:)
                        withObject:nil
                        afterDelay:0.0f];
    [autoAlertView show];
}

- (void)populateUserDetails4SQ
{
    NSLog(@"Go");
    
    PECModelDataUser *modelUser = [[PECModelDataUser getObjectData] objectAtIndex:0];
    _tfNameInput.text = modelUser.usName;
    _tfEMailInput.text = modelUser.usMail;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
    // Use this to allow upside down as well
    //return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (NSUInteger) supportedInterfaceOrientations {
    // Return a bitmask of supported orientations. If you need more,
    // use bitwise or (see the commented return).
    return UIInterfaceOrientationMaskPortrait;
    // return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    // Return the orientation you'd prefer - this is what it launches to. The
    // user can still rotate. You don't have to implement this method, in which
    // case it launches in the current orientation
    return UIDeviceOrientationPortrait;
}



@end
