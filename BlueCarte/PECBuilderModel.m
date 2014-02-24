//
//  PECBuilderModelCard.m
//  JamCard
//
//  Created by Admin on 11/28/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import "PECBuilderModel.h"
#import "PECModelDataCards.h"
#import "PECMainModel.h"
#import "PECModelDataUser.h"
#import <CoreData/CoreData.h>

@implementation PECBuilderModel

static NSMutableArray* sArrObjectsCards;

// Static Data from Cards
+(NSMutableArray*)arrObjectsCards{ return [sArrObjectsCards copy];}

//------------------------------
// Get Data From Images
//------------------------------
/*
+(UIImage*) getImagesCardsFromInternetURL:(NSString*)ImageURL
{
    NSURL *url = [NSURL URLWithString: ImageURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [[UIImage alloc] initWithData:data];
    return image;
}*/

// Общий для всех запросов парсинг ошибок и данных
+ (NSArray*)getArrayFromJsonDataServer:(NSData *)objectNotation error:(NSError **)error
{
    if(objectNotation==nil){NSLog(@"Warning: objectNotation == nil"); return false;}
    
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    NSArray *data = [[NSArray alloc]init];
    
    data = [parsedObject valueForKey:@"results"];

    /*
    // Если не возврощает блок данных инициируем плохой запрос и разбираем ошибки
    if(parsedObject.count<=2)
    {
        NSString *errorCode = [parsedObject valueForKey:@"error_code"];
        NSString *errorMsg = [parsedObject valueForKey:@"error_msg"];
        NSLog(@"errorCode:%@ errorMsg:%@",errorCode,errorMsg);
    }else
        
        if (localError != nil)
        {
            *error = localError;
            NSLog(@"localError %@", localError);
            return false;
        }else
            data = [parsedObject valueForKey:@"results"];
    */
    
    return data;
}

/*
// Парсер модель пользователей
+ (NSMutableArray *)parserJSONUsers:(NSData *)objectNotation error:(NSError **)error
{
    NSArray *data = [self getArrayFromJsonDataServer:objectNotation error:error];//[[NSArray alloc]initWithObjects:, nil];
    
    NSLog(@"[data count] %i",[data count]);
    
    if([data count]==0) return nil;
    if([data count]>1) return nil;
    
    NSMutableArray *groups = [[NSMutableArray alloc] init];
    
    for (NSDictionary *items in data)
    {
        PECModelDataUser *resParse   = [[PECModelDataUser alloc]init];
        
        resParse.idUser     = [items[@"id"] integerValue];
        resParse.usName     = items[@"name"];
        resParse.usDate     = items[@"birthday"];
        resParse.usMail     = items[@"email"];
        resParse.usPass     = items[@"password"];
        resParse.usSex      = items[@"u_sex"];
        
        [groups addObject:resParse];
    }
    
    return groups;
}
*/

// Парсер модель пользователей
+ (NSMutableArray *)parserJSONUsers:(NSData *)objectNotation error:(NSError **)error
{
    NSArray *data = [self getArrayFromJsonDataServer:objectNotation error:error];//[[ alloc]initWithObjects:, nil];
    
    if([data count]==0) return nil;

    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)])
        context = [delegate managedObjectContext];
    

    
    
    for (NSDictionary *items in data)
    {
        NSError *error;
/*
        
        // Если такой пользователь уже существует в базе (в хэше) пропускаем его запись
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"(email = %@)", items[@"email"]];
        [fetchRequest setPredicate:pred];
        NSArray *matching_objects = [context executeFetchRequest:fetchRequest error:&error];
        
        if([matching_objects count]) {
         
            NSLog(@"exist");
            continue;
            
        }
        
        
       // NSLog(@"1212");
        
        */
        
        // Create a new managed object
        NSManagedObject *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
        
        [newUser setValue:items[@"name"] forKey:@"name"];
        [newUser setValue:items[@"email"] forKey:@"email"];
        [newUser setValue:items[@"password"] forKey:@"pass"];

        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }

    }
    
    return nil;
}

// Парсер модель регистрации пользователей
+ (NSMutableArray *)parserJSONRegUsers:(NSData *)objectNotation error:(NSError **)error
{
    //NSArray *data = [self getArrayFromJsonDataServer:objectNotation error:error];//[[NSArray alloc]initWithObjects:, nil];
    
    
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    NSArray *data = [[NSArray alloc]initWithObjects:parsedObject, nil];
    
    
    NSLog(@"localError %@",localError);
    
    NSLog(@"parsedObject %@",parsedObject);
    
    NSLog(@"parsedObject count %i",[parsedObject count]);
    
    if([parsedObject count]==1) return nil;
    if([parsedObject count]==2) return nil;
    
    NSLog(@"[data count] %i",[data count]);
    
    if([data count]==0) return nil;
    if([data count]>1) return nil;
    
    NSMutableArray *groups = [[NSMutableArray alloc] init];
    
    for (NSDictionary *items in data)
    {
        PECModelDataUser *resParse   = [[PECModelDataUser alloc]init];
        
        resParse.idUser     = [items[@"id"] integerValue];
        resParse.usName     = items[@"name"];
        //        resParse.usFamily   = items[@"u_family"];
        resParse.usDate     = items[@"birthday"];
        resParse.usMail     = items[@"email"];
        
        resParse.usPass     = items[@"password"];
        
        
        //        resParse.usTelephone = userTel;
        resParse.usSex      = items[@"u_sex"];
        
        [groups addObject:resParse];
    }
    
    return groups;
}


/*
//------------------------------
// Parser JSON OBJECT
//------------------------------
+ (NSMutableArray *)groupsFromJSON:(NSData *)objectNotation error:(NSError **)error objectModel: (NSString*)modelObject
{
    NSError *localError = nil;
    
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
//    NSArray *response = [parsedObject valueForKey:@"response"];
    NSArray *response = [parsedObject valueForKey:@"results"];
    
    NSMutableArray *groups = [[NSMutableArray alloc] init];
    int incObj = 1000;
    for (NSDictionary *items in response)
    {
        
        NSDictionary *resParse = resParse;
        
        PECMainModel *model = [[NSClassFromString(modelObject) alloc] init];
        
        for (NSString *key in resParse)
        {
            if ([model respondsToSelector:NSSelectorFromString(key)])
            {
                [model setValue:[resParse valueForKey:key] forKey:key];
                
               // NSLog(@"%@ %@", key, [resParse valueForKey:key]);
            }
        }
        
        [groups addObject:model];
        
        model.progrId = incObj++;
    }
    
    return groups;
}*/


+ (NSMutableArray *)groupsFromJSON:(NSData *)objectNotation error:(NSError **)error objectModel: (NSString*)modelObject
{
    NSError *localError = nil;
    
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    //    NSArray *response = [parsedObject valueForKey:@"response"];
    NSArray *response = [parsedObject valueForKey:@"results"];
    
    NSMutableArray *groups = [[NSMutableArray alloc] init];
    int incObj = 1000;
    for (NSDictionary *items in response)
    {
        
        NSDictionary *resParse = resParse;
        
        
        PECMainModel *model = [[NSClassFromString(modelObject) alloc] init];
        
        for (NSString *key in resParse)
        {
            if ([model respondsToSelector:NSSelectorFromString(key)])
            {
                [model setValue:[resParse valueForKey:key] forKey:key];
                
                // NSLog(@"%@ %@", key, [resParse valueForKey:key]);
            }
        }
        
        [groups addObject:model];
        
        model.progrId = incObj++;
    }
    
    return groups;
}


+(NSDictionary*)sortArrayAtLiters: (NSMutableArray*) arrayObjects nameKey:(NSString*) nameKey
{
    
    
    NSMutableArray *keys = [[NSMutableArray alloc]init];
    NSMutableArray *values= [[NSMutableArray alloc]init];

    for(PECModelDataCards *obj in arrayObjects)
    {
        NSString *valueKey = obj.nameCompany;//[obj valueForKey:nameKey];
        
        [values addObject:valueKey];
        
        [keys addObject:[NSString stringWithFormat:@"%@",[valueKey substringToIndex:1]]];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjects:values forKeys:keys];

    return  dict;

}






//------------------------------
// Get Data from Internet
//------------------------------
/*
- (void)getDataAtCard:(NSString *)urlStr
{
    NSURL *url = [[NSURL alloc] initWithString:urlStr];
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
        } else {
            NSError *nError;
        }
    }];
}
*/


@end
