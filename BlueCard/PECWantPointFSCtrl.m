//
//  PECWantPointFSCtrl.m
//  BlueCarte
//
//  Created by Admin on 2/24/14.
//  Copyright (c) 2014 Paladin-Engineering. All rights reserved.
//

#import "PECWantPointFSCtrl.h"
#import "FSVenue.h"
#import "Foursquare2.h"
#import "FSConverter.h"

@interface PECWantPointFSCtrl ()

@property (weak, nonatomic) IBOutlet UILabel *venueName;
@property (weak, nonatomic) IBOutlet UILabel *venueAddress;
@property (weak, nonatomic) IBOutlet UILabel *venueDistance;
@property (weak, nonatomic) IBOutlet UIImageView *venuePhoto;

// Scroll View
@property (strong, nonatomic) IBOutlet UIView *mainContainerCards;
@property (strong, nonatomic) IBOutlet UIScrollView *headerScrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *headerPageControl;
@property (strong, nonatomic) IBOutlet UIView *contentView;


@end

@implementation PECWantPointFSCtrl

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //self.title = @"Checkin";
    self.venueName.text = self.venue.name;
    self.venueAddress.text = self.venue.location.address;
    self.venueDistance.text = [NSString stringWithFormat:@"%@ m",self.venue.location.distance];
    
    [Foursquare2 venueGetPhotos:self.venue.venueId
                          limit:@(10)
                         offset:@(1)
                       callback:^(BOOL success, id result){
                           
                           if (success)
                           {
                               // Получаю массив фотографий
                               NSDictionary *dic = result;
                               NSArray *photosArr = [dic valueForKeyPath:@"response.photos.items"];
                               FSConverter *converter = [[FSConverter alloc]init];
                               // Переконвертировал в URL и вывожу в скролл
                               [self addImagesInSlider:[converter convertToObjectsPhotos:photosArr]];
                           }
                       }];
}


- (void)addImagesInSlider: (NSArray*)imgArray
{
    
    // Количество экранов слайдеров
    int countSliders = [imgArray count];
    
    // Ширина главного контейнера
    CGFloat widthSliderContainer =  countSliders * 320.0f;
    
    // Размер главного контейнера
    CGRect newFrame = CGRectMake( 0.0f, 0.0f, widthSliderContainer, 208);
    _contentView.frame = newFrame;
    
    _headerScrollView.contentSize = _contentView.frame.size;
    _headerPageControl.numberOfPages = countSliders;
    
    int i = 0;
    for(NSString *imgURL in imgArray)
    {
        // Image Card
        CGRect imgCont = CGRectMake( 320.0f*i, 0.0f, 320.0f, 208.0f);
        UIImageView *imgPhotoView = [[UIImageView alloc]initWithFrame:imgCont];
        imgPhotoView.image = [self createImageViewFromObj:imgURL];
        
        [_contentView addSubview:imgPhotoView];
        i++;
    }
}


-(UIImage *)createImageViewFromObj: (NSString*)urlImage
{
    // Create IMAGE
    NSData *data;
    NSURL *url = [NSURL URLWithString: urlImage];
    data = [NSData dataWithContentsOfURL:url];
    UIImage *imgCard = [UIImage imageWithData:data];
    return imgCard;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}




// ~ СКРОЛЛ

- (IBAction)pageChanged:(UIPageControl *)sender
{
    CGFloat headerViewWidth = _headerScrollView.frame.size.width;
    CGRect frame = _headerScrollView.frame;
    frame.origin = CGPointMake(headerViewWidth*sender.currentPage, 0);
    [_headerScrollView scrollRectToVisible:frame animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self darkerTheBackground:scrollView.contentOffset.x];
}

- (void)darkerTheBackground:(CGFloat)xOffSet
{
    if (xOffSet != 0) {
        CGFloat pageWidth = _headerScrollView.frame.size.width;
        int page = floor((xOffSet - pageWidth / 2) / pageWidth) + 1;
        _headerPageControl.currentPage = page;
    }
}


// ~ СИСТЕМНЫЕ
- (IBAction)butBack:(UIButton *)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
