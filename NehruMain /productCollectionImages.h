//
//  productCollectionImages.h
//  nehru
//
//  Created by ADMIN on 1/20/14.
//  Copyright (c) 2014 nehru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface productCollectionImages : UICollectionViewCell
@property (nonatomic,strong)IBOutlet UIImageView *MImageItem;
@property(nonatomic,strong)IBOutlet UIButton *btnImageDetail;
@property(nonatomic,strong)IBOutlet UILabel *lblPrice;
@property(nonatomic,strong)IBOutlet UILabel *lblProductName;
@end
