//
//  PECMenuViewCtrl.m
//  BlueCarte
//
//  Created by Admin on 12/24/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import "PECMenuViewCtrl.h"
#import "PECTableActionCell.h"
#import "PECBuilderModel.h"
#import "PECModelDataCards.h"
#import "PECDetailViewCtrl.h"

@interface PECMenuViewCtrl ()


@property (strong, nonatomic) IBOutlet UITableView *tableViewControl;
@property (strong, nonatomic) IBOutlet NSDictionary *namesCardsFromTable;
@property (strong, nonatomic) IBOutlet NSArray *keysCardsFromTable;

@end

@implementation PECMenuViewCtrl

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // sort cards from ns disconary
    _namesCardsFromTable = [PECBuilderModel sortArrayAtLiters:[PECModelDataCards getObjJSON] nameKey:@"nameCompany"];
    NSArray *arrKey = [[_namesCardsFromTable allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    _keysCardsFromTable = arrKey;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)butBack:(UIButton *)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void) buttonClickTableCell: (id)sender
{
    PECDetailViewCtrl *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"detailStoryID"];
    //    checkin.venue = self.selected;
    [self.navigationController pushViewController:detail animated:YES];
}

// ----------------------------------------
// SHOW DATA TABLE.
// ----------------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int numSecIntable=1;
    
    numSecIntable = [_keysCardsFromTable count];
    
    return numSecIntable;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    NSString *sectionName =@"";
    sectionName = [_keysCardsFromTable objectAtIndex:section];
    
    return sectionName;//[self.sectionDateFormatter stringFromDate:dateRepresentingThisDay];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [_keysCardsFromTable objectAtIndex:section];
    NSArray * arrName = [[NSArray alloc] initWithObjects:[_namesCardsFromTable objectForKey:key], nil];
    int numRowsInSec = [arrName count];
    
    return numRowsInSec;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ActionTableCell";
    
    PECTableActionCell *cell = (PECTableActionCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PECActionTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
        NSString *key = [_keysCardsFromTable objectAtIndex:indexPath.section];
        NSArray *arrName = [[NSArray alloc] initWithObjects:[_namesCardsFromTable objectForKey:key], nil];

        cell.titleLabelTableCell.text = @"Сыр Маскарпоне";
        cell.nameLabelTableCell.text = [arrName objectAtIndex:indexPath.row];
    
        if([[arrName objectAtIndex:indexPath.row] isEqualToString:@"Zara"])
            cell.imageViewTableCell.image = [UIImage imageNamed:@"banner_food1.png"];
        else
            if([[arrName objectAtIndex:indexPath.row] isEqualToString:@"Avast"])
                cell.imageViewTableCell.image = [UIImage imageNamed:@"banner_food2.png"];
            else
                cell.imageViewTableCell.image = [UIImage imageNamed:@"banner_food3.png"];
    
    [cell.buttonClickTableCell setTag:1];
    [cell.buttonClickTableCell addTarget:self action:@selector(buttonClickTableCell:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

@end
