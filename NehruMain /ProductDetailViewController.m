//
//  ProductDetailViewController.m
//  nehru
//
//  Created by shelly vashishth on 03/12/13.
//  Copyright (c) 2013 nehru. All rights reserved.
//

#import "ProductDetailViewController.h"

static CGFloat kImageOriginHight = 240.f;

@interface ProductDetailViewController ()
@property (nonatomic, strong) NSMutableArray *pageImages;
@property (nonatomic, strong) NSMutableArray *pageViews;

@end

@implementation ProductDetailViewController
@synthesize dataproduct;
@synthesize pageImages = _pageImages;
@synthesize mProdctImage;
@synthesize arrImages;
@synthesize currentCellSize;
@synthesize datacart;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"icon-cart.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickedShowCart:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(280, 25, 30, 30)];
    self.navigationController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    NSLog(@"Product %@",self.dataproduct.ProductId);
}


-(void)GetAllProductSizeAvailable
{
    NSLog(@"Data product Id %@",self.dataproduct.ProductId);
    mArrSizes=[[NSMutableArray alloc]init];
    ArrProductSizeIds =[[NSMutableArray alloc]init];
    PFQuery *query = [PFQuery queryWithClassName:@"NehruProductSize"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects.
            for (PFObject *object in objects) {
                
                NSString *productSizeName=object[@"ProductSize"];
                NSString *productSizeId=object.objectId;
                
                NSLog(@"ProductSize Name %@",productSizeName);
                NSLog(@"Product Size id %@",productSizeId);
                //getting the category Name and Object Id's.
                [mArrSizes addObject:productSizeName];
                [ArrProductSizeIds addObject:productSizeId];
                NSLog(@"Arr product Sizes %@",mArrSizes);
                NSLog(@"Arr Product Size Ids %@",ArrProductSizeIds);
            }
            [self GetAllProductColorAvailable];
            [mTblSizes reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(void)GetAllProductColorAvailable
{
    NSLog(@"Data product Id %@",self.dataproduct.ProductId);
    mArrColors=[[NSMutableArray alloc]init];
    ArrProductColorIds=[[NSMutableArray alloc]init];
    PFQuery *query = [PFQuery queryWithClassName:@"NehruProductColor"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects
            for (PFObject *object in objects) {
                //getting the category Name and Object Id's
                NSString *productColorName=object[@"ProductColor"];
                NSString *productColorId=object.objectId;
          
                [mArrColors addObject:productColorName];
                [ArrProductColorIds addObject:productColorId];
                NSLog(@"Arr product colors %@",mArrColors);
                NSLog(@"Arr product Color Ids %@",ArrProductColorIds);
            }
            [mTblColors reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)ClickedBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//Load custom View
-(IBAction)actionViewLoader:(id)sender {
    [mViewMainLoader setHidden:NO];
    //Add Calculations View Controller
    PageFlippingViewController *calculationController = [self.storyboard instantiateViewControllerWithIdentifier:@"FlipperVC"];
    calculationController.getArrayItemId = self.pageImages;
    [self.navigationController pushViewController:calculationController animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *imageView1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nehru-logo.png"]];
    self.navigationItem.titleView=imageView1;
//    [mBtnInCart setBackgroundColor:[UIColor redColor]];
    [mBtnInCart setBackgroundImage:[UIImage imageNamed:@"add-to-cart.png"] forState:UIControlStateNormal];

    self.navigationController.navigationBar.translucent = NO;

    MArrMainItems = [[NSMutableArray alloc]initWithObjects:@"b2.jpg",@"b3.jpg",@"b4.jpg",@"b5.jpg",@"b6.jpg",@"b7.jpg",@"b8.jpg",@"b9.jpg",@"b10.jpg",@"b11.jpg", nil];
    self.dataproduct.productColor=@"";
    self.dataproduct.productSize=@"";
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    isSize=NO;
    isColour=NO;
    [mTblColors setHidden:YES];
    [mTblSizes setHidden:YES];
    [mViewColor setHidden:YES];
    [mViewSize setHidden:YES];
    [activityViewCart setHidden:YES];
    self.dataproduct.productreqQuantity=1;
    //Adding the viewed object into the DataHistory singleton class.
    //[mViewMainLoader setHidden:YES];
    // btnImageProduct.imageView.image=[UIImage imageNamed:@"photo1.png"];
    
    self.mProdctImage.image =self.dataproduct.imgproduct;
   // btnImageProduct.backgroundColor=[UIColor colorWithPatternImage:self.dataproduct.imgproduct];
    NSLog(@"Dataproduct %@",self.dataproduct);
//    self.backgScroll.contentSize=CGSizeMake(320, 500);
    self.itemColorView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.itemColorView.layer.borderWidth=1.0f;
    
    self.itemSizeView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.itemSizeView.layer.borderWidth=1.0f;
    [self displayDataOnscreen];

    CGSize tmpSize = self.MMainCollectionView.bounds.size;
    currentCellSize = CGSizeMake( tmpSize.width, tmpSize.height);
    
//    DataMyCart* checkoutCart = [DataMyCart sharedCart];
//    mBtnInCart.selected = [checkoutCart containsProduct:self.dataproduct] ? YES : NO;
    
//    mArrColors=[[NSMutableArray alloc]initWithObjects:@"White",@"Black",@"Red",@"Green",@"Blue", nil];
//    mArrSizes = [[NSMutableArray alloc]initWithObjects:@"Small",@"Medium",@"Large",@"Extra Large",@"Extra Extra Large", nil];
    [self GetAllProductSizeAvailable];
    [self LoadImages];
}


-(void)LoadImages
{
    self.pageImages=[[NSMutableArray alloc]init];
    self.arrImages=[[NSMutableArray alloc]init];
    self.pageImages=self.dataproduct.productImages;
    NSLog(@"Arr images %@",self.pageImages);
    for(int i=0;i<[self.pageImages count];i++)
    {
        PFFile *theImage =(PFFile*)[self.pageImages objectAtIndex:i];
        [theImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
            UIImage *image = [UIImage imageWithData:data];
            [self.arrImages addObject:image];
            
            if(i==5)
            {
                NSLog(@"Arr Images name %@",self.arrImages);
                [self.MMainCollectionView reloadData];
            }
        }];
        
        
    }
}

-(void)GetProductImagesFromParse
{
    // Set up the image we want to scroll & zoom and add it to the scroll view
//    self.pageImages = [[NSArray alloc]init];
    PFQuery *query = [PFQuery queryWithClassName:@"NehruProducts"];
    NSLog(@"Data product Id %@",self.dataproduct.ProductId);
    [query getObjectInBackgroundWithId:self.dataproduct.ProductId block:^(PFObject *objProduct, NSError *error) {
        // Do something with the returned PFObject in the gameScore variable.
        NSLog(@"OBJProduct %@", objProduct);
        self.pageImages=[objProduct objectForKey:@"ProductImages"];
        NSInteger pageCount = self.pageImages.count;
        
//        Set up the page control
//        self.pageControl.currentPage = 0;
//        self.pageControl.numberOfPages = pageCount;
        
        // Set up the array to hold the views for each page
        self.pageViews = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < pageCount; ++i) {
            [self.pageViews addObject:[NSNull null]];
        }
    }];
    NSLog(@"Page images %@",self.pageImages);
}

//mLoaderView controller
-(IBAction)closeImageLoaderView:(id)sender {
    [mViewMainLoader setHidden:YES];
}

//Adding six images to the product on parse.

-(void)AddProductImages
{
    NSMutableArray *arrofImages=[[NSMutableArray alloc]init];
    for(int i=1;i<=6;i++)
    {
        UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"images%d.jpeg",i]];
        // Resize image
        UIGraphicsBeginImageContext(CGSizeMake(640,960));
        [image drawInRect: CGRectMake(0, 0, 640,960)];
        UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSData *imageData = UIImageJPEGRepresentation(smallImage, 0.05f);
        //first Image.
        
        PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"images%d.jpeg",i] data:imageData];
        [arrofImages addObject:imageFile];

    }
        NSLog(@"Images of the product %@",arrofImages);
        PFQuery *query = [PFQuery queryWithClassName:@"NehruProducts"];
        NSLog(@"Data product Id %@",self.dataproduct.ProductId);
        [query getObjectInBackgroundWithId:self.dataproduct.ProductId block:^(PFObject *objProduct, NSError *error) {
            // Do something with the returned PFObject in the gameScore variable.
            NSLog(@"Object Product %@",objProduct);
            [objProduct setObject:arrofImages forKey:@"ProductImages"];
            [objProduct saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    // The find succeeded.
                    if(succeeded){
                        NSLog(@"Successfull loading of image array in parse.");
                    }
                    else{
                        NSLog(@"Sorry we were not able upload PFFile in parse.");
                    }
                }
                else {
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];

            NSLog(@"OBJProduct %@", objProduct);
        }];
        // Do something with the returned PFObject in the gameScore variable.
}
# pragma TableView Delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 22;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(isColour )
    {
        return [mArrColors count];
    }
    else if(isSize)
    {
        return [mArrSizes count];
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     UITableViewCell *cell;
    NSString *Identifier=@"Identifier";
    cell=[tableView dequeueReusableCellWithIdentifier:Identifier];
    
     [tableView setSeparatorInset:UIEdgeInsetsZero];
        if(cell==nil){
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
        }
        //dataproduct=[self.arrayOfAllproducts objectAtIndex:indexPath.row];
        if(isColour)
        {
        cell.textLabel.text=[mArrColors objectAtIndex:indexPath.row];
        cell.textLabel.font=[UIFont fontWithName:@"Calibri" size:12.0f];
        cell.textLabel.textColor = [UIColor colorWithRed:211.0f/256.0f green:45.0f/256.0f blue:0.0f/256.0f alpha:1.0];
//            [cell addSubview:Tlblcolor];
        }
    
        else if(isSize)
        {
            cell.textLabel.text=[mArrSizes objectAtIndex:indexPath.row];
            cell.textLabel.font=[UIFont fontWithName:@"Calibri" size:12.0f];
            cell.textLabel.textColor = [UIColor colorWithRed:211.0f/256.0f green:45.0f/256.0f blue:0.0f/256.0f alpha:1.0];
        }
        return cell;
    }


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [mViewColor setHidden:YES];
    [mViewSize setHidden:YES];
    
    if(isColour)
    {
    lblColor.text=[mArrColors objectAtIndex:indexPath.row];
        self.dataproduct.productColor=lblColor.text;
        self.dataproduct.productColorId=[ArrProductColorIds objectAtIndex:indexPath.row];
        NSLog(@"Data product color id %@",self.dataproduct.productColorId);
    }
    else
    {
    lblSize.text=[mArrSizes objectAtIndex:indexPath.row];
        self.dataproduct.productSize= lblSize.text;
        self.dataproduct.productSizeId=[ArrProductSizeIds objectAtIndex:indexPath.row];
        NSLog(@"Data product Size Id %@",self.dataproduct.productSizeId);
    }
}

#pragma UICollectionViewDelegates

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView :(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
        return [self.arrImages count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return currentCellSize;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    productCollectionImages *cell;
   
        if (indexPath.row==0) {
            identifier = @"Cell0";
        }
    cell =[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell.MImageItem setContentMode:UIViewContentModeScaleAspectFit];
    cell.MImageItem.image = [self.arrImages objectAtIndex:indexPath.row];
    cell.lblProductName.text=self.dataproduct.ProductName;
    cell.lblPrice.text=[NSString stringWithFormat:@"%0.2f",self.dataproduct.productUnitprice];
    return cell;
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UISwipeGestureRecognizer *swipegesture=[[UISwipeGestureRecognizer alloc]init];
//    [swipegesture setDelegate:self];
//    [swipegesture addTarget:self action:@selector(ClickedHandle:)];
//    [swipegesture setValue:indexPath forKey:@"ProductId"];
//}
//
//-(void)ClickedHandle:(UISwipeGestureRecognizer*)swipeGesture
//{
//    NSIndexPath *collectionViewIndex=[swipeGesture valueForKey:@"ProductId"];
//    NSLog(@"Collection View index %d",collectionViewIndex.row);
//}

-(void)displayDataOnscreen
{
    NSLog(@"Dataproduct %@",self.dataproduct);
    self.pageImages=[[NSMutableArray alloc]init];

    lblPriceProduct.font=[UIFont fontWithName:@"Calibri" size:12.0f];
    lblPriceProduct.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pro-price-bg.png"]];
    lblPriceProduct.text=[NSString stringWithFormat:@"$% 0.2f",self.dataproduct.productUnitprice];
    productName.text=self.dataproduct.ProductName;
    productName.font=[UIFont fontWithName:@"Calibri" size:18.0f];
    lblPriceProduct.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pro-price-bg.png"]];
    btnImageProduct.imageView.image = self.dataproduct.imgproduct;
    
    NSLog(@"Product Description %@",self.dataproduct.productDescription);
    txtViewdescription.text=self.dataproduct.productDescription;
    NSLog(@"product Images %@",self.dataproduct.productImages);
    }





//Adding product to wishlist in singleton and to the wishlist in parse database.
-(IBAction)AddProducttoWishlist:(id)sender
{
    //Clicked product added into the wishlist here in singleton class on the iphone itself.
    DataWishlist *wishlist=[DataWishlist sharedWishList];
    [wishlist addProduct:self.dataproduct];
    
    //Now time to add the product on the parse database.
    [self AddwishlistProductToParse:self.dataproduct.ProductId];
}

-(void)AddwishlistProductToParse:(NSString*)strproductId
{
    PFObject *gameScore = [PFObject objectWithClassName:@"NehruWishlist"];
    //gameScore[@"productId"] = strproductId;
    [gameScore setObject:strproductId forKey:@"productId"];
    [gameScore saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // The find succeeded.
            if(succeeded){
                NSLog(@"Successfull addition to wishlist.");
                [self addedToWishlist];
                
            }
            else{
                NSLog(@"Sorry we were not able to add product to wishlist.");
            }
        }
        else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(void)addedToWishlist {
    UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Got Success" message:@"Product Successfully Added to wishlist" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertview show];
}

-(IBAction)ClickedSelectSize:(id)sender
{
    if(isSize)
    {
        isSize=NO;
         [mViewSize setHidden:YES];
        [mTblSizes setHidden:YES];
       
        if(isColour)
        {
            isColour=NO;
            [mViewColor setHidden:YES];
            [mTblColors setHidden:YES];
            
        }
    }
    else if(!isSize)
    {
        isSize=YES;
        [mTblSizes setHidden:NO];
        [mViewSize setHidden:NO];
        if(isColour)
        {
            isColour=NO;
             [mViewColor setHidden:YES];
            [mTblColors setHidden:YES];
           
        }
    }
    [mTblSizes reloadData];
}

-(IBAction)ClickedSelectColor:(id)sender
{
    if(isColour)
    {
        isColour=NO;
        [mViewColor setHidden:YES];
        [mTblColors setHidden:YES];
        if(isSize)
        {
            isSize=NO;
            [mViewSize setHidden:YES];
            [mTblSizes setHidden:YES];
        }
    }
    else if(!isColour)
    {
        isColour=YES;
        [mViewColor setHidden:NO];
        [mTblColors setHidden:NO];
        if(isSize)
        {
            isSize=NO;
            [mViewSize setHidden:YES];
            [mTblSizes setHidden:YES];
        }
    }
    [mTblColors reloadData];
}

-(IBAction)ClickedAddToCart:(id)sender
{
    if ([lblColor.text isEqualToString:@"Select Color"]||[lblSize.text isEqualToString:@"Select Size"]) {
        if ([lblColor.text isEqualToString:@"Select Color"]&&[lblSize.text isEqualToString:@"Select Size"]) {
            UIAlertView *alertColor = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Select Color and Size" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertColor show];
        }
    else if ([lblColor.text isEqualToString:@"Select Color"]) {
        UIAlertView *alertColor = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Select Color" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertColor show];
    }
   else if ([lblSize.text isEqualToString:@"Select Size"]) {
        UIAlertView *alertColor = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Select Size" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertColor show];
    }
    }
    else {
    
    [activityViewCart setHidden:NO];
    [activityViewCart startAnimating];
    self.datacart=[DataMyCart sharedCart];
    
    NSString *randomproductId=[NSString stringWithFormat:@"%@%@%@",self.dataproduct.productSizeId,self.dataproduct.productColorId,self.dataproduct.ProductId];
    NSLog(@"New RandomProductId %@",randomproductId);
    self.dataproduct.RandomProductId=randomproductId;
    
    if([self CheckProductQuantity])
    {
        if (!mBtnInCart.selected) {
            [self.datacart addProduct:self.dataproduct];
            if (_timer == nil)
            {
                _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                          target:self
                                                        selector:@selector(showInCart)
                                                        userInfo:nil
                                                         repeats:NO];
            }
        }
        else
        {
            if (_timer == nil)
            {
                _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                          target:self
                                                        selector:@selector(showInCart)
                                                        userInfo:nil
                                                         repeats:NO];
            }
        }
    }
    else
    {
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Quantity out of stock" message:@"Product Quantity not available" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertview show];
        }
        [activityViewCart setHidden:YES];
        [activityViewCart stopAnimating];
  
    }
}


//Saving the products into the cart.
-(IBAction)AddingProductToCartOnParse:(id)sender
{
    NSUserDefaults *userdefualts=[NSUserDefaults standardUserDefaults];
    NSString *struserId= [userdefualts objectForKey:@"UserId"];
    NSLog(@"User Id %@",struserId);
    if(struserId ==NULL)
    {
        UIAlertView *alertColor = [[UIAlertView alloc]initWithTitle:@"Login Required" message:@"First Login to add products into cart." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertColor show];
    }
    else
    if ([lblColor.text isEqualToString:@"Select Color"]||[lblSize.text isEqualToString:@"Select Size"]) {
        if ([lblColor.text isEqualToString:@"Select Color"]&&[lblSize.text isEqualToString:@"Select Size"]) {
            UIAlertView *alertColor = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Select Color and Size" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertColor show];
        }
        else if ([lblColor.text isEqualToString:@"Select Color"]) {
            UIAlertView *alertColor = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Select Color" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertColor show];
        }
        else if ([lblSize.text isEqualToString:@"Select Size"]) {
            UIAlertView *alertColor = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Select Size" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertColor show];
        }
    }
    else {
    [activityViewCart setHidden:NO];
    [activityViewCart startAnimating];
    NSString *randomproductId=[NSString stringWithFormat:@"%@%@%@",self.dataproduct.productSizeId,self.dataproduct.productColorId,self.dataproduct.ProductId];
    NSLog(@"New RandomProductId %@",randomproductId);
        
    PFQuery *validLoginQuery=[PFQuery queryWithClassName:@"Cart"];
    [validLoginQuery whereKey:@"RandomProductId" equalTo:randomproductId];
    [validLoginQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    if (!error) {
    // The find succeeded.
        if(objects.count==1){
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Already" message:@"Product already exists in the database." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
                    [alertview show];
    }
    else{
    PFObject *usrSignUp=[PFObject objectWithClassName:@"Cart"];
    [usrSignUp setObject:struserId forKey:@"UserId"];
    [usrSignUp setObject:self.dataproduct.ProductId forKey:@"ProductId"];
    [usrSignUp setObject:randomproductId forKey:@"RandomProductId"];
    [usrSignUp setObject:self.dataproduct.ProductName forKey:@"productName"];
    [usrSignUp setObject:self.dataproduct.ProductModel forKey:@"productModel"];
    [usrSignUp setObject:[NSString stringWithFormat:@"%f",self.dataproduct.productUnitprice] forKey:@"ProductPrice"];
    [usrSignUp setObject:[NSNumber numberWithInt:self.dataproduct.productquantity]  forKey:@"ProductQty"];
    [usrSignUp setObject:self.dataproduct.CategoryId forKey:@"categoryid"];
    [usrSignUp setObject:self.dataproduct.productDescription forKey:@"ProductDescription"];
    [usrSignUp setObject:self.dataproduct.productImages forKey:@"ProductImages"];
    [usrSignUp setObject:self.dataproduct.ProductImage forKey:@"ProductImage"];
    [usrSignUp setObject:self.dataproduct.productSize forKey:@"productSize"];
    [usrSignUp setObject:self.dataproduct.productColor forKey:@"productColor"];
    [usrSignUp saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // The find succeeded.
            if(succeeded){
                self.dataproduct.RandomProductId=randomproductId;
                [activityViewCart setHidden:YES];
                [activityViewCart stopAnimating];
                if (_timer == nil)
                {
                    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                              target:self
                                                            selector:@selector(showInCart)
                                                            userInfo:nil
                                                             repeats:NO];
                }
            }
            else{
               
            }
        }
        else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    }
    }}];
    }
}


-(IBAction)ClickedIncreaseQty:(id)sender
{
    NSInteger prodQty=self.dataproduct.productquantity;
    NSString *availableQty=[NSString stringWithFormat:@"%@",lblqty.text];
    
    NSInteger qtyupdated=[availableQty integerValue];
    qtyupdated= qtyupdated+1;
    
    if(qtyupdated>prodQty)
    {
        qtyupdated=qtyupdated-1;
    }
    lblqty.text=[NSString stringWithFormat:@"%d",qtyupdated];
    self.dataproduct.productreqQuantity=qtyupdated;
}


-(IBAction)ClickedDecreaseQty:(id)sender
{
    NSString *availableQty=[NSString stringWithFormat:@"%@",lblqty.text];
    
    NSInteger qtyupdated=[availableQty integerValue];
    qtyupdated=qtyupdated-1;
    
    if(qtyupdated<1)
    {
        qtyupdated=qtyupdated+1;
    }
    lblqty.text=[NSString stringWithFormat:@"%d",qtyupdated];
    self.dataproduct.productreqQuantity=qtyupdated;
}

-(BOOL)CheckProductQuantity
{
    NSInteger getTotalQty=0;
    NSMutableArray *productArrayInCart=[self.datacart getArray];
    
    for (DataProduct* product in productArrayInCart) {
        NSLog(@"Data product Id %@",self.dataproduct.ProductId);
        NSLog(@"Data product Id %@",product.ProductId);
        NSLog(@"Random Product id %@",self.dataproduct.RandomProductId);
        NSLog(@"Random Product Id %@",product.RandomProductId);
        if([self.dataproduct.ProductId isEqualToString:product.ProductId])
        {
            getTotalQty=getTotalQty+product.productreqQuantity;
        }
    }
    if(getTotalQty >= self.dataproduct.productquantity)
    {
        return NO;
    }
    else {
        return YES;
    }
}



-(void)showInCart {
    if(mBtnInCart.selected)
    {
        mBtnInCart.selected=NO;
    [activityViewCart setHidden:YES];
    [activityViewCart stopAnimating];
    [mBtnInCart setBackgroundImage:[UIImage imageNamed:@"in-cart.png"] forState:UIControlStateNormal];
    }
    else
    {
        mBtnInCart.selected = YES;

        [activityViewCart setHidden:YES];
        [activityViewCart stopAnimating];
        [mBtnInCart setBackgroundImage:[UIImage imageNamed:@"add-to-cart.png"] forState:UIControlStateNormal];
    }
}

-(void)clickedShowCart:(id)sender
{
    if([[[DataMyCart sharedCart]getArray]count]>0)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        CartViewController *lvc = [storyboard instantiateViewControllerWithIdentifier:@"CartView"];
//        lvc.dataproduct= [self.arrayOfAllproducts objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:lvc animated:YES];

//    [self performSegueWithIdentifier:@"pushToCart" sender:0];
    }
    else
    {
        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Empty Cart" message:@"Please add product into cart" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertview show];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

   
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
