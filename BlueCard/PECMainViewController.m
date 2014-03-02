//
//  PECMainViewController.m
//  BlueCarte
//
//  Created by Admin on 12/23/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import "PECMainViewController.h"
#import "PECPriceViewCtrl.h"

@interface PECMainViewController ()

@end

@implementation PECMainViewController
{

    UIView *selectContainerView;

}

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
	// Do any additional setup after loading the view.
    
    // Hidden Navigation bar
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    // White Status Bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    
    
    [self initElementsViewController];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PECActionScreen" owner:self options:nil];
    //PECPriceViewCtrl *priceWindowNib = [[PECPriceViewCtrl alloc]init];
    //priceWindowNib =;
    
    
    //[selectContainerView addSubview:[nib objectAtIndex:0]];
}

- (void)initElementsViewController
{
    selectContainerView = (UIView*)[self.view viewWithTag:104];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
