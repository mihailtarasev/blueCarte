//
//  PECBuilderCards.h
//  JamCard
//
//  Created by Admin on 12/2/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PECBuilderCards : NSObject

- (void)addCardsToScrollView : (NSMutableArray*) objJSON
                  contentView:(UIView*) contentView
             headerScrollView:(UIScrollView*) headerScrollView
            headerPageControl:(UIPageControl*) headerPageControl
                   uiViewCntr: (UIViewController*) uiViewCntr
               dinamicContent: (BOOL) dinamicContent;


@end
