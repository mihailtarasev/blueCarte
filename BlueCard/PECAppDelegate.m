//
//  PECAppDelegate.m
//  BlueCard
//
//  Created by Admin on 12/12/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import "PECAppDelegate.h"
#import "PECViewController.h"
#import "PECRegViewCtrl.h"
#import "Foursquare2.h"

@implementation PECAppDelegate

@synthesize window = _window;


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
//    return [FBSession.activeSession handleOpenURL:url];
    
    NSLog(@"sourceApplication %@",sourceApplication);
    
    return [Foursquare2 handleURL:url];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // FORSQUARE
    [Foursquare2 setupFoursquareWithClientId:@"5P1OVCFK0CCVCQ5GBBCWRFGUVNX5R4WGKHL2DGJGZ32FDFKT"
                                      secret:@"UPZJO0A0XL44IHCD1KQBMAYGCZ45Z03BORJZZJXELPWHPSAR"
                                 callbackURL:@"testapp123://foursquare"];
    
    // FACEBOOK
    /*
    // See if the app has a valid token for the current state.
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        // To-do, show logged in view
        [self openFacebookSession];
    } else {
        // No, display the login page.
        [self showLoginView];
    }
     */

    return YES;
}

- (void)showLoginView
{
    //UIViewController *topViewController = [self.navController topViewController];
    
    //PECRegViewCtrl* loginViewController =
    //[[SCLoginViewController alloc]initWithNibName:@"SCLoginViewController" bundle:nil];
    //[topViewController presentViewController:loginViewController animated:NO completion:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}
/*
#pragma mark - URL handler

- (void)openFacebookSession
{
    [FBSession openActiveSessionWithReadPermissions:@[@"basic_info",@"email"]
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
}

- (void)closeFacebookSession {
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error {
    switch (state) {
        case FBSessionStateOpen: {
            //Save the used SocialAccountType so it can be retrieved the next time the app is started.
            
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
            PECRegViewCtrl *destCon = [storyboard instantiateViewControllerWithIdentifier:@"autorizationStoryID"];
            UINavigationController *navController =(UINavigationController *) self.window.rootViewController;
            [navController pushViewController:destCon animated:YES];
           
 //!!!
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
            PECRegViewCtrl *destCon = [storyboard instantiateViewControllerWithIdentifier:@"autorizationStoryID"];
            UINavigationController *navController =(UINavigationController *) self.window.rootViewController;
            [navController pushViewController:destCon animated:YES];
 
//!!!!            
            NSLog(@"FBSessionStateOpen");
            
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            // Once the user has logged out, we want them to be looking at the root view.
           // [self.navigationController popToRootViewControllerAnimated:YES];
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Facebook Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}*/

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    //self.isNavigatingAwayFromLogin = NO;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //self.isNavigatingAwayFromLogin = (viewController != self.loginViewController);
}

@end
