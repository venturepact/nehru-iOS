//
//  ProductDetailViewController.m
//  nehru
//
//  Created by shelly vashishth on 03/12/13.
//  Copyright (c) 2013 nehru. All rights reserved.
//

#import "ProductDetailViewController.h"

@interface ProductDetailViewController ()
@property (nonatomic, strong) NSMutableArray *pageImages;
@property (nonatomic, strong) NSMutableArray *pageViews;

- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;

@end

@implementation ProductDetailViewController
@synthesize dataproduct,datamyCart;
@synthesize pageImages = _pageImages;
@synthesize carousel;
@synthesize scrollView;
@synthesize pageControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setNavigationFrame
{
//    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
//    {
//        CGRect frame = self.navigationController.view.frame;
//        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//        {
//            frame.origin.y = 20;
//        }
//        else
//        {
//            frame.origin.x = 20;
//        }
//        [self.navigationController.view setFrame:frame];
//    }
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav-bg.png"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title=@"Nehru";
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,shadow, NSShadowAttributeName,[UIFont fontWithName:@"Calibri" size:14.0], NSFontAttributeName, nil]];
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"icon-cart.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickedShowCart:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(280, 25, 30, 30)];
    self.navigationController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
//    [self.navigationController pushViewController:viewController2 animated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated
{
//   [self setNavigationFrame];
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"icon-cart.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickedShowCart:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(280, 25, 30, 30)];
    self.navigationController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    NSLog(@"Product %@",self.dataproduct.ProductId);
    // Set up the content size of the scroll view
    self.backgScroll.contentSize=CGSizeMake(320, 500);
}

-(void)GetAllProductSizeAvailable
{
    NSLog(@"Data product Id %@",self.dataproduct.ProductId);
    ArrProductSizes=[[NSMutableArray alloc]init];
    PFQuery *query = [PFQuery queryWithClassName:@"NehruProductSize"];
    [query whereKey:@"ProductId" equalTo:self.dataproduct.ProductId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects
            for (PFObject *object in objects) {
                //getting the category Name and Object Id's
                [ArrProductSizes addObject:object[@"ProductSize"]];
                NSLog(@"Arr product Sizes %@",ArrProductSizes);
                [self GetAllProductColorAvailable];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)loadVisiblePages {
    // First, determine which page is currently visible
    
    NSLog(@"Page images %@",self.pageImages);
    NSInteger pageCount = self.pageImages.count;
    // Set up the page control
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = pageCount;
    
    // Set up the array to hold the views for each page
    self.pageViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < pageCount; ++i) {
        [self.pageViews addObject:[NSNull null]];
    }
    
    self.scrollView.frame=CGRectMake(0, 0, 320, 180);
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    NSInteger count= self.pageImages.count;
    // [self.scrollView setContentOffset:CGPointMake(1536, 0) animated:YES];
    [self.scrollView setContentSize:CGSizeMake(count*320,180)];
    // Update the page control
    self.pageControl.currentPage = page;
    
    // Work out which pages we want to load
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
    // Purge anything before the first page
    for (NSInteger i=0; i<firstPage; i++) {
        [self purgePage:i];
    }
    for (NSInteger i=firstPage; i<=lastPage; i++) {
        [self loadPage:i];
    }
    for (NSInteger i=lastPage+1; i<self.pageImages.count; i++) {
        NSLog(@"page  Images count %d",self.pageImages.count);
        [self purgePage:i];
    }
}

- (void)loadPage:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) {
        // If it's outside the range of what we have to display, then do nothing
        
        NSLog(@"Page images count %d",self.pageImages.count);
        return;
    }
    // Load an individual page, first seeing if we've already loaded it
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView == [NSNull null]) {
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        UIImageView *imageView1=[[UIImageView alloc]initWithFrame:frame];
        imageView1.frame=frame;
        imageView1.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"photo1.png"]];
//        [imageView1 addSubview:productName];
//        [imageView1 addSubview:AddBtnwishlist];
//        [imageView1 addSubview:lblPriceProduct];
//        [imageView1 addSubview:pageControl];
//        [imageView1 addSubview:btnImageProduct];
        [self.scrollView addSubview:imageView1];
        [self.pageViews replaceObjectAtIndex:page withObject:imageView1];
    }
}

- (void)purgePage:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) {
        // If it's outside the range of what we have to display, then do nothing
        return;
    }
    // Remove a page from the scroll view and reset the container array
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null]) {
        [pageView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}


-(void)GetAllProductColorAvailable
{
    NSLog(@"Data product Id %@",self.dataproduct.ProductId);
    ArrProductColors=[[NSMutableArray alloc]init];
    PFQuery *query = [PFQuery queryWithClassName:@"NehruProductColor"];
    [query whereKey:@"productId" equalTo:self.dataproduct.ProductId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            
            // Do something with the found objects
            for (PFObject *object in objects) {
                //getting the category Name and Object Id's
                [ArrProductColors addObject:object[@"ProductColor"]];
                NSLog(@"Arr product colors %@",ArrProductColors);
            }
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
    
//    [UIView transitionWithView:self.mLoaderView
//                      duration:10.0f
//                       options:UIViewAnimationOptionTransitionCurlDown
//                    animations:^{
//                        [self.mLoaderView addSubview:calculationController.view];
//                    }
//                    completion:nil];
//    [self addChildViewController:calculationController];
//    calculationController.view.frame = self.mLoaderView.bounds;
//    [self.mLoaderView addSubview:calculationController.view];
//    [calculationController didMoveToParentViewController:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *imageView1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nehru-logo.png"]];
    self.navigationItem.titleView=imageView1;
    
    isSize=NO;
    isColour=NO;
    [mTblColors setHidden:YES];
    [mTblSizes setHidden:YES];
//    [mTblSizes setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0,121,121)];
    [mViewColor setHidden:YES];
    [mViewSize setHidden:YES];
    [mBtnInCart setHidden:YES];
    [activityViewCart setHidden:YES];
    //Adding the viewed object into the DataHistory singleton class.
    //[mViewMainLoader setHidden:YES];
    
//    btnImageProduct.imageView.image=[UIImage imageNamed:@"photo1.png"];
    mProdctImage.image =self.dataproduct.imgproduct;
   // btnImageProduct.backgroundColor=[UIColor colorWithPatternImage:self.dataproduct.imgproduct];
    NSLog(@"Dataproduct %@",self.dataproduct);
    self.backgScroll.contentSize=CGSizeMake(320, 500);
    self.itemColorView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.itemColorView.layer.borderWidth=1.0f;
    
    self.itemSizeView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.itemSizeView.layer.borderWidth=1.0f;
    
    arrofSize=[[NSMutableArray alloc]initWithObjects:@"Size 1",@"Size 2", nil];
    arrofColor=[[NSMutableArray alloc]initWithObjects:@"Color 1",@"Color 2", nil];
//    isSize=YES;
    
    [self displayDataOnscreen];
    
    mArrColors=[[NSMutableArray alloc]initWithObjects:@"White",@"Black",@"Red",@"Green",@"Blue", nil];
    mArrSizes = [[NSMutableArray alloc]initWithObjects:@"Small",@"Medium",@"Large",@"Extra Large",@"Extra Extra Large", nil];
//    [self GetProductImagesFromParse];
    
    [self GetAllProductSizeAvailable];
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
        
        // Set up the page control
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
    btnColor.titleLabel.text=[mArrColors objectAtIndex:indexPath.row];
        self.dataproduct.productColor=btnColor.titleLabel.text;
    }
    else
    {
    btnSize.titleLabel.text=[mArrSizes objectAtIndex:indexPath.row];
        self.dataproduct.productSize=btnSize.titleLabel.text;
    }
}

-(void)addedToCartAlert {
    UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Got Success" message:@"Product Successfully Added to cart" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertview show];
}



-(void)displayDataOnscreen
{
    NSLog(@"Dataproduct %@",self.dataproduct);
    self.pageImages=[[NSMutableArray alloc]init];
    lblproductModelName.text=self.dataproduct.ProductModel;
    lblproductModelName.font=[UIFont fontWithName:@"Calibri" size:12.0f];
    lblproductQuantity.text=[NSString stringWithFormat:@"%d",dataproduct.productquantity];
    lblproductQuantity.font=[UIFont fontWithName:@"Calibri" size:12.0f];
     lblPriceProduct.font=[UIFont fontWithName:@"Calibri" size:12.0f];
     lblPriceProduct.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pro-price-bg.png"]];
    lblPriceProduct.text=[NSString stringWithFormat:@"$% 0.2f",self.dataproduct.productUnitprice];
    productName.text=self.dataproduct.ProductName;
    productName.font=[UIFont fontWithName:@"Calibri" size:18.0f];
    lblPriceProduct.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pro-price-bg.png"]];
    btnImageProduct.imageView.image = self.dataproduct.imgproduct;

    NSLog(@"product Images %@",self.dataproduct.productImages);
    NSMutableArray *arrimages=[[NSMutableArray alloc]init];
    arrimages=self.dataproduct.productImages;
    NSLog(@"Arr images %@",arrimages);
     UIImage *image = [UIImage imageNamed:@"bg1.jpg"];
    UIImage *image1=[UIImage imageNamed:@"bg2.jpg"];
    
    UIImage *image2=[UIImage imageNamed:@"bg3.jpg"];
    
    UIImage *image3=[UIImage imageNamed:@"bg4.jpg"];
    [self.pageImages addObject:image];
    [self.pageImages addObject:image1];
    
    [self.pageImages addObject:image2];
    [self.pageImages addObject:image3];
    
//    for(int i=0;i<[arrimages count];i++)
//    {
//        PFFile *theImage =[arrimages objectAtIndex:i];
//        [theImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
//            UIImage *image = [UIImage imageWithData:data];
//            
//            NSLog(@"Image %@",image);
//            
//            
//            NSLog(@"Page Images %@",self.pageImages);
//        }];
//    }
   // [self loadVisiblePages];
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


-(IBAction)ShowMyWishlist:(id)sender
{
    [self performSegueWithIdentifier:@"pushToWishlist" sender:0];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushToWishlist"])
    {
     WishListViewController *detailController = segue.destinationViewController;
        NSLog(@"Detail View controller %@",detailController);
    }
    else if([segue.identifier isEqualToString:@"pushToCart"])
    {
    CartViewController *detailController = segue.destinationViewController;
        NSLog(@"Detail View controller %@",detailController);
    }
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
//    isColour=NO;
//    
//    isSize=YES;
//    if (isClicked!=YES) {
//        
//        [mTblSizes setHidden:NO];
//        [mViewSize setHidden:NO];
//        isClicked=YES;
//    }
//    else {
//        [mTblSizes setHidden:YES];
//        [mViewSize setHidden:YES];
//        isClicked =NO;
//    }

//    isSize=YES;
//    [tblselectSize reloadData];
//    isSize=YES;
//    isColour=NO;
//    LCTableViewPickerControl *pickerView = [[LCTableViewPickerControl alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, kPickerControlWidth, kPickerControlAgeHeight) title:@"Please select the color" value:_pickValue items:ArrProductSizes];
//    [pickerView setDelegate:self];
//    [pickerView setTag:0];
//    
//    [self.view addSubview:pickerView];
//    [pickerView show];
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
    
//    BOOL isColor=YES;
//    Bool issize =NO;
//
//    isColour=YES;
//    isSize=NO;
    
//    if(mTblColors !=Nil)
//    {
//        [mTblColors setHidden:NO];
//    }
//    if (isClicked!=YES) {
//     
//        [mTblColors setHidden:NO];
//        [mViewColor setHidden:NO];
//        isClicked=YES;
//    }
//    else {
//        [mTblColors setHidden:YES];
//        [mViewColor setHidden:YES];
//        isClicked =NO;
//    }
////    isColour=YES;
////    [tblSelectColor reloadData];
//    isSize=NO;
//    isColour=YES;
//    LCTableViewPickerControl *pickerView = [[LCTableViewPickerControl alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, kPickerControlWidth, kPickerControlAgeHeight) title:@"Please select the color" value:_pickValue items:ArrProductColors];
//    [pickerView setDelegate:self];
//    [pickerView setTag:0];
//    
//    [self.view addSubview:pickerView];
//    [pickerView show];
}

//- (void)dismissPickerControl:(LCTableViewPickerControl*)view
//{
//    [view dismiss];
//}

//#pragma mark - LCTableViewPickerDelegate
//- (void)selectControl:(LCTableViewPickerControl*)view didSelectWithItem:(id)item
//{
//    /*Check item is NSString or NSNumber , if it is necessary */
//    if(isSize)
//    {
//    if (view.tag == 0)
//    {
//        if ([item isKindOfClass:[NSString class]])
//        {
//            
//        }
//        else if ([item isKindOfClass:[NSNumber class]])
//        {
//            
//        }
//    }
//    self.pickValue = item;
//    [self dismissPickerControl:view];
//    }
//    else
//    {
//        if (view.tag == 0)
//        {
//            if ([item isKindOfClass:[NSString class]])
//            {
//                
//            }
//            else if ([item isKindOfClass:[NSNumber class]])
//            {
//                
//            }
//        }
//        self.pickValue = item;
//
//        [self dismissPickerControl:view];
//    }
//}
//
//- (void)selectControl:(LCTableViewPickerControl *)view didCancelWithItem:(id)item
//{
//    [self dismissPickerControl:view];
//}
//
-(IBAction)ClickedAddToCart:(id)sender
{
    if ([btnColor.titleLabel.text isEqualToString:@"select color"]||[btnSize.titleLabel.text isEqualToString:@"select size"]) {
        if ([btnColor.titleLabel.text isEqualToString:@"select color"]&&[btnSize.titleLabel.text isEqualToString:@"select size"]) {
            UIAlertView *alertColor = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Select Color and Size" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertColor show];

        }
    else if ([btnColor.titleLabel.text isEqualToString:@"select color"]) {
        UIAlertView *alertColor = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Select Color" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertColor show];
    }
   else if ([btnSize.titleLabel.text isEqualToString:@"select size"]) {
        UIAlertView *alertColor = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Select Size" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertColor show];
    }
    }
    else {
    
    [activityViewCart setHidden:NO];
     [activityViewCart startAnimating];
    self.datamyCart=[DataMyCart sharedCart];
  
    [self.datamyCart addProduct:self.dataproduct];
   // [self addedToCartAlert];
    NSLog(@"Data my Cart %@",self.datamyCart);
    [activityViewCart startAnimating];
    if (_timer == nil)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                  target:self
                                                selector:@selector(showInCart)
                                                userInfo:nil
                                                 repeats:YES];
    }
    
    }
}

-(void)showInCart {
    [mBtnInCart setHidden:NO];
}

-(void)clickedShowCart:(id)sender
{
    [self performSegueWithIdentifier:@"pushToCart" sender:0];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // Load the pages which are now on screen
    
//    if(scrollView==self.scrollView)
//    {
//  //  [self loadVisiblePages];
//    }
//    [self loadVisiblePages];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
