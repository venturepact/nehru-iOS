//
//  nSubCat.h
//  nehru
//
//  Created by ADMIN on 11/28/13.
//  Copyright (c) 2013 nehru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "nSubCatCell.h"
#import "WishListViewController.h"
#import <Parse/Parse.h>
#import "DataProduct.h"

@interface nSubCat : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    IBOutlet UIButton *btnFormal;
    IBOutlet UIButton *btnCasual;
    IBOutlet UITableView *tblView1;
    IBOutlet UIView *ViewMove;
    
    NSMutableArray *arrcategories;
    NSMutableArray *arrformalproducts;
    
    NSMutableArray *arrcasualProducts;
}
//-(IBAction)ClickedOnbtnFormal:(id)sender;
@end
