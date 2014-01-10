//
//  DataWishlist.m
//  nehru
//
//  Created by shelly vashishth on 09/12/13.
//  Copyright (c) 2013 nehru. All rights reserved.
//

#import "DataWishlist.h"

@implementation DataWishlist
@synthesize myWishlistArray;

+ (id)sharedWishList
{
    static DataWishlist *sharedwishlist = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedwishlist = [[self alloc] init];
        
    });
    return sharedwishlist;
}

- (id)init {
    if (self = [super init]) {
        self.myWishlistArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSMutableArray *) getArray{
    return self.myWishlistArray;
}

- (void) addArray:(NSObject *)objectToAdd{
    [self.myWishlistArray addObject:objectToAdd];
}

-(void)mutableCopyArrayWishList:(NSMutableArray*)ArrayToCopy
{
    self.myWishlistArray =[ArrayToCopy mutableCopy];
    
    NSLog(@"myWishlist Aray %@",self.myWishlistArray);
}

-(BOOL)containsProduct:(DataProduct*)product
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"ProductId=%@", product.ProductId];
    NSArray* duplicateProducts = [self.myWishlistArray filteredArrayUsingPredicate:predicate];
    return (duplicateProducts.count > 0) ? YES : NO;
}

- (void)addProduct:(DataProduct*)product
{
    if (![self containsProduct:product]) {
        [self.myWishlistArray addObject:product];
    }
}

- (void)removeProduct:(DataProduct*)product
{
    [self.myWishlistArray removeObject:product];
}

- (void)clearWishlist
{
    self.myWishlistArray = [[NSMutableArray alloc] init];
}


@end
