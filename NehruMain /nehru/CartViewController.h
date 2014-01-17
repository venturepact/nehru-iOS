//
//  CartViewController.h
//  nehru
//
//  Created by admin on 06/12/13.
//  Copyright (c) 2013 nehru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCartCell.h"
#import "DataMyCart.h"
#import "DataProduct.h"
#import "nViewController.h"

@interface CartViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    IBOutlet UITableView *tblView1;
    BOOL IsAdd;
    
    IBOutlet UIButton *btnBack;
    IBOutlet UIView *viewcheckout;
}
@property(nonatomic,strong)IBOutlet UIScrollView *mainScrollView;
@property(nonatomic,strong)UITabBarController *tabbarController;
@property(nonatomic,strong)DataMyCart *datacart;
@property(nonatomic,strong)DataProduct *dataProduct;
@property(nonatomic,strong)NSMutableArray *cartArray;
@property(nonatomic,strong)IBOutlet UIView *BckViewTotal;
@property(nonatomic,assign)IBOutlet UILabel* lblsubtotal;
@property(nonatomic,assign)IBOutlet UILabel* lblvat;
@property(nonatomic,assign)IBOutlet UILabel* lblecotax;
@property(nonatomic,assign)IBOutlet UILabel* lbltotal;
-(void)checkProductAvailability;
- (IBAction)goBack:(id)sender;
-(IBAction)ClickedCheckout:(id)sender;
@end
