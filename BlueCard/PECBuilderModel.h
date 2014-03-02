//
//  PECBuilderModelCard.h
//  JamCard
//
//  Created by Admin on 11/28/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PECBuilderModel : NSObject

+ (NSMutableArray *)groupsFromJSON:(NSData *)objectNotation error:(NSError **)error objectModel: (NSString*)model;
//- (void)getDataAtCard: (NSString*)urlStr;
+ (NSMutableArray*)arrObjectsCards;
+(NSDictionary*)sortArrayAtLiters: (NSMutableArray*) arrayObjects nameKey:(NSString*) nameKey;

// Парсер модель пользователей
+ (NSMutableArray *)parserJSONUsers:(NSData *)objectNotation error:(NSError **)error;

// Парсер модель регистрации пользователей
+ (NSMutableArray *)parserJSONRegUsers:(NSData *)objectNotation error:(NSError **)error;

@end
