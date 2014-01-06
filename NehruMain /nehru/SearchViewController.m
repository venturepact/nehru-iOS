//
//  SearchViewController.m
//  nehru
//
//  Created by ADMIN on 12/31/13.
//  Copyright (c) 2013 nehru. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController
@synthesize mutableTableDataArray;
@synthesize strSearchData;
@synthesize arrayOfAllproducts;
@synthesize arrformalproducts;

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
	// Do any additional setup after loading the view.
    
//    [self setNavigationFrame];
    self.arrayOfAllproductsName=[[NSMutableArray alloc]init];
    
    viewCategory.frame = CGRectMake(-80, 0, 320, 33);
////    self.navigationItem.backBarButtonItem.=[UIColor orangeColor];
//  
////    navitem=[UIColor redColor];
//    //navitem.backBarButtonItem = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"arrow-left.png"]];
//    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddProducttoWishlist:) name:@"AddToWishlistthroughSearch" object:nil];
    
    [self GetProducts];
    
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
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    
    //dynamically creating the UInavigationBar.
    [self setNavigationFrame];
    
    [UIView beginAnimations:@"bucketsOff" context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    
    //position off screen
    ViewCasual.frame=CGRectMake(484, 70  , 320 , 420);
    ViewFormal.frame=CGRectMake(0, 70, 320, 480);
    //animate off screen
    [UIView commitAnimations];
    [mTableCasual reloadData];
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
    //    ViewFirst.frame = CGRectMake(0, -2, 320, 480);
    //    ViewFirst.transform = CGAffineTransformMakeRotation(0);
    //[ViewFirst setHidden:YES];
    [UIView commitAnimations];
    [UIView beginAnimations:nil context:NULL];
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
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
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
        
        PFFile *theImage =(PFFile*)dataproduct.ProductImage;
        [theImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
            UIImage *image = [UIImage imageWithData:data];
            mainTableCell.imgproduct.image=image;
        }];
        mainTableCell.bgContentView.image=[UIImage imageNamed:@"main-product-bg_shadow s.png"];
        mainTableCell.lblproductName.text=dataproduct.ProductName;
        mainTableCell.lblproductName.font=[UIFont fontWithName:@"Calibri" size:12.0f];
        mainTableCell.lblproductModelName.text=dataproduct.ProductModel;
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
        PFFile *theImage =(PFFile*)dataproduct.ProductImage;
        [theImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
            UIImage *image = [UIImage imageWithData:data];
            mainTableCell.imgproduct.image=image;
        }];
        mainTableCell.lblproductName.text=dataproduct.ProductName;
        mainTableCell.lblproductModelName.text=dataproduct.ProductModel;
        
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
// called when 'return' key pressed. return NO to ignore.
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - TextField delegates

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSString *str=searchTableview.text;
    if([str length]>0)
    {
        self.strSearchData=[NSString stringWithFormat:@"%@",searchTableview.text];
        [self Search];
    }
    if ([str length]==0) {
        if(isCasual)
        {
            self.mutableTableDataArray=[self.arrayOfAllproducts mutableCopy];
            [mTableCasual reloadData];
        }
        else
        {
            self.mutableTableDataArray=[self.arrformalproducts mutableCopy];
            [mTableFormal reloadData];
        }
    }
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)Search:(id)sender
{
    [self Search];
}

-(void)Search
{
    [searchTableview resignFirstResponder];
    //Calling webservice so as to get the data acording to type and rent....
    if([searchTableview.text isEqualToString:@""]||[searchTableview.text isEqualToString:nil]||[searchTableview.text isEqual:[NSNull null]])
    {
        
    }
    else
    {
        self.mutableTableDataArray=[[NSMutableArray alloc]init];
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"ProductName BEGINSWITH[cd]%@",searchTableview.text];
        NSArray* searchedList;
        if(isCasual)
        {
        searchedList = [self.arrayOfAllproducts filteredArrayUsingPredicate:predicate];
        }
        else
        {
            searchedList = [self.arrformalproducts filteredArrayUsingPredicate:predicate];
        }
        self.mutableTableDataArray=[searchedList mutableCopy];
        [mTableCasual reloadData];
    }
}

//Left view controller
-(void)oneFingerSwipeLeft: (UITapGestureRecognizer *) recognizer {
    //Adding the Refresh Controller on the UITableView
    
    isFormal=YES;
    isCasual=NO;
    
    mTableFormal.contentInset=UIEdgeInsetsMake(0.0,0.0,70,0.0);
    
    [UIView beginAnimations:@"bucketsOff" context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    
    //position off screen
    ViewCasual.frame=CGRectMake(0 , 70  , 320 , 420);
    ViewFormal.frame=CGRectMake(-484, 70, 320, 480);
    
    viewCategory.frame = CGRectMake(80, 0, 320, 33); //animate off screen
    [UIView commitAnimations];
    
    [mTableFormal reloadData];
}

//Right View controller

-(void)oneFingerSwipeRight: (UITapGestureRecognizer *) recognizer {
    isCasual=YES;
    isFormal=NO;
    
    mTableCasual.contentInset = UIEdgeInsetsMake(0.0, 0.0, 100, 0.0);
    
    [UIView beginAnimations:@"bucketsOff" context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    
    //position off screen
    ViewCasual.frame=CGRectMake(484, 70  , 320 , 420);
    ViewFormal.frame=CGRectMake(0, 70, 320, 480);
    viewCategory.frame = CGRectMake(-80, 0, 320, 33);
    //animate off screen
    [UIView commitAnimations];
    [mTableCasual reloadData];
}



//formal table reloading.
-(IBAction)ClickedOnbtnFormal:(id)sender {
    isFormal=YES;
    isCasual=NO;
    
    if(isFormal)
    {
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
        }
        //  update the last update date
        [_refreshHeaderView refreshLastUpdatedDate];
    }
    
    mTableFormal.contentInset=UIEdgeInsetsMake(0.0,0.0,70,0.0);
    
    [UIView beginAnimations:@"bucketsOff" context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    
    //position off screen
    ViewCasual.frame=CGRectMake(0 , 70  , 320 , 420);
    ViewFormal.frame=CGRectMake(-484, 70, 320, 480);
    
    viewCategory.frame = CGRectMake(80, 0, 320, 33);
    //animate off screen
    [UIView commitAnimations];
    [mTableFormal reloadData];
}

//casual table loading.
-(IBAction)ClickedOnbtnCasual:(id)sender {
    isCasual=YES;
    isFormal=NO;
    
    if(isCasual)
    {
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
        }
        //  update the last update date
        [_refreshHeaderView refreshLastUpdatedDate];
    }
    
    mTableCasual.contentInset = UIEdgeInsetsMake(0.0, 0.0, 100, 0.0);
    
    [UIView beginAnimations:@"bucketsOff" context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    
    //position off screen
    ViewCasual.frame=CGRectMake(484, 70  , 320 , 420);
    ViewFormal.frame=CGRectMake(0, 70, 320, 480);
    viewCategory.frame = CGRectMake(-80, 0, 320, 33);
    //animate off screen
    [UIView commitAnimations];
    [mTableCasual reloadData];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
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
