//
//  WishListViewController.m
//  nehru
//
//  Created by shelly vashishth on 09/12/13.
//  Copyright (c) 2013 nehru. All rights reserved.
//

#import "WishListViewController.h"

@interface WishListViewController ()

@end

@implementation WishListViewController
@synthesize WishlistArray;
@synthesize datawishlist;
@synthesize dataproduct;

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
	// Do any additional setup after loading the view.
    
    self.navigationItem.title=@"WishList";
}

-(void)viewWillAppear:(BOOL)animated
{
    self.WishlistArray=[[NSMutableArray alloc]init];
    self.WishlistArray=[[DataWishlist sharedWishList]getArray];
    NSLog(@"Cart from the singleton class myCart %@",self.WishlistArray);
    [self.datawishlist mutableCopyArrayWishList:self.WishlistArray];
    [tblwishlist reloadData];
}

//loading wishlist data from parse.

/*-(void)GetWishListfromParse
{
 //getting data from parse.
 arrayOfAllproducts=[[NSMutableArray alloc]init];
 //getting all the products in the database.
 PFQuery *query = [PFQuery queryWithClassName:@"NehruProducts"];
 //    [query whereKey:@"productName" equalTo:@"jacket 3"];
 [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
 if (!error) {
 // The find succeeded.
 //calling casual
 
 [UIView beginAnimations:@"bucketsOff" context:nil];
 [UIView setAnimationDuration:0.4];
 [UIView setAnimationDelegate:self];
 
 //position off screen
 ViewCasual.frame=CGRectMake(484, 40 , 320,420);
 ViewFormal.frame=CGRectMake(0, 40, 320, 480);
 //animate off screen
 [UIView commitAnimations];
 
 [mTableCasual reloadData];
 
 // Do something with the found objects
 for (PFObject *object in objects) {
 //getting the category Name and Object Id's
 DataProduct *dataproduct=[[DataProduct alloc]init];
 dataproduct.ProductId=object.objectId;
 dataproduct.ProductImage=object[@"productImage"];
 dataproduct.ProductName=object[@"productName"];
 dataproduct.ProductModel=object[@"productModel"];
 NSString *strproductQty=object[@"productQty"];
 NSString *strProductPrice=object[@"productPrice"];
 dataproduct.productImages=object[@"ProductImages"];
 
 dataproduct.productquantity=[strproductQty integerValue];
 dataproduct.productUnitprice=[strProductPrice floatValue];
 dataproduct.CategoryId=object[@"categoryId"];
 [arrayOfAllproducts addObject:dataproduct];
 }
 [mTableCasual reloadData];
 } else {
 // Log details of the failure
 NSLog(@"Error: %@ %@", error, [error userInfo]);
 }
 }];
}*/

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"wishlistArray %@",self.WishlistArray);
//    return 1;
    return [self.WishlistArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *tableIdentifier=@"WishlistTable";
    UITableViewCell *tblViewCell;
    if(indexPath.section==0)
    {
        WishListCustomCell *mainTableCell=[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
        if(mainTableCell==nil){
            mainTableCell=[[WishListCustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
        }
        DataProduct *Objdataproduct=[[DataProduct alloc]init];
        Objdataproduct=[self.WishlistArray objectAtIndex:indexPath.row];
        PFFile *theImage =(PFFile*)Objdataproduct.ProductImage;
        [theImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
            UIImage *image = [UIImage imageWithData:data];
            mainTableCell.imgProduct.image=image;
        }];
        mainTableCell.lblproductName.text=Objdataproduct.ProductName;
        mainTableCell.lblPriceOfProduct.text=[NSString stringWithFormat:@"$%0.2f",Objdataproduct.productUnitprice];
        mainTableCell.lblproductModel.text=[NSString stringWithFormat:@"%@",Objdataproduct.ProductModel];
        return mainTableCell;
    }
    return tblViewCell;
}

-(void)checkProductAvailabilityInWishList
{
    //If the product is already available in cart, it should not be added.
    for(int i=0;i<=5;i++)
    {
        DataProduct *newobjectToadd=[[DataProduct alloc]init];
        newobjectToadd.ProductId=[NSString stringWithFormat:@"100%d",i+1];
        newobjectToadd.ProductName=[NSString stringWithFormat:@"Nehru Jacket %d",i+1];
        newobjectToadd.ProductModel=[NSString stringWithFormat:@"Model %d",1];
        newobjectToadd.productquantity=1;
        newobjectToadd.productSubTotal=300.0;
        newobjectToadd.productUnitprice=300.0;
        newobjectToadd.ProductImage=[NSString stringWithFormat:@"images%d.jpeg",i+1];
        IsAdd=YES;
        
        if([self.WishlistArray count]>0)
        {
            for(int j=0;j<[self.WishlistArray count];j++){
                self.dataproduct =[self.WishlistArray objectAtIndex:j];
                if([self.dataproduct.ProductId isEqualToString:newobjectToadd.ProductId])
                {
                    IsAdd=NO;
                }
            }
            if(IsAdd)
            {
                [self.WishlistArray addObject:newobjectToadd];
            }
        }
        else
        {
            [self.WishlistArray addObject:newobjectToadd];
        }}
}

//Editing style for the UITableviewCell

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    // Updates the appearance of the Edit|Done button as necessary.
    [super setEditing:editing animated:animated];
    [tblwishlist setEditing:editing animated:animated];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView beginUpdates];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Do whatever data deletion you need to do...
        // Delete the row from the data source
        
        [self.WishlistArray removeObjectAtIndex:indexPath.row];
        [self.datawishlist mutableCopyArrayWishList:self.WishlistArray];
        
        [tblwishlist deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        
        [tblwishlist reloadData];
    }
    [tableView endUpdates];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
