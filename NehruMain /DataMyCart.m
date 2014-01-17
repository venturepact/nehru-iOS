//
//  DataMyCart.m
//  nehru
//
//  Created by shelly vashishth on 09/12/13.
//  Copyright (c) 2013 nehru. All rights reserved.
//

#import "DataMyCart.h"

@implementation DataMyCart
@synthesize myCartArray;

#pragma mark Singleton Methods

+ (id)sharedCart {
    static DataMyCart *sharedCart = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCart = [[self alloc] init];
    });
    return sharedCart;
}

- (id)init {
    if (self = [super init]) {
       self.myCartArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSMutableArray *) getArray{
    return self.myCartArray;
}

- (void)addArray:(NSObject *)objectToAdd{
    [self.myCartArray addObject:objectToAdd];
}

-(void)mutableCopyArrayCart:(NSMutableArray*)ArrayToCopy
{
    self.myCartArray =[ArrayToCopy mutableCopy];
    NSLog(@"myCart Aray %@",self.myCartArray);
}

- (BOOL)containsProduct:(DataProduct *)product {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"RandomProductId=%@", product.RandomProductId];
    NSArray* duplicateProducts = [self.myCartArray filteredArrayUsingPredicate:predicate];
    return (duplicateProducts.count > 0) ? YES : NO;
}



- (void)addProduct:(DataProduct*)product {
    if (![self containsProduct:product]) {
        [self.myCartArray addObject:product];
    }
}

- (void)removeProduct:(DataProduct *)product {
    [self.myCartArray removeObject:product];
}

- (void)clearCart {
    myCartArray = [[NSMutableArray alloc] init];
}

- (NSNumber*)total {
    double total = 0.0;
    for (DataProduct* product in myCartArray) {
        total += product.productUnitprice ;
    }
    return @(total);
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end
