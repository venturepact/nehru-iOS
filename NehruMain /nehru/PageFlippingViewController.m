//
//  PageFlippingViewController.m
//  ModProject
//
//  Created by admin on 20/04/13.
//  Copyright (c) 2013 ADMIN. All rights reserved.
//

#import "PageFlippingViewController.h"

@interface PageFlippingViewController ()

@end

@implementation PageFlippingViewController

NSString *getWebServicePath;
NSInteger getDATA;
BOOL isGETDATA=TRUE;
BOOL isIndexSet=TRUE;
NSInteger getIndex;

// web service methods
NSMutableData *webData;
NSMutableString *soapResults;
NSURLConnection *conn;
NSString *UserValidated;
NSString *MyBoard;
//XML Parser
//---xml parsing---
NSXMLParser *xmlParser;
BOOL elementFound;
int flag;

@synthesize carousel;
@synthesize wrap;
@synthesize getArrayItemId;

-(void)ClosetItemAdd:(NSInteger)getResponse
{
    if(getResponse==1)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"MOD" message:@"Item added to closet" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"MOD" message:@"Item already added or error" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];

    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
          return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
   // self.getArrayItemId=[[NSMutableArray alloc]init];
    self.getArrayItemId=[[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"bg2.jpg"],[UIImage imageNamed:@"bg4.jpg"],[UIImage imageNamed:@"bg3.jpg"], nil];
    
    //changing the background for the UINavigationController.

     [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"yourImage"] forBarMetrics:UIBarMetricsDefault];
    
	//create carousel
	self.carousel = [[iCarousel alloc] initWithFrame:self.view.bounds];
	self.carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.carousel.type = iCarouselTypeCoverFlow2;
	self.carousel.delegate = self;
	self.carousel.dataSource = self;
    
	//add carousel to view
	[self.view addSubview:self.carousel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake( 20,2 ,45 ,30);
    
    UIImage *buttonImage = [UIImage imageNamed:@"modBack.png"];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(Cancelclicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem=buttonItem;
    
}

-(IBAction)Cancelclicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [getArrayItemId count];
}

- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize  :(UIImage*)sourceImage
{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
 
    return newImage;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    
//    NSString *str=[NSString stringWithFormat:@"%@",];
    UIImage *image=[self.getArrayItemId objectAtIndex:index];
    
//    NSLog(@"String %@",str);
    // main white background image
    
    UIImageView * img_view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 420.f)];
    [img_view setImage:image];
    [img_view setContentMode:UIViewContentModeScaleToFill];
    
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 420.0f)];
//    view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[self.getArrayItemId objectAtIndex:index]]]];
    
//    view.backgroundColor=[UIColor colorWithPatternImage:image];
//    view.contentMode = UIViewContentModeScaleToFill;
    [view addSubview:img_view];
    //view.clipsToBounds=YES;
    return view;
}


- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * carousel.itemWidth);
}

- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return wrap;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.05f;
        }
        case iCarouselOptionFadeMax:
        {
            if (carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        default:
        {
            return value;
        }
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


@end
