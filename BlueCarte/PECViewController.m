//
//  PECViewController.m
//  BlueCard
//
//  Created by Admin on 12/12/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import "PECViewController.h"
#import "PECAppDelegate.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "PECMapViewController.h"
#import "Foursquare2.h"
#import <CoreLocation/CoreLocation.h>
#import "PECModelDataUser.h"
#import <AudioToolbox/AudioToolbox.h>
#import "PECNetworkDataCtrl.h"
#import "PECModelsData.h"

#import <CoreData/CoreData.h>

#include "PECMainViewController.h"


@interface PECViewController ()
{
    NSDictionary<FBGraphUser> *userData;
    
    // Sound
    SystemSoundID soundID;
    NSString *soundFileName;
    NSString *soundFile;
}

@property (strong, nonatomic) IBOutlet UITextField *tfLoginInput;
@property (strong, nonatomic) IBOutlet UITextField *tfPassInput;

@property (strong) NSMutableArray *devices;

@end

@implementation PECViewController

// Google key
// static NSString * const kClientId = @"804961937404-he7akc7e6keduodljud8pq1854crvrse.apps.googleusercontent.com";

@synthesize scrollView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Hidden Navigation bar
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    // White Status Bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)soundClickName : (NSString*)soundName
{
    soundFile = [[NSBundle mainBundle] pathForResource:soundName ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:soundFile], &soundID);
    AudioServicesPlaySystemSound(soundID);
}

// Scroll Hidden Keyboard
- (IBAction)HideKeyboard:(id)sender {
    [self.view endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

// ~ LOGIN

- (IBAction)butLogIn:(UIButton *)sender
{
   // /*
    [self soundClickName:@"main_menu_sound"];
    
    NSString *loginMail = [NSString stringWithFormat:@"email=%@",_tfLoginInput.text];
    NSString *pass = _tfPassInput.text;
    
    PECNetworkDataCtrl *net = [[PECNetworkDataCtrl alloc]init];

    
    
    
    
    
    
    
    
    
    [net getUserlDataServerFromEmai:loginMail callback:^(id sender){
        
        
        NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"(email = %@)", _tfLoginInput.text];
        [fetchRequest setPredicate:pred];
        NSError *error;
        NSArray *matching_objects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        
        for(NSDictionary *ds in matching_objects)
            NSLog(@"ds %@",ds );
        
        
        if(![matching_objects count])
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self cellAlertMsg:@"Неправильный e-mail"];
            });
        }
        else{
            NSManagedObject *userObj = [matching_objects objectAtIndex:0];
            
            if([userObj valueForKey:@"email"])
            {
                if([[userObj valueForKey:@"pass"] isEqualToString:pass])
                {
                    dispatch_sync(dispatch_get_main_queue(), ^{ [self cellAlertMsg:@"Все верно"]; });
                    
                    PECMapViewController *viewCtrl = [self.storyboard instantiateViewControllerWithIdentifier:@"mapStoryID"];
                    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:viewCtrl] init];
                    [self presentViewController:navController animated:YES completion:nil];
                }
                else
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self cellAlertMsg:@"Неправильный пароль"];
                         });
            }
            else
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self cellAlertMsg:@"Неправильный e-mail"];
                });
            
        }
    }];

}




///*

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    
    if ([delegate performSelector:@selector(managedObjectContext)])
        context = [delegate managedObjectContext];

    return context;
}

//*/


// ~ Registration Button
- (IBAction)butReg:(UIButton *)sender
{
    PECRegViewCtrl *autorizationCardController = [self.storyboard instantiateViewControllerWithIdentifier:@"regStoryID"];
    [self.navigationController pushViewController: autorizationCardController animated:YES];
}

// ~ FOURSQUARE
- (IBAction)but4SQAuth:(UIButton *)sender
{

    if ([Foursquare2 isAuthorized])
    {
        NSLog(@"Autorization 4SQ. Close Session");
        [self userGetDetailData];
        
	} else{
        NSLog(@"NO Autorization 4SQ. Open Session");
        [Foursquare2 authorizeWithCallback:^(BOOL success, id result) {
            if (success)
            {
                [self userGetDetailData];
            }
        }];
    }
}

- (void)userGetDetailData
{
    [Foursquare2  userGetDetail:@"self"
                       callback:^(BOOL success, id result){
                           if (success)
                           {
                               NSDictionary *dic = result;

                               PECModelDataUser *modelUser = [[PECModelDataUser alloc] init];
                               modelUser.usName = [dic valueForKeyPath:@"response.user.firstName"];
                               modelUser.usMail = [dic valueForKeyPath:@"response.user.contact.email"];
                               
                               NSMutableArray *arr = [[NSMutableArray alloc] init];
                               [arr addObject:modelUser];
                               [PECModelDataUser setObjectData:arr];
                               
                               // Registration in Blule Card
                               if(false)
                               {
                                   PECMapViewController *viewCtrl = [self.storyboard instantiateViewControllerWithIdentifier:@"mapStoryID"];
                                   UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:viewCtrl] init];
                                   [self presentViewController:navController animated:YES completion:nil];
                                   
                               }else{
                                   PECRegViewCtrl *autorizationCardController = [self.storyboard instantiateViewControllerWithIdentifier:@"regStoryID"];
                                   [self.navigationController pushViewController: autorizationCardController animated:YES];
                               }
                           }
                       }];
}


// ~ FACEBOOK
- (IBAction)butFacebookAuth:(UIButton *)sender {
    PECAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate openFacebookSession];
    
//    PECAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
//    [appDelegate closeFacebookSession];
}

/*
// ------------------
// ----- GOOGLE -----
// ------------------
- (IBAction)butGoogleAuth:(UIButton *)sender {

    NSLog(@"GOOGLE");
    [Foursquare2 removeAccessToken];
}
 */

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

@end
