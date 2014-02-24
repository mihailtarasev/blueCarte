//
//  PECNetworkDataCtrl.h
//  BlueCarte
//
//  Created by Admin on 2/7/14.
//  Copyright (c) 2014 Paladin-Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (DummyInterface)
+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;
@end

@interface PECNetworkDataCtrl : NSObject

// Скачивание данных всех пользователей
- (void)getALLUserDataServer:(void (^)(id)) callback;

// Скачивание данных пользователя по email
- (void)getUserlDataServerFromEmai:(NSString*)email callback:  (void (^)(id)) callback;

// Регистрация пользователей
- (void)regUserDataServer: (NSString*) dataUser callback:(void (^)(id)) callback;


// Скачивание данных всех пользователей
- (void)getLocationDataServer:(void (^)(id)) callback;

@end
