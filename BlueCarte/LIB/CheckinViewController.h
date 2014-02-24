//
//  CheckinViewController.h
//  Foursquare2-iOS
//
//  Created by Constantine Fry on 1/21/13.
//
//

#import <UIKit/UIKit.h>

@class FSVenue;
@interface CheckinViewController : UIViewController

- (IBAction)butBack:(UIButton *)sender;

@property (strong, nonatomic) FSVenue *venue;

@end
