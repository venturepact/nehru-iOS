//
//  ProductDetailViewController.h
//  nehru
//
//  Created by shelly vashishth on 03/12/13.
//  Copyright (c) 2013 nehru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartViewController.h"
#import "DataProduct.h"
#import "DataWishlist.h"
#import "DataMyCart.h"
#import "WishListViewController.h"
#import "PageController.h"
#import "iCarousel.h"
#import "ProductListingViewController.h"
#import "PageFlippingViewController.h"

@interface ProductDetailViewController : UIViewController<UIScrollViewDelegate,UITextFieldDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    PageController *pageControllerView;
    UINavigationController *navController;
    NSMutableArray *arrofSize;
    NSMutableArray *arrofColor;
    IBOutlet UIButton *btnImageProduct;
    
   // IBOutlet UIImageView *imgViewProduct;
    IBOutlet UILabel *productName;
   
    IBOutlet UILabel *lblproductDescription;
    IBOutlet UILabel *lblproductQuantity;
    IBOutlet UILabel *lblproductModelName;
    IBOutlet UIButton *btnMoreProdctImages;
    IBOutlet UIButton *btnCloseImagesView;
    IBOutlet UIView *mViewMainLoader;
    BOOL isSize;
    BOOL isColour;
//    IBOutlet UIView *mLoaderView;
    IBOutlet UIButton *btnSize;
    IBOutlet UIButton *btnColor;
    IBOutlet UIBarButtonItem *btnBack;
    
    NSMutableArray *ArrProductSizes;
    NSMutableArray *ArrProductColors;
    
    NSMutableArray *mArrColors;
    NSMutableArray *mArrSizes;
    
    NSMutableArray *ArrProductSizeIds;
    NSMutableArray *ArrProductColorIds;
    
    NSTimer *_timer;
    IBOutlet UILabel *lblPriceProduct;
    IBOutlet UIView *imageView;
    IBOutlet UIButton *AddBtnwishlist;
    IBOutlet UIImageView *mProdctImage;
    IBOutlet UITableView *mTblColors;
    IBOutlet UITableView *mTblSizes;
  
    IBOutlet UIView *mViewColor;
    IBOutlet UIView *mViewSize;
    IBOutlet UIActivityIndicatorView *activityViewCart;
    IBOutlet UIButton *mBtnInCart;
    
    IBOutlet UIView *mViewProdctName;
}
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) iCarousel *carousel;
@property (weak, nonatomic) IBOutlet UIScrollView *backgScroll;
@property (nonatomic, strong) UIView *maskView;
@property (weak) id pickValue;
@property(nonatomic,strong)DataProduct *dataproduct;
@property(nonatomic,strong)DataMyCart *datamyCart;

//UIViews on the page
@property(weak) IBOutlet UIView *itemNameView;
@property(weak) IBOutlet UIView *itemDescView;
@property(weak) IBOutlet UIView *itemColorView;
@property(weak) IBOutlet UIView *itemSizeView;
@property(weak) IBOutlet UIView *itemQuantityView;
-(IBAction)clickedShowCart:(id)sender;
-(IBAction)ClickedSelectSize:(id)sender;
-(IBAction)ClickedSelectColor:(id)sender;
-(IBAction)ClickedAddToCart:(id)sender;
-(IBAction)AddProducttoWishlist:(id)sender;
-(void)displayDataOnscreen;
-(void)AddProductImages;
-(void)GetProductImagesFromParse;
-(IBAction)closeImageLoaderView:(id)sender;
-(IBAction)ClickedBackBtn:(id)sender;
-(IBAction)actionViewLoader:(id)sender;
@end