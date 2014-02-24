//
//  PECModelDataUser.m
//  JamCard
//
//  Created by Admin on 12/4/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import "PECModelDataUser.h"

static NSMutableArray *objData;

@implementation PECModelDataUser

+(NSMutableArray*)getObjectData{ return [objData copy];}
+(void)setObjectData: (NSMutableArray*)objJSONloc{ objData = objJSONloc;}
@end
