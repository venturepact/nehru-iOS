//
//  ProductListingViewController.m
//  nehru
//
//  Created by shelly vashishth on 21/12/13.
//  Copyright (c) 2013 nehru. All rights reserved.
//

#import "ProductListingViewController.h"

@interface ProductListingViewController ()

@end

@implementation ProductListingViewController
@synthesize arrayOfAllproducts;
@synthesize nativeIndicator;
@synthesize arrformalproducts;
@synthesize blockerView;

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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [activity1 startAnimating];
    
    [activity2 startAnimating];
    [self initialViews];
    
        //Refresh view on the second UITableView
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddProducttoWishlist:) name:@"AddToWishlist" object:nil];
//    [self GetProducts];
}

-(void)LoadIndicatorView
{
    //this view showing the activity indicator.
    self.blockerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 60)];
    self.blockerView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    self.blockerView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    self.blockerView.clipsToBounds = YES;
    self.blockerView.layer.cornerRadius = 10;
    
    UILabel	*label = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, blockerView.bounds.size.width, 15)];
    label.text = @"Please Wait...";
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:15];
    [self.blockerView addSubview:label];
    
    UIActivityIndicatorView	*spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    spinner.center = CGPointMake(self.blockerView.bounds.size.width/2, (self.blockerView.bounds.size.height/2)+10);
    [self.blockerView addSubview:spinner];
    [self.view addSubview:self.blockerView];
    [spinner startAnimating];
}

-(void)initialViews
{
    isCasual=YES;
    
    mTableCasual.contentInset = UIEdgeInsetsMake(0.0, 0.0, 100, 0.0);
    mTableFormal.contentInset=UIEdgeInsetsMake(0.0,0.0,70,0.0);
    
    viewCategory.frame = CGRectMake(-80, 0, 320, 33);
    
    UISwipeGestureRecognizer *oneFingerSwipeLeft = [[UISwipeGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(oneFingerSwipeLeft:)];
    [oneFingerSwipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [[self view] addGestureRecognizer:oneFingerSwipeLeft];
    
    UISwipeGestureRecognizer *oneFingerSwipeRight = [[UISwipeGestureRecognizer alloc]
                                                     initWithTarget:self
                                                     action:@selector(oneFingerSwipeRight:)];
    [oneFingerSwipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:oneFingerSwipeRight];
    
    if(isCasual)
    {
        if (_refreshHeaderView == nil) {
            
            EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - mTableCasual.bounds.size.height, self.view.frame.size.width, mTableCasual.bounds.size.height)];
            view.delegate = self;
            [mTableCasual addSubview:view];
            _refreshHeaderView = view;
            //[view release];
        }
        //  update the last update date
        [_refreshHeaderView refreshLastUpdatedDate];
    }
    [self GetProducts];
}


-(void)AddProducttoWishlist:(NSNotification *)notification
{
    NSDictionary *dict= notification.userInfo;
    NSLog(@"Dict %@",dict);
   NSString *strindexPath=[NSString stringWithFormat:@"%@",[dict objectForKey:@"FavoritesTag"]];
    NSInteger indexpath1=[strindexPath integerValue];
    
    NSLog(@"IndexPath %d",indexpath1);
    DataProduct *dataproduct1;
    if(isCasual)
    {
      dataproduct1 = [self.arrayOfAllproducts objectAtIndex:indexpath1];
    }
    else
    {
      dataproduct1=[self.arrformalproducts objectAtIndex:indexpath1];
    }
    
    NSLog(@"Data product Name %@",dataproduct1.ProductName);
    //Clicked product added into the wishlist here in singleton class on the iphone itself.
    DataWishlist *wishlist=[DataWishlist sharedWishList];
    [wishlist.myWishlistArray addObject:dataproduct1];
    
    //Now time to add the product on the parse database.
    
    [self AddwishlistProductToParse:dataproduct1.ProductId];
}

-(void)AddwishlistProductToParse:(NSString*)strproductId
{
    PFObject *gameScore = [PFObject objectWithClassName:@"NehruWishlist"];
    [gameScore setObject:strproductId forKey:@"productId"];
    [gameScore saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // The find succeeded.
            if(succeeded){
                NSLog(@"Successfull addition to wishlist.");
                [self GetProducts];
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
    
    PFQuery *query = [PFQuery queryWithClassName:@"NehruProducts"];
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:strproductId block:^(PFObject *nehruproduct, NSError *error) {
        
        // Now let's update it with some new data. In this case, only cheatMode and score
        // will get sent to the cloud. playerName hasn't changed.
        nehruproduct[@"isfavorite"] = @"True";
//        gameScore[@"score"] = @1338;
        [nehruproduct saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(!error)
            {
                if(succeeded)
                {
                    NSLog(@"Successfully updated the object data product");
                }
                else
                {
                    NSLog(@"Not able to update the data product with the isfavorite");
                }
            }
            else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }];
    
}

//getting all the products from the parse Database.
-(void)GetProducts
{
    self.arrayOfAllproducts=[[NSMutableArray alloc]init];
    self.arrformalproducts=[[NSMutableArray alloc]init];
    //getting all the products in the database.
    PFQuery *query = [PFQuery queryWithClassName:@"NehruProducts"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // Do something with the found objects
            for (PFObject *object in objects) {
                //getting the category Name and Object Id's
                DataProduct *dataproduct=[[DataProduct alloc]init];
                dataproduct.ProductId=object.objectId;
                dataproduct.ProductImage=object[@"productImage"];
                
                PFFile *theImage =(PFFile*)dataproduct.ProductImage;
                [theImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
                    UIImage *image = [UIImage imageWithData:data];
                    dataproduct.imgproduct=image;
                }];
                dataproduct.ProductName=object[@"productName"];
                dataproduct.ProductModel=object[@"productModel"];
                NSString *strproductQty=object[@"productQty"];
                NSString *strProductPrice=object[@"productPrice"];
                dataproduct.productImages=object[@"ProductImages"];
                dataproduct.isfavorite=object[@"isfavorite"];
                
                NSLog(@"Data product favorite %@",dataproduct.isfavorite);
                dataproduct.productquantity=[strproductQty integerValue];
                dataproduct.productUnitprice=[strProductPrice floatValue];
                dataproduct.CategoryId=object[@"categoryid"];
                
                if([dataproduct.CategoryId isEqualToString:@"AEE5blnumJ"])
                {
                    [self.arrayOfAllproducts addObject:dataproduct];
                }
                else
                {
                    [self.arrformalproducts addObject:dataproduct];
                }
            }
            if(isCasual)
            {
                [mTableCasual reloadData];
            }
            else
            {
                [mTableFormal reloadData];
            }
            [activity1 stopAnimating];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


- (void)uploadImages
{
    //Running query for saving the images in the NehruProduct Table.
    PFQuery *query = [PFQuery queryWithClassName:@"NehruProducts"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d products.", objects.count);
            int i=0;
            // Do something with the found objects
            for (PFObject *object in objects) {
                i++;
                NSLog(@"image100%d",i);
                UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"image100%d.jpg",i]];
                // Resize image
                UIGraphicsBeginImageContext(CGSizeMake(640,960));
                [image drawInRect: CGRectMake(0, 0, 640,960)];
                UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                NSData *imageData = UIImageJPEGRepresentation(smallImage, 0.05f);
                //first Image.
                
                PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"image100%d.jpg",i] data:imageData];
                [object setObject:imageFile forKey:@"productImage"];
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        // The find succeeded.
                        if(succeeded){
                            NSLog(@"Successful UpLoading of photos");
                        }
                        else{
                            NSLog(@"Sorry we were not able to upload the photos.");
                        }
                    }
                    else {
                        // Log details of the failure
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
                }];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


//Left view controller
-(void)oneFingerSwipeLeft: (UITapGestureRecognizer *) recognizer {
    //Adding the Refresh Controller on the UITableView
    
    isFormal=YES;
    isCasual=NO;
    btnFormal.titleLabel.font=[UIFont fontWithName:@"Calibri" size:14.0f];
    mTableFormal.contentInset=UIEdgeInsetsMake(0.0,0.0,70,0.0);
    
    [UIView beginAnimations:@"bucketsOff" context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    
    //position off screen
    ViewCasual.frame=CGRectMake(0 , 40  , 320 , 420);
    ViewFormal.frame=CGRectMake(-484, 40, 320, 480);
    
    viewCategory.frame = CGRectMake(80, 0, 320, 33); //animate off screen
    [UIView commitAnimations];
    
    [mTableFormal reloadData];
}

//Right View controller

-(void)oneFingerSwipeRight: (UITapGestureRecognizer *) recognizer {
    isCasual=YES;
    isFormal=NO;
    
    btnCasual.titleLabel.font=[UIFont fontWithName:@"Calibri" size:14.0f];
    mTableCasual.contentInset = UIEdgeInsetsMake(0.0, 0.0, 100, 0.0);
//    mTableFormal.contentInset=UIEdgeInsetsMake(0.0,0.0,70,0.0);

    [UIView beginAnimations:@"bucketsOff" context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    
    //position off screen
    ViewCasual.frame=CGRectMake(484, 40  , 320 , 420);
    ViewFormal.frame=CGRectMake(0, 40, 320, 480);
    viewCategory.frame = CGRectMake(-80, 0, 320, 33);
    //animate off screen
    [UIView commitAnimations];
    [mTableCasual reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
   [super viewWillAppear:YES];
    [self initialViews];
    
    [self setNavigationFrame];
    [UIView beginAnimations:@"bucketsOff" context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    
    //position off screen
    ViewCasual.frame=CGRectMake(484, 40  , 320 , 420);
    ViewFormal.frame=CGRectMake(0, 40, 320, 480);
    //animate off screen
    [UIView commitAnimations];
    [mTableCasual reloadData];
}


-(void)viewWillDisappear:(BOOL)animated
{

    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    //[UIView setAnimationRepeatCount:1e100f];  //coutless
    [UIView setAnimationRepeatCount:1];   // 1 time
    //[UIView setAnimationRepeatAutoreverses:YES];
    ViewFirst.frame = CGRectMake(0, -2, 320, 480);
    ViewFirst.transform = CGAffineTransformMakeRotation(0);
    //[ViewFirst setHidden:YES];
    [UIView commitAnimations];
    [UIView beginAnimations:nil context:NULL];
}

//formal table reloading.
-(IBAction)ClickedOnbtnFormal:(id)sender {
    isFormal=YES;
    isCasual=NO;

    btnFormal.titleLabel.font=[UIFont fontWithName:@"Calibri" size:14.0f];
    
    
    if(isFormal)
    {
        if(_refreshHeaderView!=nil)
        {
            _refreshHeaderView=nil;
        }
            EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - mTableFormal.bounds.size.height, self.view.frame.size.width, mTableFormal.bounds.size.height)];
            view.delegate = self;
            [mTableFormal addSubview:view];
            _refreshHeaderView = view;
            //[view release];
        //  update the last update date
        [_refreshHeaderView refreshLastUpdatedDate];
    }
    
    mTableFormal.contentInset=UIEdgeInsetsMake(0.0,0.0,70,0.0);
    
    [UIView beginAnimations:@"bucketsOff" context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    
    //position off screen
    ViewCasual.frame=CGRectMake(0 , 40  , 320 , 420);
    ViewFormal.frame=CGRectMake(-484, 40, 320, 480);
    
    viewCategory.frame = CGRectMake(80, 0, 320, 33);
    //animate off screen
    [UIView commitAnimations];
    [mTableFormal reloadData];
}

//casual table loading.
-(IBAction)ClickedOnbtnCasual:(id)sender {
    isCasual=YES;
    isFormal=NO;
btnCasual.titleLabel.font=[UIFont fontWithName:@"Calibri" size:14.0f];
    if(isCasual)
    {
            if(_refreshHeaderView!=nil)
            {
                _refreshHeaderView=nil;
            }
            EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - mTableCasual.bounds.size.height, self.view.frame.size.width, mTableCasual.bounds.size.height)];
            view.delegate = self;
            [mTableCasual addSubview:view];
            _refreshHeaderView = view;
            //[view release];
        //  update the last update date
        [_refreshHeaderView refreshLastUpdatedDate];
    }
    
    mTableCasual.contentInset = UIEdgeInsetsMake(0.0, 0.0, 100, 0.0);
    
    [UIView beginAnimations:@"bucketsOff" context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    
    //position off screen
    ViewCasual.frame=CGRectMake(484, 40  , 320 , 420);
    ViewFormal.frame=CGRectMake(0, 40, 320, 480);
    viewCategory.frame = CGRectMake(-80, 0, 320, 33); 
    //animate off screen
    [UIView commitAnimations];
    [mTableCasual reloadData];
}

-(IBAction)ActionRemoveView:(id)sender {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationRepeatCount:1]; // 1 time
    ViewFirstScreen.frame = CGRectMake(-100, 225, 10, 10);
    ViewFirstScreen.transform = CGAffineTransformMakeRotation(60);
    [UIView commitAnimations];
    [UIView beginAnimations:nil context:NULL];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(isCasual)
    {
        return [self.arrayOfAllproducts count];
    }
    else
    {
        return [self.arrformalproducts count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DataProduct *dataproduct=[[DataProduct alloc]init];
    NSString *tableIdentifier=@"nSubProductTable";
    nSubCatCell *mainTableCell;
    if(isCasual)
    {
    nSubCatCell *mainTableCell=[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if(mainTableCell==nil){
        mainTableCell=[[nSubCatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }
    dataproduct=[self.arrayOfAllproducts objectAtIndex:indexPath.row];
    
    NSLog(@"Data product image %@",dataproduct.imgproduct);
    mainTableCell.imgproduct.image=dataproduct.imgproduct;
    mainTableCell.bgContentView.image=[UIImage imageNamed:@"main-product-bg_shadow s.png"];
    mainTableCell.lblproductName.text=dataproduct.ProductName;
    mainTableCell.lblproductName.font=[UIFont fontWithName:@"Calibri" size:12.0f];
    mainTableCell.lblproductModelName.text=dataproduct.ProductModel;
        mainTableCell.lblproductModelName.font=[UIFont fontWithName:@"Calibri" size:12.0f];
    NSString *strisfavorite= dataproduct.isfavorite;
    mainTableCell.btnfavorites.tag=indexPath.row;
     if([strisfavorite isEqualToString:@"True"])
     {
         mainTableCell.btnfavorites.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"wishlist-bg_icon_hover.png"]];
     }
     else
     {
         mainTableCell.btnfavorites.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"wishlist-bg_icon.png"]];
     }
        return mainTableCell;
}
        
    else if(isFormal)
    {
        nSubCatCell *mainTableCell=[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
        if(mainTableCell==nil){
            mainTableCell=[[nSubCatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
        }
       
        dataproduct=[self.arrformalproducts objectAtIndex:indexPath.row];
        NSLog(@"Data product name %@",dataproduct.ProductName);
        
        mainTableCell.bgContentView.image=[UIImage imageNamed:@"main-product-bg_shadow s.png"];
        NSLog(@"Data product image %@",dataproduct.imgproduct);
        mainTableCell.imgproduct.image=dataproduct.imgproduct;
  mainTableCell.lblproductName.font=[UIFont fontWithName:@"Calibri" size:12.0f];
        mainTableCell.lblproductName.text=dataproduct.ProductName;
        mainTableCell.lblproductModelName.text=dataproduct.ProductModel;
          mainTableCell.lblproductModelName.font=[UIFont fontWithName:@"Calibri" size:12.0f];
        NSString *strisfavorite= dataproduct.isfavorite;
         mainTableCell.btnfavorites.tag=indexPath.row;
        if([strisfavorite isEqualToString:@"True"])
        {
            mainTableCell.btnfavorites.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"wishlist-bg_icon_hover.png"]];
        }
        else
        {
            mainTableCell.btnfavorites.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"wishlist-bg_icon.png"]];
        }
        return mainTableCell;
    }
    return mainTableCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndex=[NSString stringWithFormat:@"%d",indexPath.row];
    [self performSegueWithIdentifier:@"pushToProductDetail" sender:selectedIndex];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSInteger productIndexpath=[sender integerValue];
    if ([segue.identifier isEqualToString:@"pushToProductDetail"])
    {
        ProductDetailViewController *detailController = segue.destinationViewController;
        detailController.dataproduct = [self.arrayOfAllproducts objectAtIndex:productIndexpath];
    }    
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    
    _reloading=YES;
   [self GetProducts];
}

- (void)doneLoadingTableViewData{
	//  model should call this when its done loading
   if(isCasual)
   {
    _reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:mTableCasual];
   }
    else
    {
        _reloading=NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:mTableFormal];
    }
   }

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
  
    if(_refreshHeaderView !=nil)
    {
	  [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if(_refreshHeaderView!=nil)
    {
	  [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
    return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	return [NSDate date]; // should return date data source was last changed
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
