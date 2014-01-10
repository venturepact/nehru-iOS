//
//  WishListViewController.h
//  nehru
//
//  Created by shelly vashishth on 09/12/13.
//  Copyright (c) 2013 nehru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WishListCustomCell.h"
#import "DataProduct.h"
#import "DataWishlist.h"
#import "ProductDetailViewController.h"

@interface WishListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *tblwishlist;
    BOOL IsAdd;
}
@property(nonatomic,strong)DataWishlist *datawishlist;
@property(nonatomic,strong)DataProduct *dataproduct;
@property(nonatomic,strong)NSMutableArray *WishlistArray;
-(void)checkProductAvailabilityInWishList;
@end
