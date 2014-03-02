//
//  PECNetworkDataCtrl.m
//  BlueCarte
//
//  Created by Admin on 2/7/14.
//  Copyright (c) 2014 Paladin-Engineering. All rights reserved.
//

#import "PECNetworkDataCtrl.h"
#import "PECModelsData.h"
#import "PECBuilderModel.h"

// Базовый путь к серверу
static NSString const * BASE_URL = @"http://109.120.150.225:90/";

// Данные партнеров которые ближе всего к пользователю
static NSString const * GET_USERINFOS = @"userinfos/?";

@implementation PECNetworkDataCtrl{
    NSData *responseData;
}

// СИСТЕМНЫЕ
/*
// Асинхронный Get запрос к серверу
- (void)asynchronousRequest:(NSString*) url params: (NSString*) params callback:(void (^)(id)) callback
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:url]];
    [request setURL:[[NSURL alloc] initWithString:url]];
    [request setHTTPMethod:@"GET"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:url]]
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         responseData = data;
         callback(self);
     }];
}
 */

// Асинхронный Post/Put запрос к серверу
- (void)asynPostReq:(NSString*)metod url: (NSURL*) url params: (NSString*) params callback:(void (^)(id)) callback
{
    
    NSLog(@"params!! %@",params);
    
    NSString *post =[[NSString alloc] initWithFormat:@"%@",params];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    //[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setURL:url];
    [request setHTTPMethod:metod];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"Token 894453e683054a733bc86f9b737259b05f2ff8d9" forHTTPHeaderField:@"Authorization"];
    
    [request setHTTPBody:postData];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         responseData = nil;
         responseData = data;
         
         NSLog(@"responseData %@", responseData);
         
         callback(self);
     }];
}


// Асинхронный Get запрос к серверу
- (void)asynGetReq:(NSString*)metod url: (NSURL*) url params: (NSString*) params callback:(void (^)(id)) callback
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"Token 894453e683054a733bc86f9b737259b05f2ff8d9" forHTTPHeaderField:@"Authorization"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         responseData = nil;
         responseData = data;
         callback(self);
     }];
}

// Скачивание данных всех пользователей
- (void)getALLUserDataServer:(void (^)(id)) callback
{
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@format=json",BASE_URL, GET_USERINFOS]];
    [self asynGetReq:@"GET"
              url:url
           params:nil
         callback:^(id sender){
             callback(self);
         }];
}

// Скачивание данных пользователя по email
- (void)getUserlDataServerFromEmai:(NSString*)email callback:  (void (^)(id)) callback
{
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@&format=json",BASE_URL,GET_USERINFOS,email]];
    [self asynGetReq:@"GET"
                 url:url
              params:nil
            callback:^(id sender){
                
                 NSError *nError;
                [PECModelsData setModelUser:[PECBuilderModel parserJSONUsers:responseData error:&nError]];
                
                NSLog(@"responseData %@", responseData);
                callback(self);
            }];
}

// Регистрация пользователей
- (void)regUserDataServer: (NSString*) dataUser callback:(void (^)(id)) callback
{
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@format=json",BASE_URL, GET_USERINFOS]];
    [self asynPostReq:@"POST"
                         url:url
                      params:dataUser
                    callback:^(id sender){
                        NSError *nError;
                        [PECModelsData setModelUser:[PECBuilderModel parserJSONRegUsers:responseData error:&nError]];
                        callback(self);
                    }];
}


@end
