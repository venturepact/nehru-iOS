//
//  nMainCat.m
//  nehru
//
//  Created by ADMIN on 11/28/13.
//  Copyright (c) 2013 nehru. All rights reserved.
//

#import "nMainCat.h"

@interface nMainCat ()
@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;
@end

@implementation nMainCat
@synthesize revealButtonItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self.revealButtonItem setTarget: self.revealViewController];
//    [self.revealButtonItem setAction: @selector( revealToggle: )];
//    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
//    
    // set Inset of ios 6 and 7
    if([[[UIDevice currentDevice]systemVersion]floatValue]==6.1
       || [[[UIDevice currentDevice]systemVersion]floatValue]==6.0){
    }
    else {
        nMainCatTable.separatorInset=UIEdgeInsetsZero;
    }
    // set array of the image and text
    arrOfMainCatImg=[NSArray arrayWithObjects:@"bckgImage1.png",@"bckgImage2.png",@"bckgImage3.png",nil];
//                     @"bckgImage4.png",@"bckgImage1.png",@"bckgImage2.png", @"bckgImage3.png",@"bckgImage4.png",nil];
    arrOfMainCatText=[NSArray arrayWithObjects:@"Casual",@"Formal",@"Casual",nil];
//                      @"Casual",@"Formal",@"Casual",@"Formal", nil];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *tableIdentifier=@"nMainCatTable";
    nMainCatCell *mainTableCell=[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    
    if(mainTableCell==nil){
        mainTableCell=[[nMainCatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }
    // set data to table
    mainTableCell.nMainCatImg.image=[UIImage imageNamed:[arrOfMainCatImg objectAtIndex:indexPath.row]];
    mainTableCell.nMainCatTitleText.text=[arrOfMainCatText objectAtIndex:indexPath.row];
 
    // return cell
    return mainTableCell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"Arr of main cat images %d",[arrOfMainCatImg count]);
    NSLog(@"Arr of main category text %d",[arrOfMainCatText count]);
    return [arrOfMainCatImg count];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger currentOffset = nMainCatTable.contentOffset.y;
    NSInteger maximumOffset = nMainCatTable.contentSize.height - nMainCatTable.frame.size.height;
    // Change 10.0 to adjust the distance from bottom
    if (maximumOffset - currentOffset <= 10.0) {
            [nMainCatTable reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
