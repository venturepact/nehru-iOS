//
//  nMainCat.h
//  nehru
//
//  Created by ADMIN on 11/28/13.
//  Copyright (c) 2013 nehru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "nMainCatCell.h"

@interface nMainCat : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    IBOutlet UITableView *nMainCatTable;
    NSArray *arrOfMainCatImg;
    NSArray *arrOfMainCatText;
}
@end
