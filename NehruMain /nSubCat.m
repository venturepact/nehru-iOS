//
//  nSubCat.m
//  nehru
//
//  Created by ADMIN on 11/28/13.
//  Copyright (c) 2013 nehru. All rights reserved.
//

#import "nSubCat.h"
#import "DataCategory.h"

@interface nSubCat ()

@end

@implementation nSubCat
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
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,0,100,30)];
    view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"reveal-icon.png"]];
    
    UIButton *btnleft=[UIButton buttonWithType:UIButtonTypeCustom];
    btnleft.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"reveal-icon.png"]];
    
    UILabel *lblproductsInCart=[[UILabel alloc]init];
    lblproductsInCart.text=@"2";
    lblproductsInCart.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@""]];
    
    //Getting the Categories of the all products available in database.
    
    [self getCategories];
    
//   [self DisplayCategories];
    
    
//    [self animateTable];

//    [self GetProducts];
//    UIBarButtonItem *btnleft=[[UIBarButtonItem alloc]initWithTitle:@"Cart" style:UIBarButtonItemStyleBordered target:self action:@selector(ClickedCart)];
//    [view addSubview:btnleft];
//    [btnleft setBackgroundImage:[UIImage imageNamed:@"reveal-icon.png"] forState:UIControlStateNormal barMetrics:nil];
//    [self.navigationController.navigationItem.rightBarButtonItem];
}

-(void)getCategories
{
    arrcategories=[[NSMutableArray alloc]init];
    PFQuery *query = [PFQuery queryWithClassName:@"NehruCategories"];
    //    [query whereKey:@"playerName" equalTo:@"Dan Stemkoski"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                
                DataCategory *datacategory=[[DataCategory alloc]init];
                datacategory.CategoryName=object[@"categoryName"];
                datacategory.CategoryId=object.objectId;
                NSLog(@"CategoryId %@",datacategory.CategoryId);
                //getting the category Name and Object Id's
                [arrcategories addObject:datacategory];
                NSLog(@"%@",object[@"categoryName"]);
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


//Getting the products according to specific categories.
//here Formal and casual is used mostly.
-(IBAction)GetProductAccCategory:(id)sender
{
    NSLog(@"Array of categories %@",arrcategories);
    arrcasualProducts=[[NSMutableArray alloc]init];
    arrformalproducts=[[NSMutableArray alloc]init];
    for(int i=0;i<[arrcategories count];i++)
    {
        DataCategory *datacategory=[[DataCategory alloc]init];
        datacategory=[arrcategories objectAtIndex:i];
        NSString *CategoryName=datacategory.CategoryName;
        NSLog(@"Category Name %@",CategoryName);
        NSLog(@"Category Id %@",datacategory.CategoryId);
        PFQuery *query = [PFQuery queryWithClassName:@"NehruProducts"];
        [query whereKey:@"categoryid" equalTo:datacategory.CategoryId];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                NSLog(@"Successfully retrieved %d products according to this category %@.", objects.count,datacategory.CategoryId);
                // Do something with the found objects
                for (PFObject *object in objects) {
                    NSLog(@"%@", object.objectId);
                    
                    DataProduct *dataproducts=[[DataProduct alloc]init];
                    dataproducts.ProductName=object[@"productName"];
                    dataproducts.ProductId=object[@"objectId"];
                    dataproducts.ProductImage=object[@"productImage"];
                    dataproducts.ProductModel=object[@"productModel"];
                    
                    NSLog(@"Data product %@",dataproducts);
                    //list of formal products
                    if([CategoryName isEqualToString:@"Formal"])
                    {
                        [arrformalproducts addObject:dataproducts];
                        
                        NSLog(@"Arr of formal products %@",arrformalproducts);
                    }
                    //list of casual products.
                    else if([CategoryName isEqualToString:@"Casual"])
                    {
                        [arrcasualProducts addObject:dataproducts];
                        NSLog(@"Arr of casual products %@",arrcasualProducts);
                        [tblView1 reloadData];
                    }
                }
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
}

//-(void)DisplayCategories
//{
//    DataCategory *datacategory=[[DataCategory alloc]init];
//    NSLog(@"Array of Categories %@",arrcategories);
//    for(int i=0;i<=[arrcategories count];i++)
//    {
//       datacategory=[arrcategories objectAtIndex:0];
//       btnCasual.titleLabel.text=datacategory.CategoryName;
//        
//        datacategory=[arrcategories objectAtIndex:1];
//        btnFormal.titleLabel.text=datacategory.CategoryName;
//    }
//}
//
//-(IBAction)ClickedOnbtnFormal:(id)sender
//{
//    [UIView transitionFromView:tblView1
//                        toView:tblView1
//                      duration:1
//                       options:UIViewAnimationTransitionCurlDown
//                    completion:nil];
//
//}

//-(void)animateTable
//{
//    [UIView transitionFromView:tblView1
//                        toView:tblView1
//                      duration:1
//                       options:UIViewAnimationOptionTransitionFlipFromLeft
//                    completion:nil];
//}
//

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *tableIdentifier=@"nSubProductTable";
    nSubCatCell *mainTableCell=[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    
    if(mainTableCell==nil){
        mainTableCell=[[nSubCatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }
    DataProduct *dataproducts=[arrcasualProducts objectAtIndex:indexPath.row];
    
    mainTableCell.lblproductName.text=dataproducts.ProductName;
    mainTableCell.btnfavorites.titleLabel.text=@"Add to Favorites";
    return mainTableCell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrcasualProducts count];
}


-(void)ClickedBtnfavorites
{
    WishListViewController *wishlist=[[WishListViewController alloc]init];
    [self.navigationController pushViewController:wishlist animated:YES];
}


//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSInteger currentOffset = nMainCatTable.contentOffset.y;
//    NSInteger maximumOffset = nMainCatTable.contentSize.height - nMainCatTable.frame.size.height;
//    
//    // Change 10.0 to adjust the distance from bottom
//    if (maximumOffset - currentOffset <= 10.0) {
//        
//        [nMainCatTable reloadData];
//    }
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
