//
//  nSubCatCell.m
//  nehru
//
//  Created by ADMIN on 11/28/13.
//  Copyright (c) 2013 nehru. All rights reserved.
//

#import "nSubCatCell.h"

@implementation nSubCatCell
@synthesize imgproduct;
@synthesize lblproductModelName;
@synthesize lblproductName;
@synthesize btnfavorites;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"main-product-bg_shadow.png"]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)ClickedAddProducttoWishlist:(id)sender
{
    NSString *str=[NSString stringWithFormat:@"%d",btnfavorites.tag];
    
    NSDictionary *aDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 str, @"FavoritesTag",
                                 nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddToWishlist" object:nil userInfo:aDictionary];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"AddToWishlistthroughSearch" object:nil userInfo:aDictionary];
}

@end
