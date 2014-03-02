//
//  PECTableActionCell.h
//  JamCard
//
//  Created by Admin on 12/3/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PECTableActionCell : UITableViewCell



@property (nonatomic, weak) IBOutlet UILabel *nameLabelTableCell;
@property (nonatomic, weak) IBOutlet UILabel *titleLabelTableCell;
//@property (nonatomic, weak) IBOutlet UILabel *prepTimeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewTableCell;
@property (nonatomic, weak) IBOutlet UIButton *buttonClickTableCell;

@end
