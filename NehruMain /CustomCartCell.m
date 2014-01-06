//
//  CustomCartCell.m
//  nehru
//
//  Created by admin on 06/12/13.
//  Copyright (c) 2013 nehru. All rights reserved.
//

#import "CustomCartCell.h"

@implementation CustomCartCell
@synthesize imgProduct;
@synthesize lblproductName;
@synthesize lblproductquantity;
@synthesize lblproductModel;
@synthesize lblPriceOfProduct;
@synthesize lblTotalprice;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
