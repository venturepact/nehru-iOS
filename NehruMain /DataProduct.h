//
//  DataProduct.h
//  nehru
//
//  Created by admin on 07/12/13.
//  Copyright (c) 2013 nehru. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataProduct : NSObject
@property(nonatomic,strong)UIImage *imgproduct;
@property(nonatomic,strong)NSString *isfavorite;
@property(nonatomic,strong)NSString *ProductId;
@property(nonatomic,strong)NSObject *ProductImage;
@property(nonatomic,strong)NSString *ProductName;
@property(nonatomic,strong)NSString *CategoryId;
@property(nonatomic,strong)NSString *ProductModel;
@property(nonatomic,assign)NSInteger productquantity;
@property(nonatomic,strong)NSMutableArray *productImages;
@property(nonatomic,strong)NSMutableArray *ArrProductSizes;
@property(nonatomic,assign)float productUnitprice;
@property(nonatomic,assign)float productSubTotal;
@property(nonatomic,assign)float CartTotal;
@end
