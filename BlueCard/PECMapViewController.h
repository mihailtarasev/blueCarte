//
//  PECMapViewController.h
//  BlueCarte
//
//  Created by Admin on 12/18/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface PECMapViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, MKAnnotation>

@property (retain, nonatomic) IBOutlet UIView *actionContainer;
@property (retain, nonatomic) IBOutlet UIView *mapContainer;
@property (retain, nonatomic) IBOutlet UIView *spisokContainer;

- (IBAction)secSegmentCtrlClick:(UISegmentedControl *)sender;

- (IBAction)pageActionChanged:(UIPageControl *)sender;

- (IBAction)scrollActionChanged:(UIButton *)sender;

@end
