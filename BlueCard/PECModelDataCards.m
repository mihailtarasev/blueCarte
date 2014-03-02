//
//  PECModelDataCards.m
//  JamCard
//
//  Created by Admin on 11/28/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import "PECModelDataCards.h"

// ---- Серверные данные -----

// Получить все карты
static const NSString *sURL_CARD_GET_ALL = @"http://paladin-engineering.ru/data/jamSon.php";

// ---- Системные данные -----
static NSMutableArray *objJSON;

@implementation PECModelDataCards

+(NSMutableArray*)getObjJSON{ return [objJSON copy];}
+(void)setObjJSON: (NSMutableArray*)objJSONloc{ objJSON = objJSONloc; }


+(NSString*)URL_CARD_GET_ALL{ return [sURL_CARD_GET_ALL copy];}

@end




