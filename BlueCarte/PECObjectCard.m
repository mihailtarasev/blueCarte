//
//  PECObjectCard.m
//  JamCard
//
//  Created by Admin on 12/10/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import "PECObjectCard.h"

@implementation PECObjectCard


/* 
 Card subview at:
 
 - Background Image
 - Plus Image
 - Up Button on Click
*/
-(UIView*)inWithParamImageCard:(UIImage*) imageCard
                  cardImagesFrame: (CGRect) cardImagesFrame
                    tagFromObject: (int) tagFromObject
                       uiViewCntr: (UIViewController*) uiViewCntr
                    activationCard:(int)activationCard
{
    
    // Settings
    tagFromObject += 1000;
    
    UIView * containerCards = [[UIView alloc]initWithFrame:cardImagesFrame];
    
    // Image Card
    CGRect cardImagesCont = CGRectMake( 0, 0, cardImagesFrame.size.width, cardImagesFrame.size.height);
    UIImageView *imgCard = [[UIImageView alloc]initWithFrame:cardImagesCont];
    imgCard.image = imageCard;
    imgCard.layer.cornerRadius = (cardImagesFrame.size.width/100.0f)*5;
    imgCard.layer.masksToBounds = YES;
    [containerCards addSubview:imgCard];
        
    // Navigations Panel
    CGRect cardNavPanel;
    
    if(!activationCard)
        cardNavPanel = CGRectMake( 0, 0, cardImagesFrame.size.width, cardImagesFrame.size.height);
    else
        cardNavPanel = CGRectMake( 0, cardImagesFrame.size.height-30, cardImagesFrame.size.width, 30);
    
    UIView *uiCardNavPanel = [[UIView alloc]initWithFrame:cardNavPanel];
    [uiCardNavPanel setBackgroundColor:[UIColor whiteColor]];
    [uiCardNavPanel setAlpha:0.4f];
    [uiCardNavPanel setTag: 3];
    [containerCards addSubview:uiCardNavPanel];

    // TextView Distance
    CGRect cardDistance = CGRectMake( cardNavPanel.size.width-40, cardNavPanel.size.height-20, 30, 10);
    UILabel *lbCardDistance = [[UILabel alloc]initWithFrame:cardDistance];
    [lbCardDistance setFont:[UIFont fontWithName:@"Helvetica" size:10]];
    [lbCardDistance setText:@"100 m"];
    [lbCardDistance setTag: 4];
    [uiCardNavPanel addSubview:lbCardDistance];
    
    // Image Plus
    CGRect cardImagesPlus = CGRectMake( 7, 7, 37, 37);
    UIImageView *imgCardPlus = [[UIImageView alloc]initWithFrame:cardImagesPlus];
    imgCardPlus.image = [UIImage imageNamed:@"plus_card"];
    [imgCardPlus setTag: 2];

    [containerCards addSubview:imgCardPlus];
    
    if(activationCard)
    {
        [imgCardPlus setHidden:true];
    }else{
        [imgCardPlus setHidden:false];
    }

    
    // Button Card Up Image
    UIButton *button = [[UIButton alloc] initWithFrame: cardImagesCont];
    [button setTitle: @"" forState: UIControlStateNormal];
    [button setTitleColor: [UIColor redColor] forState: UIControlStateNormal];
    [button setTag: tagFromObject-1];
    [button addTarget: uiViewCntr
               action: @selector(buttonCardClicked:)
     forControlEvents: UIControlEventTouchDown];
    [containerCards addSubview:button];
        
    return containerCards;
    
}

/*
for(UIView *view in [uiDardActivatePlus subviews])
{
    [[view viewWithTag:2] setHidden:true];
    CGRect cardNavPanel = CGRectMake( 0, [view viewWithTag:3].frame.size.height-30, [view viewWithTag:3].frame.size.width, 30);
    [[view viewWithTag:3] setFrame:cardNavPanel];
    CGRect cardDistance = CGRectMake( [view viewWithTag:3].frame.size.width-40, [view viewWithTag:3].frame.size.height-20, 30, 10);
    [[view viewWithTag:4] setFrame:cardDistance];
}
*/


+(void) activateDeActivateCardView: (UIView*) viewCard activation: (int) activation
{

    CGRect cardNavPanel; CGRect cardDistance;
    
    for(UIView *view in [viewCard subviews])
    {
        if(!activation)
        {
            // de activation
            [[view viewWithTag:2] setHidden:false];
            cardNavPanel = CGRectMake( 0, 0, viewCard.frame.size.width, viewCard.frame.size.height);
            cardDistance = CGRectMake( viewCard.frame.size.width-40, viewCard.frame.size.height-20, 30, 10);
        }
        else{
            // activation
            [[view viewWithTag:2] setHidden:true];
            cardNavPanel = CGRectMake( 0, viewCard.frame.size.height-30, viewCard.frame.size.width, 30);
            cardDistance = CGRectMake( viewCard.frame.size.width-40, 10, 30, 10);
        }
        
       [[view viewWithTag:3] setFrame:cardNavPanel];
       [[view viewWithTag:4] setFrame:cardDistance];
        
    }

}


@end
