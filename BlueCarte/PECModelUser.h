//
//  PECModelUser.h
//  BlueCarte
//
//  Created by Admin on 12/19/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PECModelUser : NSObject

@property int usRegistration;
@property (strong, nonatomic) NSString *idUser;

@property (strong, nonatomic) NSString *usName;
@property (strong, nonatomic) NSString *usFamily;
@property (strong, nonatomic) NSString *usDate;
@property (strong, nonatomic) NSString *usNumPhone;
@property (strong, nonatomic) NSString *usMail;
@property (strong, nonatomic) NSString *usSex;

+(NSMutableArray*)getObjectData;
+(void)setObjectData: (NSMutableArray*)objDataloc;

@end
