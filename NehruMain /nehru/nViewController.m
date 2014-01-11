//
//  nViewController.m
//  nehru
//
//  Created by ADMIN on 11/27/13.
//  Copyright (c) 2013 nehru. All rights reserved.
//

#import "nViewController.h"
#import "ProductListingViewController.h"

@interface nViewController ()

@end

@implementation nViewController

#pragma mark View Methods

-(void)viewDidAppear:(BOOL)animated{
    if(isComingBack){
        dispatch_resume(nTimer);
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    
    mTagImage.frame = CGRectMake(55, 235, 230, 149);

    NSUserDefaults *Defaults=[NSUserDefaults standardUserDefaults];
    NSString *emailaddress= [[Defaults valueForKey:@"emailId"]mutableCopy];
    NSLog(@"email address %@",emailaddress);
    NSString *gendertext=[[Defaults valueForKey:@"Female"]mutableCopy];
    if(emailaddress.class ==NULL)
    {
        NSLog(@"It is kind of NSNull class.");
        emailaddress=@"null";
    }
 UserPhoto.image=[UIImage imageNamed:@"female.png"];
   if([emailaddress isEqualToString:@"null"]||[emailaddress isEqualToString:Nil])
    {
        [mainViewForProfile setHidden:YES];
    }
    else
    {
        [mainViewForProfile setHidden:NO];
        if([gendertext isEqualToString:@"Female"])
        {
            UserPhoto.image=[UIImage imageNamed:@"female.png"];
           
        }
        else
        {
            UserPhoto.image=[UIImage imageNamed:@"male.png"];
        }
        lblusername.text =[NSString stringWithFormat:@"%@ %@",[Defaults valueForKey:@"firstName"],[Defaults valueForKey:@"lastName"]];
        
        lblemailid.text=[NSString stringWithFormat:@"%@",[Defaults valueForKey:@"emailId"]];
    }
    
//    if(IS_IPHONE_5)
//    {
//        bckgImage.frame=CGRectMake(0, 0,320,568);
//    }
//    else
//    {
//        bckgImage.frame=CGRectMake(0, 0, 320, 480);
//    }
}

-(IBAction)ClickedFemale:(id)sender
{
    strGender=@"Female";
}

-(IBAction)ClickedMale:(id)sender
{
    strGender=@"Male";
}


-(void)initialView
{
    mTagImage.frame = CGRectMake(55, 235, 230, 149);
    
    [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:FALSE];
    
    txtPassword.text=@"";
    txtlastname.text=@"";
    txtEmailId.text=@"";
    txtConfirmPassword.text=@"";
    txtfirstname.text=@"";
    
    [btnSignImage setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@""]]];
    [btnSignUpImage setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"register-hover-bg-text.png"]]];
    
    [btnSignImage setTitle:@"SignIn" forState:UIControlStateNormal];
    [btnSignUpImage setTitle:@"" forState:UIControlStateNormal];

    
    NSUserDefaults *Defaults=[NSUserDefaults standardUserDefaults];
    NSString *emailaddress= [[Defaults valueForKey:@"emailId"]mutableCopy];
    NSLog(@"email address %@",emailaddress);
    NSString *gendertext=[Defaults valueForKey:@"Gender"];
    if(emailaddress.class ==NULL)
    {
        NSLog(@"It is kind of NSNull class.");
        emailaddress=@"null";
    }
    
    if([emailaddress isEqualToString:@"null"]||[emailaddress isEqualToString:Nil])
    {
        [mainViewForProfile setHidden:YES];
    }
    else
    {
        [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:TRUE];
        
        [mainViewForProfile setHidden:NO];
        if([gendertext isEqualToString:@"Female"])
        {
            [UserPhoto setImage:[UIImage imageNamed:@"female.png"]];
        }
        else
        {
            UserPhoto.image=[UIImage imageNamed:@"male.png"];
        }
        lblusername.text =[NSString stringWithFormat:@"%@ %@",[Defaults valueForKey:@"firstName"],[Defaults valueForKey:@"lastName"]];
        
        lblemailid.text=[NSString stringWithFormat:@"%@",[Defaults valueForKey:@"emailId"]];
    }

    
    }


- (void)viewDidLoad
{
    [super viewDidLoad];
    //user interaction for UItabBarController

  
    [self initialView];
    
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nehru-logo.png"]];
    self.navigationItem.titleView=imageView;
    
    //Tab bar user Interaction
    
    /* [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:FALSE];
    
    txtPassword.text=@"";
    txtlastname.text=@"";
    txtEmailId.text=@"";
    txtConfirmPassword.text=@"";
    txtfirstname.text=@"";
    
    [btnSignImage setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@""]]];
    [btnSignUpImage setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"register-hover-bg-text.png"]]];
    
    [btnSignImage setTitle:@"SignIn" forState:UIControlStateNormal];
    [btnSignUpImage setTitle:@"Register" forState:UIControlStateNormal];
    */
   /* static int i=0;
    bckgImages=[NSArray arrayWithObjects:@"bg1.jpg",@"bg2.jpg",@"bg3.jpg",@"bg4.jpg",@"bg5.jpg",@"bg6.jpg",nil];
    
    // Thread delay
    bckgTime=dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC);
    
    if(IS_IPHONE_5)
    {
        bckgImage.frame=CGRectMake(0,0,320,580);
    }
    else
    {
        bckgImage.frame=CGRectMake(0, 0, 320, 480);
    }
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    nTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, backgroundQueue);
    dispatch_source_set_timer(nTimer, DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC, 0.05 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(nTimer, ^{
        //background.alpha=0.5;
        
        if (i == [bckgImages count]){
            i=0;
        }
        
        NSLog(@"%d",i);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            bckgImage.alpha=1;
            bckgImage.image =[UIImage imageNamed:[bckgImages objectAtIndex:i]];
            i++;
        });
    });
    dispatch_resume(nTimer);*/
}

-(IBAction)goToBrowse:(id)sender{
    dispatch_suspend(nTimer);
    isComingBack=TRUE;
//    [self performSegueWithIdentifier:@"gotToBrowse" sender:self];
}

-(IBAction)btnsignIn:(id)sender
{
     btnSignImage.titleLabel.font=[UIFont fontWithName:@"Helvetica Bold 15.0" size:12.0f];
    [btnSignImage setTitle:@"Sign In" forState:UIControlStateNormal];
   
    [btnSignImage setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@""]]];
    [btnSignUpImage setTitle:@"" forState:UIControlStateNormal];
    btnSignUpImage.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"register-hover-bg-text.png"]];
    [signInView setHidden:NO];
    [signUpView setHidden:YES];
}

-(IBAction)btnsignUp:(id)sender
{
    btnSignUpImage.titleLabel.font=[UIFont fontWithName:@"Helvetica Bold 15.0" size:12.0f];
    [btnSignUpImage setTitle:@"Register" forState:UIControlStateNormal];
    [btnSignImage setTitle:@"" forState:UIControlStateNormal];
    [btnSignUpImage setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@""]]];
    [btnSignImage setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"signin-hover-bg-text.png"]]];
    
    [signInView setHidden:YES];
    [signUpView setHidden:NO];
}

//- (IBAction)didChangeSegmentControl:(UISegmentedControl *)control {
//     if([segmentedControl selectedSegmentIndex]==0)
//     {
//       [signInView setHidden:NO];
//       [signUpView setHidden:YES];
//     }
//    else if([segmentedControl selectedSegmentIndex]==1)
//    {
//        [signInView setHidden:YES];
//        [signUpView setHidden:NO];
//    }
//}

-(IBAction)ClickedSignUp:(id)sender
{
    NSLog(@"StrGender %@",strGender);
    if([txtConfirmPassword.text isEqualToString:@""]||[txtEmailId.text isEqualToString:@""]||[txtfirstname.text isEqualToString:@""]||[txtlastname.text isEqualToString:@""]||[txtPassword.text isEqualToString:@""]||[strGender isEqualToString:@""]||strGender.class == NULL)
    {
        // show alert on empty fields
        if(strGender.class==NULL)
        {
            UIAlertView *showEmptyField=[[UIAlertView alloc]initWithTitle:@"nehru" message:@"Select gender" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [showEmptyField show];
        }
        else
        {
        UIAlertView *showEmptyField=[[UIAlertView alloc]initWithTitle:@"nehru" message:@"Fields cannot be left blank" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [showEmptyField show];
        }
    }
    else if(![self validateEmailWithString:txtEmailId.text])
    {
        UIAlertView *showEmptyField=[[UIAlertView alloc]initWithTitle:@"Wrong Information" message:@"Email Id is not in correct format" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [showEmptyField show];
    }
    else {
    PFQuery *validLoginQuery=[PFQuery queryWithClassName:@"NehruUser"];
    [validLoginQuery whereKey:@"emailId" equalTo:txtEmailId.text];
    [validLoginQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            if(objects.count==1){
                UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"" message:@"Email exists in the database" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
                [alertview show];
                NSLog(@"email exists");
            }
            else{
                PFObject *usrSignUp=[PFObject objectWithClassName:@"NehruUser"];
                [usrSignUp setObject:txtfirstname.text forKey:@"firstName"];
                [usrSignUp setObject:txtlastname.text forKey:@"lastName"];
                [usrSignUp setObject:txtEmailId.text forKey:@"emailId"];
                [usrSignUp setObject:txtPassword.text forKey:@"userPassword"];
                [usrSignUp setObject:strGender forKey:@"Gender"];
                [usrSignUp saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        // The find succeeded.
                        if(succeeded){
                            NSLog(@"Successfull SignUp");
                            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Successfull SignUp" message:@"Successfull SignUp" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                            alert.tag=34559;
                            [alert show];
                            
                            NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
//                          [userDefaults setObject:txtEmailId.text forKey:@"UserId"];
                            [userDefaults setValue:txtfirstname.text forKey:@"firstName"];
                            [userDefaults setValue:txtlastname.text forKey:@"lastName"];
                            [userDefaults setValue:txtEmailId.text forKey:@"emailId"];
                            [userDefaults synchronize];
                            
                            [self ResignKeys];
                        }
                        else{
//                            NSLog(@"Sorry we were not able to sign up");
                            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Not able to sign up" message:@"Not able to sign up" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                            [alert show];
                        }
                    }
                    else {
                        // Log details of the failure
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
                }];
            }
        }
        else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    }
}

-(IBAction)ClickedSignOutBtn:(id)sender
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    [self initialView];
}

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

-(void)ResignKeys
{
    txtPassword.text=@"";
    txtlastname.text=@"";
    txtEmailId.text=@"";
    txtConfirmPassword.text=@"";
    txtfirstname.text=@"";
    [txtConfirmPassword resignFirstResponder];
    [txtEmailId resignFirstResponder];
    [txtfirstname resignFirstResponder];
    [txtlastname resignFirstResponder];
    [txtPassword resignFirstResponder];
}

-(IBAction)ClickedSignIn:(id)sender
{
    if([signInEmailId.text isEqualToString:@""]||[signInPassword.text isEqualToString:@""]){
        // show alert on empty fields
        UIAlertView *showEmptyField=[[UIAlertView alloc]initWithTitle:@"nehru" message:@"Fields cannot be left empty" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [showEmptyField show];
    }
    else{
        PFQuery *validLoginQuery=[PFQuery queryWithClassName:@"NehruUser"];
        [validLoginQuery whereKey:@"emailId" equalTo:signInEmailId.text];
        [validLoginQuery whereKey:@"userPassword" equalTo:signInPassword.text];
        [validLoginQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                if(objects.count==0)
                {
                    UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Incorrect Information" message:@"Username or Password incorrect" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
                    [alertview show];
                }
                else if(objects.count==1){
                    PFObject *AppUser=[objects objectAtIndex:0];
                    NSLog(@"App User %@",AppUser);
                    NSString *str1=AppUser[@"objectId"];
                    NSString *str2=AppUser[@"firstName"];
                    NSString *str3=AppUser[@"lastName"];
                    NSString *str4=AppUser[@"emailId"];
                    NSString *str5=AppUser[@"Gender"];
                    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
                    [userDefaults setValue:str1 forKey:@"UserId"];
                    [userDefaults setValue:str2 forKey:@"firstName"];
                    [userDefaults setValue:str3 forKey:@"lastName"];
                    [userDefaults setValue:str4 forKey:@"emailId"];
                    [userDefaults setValue:str5 forKey:@"Gender"];
                    [userDefaults synchronize];
                                       
                    [userDefaults valueForKey:@"emailId"];
                    NSLog(@"User Defaults %@",userDefaults);
                    //here getting the user Image back on the screen.
                    PFFile *userImageFile = AppUser[@"UserPhoto"];
                    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                        if (!error) {
                            UIImage *image = [UIImage imageWithData:imageData];
                            UserImgVIew.image = image;
                        }
                    }];
                    
                    UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Successfull Login" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
                    alertview.tag=100867;
                    [alertview show];
                    signInPassword.text=@"";
                    signInEmailId.text=@"";
                }
                else{
                    UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Incorrect Information" message:@"Username or Password incorrect" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
                    [alertview show];
                }
            }
            else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"info of the image get from simulator %@",info);
	[picker dismissViewControllerAnimated:YES completion:nil];
    
    [choosePhotoBtn setImage:nil forState:UIControlStateNormal];
    UIImage *image=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    [choosePhotoBtn setImage:image forState:UIControlStateHighlighted];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==100867)
    {
    if(buttonIndex ==0)
    {
        UIView * fromView = self.tabBarController.selectedViewController.view;
        UIView * toView = [[self.tabBarController.viewControllers objectAtIndex:1] view];
        
        // Transition using a page curl.
        [UIView transitionFromView:fromView
                            toView:toView
                          duration:1.0
                           options:UIViewAnimationOptionTransitionCurlUp
                        completion:^(BOOL finished) {
                            if (finished) {
                                self.tabBarController.selectedIndex = 1;
                            }
                        }];
        NSLog(@"Do Nothing");
//        [self performSegueWithIdentifier:@"productListing" sender:self];
    }
    }
    if(alertView.tag==34559)
    {
     if(buttonIndex ==0)
      {
          // Get views. controllerIndex is passed in as the controller we want to go to.
          UIView * fromView = self.tabBarController.selectedViewController.view;
          UIView * toView = [[self.tabBarController.viewControllers objectAtIndex:1] view];
          
          // Transition using a page curl.
          [UIView transitionFromView:fromView
                              toView:toView
                            duration:1.0
                             options:UIViewAnimationOptionTransitionCurlUp
                          completion:^(BOOL finished) {
                              if (finished) {
                                  self.tabBarController.selectedIndex = 1;
                              }
                          }];
         NSLog(@"Do Nothing");
      }
    }
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

-(IBAction)ClickedExplore:(id)sender
{
    // Get views. controllerIndex is passed in as the controller we want to go to.
    UIView * fromView = self.tabBarController.selectedViewController.view;
    UIView * toView = [[self.tabBarController.viewControllers objectAtIndex:1] view];
    
    // Transition using a page curl.
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:1.0
                       options:UIViewAnimationOptionTransitionCurlUp
                    completion:^(BOOL finished) {
                        if (finished) {
                            self.tabBarController.selectedIndex = 1;
                        }
                    }];

}

-(IBAction) getPhoto:(id) sender {
	UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	
	if((UIButton *) sender == choosePhotoBtn) {
		picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        //	} else {
        //		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
	[self presentViewController:picker animated:YES completion:nil];
}

// return NO to disallow editing.
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

// became first responder
- (void)textFieldDidBeginEditing:(UITextField *)textField
{

}

// return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
{
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
// return NO to not change text
{
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
// called when 'return' key pressed. return NO to ignore.
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
