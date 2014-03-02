//
//  PECVenue.m
//  BlueCarte
//
//  Created by Admin on 12/23/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import "PECVenue.h"

@implementation PECLocation

@end

@implementation PECVenue
- (id)init {
    self = [super init];
    if (self) {
        self.location = [[PECLocation alloc]init];
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate {
    return self.location.coordinate;
}

- (NSString *)title {
    return self.name;
}
@end