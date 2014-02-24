//
//  PECBuilderCards.m
//  JamCard
//
//  Created by Admin on 12/2/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import "PECBuilderCards.h"
#import "PECObjectCard.h"
#import "PECModelDataCards.h"

@implementation PECBuilderCards
{
    int marginCards;
    int countCardsAtWidth;
    float widthDiscontCard;
    float heightDiscontCard;
    int offsetXContView;
    int cardInContainerX;
    int cardInContainerY;
    int kCrdInCt;
    int tagFromObject;
    int tagFromContent;
    
    UIView *containerCards;

}



// ----------------------------------------
// SHOW CARDS.
// ----------------------------------------
- (void)addCardsToScrollView : (NSMutableArray*) objJSON
                  contentView:(UIView*) contentView
             headerScrollView:(UIScrollView*) headerScrollView
            headerPageControl:(UIPageControl*) headerPageControl
                   uiViewCntr: (UIViewController*) uiViewCntr
               dinamicContent: (BOOL) dinamicContent
{
    
    // SETTINGS VIEWCARD IN CONTAINER
    // tagFromObject = 1000
    // 0 - 999 reserved tag!
    countCardsAtWidth = 1; // количество карт по ширине
    marginCards = 7.0f;   // отступы между картами
    //-------------------------------
    
    widthDiscontCard = (320.0f-(marginCards * (countCardsAtWidth+1.0f)))/countCardsAtWidth;
    heightDiscontCard = widthDiscontCard * 0.6f;
    
    int countCardsInContainer = ((contentView.frame.size.height-(marginCards * (countCardsAtWidth+1.0f))) / heightDiscontCard) * countCardsAtWidth;
    
    if (!countCardsInContainer) countCardsInContainer=1;
    
    int countCards = objJSON.count;
    float countSliders = ceilf((float)countCards/ (float)countCardsInContainer);
    
    
    CGFloat widthSliderContainer =  countSliders * 320.0f;
    CGRect oldFrame = contentView.frame;
    CGFloat heightSliderContainer =  oldFrame.size.height;
    
    if(dinamicContent){
        countSliders = 1;
        widthSliderContainer = 320.0f;
        heightSliderContainer = (countCards / countCardsAtWidth) * heightDiscontCard + (marginCards*2);
        headerScrollView.pagingEnabled = false;
    }
    
    CGRect newFrame = CGRectMake( oldFrame.origin.x, oldFrame.origin.y, widthSliderContainer, heightSliderContainer);
    contentView.frame = newFrame;
    headerScrollView.contentSize = contentView.frame.size;
    headerPageControl.numberOfPages = (int)countSliders;
    
    offsetXContView = -320; tagFromObject=0; tagFromContent=0;
    
    for(NSObject *obj in objJSON){

        UIImage *image = [self createImageViewFromObj:obj];
        
        // Asynh loading images from url
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{

            // Create and calc position new Container
            if(tagFromContent%(countCardsInContainer) == 0)
            {
                containerCards = [[UIView alloc]initWithFrame:CGRectMake( offsetXContView+=320, -100, 320, 320 )];
                cardInContainerX = marginCards; cardInContainerY = marginCards;
            }
            
            // Calc Position Cards in Container
            if(tagFromContent%(countCardsAtWidth) == 0 ){
                cardInContainerY+=(heightDiscontCard + marginCards); cardInContainerX = marginCards; kCrdInCt+=1;
            }else
                cardInContainerX += (widthDiscontCard+marginCards);
            
            // inc Object in Container
            
            tagFromContent++;
            
            CGRect cardImagesFrame = CGRectMake( cardInContainerX, cardInContainerY, widthDiscontCard, heightDiscontCard );
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                PECObjectCard *objCard = [[PECObjectCard alloc]init];
                
                //NSLog(@"tagFromObject %i", tagFromObject);
                
                // Create Object Card
                tagFromObject++;
                
                UIView *ObjCardView = [objCard inWithParamImageCard:image cardImagesFrame:cardImagesFrame tagFromObject:tagFromObject uiViewCntr:uiViewCntr activationCard:((PECModelDataCards*)obj).cardActivate ];
                

                if (dinamicContent)
                {
                    if(((PECModelDataCards*)obj).cardActivate)
                        [containerCards addSubview:ObjCardView];
                }else
                    [containerCards addSubview:ObjCardView];
                
                //ObjCardView
                ((PECModelDataCards*)obj).uiCards = ObjCardView;

                
                // Add container cards to Scroll
                [contentView addSubview:containerCards];
            });
        });
    }
    
}


-(UIImage *)createImageViewFromObj: (NSObject*) obj
{

    // Create IMAGE
    NSData *data;
    NSData *dataImgCard = [obj valueForKey:@"dataImgCard"];
    if(dataImgCard != NULL){
        // Data Exist CREATE CARDS
        data = dataImgCard;
    }else{
        // Loading Images From URL. CREATE CARDS
        NSURL *url = [NSURL URLWithString: [obj valueForKey:@"urlImgCard"]];
        data = [NSData dataWithContentsOfURL:url];
        [obj setValue:data forKey:@"dataImgCard"];
    }
    
    return [UIImage imageWithData:data];
}

@end
