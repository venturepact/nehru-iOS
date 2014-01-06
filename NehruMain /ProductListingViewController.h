//
//  ProductListingViewController.h
//  nehru
//
//  Created by shelly vashishth on 21/12/13.
//  Copyright (c) 2013 nehru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "nSubCatCell.h"
#import "WishListViewController.h"
#import <Parse/Parse.h>
#import "DataProduct.h"
#import "DataCategory.h"
#import "ProductDetailViewController.h"
#import "DataWishlist.h"

@interface ProductListingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,UIAlertViewDelegate>
{
    IBOutlet UIView *ViewCasual;
    IBOutlet UIView *ViewFormal;
    IBOutlet UIView *ViewFirst;
    IBOutlet UIView *ViewFirstScreen;
    IBOutlet UITableView *mTableCasual;
    IBOutlet UITableView *mTableFormal;
    
    IBOutlet UIImageView *viewCategory;
    IBOutlet UIView *bgContentView;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    
    //  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes
	BOOL _reloading;
    
    NSString *selectedIndex;
    
    IBOutlet UIView *btnbckgroundView;
    BOOL isCasual;
    BOOL isFormal;
    
    IBOutlet UIButton *btnCasual;
    
    IBOutlet UIButton *btnFormal;
    
    IBOutlet UIActivityIndicatorView *activity1;
    IBOutlet UIActivityIndicatorView *activity2;
//    IBOutlet UIView *activityIndicatorView;
}
@property (unsafe_unretained, nonatomic) IBOutlet UIActivityIndicatorView *nativeIndicator;
@property(nonatomic,strong)NSMutableArray *arrayOfAllproducts;
@property(nonatomic,strong)NSMutableArray *arrformalproducts;
@property (nonatomic, retain) UIView *blockerView;
-(void)AddwishlistProductToParse:(NSString*)strproductId;
-(IBAction)ActionRemoveView:(id)sender;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
@end
