//
//  PECMapViewController.m
//  BlueCarte
//
//  Created by Admin on 12/18/13.
//  Copyright (c) 2013 Paladin-Engineering. All rights reserved.
//

#import "PECMapViewController.h"
#import "PECAnnotation.h"
#import "Foursquare2.h"
#import "FSConverter.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "FSVenue.h"
#import "PECVenue.h"
#import "PECSettingsViewCtrl.h"
#import "PECVenueParser.h"
#import "PECBuilderCards.h"
#import "PECModelDataCards.h"
#import "PECBuilderModel.h"
#import "PECTableActionCell.h"
#import "PECRestoranViewCtr.h"
#import "CheckinViewController.h"
#import "PECWantPointFSCtrl.h"

@interface PECMapViewController () <CLLocationManagerDelegate>

// ACTION Screen
@property (strong, nonatomic) IBOutlet UIView *contentActionView;
@property (strong, nonatomic) IBOutlet UIScrollView *headerScrollActionView;
@property (strong, nonatomic) IBOutlet UIPageControl *headerPageActionControl;
@property (nonatomic) BOOL usedPageActionControl;

// MAP Screen
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

// SPISOK SCREEN
@property (strong, nonatomic) IBOutlet UIView *allCardContainer;

@property (strong, nonatomic) IBOutlet UIScrollView *headerScrollViewAll;
@property (strong, nonatomic) IBOutlet UIPageControl *headerPageControlAll;
@property (strong, nonatomic) IBOutlet UIView *contentViewAll;


@property (strong, nonatomic) IBOutlet NSDictionary *namesCardsFromTable;
@property (strong, nonatomic) IBOutlet NSArray *keysCardsFromTable;


// Filter Map
@property (strong, nonatomic) IBOutlet UIView *mapCardContainer;

@property (strong, nonatomic) NSArray *nearbyVenues;
@property (strong, nonatomic) FSVenue *selected;

// Scroll Page
@property (strong, nonatomic) IBOutlet UIScrollView *headerScrollView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *headerSegmentControl;
@property (nonatomic) BOOL usedScrollControl;

@end

@implementation PECMapViewController
{
    UIView *actionContainerView;
    PECBuilderCards *builderCrds;
    NSArray *tableData;
    int tableRowControllerSelection;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    tableRowControllerSelection = 0;
    
    // Инициализация
    [self initElementsViewController];
    
    
    [self dataInitDataTableActions];
    
    [self PAGE_ACTION_CONTROL];
    
    //NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PECActionScreen" owner:self options:nil];
    //[actionContainerView addSubview:[nib objectAtIndex:0]];
    
    // Настройка mapkit
    [_mapView setShowsUserLocation:YES];
    [_mapView setDelegate:self];
    
    // Начальная координата
    [_mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(59.94397,30.107048), MKCoordinateSpanMake(0.4,0.4))];

    
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

- (void)initElementsViewController
{
    actionContainerView = (UIView*)[self.view viewWithTag:100];
}

// BLUECARTE MAPKIT
- (void)getVenuesBlueCarteForLocation
{
    NSString *urlAsString = @"http://paladin-engineering.ru/data/blueCarte.php";
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:urlAsString]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSError *nError;
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&nError];
         NSArray *venues = [dic valueForKeyPath:@"response.venues"];
         PECVenueParser *converter = [[PECVenueParser alloc]init];
         NSArray *nearbyPecVenues = [converter convertToObjects:venues];
         [self.mapView addAnnotations:nearbyPecVenues];
     }];
}

// FORSCQUARE MAPKIT
- (void)getVenuesForLocation:(CLLocation *)location
{
    NSString *catId = @"4d4b7105d754a06374d81259";
    
    [Foursquare2 venueSearchNearByLatitude:@(location.coordinate.latitude)
                                 longitude:@(location.coordinate.longitude)
                                     query:nil
                                     limit:nil
                                    intent:intentCheckin
                                    radius:@(500)
                                categoryId:catId
                                  callback:^(BOOL success, id result){
                                      if (success) {
                                          
                                          NSDictionary *dic = result;
                                          NSArray *venues = [dic valueForKeyPath:@"response.venues"];
                                          
                                          FSConverter *converter = [[FSConverter alloc]init];
                                          self.nearbyVenues = [converter convertToObjects:venues];
                                          //[self.tableView reloadData];
                                          [self proccessAnnotations];
                                          
                                      }
                                  }];
}

 - (void)removeAllAnnotationExceptOfCurrentUser
{
     NSMutableArray *annForRemove = [[NSMutableArray alloc] initWithArray:self.mapView.annotations];
     if ([self.mapView.annotations.lastObject isKindOfClass:[MKUserLocation class]]) {
         [annForRemove removeObject:self.mapView.annotations.lastObject];
     } else {
         for (id <MKAnnotation> annot_ in self.mapView.annotations) {
             if ([annot_ isKindOfClass:[MKUserLocation class]] ) {
                 [annForRemove removeObject:annot_];
                 break;
             }
         }
     }
 
     [self.mapView removeAnnotations:annForRemove];
 }
 

- (void)proccessAnnotations
{
//    [self removeAllAnnotationExceptOfCurrentUser];
    [self.mapView addAnnotations:self.nearbyVenues];
}


- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    [self.locationManager stopUpdatingLocation];
    [self getVenuesForLocation:newLocation];
    [self getVenuesBlueCarteForLocation];
    [self setupMapForLocatoion:newLocation];
}

- (void)setupMapForLocatoion:(CLLocation *)newLocation
{
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.003;
    span.longitudeDelta = 0.003;
    CLLocationCoordinate2D location;
    location.latitude = newLocation.coordinate.latitude;
    location.longitude = newLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
     [self.mapView setRegion:region animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if (annotation == mapView.userLocation)
        return nil;
    
    static NSString *s = @"ann";
    MKAnnotationView *pin = [mapView dequeueReusableAnnotationViewWithIdentifier:s];
    if (!pin)
    {
        pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:s];
        pin.canShowCallout = YES;
        pin.calloutOffset = CGPointMake(0, 0);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        if([annotation isKindOfClass:[FSVenue class]])
        {
            pin.image = [UIImage imageNamed:@"pin.png"];
            [button addTarget:self
                       action:@selector(checkinButton) forControlEvents:UIControlEventTouchUpInside];
        }

        if([annotation isKindOfClass:[PECVenue class]])
        {
            pin.image = [UIImage imageNamed:@"pin_paladin.png"];
            [button addTarget:self
                       action:@selector(magasineButtonPaladin) forControlEvents:UIControlEventTouchUpInside];
        }
        pin.rightCalloutAccessoryView = button;
    }
    return pin;
}

- (void)checkinButton
{
    self.selected = self.mapView.selectedAnnotations.lastObject;
    [self userDidSelectVenueFS];
}

- (void)magasineButtonPaladin
{
    PECRestoranViewCtr *checkin = [self.storyboard instantiateViewControllerWithIdentifier:@"restoranStoryID"];
    //    checkin.venue = self.selected;
    [self.navigationController pushViewController:checkin animated:YES];
}

// Пользователь нажал на точку которой нет в системе блюКарт
- (void)userDidSelectVenueFS
{
    [self wantPointFS];
}

// Переход на экран "Хочу иметь этот ресторан в системе БлоюКарт"
- (void)wantPointFS
{
    PECWantPointFSCtrl *pageWantPointFS = [self.storyboard instantiateViewControllerWithIdentifier:@"wantFSPointStoryID"];
    pageWantPointFS.venue = self.selected;
    [self.navigationController pushViewController:pageWantPointFS animated:YES];
}

// -------------- BLUECARTE ACTION --------------

/*
// Пользователь нажал на точку которой нет в системе блюКарт
- (void)userDidSelectVenue {
    
    [self wantPointFS];
    
    
     
     if ([Foursquare2 isAuthorized]) {
     [self wantPointFS];
     } else {
     [Foursquare2 authorizeWithCallback:^(BOOL success, id result) {
     if (success) {
     [Foursquare2  userGetDetail:@"self"
     callback:^(BOOL success, id result){
     if (success) {
     //                                           [self updateRightBarButtonStatus];
     [self wantPointFS];
     
     }
     }];
     }
     }];
     }

 }

#pragma mark - Table view delegate

- (void)checkin {
    CheckinViewController *checkin = [self.storyboard instantiateViewControllerWithIdentifier:@"checkInStoryID"];
    //    checkin.venue = self.selected;
    [self.navigationController pushViewController:checkin animated:YES];
}
 
*/
 

- (void)PAGE_ACTION_CONTROL
{
    builderCrds = [[PECBuilderCards alloc] init];
    
    // Loading data from internet
    //if(![PECModelDataCards getObjJSON].count){
#pragma mark - Page View Controller Loading Data Dards in objJSON
        [self getDataAtCardURL:[PECModelDataCards URL_CARD_GET_ALL] PARAMS:@"#"];
    //}else{
//        [builderCrds addCardsToScrollView:[PECModelDataCards getObjJSON] contentView:_contentActionView headerScrollView:_headerScrollView headerPageControl:_headerPageActionControl uiViewCntr:self dinamicContent:false];
    //}
}

- (void)getDataAtCardURL:(NSString*) URL PARAMS: (NSString*) PARAMS
{
    NSString *urlAsString = [NSString stringWithFormat:@"%@?%@",URL, PARAMS];
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:urlAsString]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         
         NSError *nError;
         [PECModelDataCards setObjJSON:[PECBuilderModel groupsFromJSON:data error:&nError objectModel:@"PECModelDataCards"]];
         
         [builderCrds addCardsToScrollView:[PECModelDataCards getObjJSON] contentView:_contentActionView headerScrollView:_headerScrollView headerPageControl:_headerPageActionControl uiViewCntr:self dinamicContent:false];
     }];
}

- (IBAction)pageActionChanged:(UIPageControl *)sender
{
    CGFloat headerViewWidth = _headerScrollView.frame.size.width;
    CGRect frame = _headerScrollView.frame;
    frame.origin = CGPointMake(headerViewWidth*sender.currentPage, 0);
    self.usedPageActionControl = YES;
    [_headerScrollView scrollRectToVisible:frame animated:YES];
}

- (IBAction)scrollActionChanged:(UIButton *)sender{}

// autorization and details cards
- (void)buttonCardClicked: (id)sender{}


// ----------------------------------------
// SHOW DATA TABLE.
// ----------------------------------------
// DATA. Init Base Data table
- (void)dataInitDataTableActions
{
    // Initialize table data
    tableData = [NSArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int numSecIntable=1;
    
    if(tableRowControllerSelection==0)
        numSecIntable = 1;
    
    if(tableRowControllerSelection==1)
        numSecIntable = [_keysCardsFromTable count];
    
    return numSecIntable;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    NSString *sectionName =@"";
    
    if(tableRowControllerSelection==0)
        sectionName =@"";
    
    if(tableRowControllerSelection==1)
        sectionName = [_keysCardsFromTable objectAtIndex:section];
    
    
    return sectionName;//[self.sectionDateFormatter stringFromDate:dateRepresentingThisDay];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int numRowsInSec = [tableData count];
    
    if(tableRowControllerSelection==0)
        numRowsInSec = [tableData count];
    
    if(tableRowControllerSelection==1)
    {
        NSString *key = [_keysCardsFromTable objectAtIndex:section];
        NSArray * arrName = [[NSArray alloc] initWithObjects:[_namesCardsFromTable objectForKey:key], nil];
        
        numRowsInSec = [arrName count];
    }
    
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
    
    
    if(tableRowControllerSelection==0)
    {
        //cell.nameLabelTableCell.text = @"25 скидка на маникюр и прочие женские радости от компании Красотка";//[tableData objectAtIndex:indexPath.row];
        //cell.imageViewTableCell.image = [UIImage imageNamed:@"ZG.png"];
    }
    
    //if(tableRowControllerSelection==1)
    //{
        NSString *key = [_keysCardsFromTable objectAtIndex:indexPath.section];
        NSArray *arrName = [[NSArray alloc] initWithObjects:[_namesCardsFromTable objectForKey:key], nil];
    
        cell.imageViewTableCell.image = [UIImage imageNamed:@"ava_small1.png"];
    
        cell.titleLabelTableCell.text = @"Скидка 50%";
        cell.nameLabelTableCell.text = @"«Ледовый Дворец» гостеприимного курорта «Игора» — настоящая шкатулка, полная приятных сюрпризов: здесь каждый найдет себе занятие по вкусу и настроению.";
    
    
        if((long)indexPath.row==0)
            cell.imageViewTableCell.image = [UIImage imageNamed:@"banner_small_promo1.png"];
        else
            if((long)indexPath.row==1)
                cell.imageViewTableCell.image = [UIImage imageNamed:@"banner_small_promo2.png"];
            else
                cell.imageViewTableCell.image = [UIImage imageNamed:@"banner_small_promo3.png"];
    
    
    
    //}
    
    [cell.buttonClickTableCell setTag:1];
    [cell.buttonClickTableCell addTarget:self action:@selector(buttonClickTableCell:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //cell.prepTimeLabel.text = [prepTime objectAtIndex:indexPath.row];
    
    return cell;
}

- (void) buttonClickTableCell: (id)sender
{
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


// Send data to Page "Detail Action"
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showActionDetail"]) {
//        NSIndexPath *indexPath = [self.tableViewControl indexPathForSelectedRow];
//        PECDetailActionViewCtrl *destViewController = segue.destinationViewController;
        //destViewController.recipeName = [recipes objectAtIndex:indexPath.row];
    }
}

// -------------- BLUECARTE SPISOK --------------



// -------------- SEGMENT CONTROL--------------
- (IBAction)secSegmentCtrlClick:(UISegmentedControl *)sender{
    
    self.usedScrollControl = YES;
    
    if(sender.selectedSegmentIndex == 0)
        [_headerScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    if(sender.selectedSegmentIndex == 1)
        [_headerScrollView setContentOffset:CGPointMake(320, 0) animated:YES];
    
    if(sender.selectedSegmentIndex == 2)
        [_headerScrollView setContentOffset:CGPointMake(640, 0) animated:YES];
    
}

// --------------------- Scroll View -------------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
    if (!self.usedScrollControl && scrollView == _headerScrollView) {
        [self darkerTheBackground:scrollView.contentOffset.x];
    }

    
    if (!self.usedPageActionControl && scrollView == _headerScrollActionView) {
        [self darkerTheBackgroundAction:scrollView.contentOffset.x];
    }
}

- (void)darkerTheBackground:(CGFloat)xOffSet
{
    if (xOffSet != 0) {
        CGFloat pageWidth = _headerScrollView.frame.size.width;
            int page = floor((xOffSet - pageWidth / 2) / pageWidth) + 1;
            _headerSegmentControl.selectedSegmentIndex = page;
    }
}

- (void)darkerTheBackgroundAction:(CGFloat)xOffSet
{
    if (xOffSet != 0) {
        CGFloat pageWidth = _headerScrollView.frame.size.width;
        int page = floor((xOffSet - pageWidth / 2) / pageWidth) + 1;
        _headerPageActionControl.currentPage = page;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == _headerScrollView) {
        self.usedScrollControl = NO;
    }
    if (scrollView == _headerScrollActionView) {
        self.usedPageActionControl = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _headerScrollView) {
        self.usedScrollControl = NO;
    }
    if (scrollView == _headerScrollActionView) {
        self.usedPageActionControl = NO;
    }
}

// --------------------- System -------------

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
    // Use this to allow upside down as well
    //return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (NSUInteger) supportedInterfaceOrientations {
    // Return a bitmask of supported orientations. If you need more,
    // use bitwise or (see the commented return).
    return UIInterfaceOrientationMaskPortrait;
    // return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    // Return the orientation you'd prefer - this is what it launches to. The
    // user can still rotate. You don't have to implement this method, in which
    // case it launches in the current orientation
    return UIDeviceOrientationPortrait;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



@end
