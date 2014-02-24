//
//  PECModelUser.m
//  BlueCarte
//
//  Created by Admin on 12/19/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import "PECModelUser.h"

static NSMutableArray *objData;

@implementation PECModelUser

+(NSMutableArray*)getObjectData{ return [objData copy];}
+(void)setObjectData: (NSMutableArray*)objJSONloc{ objData = objJSONloc;}

@end
