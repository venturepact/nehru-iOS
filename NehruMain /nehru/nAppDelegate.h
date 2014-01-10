//
//  nAppDelegate.h
//  nehru
//
//  Created by ADMIN on 11/27/13.
//  Copyright (c) 2013 nehru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataMyCart.h"
#import "DataWishlist.h"

@interface nAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic)DataMyCart *datamycart;
@property(strong,nonatomic)DataWishlist *datawishlist;
@end
