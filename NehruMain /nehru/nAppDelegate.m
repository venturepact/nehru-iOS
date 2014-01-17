//
//  nAppDelegate.m
//  nehru
//
//  Created by ADMIN on 11/27/13.
//  Copyright (c) 2013 nehru. All rights reserved.
//

#import "nAppDelegate.h"
#import <Parse/Parse.h>

@implementation nAppDelegate
@synthesize datamycart,datawishlist;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // parse application key
    [Parse setApplicationId:@"e9TfdXlTdkHGWx4O7hxgFonMAny0kHWrX4jgsHRs"
                  clientKey:@"jRz99oh0UtBej0sBLJSUHnGxYVhiD9CARAoZVIKk"];
    
    //initializing the class datacart.
    self.datamycart=[DataMyCart sharedCart];
    //self.datamycart.myCartArray=[[NSMutableArray alloc]init];
    
    //initializing the class wishlist.
    self.datawishlist=[DataWishlist sharedWishList];
    //self.datawishlist.myWishlistArray=[[NSMutableArray alloc]init];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
