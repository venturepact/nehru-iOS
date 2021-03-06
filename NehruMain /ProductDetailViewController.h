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
#import "nAppDelegate.h"
#import "ProductListingViewController.h"
#import "PageFlippingViewController.h"
#import "productCollectionImages.h"

@interface ProductDetailViewController : UIViewController<UIScrollViewDelegate,UITextFieldDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate>
{
    PageController *pageControllerView;
    UINavigationController *navController;
    NSMutableArray *arrofSize;
    NSMutableArray *arrofColor;
    IBOutlet UIButton *btnImageProduct;
    
   // IBOutlet UIImageView *imgViewProduct;
    IBOutlet UILabel *productName;
   

    UIView *mViewMainLoader;
    
    NSMutableArray *MArrMainItems;
    BOOL isSize;
    BOOL isColour;
    
    IBOutlet UILabel *lblqty;
//    IBOutlet UIView *mLoaderView;
    IBOutlet UIButton *btnSize;
    IBOutlet UIButton *btnColor;
    
    
    IBOutlet UILabel *lblColor;
    IBOutlet UILabel *lblSize;
    
    IBOutlet UITextView *txtViewdescription;
    
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
//    IBOutlet UIImageView *mProdctImage;
    IBOutlet UITableView *mTblColors;
    IBOutlet UITableView *mTblSizes;
  
    IBOutlet UIView *mViewColor;
    IBOutlet UIView *mViewSize;
    IBOutlet UIActivityIndicatorView *activityViewCart;
    IBOutlet UIButton *mBtnInCart;
    
    IBOutlet UIView *mViewProdctName;
    
    NSMutableArray *productArrayInCart;
}
@property(nonatomic,assign)CGSize currentCellSize;
@property(nonatomic,strong)NSMutableArray *arrImages;
@property (nonatomic,strong) IBOutlet UICollectionView *MMainCollectionView;
@property(nonatomic,strong)  IBOutlet UIImageView *mProdctImage;
@property (strong, nonatomic) IBOutlet UIScrollView *backgScroll;
@property (nonatomic, strong) UIView *maskView;
@property(nonatomic,strong)DataProduct *dataproduct;
@property(nonatomic,strong)DataMyCart *datacart;

//UIViews on the page
-(IBAction)clickedShowCart:(id)sender;
-(IBAction)ClickedSelectSize:(id)sender;
-(IBAction)ClickedSelectColor:(id)sender;
-(IBAction)ClickedAddToCart:(id)sender;
-(IBAction)AddProducttoWishlist:(id)sender;
-(void)displayDataOnscreen;
-(void)AddProductImages;
-(void)GetProductImagesFromParse;
-(void)GetAllProductsFromCart;
-(IBAction)closeImageLoaderView:(id)sender;
-(IBAction)ClickedBackBtn:(id)sender;
-(IBAction)actionViewLoader:(id)sender;
-(BOOL)CheckProductQuantity;
-(IBAction)ClickedIncreaseQty:(id)sender;
-(IBAction)ClickedDecreaseQty:(id)sender;
@end