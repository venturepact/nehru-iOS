//
//  nSubCatCell.h
//  nehru
//
//  Created by ADMIN on 11/28/13.
//  Copyright (c) 2013 nehru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface nSubCatCell : UITableViewCell
@property(nonatomic,strong)IBOutlet UILabel *lblproductName;
@property(nonatomic,strong)IBOutlet UIImageView *imgproduct;
@property(nonatomic,strong)IBOutlet UILabel *lblproductModelName;
@property(nonatomic,strong)IBOutlet UIButton *btnfavorites;
@property(nonatomic,strong)IBOutlet UIImageView *bgContentView;
-(IBAction)ClickedAddProducttoWishlist:(id)sender;
@end
