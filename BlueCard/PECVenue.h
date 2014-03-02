//
//  PECVenue.h
//  BlueCarte
//
//  Created by Admin on 12/23/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface PECLocation : NSObject {
    CLLocationCoordinate2D _coordinate;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,strong)NSNumber *distance;
@property (nonatomic,strong)NSString *address;

@end

@interface PECVenue : NSObject<MKAnnotation>

@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *venueId;
@property (nonatomic,strong)PECLocation *location;

@end



















