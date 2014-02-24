//
//  PECObjectCard.h
//  JamCard
//
//  Created by Admin on 12/10/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PECObjectCard : UIView

-(UIView*)inWithParamImageCard:(UIImage*) imageCard
                 cardImagesFrame: (CGRect) cardImagesFrame
                   tagFromObject: (int) tagFromObject
                      uiViewCntr: (UIViewController*) uiViewCntr
                activationCard: (int) activationCard;

+(void) activateDeActivateCardView: (UIView*) viewCard activation: (int) activation;

@end
