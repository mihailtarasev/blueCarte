//
//  PECSettingsViewCtrl.m
//  BlueCarte
//
//  Created by Admin on 12/19/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import "PECSettingsViewCtrl.h"
#import "PECViewController.h"
#import "PECModelDataUser.h"
#import "PECModelsData.h"

@interface PECSettingsViewCtrl ()

// Scroll Page
@property (strong, nonatomic) IBOutlet UIScrollView *headerScrollView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *headerSegmentControl;
@property (nonatomic) BOOL usedScrollControl;


@property (strong, nonatomic) IBOutlet UITextField *tfNameInput;
@property (strong, nonatomic) IBOutlet UITextField *tfPhoneInput;
@property (strong, nonatomic) IBOutlet UITextField *tfeMailInput;

@end

@implementation PECSettingsViewCtrl

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
    
    
    PECModelDataUser *user = [[PECModelDataUser alloc]init];
    
    if(user!=nil){
        user = [[PECModelsData getModelUser] objectAtIndex:0];
        _tfNameInput.text = user.usName;
        _tfPhoneInput.text = user.usNumPhone;
        _tfeMailInput.text = user.usMail;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)butBack:(UIButton *)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}
- (IBAction)butLogOut:(UIButton *)sender
{
    
    [PECModelsData setModelUser:NULL];
    
    
    PECViewController *viewCtrl = [self.storyboard instantiateViewControllerWithIdentifier:@"autorizationStoryID"];
    UINavigationController *navController = [[[UINavigationController alloc] initWithRootViewController:viewCtrl] init];
    [self presentViewController:navController animated:YES completion:nil];
}


// -------------- SEGMENT CONTROL--------------
- (IBAction)secSegmentCtrlClick:(UISegmentedControl *)sender{
    
    self.usedScrollControl = YES;
    
    if(sender.selectedSegmentIndex == 0)
        [_headerScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    if(sender.selectedSegmentIndex == 1)
        [_headerScrollView setContentOffset:CGPointMake(320, 0) animated:YES];
    
    if(sender.selectedSegmentIndex == 2)
        [_headerScrollView setContentOffset:CGPointMake(640, 0) animated:YES];
    
}

// --------------------- Scroll View -------------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.usedScrollControl && scrollView == _headerScrollView) {
        [self darkerTheBackground:scrollView.contentOffset.x];
    }
}

- (void)darkerTheBackground:(CGFloat)xOffSet
{
    if (xOffSet != 0) {
        CGFloat pageWidth = _headerScrollView.frame.size.width;
        int page = floor((xOffSet - pageWidth / 2) / pageWidth) + 1;
        _headerSegmentControl.selectedSegmentIndex = page;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == _headerScrollView) {
        self.usedScrollControl = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _headerScrollView) {
        self.usedScrollControl = NO;
    }
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
