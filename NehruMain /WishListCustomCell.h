//
//  WishListCustomCell.h
//  nehru
//
//  Created by shelly vashishth on 09/12/13.
//  Copyright (c) 2013 nehru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WishListCustomCell : UITableViewCell
@property(nonatomic,strong)IBOutlet UIImageView *imgProduct;
@property(nonatomic,strong)IBOutlet UILabel *lblproductName;
@property(nonatomic,strong)IBOutlet UILabel *lblproductModel;
@property(nonatomic,strong)IBOutlet UILabel *lblPriceOfProduct;
@end
