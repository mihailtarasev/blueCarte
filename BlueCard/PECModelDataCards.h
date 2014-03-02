//
//  PECModelDataCards.h
//  JamCard
//
//  Created by Admin on 11/28/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PECMainModel.h"

@interface PECModelDataCards : PECMainModel

@property int cardActivate;
@property (strong, nonatomic) NSString *idCard;
@property (strong, nonatomic) NSString *numberCard;
@property (strong, nonatomic) NSString *nameCard;

@property (strong, nonatomic) NSString *formatCard;
@property (strong, nonatomic) NSString *numberPartberCard;
@property (strong, nonatomic) NSString *statusCard;
@property (strong, nonatomic) NSString *idUserCard;
@property (strong, nonatomic) NSString *descCard;
@property (strong, nonatomic) NSString *dateActivateCard;
@property (strong, nonatomic) NSString *urlImgCard;
@property (strong, nonatomic) NSData *dataImgCard;
@property (strong, nonatomic) UIView *uiCards;
@property (strong, nonatomic) NSString *nameCompany;







+(NSString*)URL_CARD_GET_ALL;


+(NSMutableArray*)getObjJSON;
+(void)setObjJSON: (NSMutableArray*)objJSONloc;

@end