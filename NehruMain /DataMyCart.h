//
//  DataMyCart.h
//  nehru
//
//  Created by admin on 07/12/13.
//  Copyright (c) 2013 nehru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataProduct.h"

@interface DataMyCart : NSObject
{
//    NSMutableArray *myCartArray;
}
@property(nonatomic,strong)NSMutableArray *myCartArray;
+ (id)sharedCart;
- (NSMutableArray *) getArray;
- (void)addArray:(NSObject *)objectToAdd;
-(void)mutableCopyArrayCart:(NSMutableArray*)ArrayToCopy;
//additions for cart
- (BOOL)containsProduct:(DataProduct*)product;
- (void)addProduct:(DataProduct*)product;
- (void)removeProduct:(DataProduct*)product;
- (void)clearCart;
- (NSNumber*)total;
@end


