//
//  CustomCartCell.h
//  nehru
//
//  Created by admin on 06/12/13.
//  Copyright (c) 2013 nehru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCartCell : UITableViewCell
@property(nonatomic,strong)IBOutlet UIImageView *imgProduct;
@property(nonatomic,strong)IBOutlet UILabel *lblproductName;
@property(nonatomic,strong)IBOutlet UILabel *lblproductModel;
@property(nonatomic,strong)IBOutlet UILabel *lblproductquantity;
@property(nonatomic,strong)IBOutlet UILabel *lblPriceOfProduct;
@property(nonatomic,strong)IBOutlet UILabel *lblTotalprice;
@end
