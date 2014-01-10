//
//  PageFlippingViewController.h
//  ModProject
//
//  Created by admin on 20/04/13.
//  Copyright (c) 2013 ADMIN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "ProductDetailViewController.h"

@interface PageFlippingViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>
{
    UIImageView *backgroundView;
    NSString *getWebService;
//    IBOutlet UIActivityIndicatorView *activity;
}

@property(nonatomic, retain) iCarousel *carousel;
@property(nonatomic,strong)NSMutableArray *getArrayItemId;
@property(nonatomic, assign) BOOL wrap;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize :(UIImage*)sourceImage;
@end
