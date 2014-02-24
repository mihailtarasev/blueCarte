//
//  CheckinViewController.m
//  Foursquare2-iOS
//
//  Created by Constantine Fry on 1/21/13.
//
//

#import "CheckinViewController.h"
#import "Foursquare2.h"
#import "FSVenue.h"

@interface CheckinViewController ()

@property (weak, nonatomic) IBOutlet UILabel *venueName;
@property (weak, nonatomic) IBOutlet UIButton *uploadPhotButton;
@property (strong, nonatomic) NSString *checkin;

- (IBAction)checkin:(id)sender;
@end

@implementation CheckinViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Checkin";
    self.venueName.text = self.venue.name;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)checkin:(id)sender {
    /*
    [Foursquare2 checkinAddAtVenue:self.venue.venueId
                             shout:@"Testing"
                          callback:^(BOOL success, id result) {
                              if (success) {
                                  self.checkin = [result valueForKeyPath:@"response.checkin.id"];
                                  [self showAlertViewWithTitle:@"Checkin Successfull"];
                                  self.uploadPhotButton.enabled = YES;
                              }
                          }];
     */
}

- (IBAction)addPhoto:(id)sender {
    /*
    [Foursquare2 photoAdd:[UIImage imageNamed:@"testimage@2x.png"]
                toCheckin:self.checkin
                 callback:^(BOOL success, id result) {
                     if (success) {
                         [self showAlertViewWithTitle:@"Photo was added"];
                     }
                }];
     */
}

- (void)showAlertViewWithTitle:(NSString *)title {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}


- (IBAction)butBack:(UIButton *)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
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
