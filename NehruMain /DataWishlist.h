//
//  DataWishlist.h
//  nehru
//
//  Created by shelly vashishth on 09/12/13.
//  Copyright (c) 2013 nehru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataProduct.h"

@interface DataWishlist : NSObject
{
}
@property(nonatomic,strong)NSMutableArray *myWishlistArray;
+ (id)sharedWishList;
- (NSMutableArray *)getArray;
- (void) addArray:(NSObject *)objectToAdd;
-(void)mutableCopyArrayWishList:(NSMutableArray*)ArrayToCopy;
//additions for wishlist.
- (BOOL)containsProduct:(DataProduct*)product;
- (void)addProduct:(DataProduct*)product;
- (void)removeProduct:(DataProduct*)product;
- (void)clearWishlist;
@end
