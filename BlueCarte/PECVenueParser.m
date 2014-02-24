//
//  PECVenueParser.m
//  BlueCarte
//
//  Created by Admin on 12/23/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import "PECVenueParser.h"
#import "PECVenue.h"

@implementation PECVenueParser
- (NSArray *)convertToObjects:(NSArray *)venues {
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:venues];
    for (NSDictionary *v  in venues) {
        PECVenue *ann = [[PECVenue alloc]init];
        ann.name = v[@"name"];
        ann.venueId = v[@"id"];
        
        ann.location.address = v[@"location"][@"address"];
        ann.location.distance = v[@"location"][@"distance"];
        
        
        NSLog(@"address %@",v[@"location"][@"address"]);
        NSLog(@"distance %@",v[@"location"][@"distance"]);
        
        [ann.location setCoordinate:CLLocationCoordinate2DMake([v[@"location"][@"lat"] doubleValue],
                                                               [v[@"location"][@"lng"] doubleValue])];
        [objects addObject:ann];
    }
    return objects;
}
@end
