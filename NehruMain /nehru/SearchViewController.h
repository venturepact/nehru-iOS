//
//  SearchViewController.h
//  nehru
//
//  Created by ADMIN on 12/31/13.
//  Copyright (c) 2013 nehru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "DataProduct.h"
#import "ProductDetailViewController.h"
#import "nSubCatCell.h"


@interface SearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,EGORefreshTableHeaderDelegate>
{
    IBOutlet UITextField *searchTableview;
    
    IBOutlet UIButton *tBtnSearch;
    
    IBOutlet UIView *ViewCasual;
    IBOutlet UIView *ViewFormal;
    IBOutlet UITableView *mTableFormal;
    
    IBOutlet UIImageView *viewCategory;
    IBOutlet UIView *bgContentView;
    
    IBOutlet UITableView *mTableCasual;
    BOOL isCasual;
    BOOL isFormal;
    NSString *selectedIndex;
    
    IBOutlet UIView *btnbckgroundView;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    
    //  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes
	BOOL _reloading;
    IBOutlet UINavigationBar *navitem;
    IBOutlet UIBarButtonItem *barButton;
    IBOutlet UIBarButtonItem *button2;
}
@property(nonatomic,strong)NSMutableArray *arrayOfAllproducts;
@property(nonatomic,strong)NSMutableArray *arrformalproducts;
@property(nonatomic,strong)NSMutableArray *arrayOfAllproductsName;
@property(nonatomic,strong)NSMutableArray *mutableTableDataArray;
@property(nonatomic,retain)NSString *strSearchData;
@end
