//
//  CartViewController.m
//  nehru
//
//  Created by shelly vashishth on 09/12/13.
//  Copyright (c) 2013 nehru. All rights reserved.
//

#import "CartViewController.h"

@interface CartViewController ()

@end

@implementation CartViewController
@synthesize lblsubtotal;
@synthesize lblvat;
@synthesize lblecotax;
@synthesize lbltotal;
@synthesize dataProduct;
@synthesize BckViewTotal;
@synthesize cartArray;
@synthesize tabbarController;
@synthesize datacart;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)goBack:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//Hide and Show the Tab bar controller iphone sdk.

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nehru-logo.png"]];
    self.navigationItem.titleView=imageView;
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title=@"Cart";
//    self.dataProduct=[[DataProduct alloc]init];
//    
//    self.datacart=[DataMyCart sharedCart];
    self.cartArray=[[NSMutableArray alloc]init];
//    self.cartArray=[[DataMyCart sharedCart]getArray];
//    
//    NSLog(@"cart Array %@",self.cartArray);
//    [self.datacart mutableCopyArrayCart:self.cartArray];
//    [self calculatetheTotal];
    
//    [tblView1 reloadData];
    if(IS_HEIGHT_GTE_568)
    {
        viewcheckout.frame=CGRectMake(0,460 , 320, 46);
    }
    else
    {
        viewcheckout.frame=CGRectMake(0,320,320,46);
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    if(IS_HEIGHT_GTE_568)
    {
        self.BckViewTotal.frame=CGRectMake(0,410, 320, 56);
    }
    else{
        self.BckViewTotal.frame=CGRectMake(0,410,320,56);
    }
    self.navigationItem.title=@"Cart";
    self.dataProduct=[[DataProduct alloc]init];
    
//    self.datacart=[DataMyCart sharedCart];
    self.cartArray=[[NSMutableArray alloc]init];
//    self.cartArray=[[DataMyCart sharedCart]getArray];
    
    NSLog(@"cart Array %@",self.cartArray);
//    [self.datacart mutableCopyArrayCart:self.cartArray];
    [self calculatetheTotal];
    
    [tblView1 reloadData];
    [self CartProducts];
}

- (void)viewWillDisappear:(BOOL)animated
{
//    ((UITabBarController *)self.parentViewController).tabBar.hidden = NO;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.cartArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *tableIdentifier=@"CartTable";
    
    
    UITableViewCell *tblViewCell;
    if(indexPath.section==0)
    {
    CustomCartCell *mainTableCell=[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if(mainTableCell==nil){
        mainTableCell=[[CustomCartCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }
    DataProduct *Objdataproduct=[[DataProduct alloc]init];
    Objdataproduct=[self.cartArray objectAtIndex:indexPath.row];
    NSLog(@"Image Name %@",Objdataproduct.ProductImage);
        PFFile *theImage =(PFFile*)Objdataproduct.ProductImage;
        [theImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
            UIImage *image = [UIImage imageWithData:data];
            mainTableCell.imgProduct.image=image;
        }];
    mainTableCell.lblproductName.text=Objdataproduct.ProductName;
    mainTableCell.lblproductquantity.text=[NSString stringWithFormat:@"%d",Objdataproduct.productreqQuantity];
    mainTableCell.lblPriceOfProduct.text=[NSString stringWithFormat:@"$%0.2f",Objdataproduct.productUnitprice];
    mainTableCell.lblproductModel.text=[NSString stringWithFormat:@"%@",Objdataproduct.ProductModel];
    mainTableCell.lblTotalprice.text=[NSString stringWithFormat:@"%0.2f",Objdataproduct.productSubTotal];
    mainTableCell.lblproductColor.text=[NSString stringWithFormat:@"%@",Objdataproduct.productColor];
    mainTableCell.lblproductSize.text=[NSString stringWithFormat:@"%@",Objdataproduct.productSize];

    mainTableCell.selectionStyle=UITableViewCellSelectionStyleNone;
    return mainTableCell;
    }
    
  tblViewCell.selectionStyle=UITableViewCellSelectionStyleNone;
  return tblViewCell;
}

-(void)checkProductAvailability
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
        
       if([self.cartArray count]>0)
       {
       for(int j=0;j<[self.cartArray count];j++){
        self.dataProduct =[self.cartArray objectAtIndex:j];
        if([self.dataProduct.ProductId isEqualToString:newobjectToadd.ProductId])
        {
            IsAdd=NO;
        }
    }
    if(IsAdd)
    {
        [self.cartArray addObject:newobjectToadd];
    }
    }
    else
    {
        [self.cartArray addObject:newobjectToadd];
    }
    }
}

-(void)calculatetheTotal
{
    float totalPrice;
    //Calculating the total cost for all the products added into the cart.
    for(int i=0;i<[self.cartArray count];i++)
    {
        DataProduct *dataproduct=[self.cartArray objectAtIndex:i];
        totalPrice =totalPrice+dataproduct.productUnitprice;
        NSLog(@"Total price %0.2f",totalPrice);
    }
    self.lbltotal.text=[NSString stringWithFormat:@"Total:$%0.2f",totalPrice];
}

//Editing style for the UITableviewCell
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    // Updates the appearance of the Edit|Done button as necessary.
    [super setEditing:editing animated:animated];
    [tblView1 setEditing:editing animated:animated];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView beginUpdates];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Do whatever data deletion you need to do...
        // Delete the row from the data source
        
        [self.cartArray removeObjectAtIndex:indexPath.row];
        [self.datacart mutableCopyArrayCart:self.cartArray];
        
       [tblView1 deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        
        [tblView1 reloadData];
        
        [self calculatetheTotal];
    }
    [tableView endUpdates];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)CartProducts
{
    NSUserDefaults *userdefualts=[NSUserDefaults standardUserDefaults];
    NSString *struserId= [userdefualts objectForKey:@"UserId"];
    //getting all the products in the database.
    PFQuery *query = [PFQuery queryWithClassName:@"Cart"];
    [query whereKey:@"UserId" equalTo:struserId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects
            for (PFObject *object in objects) {
                //getting the category Name and Object Id's
                DataProduct *dataproduct=[[DataProduct alloc]init];
                dataproduct.ProductId=object[@"ProductId"];
                dataproduct.RandomProductId=object[@"RandomProductId"];
                dataproduct.ProductName=object[@"productName"];
                dataproduct.CategoryId=object[@"categoryid"];
                dataproduct.productSize=object[@"productSize"];
                dataproduct.productDescription=object[@"ProductDescription"];
                dataproduct.productColor=object[@"productColor"];
                dataproduct.ProductModel=object[@"productModel"];
                NSString *strproductQty=object[@"ProductQty"];
                NSString *strProductPrice=object[@"ProductPrice"];
                NSString *strreqquantity=object[@"RequiredQuantity"];
                dataproduct.productreqQuantity=[strreqquantity integerValue];
                dataproduct.ProductImage=object[@"ProductImage"];
                dataproduct.productImages=object[@"ProductImages"];
                dataproduct.productDescription=object[@"ProductDescription"];
                dataproduct.productquantity=[strproductQty integerValue];
                dataproduct.productUnitprice=[strProductPrice floatValue];
                [self.cartArray addObject:dataproduct];
                
                PFFile *theImage =(PFFile*)dataproduct.ProductImage;
                [theImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
                    UIImage *image = [UIImage imageWithData:data];
                    dataproduct.imgproduct=image;
                }];
            }
            [tblView1 reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(IBAction)ClickedCheckout:(id)sender
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ShippingDetailsViewController*lvc = [storyboard instantiateViewControllerWithIdentifier:@"ShippingDetails"];
//    lvc.dataproduct= [self.arrayOfAllproducts objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:lvc animated:YES];
    
//    NSUserDefaults *userdefaults=[NSUserDefaults standardUserDefaults];
//    NSString *strfirstName= [userdefaults objectForKey:@"firstName"];
//    if([strfirstName isEqualToString:@""]||strfirstName ==nil)
//    {
//        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Login required" message:@"Please login first to Checkout" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alertview show];
//    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
     if(buttonIndex==0)
     {
         [alertView dismissWithClickedButtonIndex:0 animated:YES];
         // Get views. controllerIndex is passed in as the controller we want to go to.
         UIView * fromView = self.tabBarController.selectedViewController.view;
         UIView * toView = [[self.tabBarController.viewControllers objectAtIndex:2] view];
         
         // Transition using a page curl.
         [UIView transitionFromView:fromView
                             toView:toView
                           duration:1.0
                            options:(2 >self.tabBarController.selectedIndex ? UIViewAnimationOptionTransitionCurlUp : UIViewAnimationOptionTransitionCurlDown)
                         completion:^(BOOL finished) {
                             if (finished) {
                                 self.tabBarController.selectedIndex = 2;
                             }
                         }];
     }
}

//- (IBAction)goBack:(id)sender
//{
//    [self.navigationController popViewControllerAnimated:YES];
////    ((UITabBarController *)self.parentViewController).selectedIndex = 0;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
