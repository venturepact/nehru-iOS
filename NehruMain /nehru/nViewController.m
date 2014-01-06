//
//  nViewController.m
//  nehru
//
//  Created by ADMIN on 11/27/13.
//  Copyright (c) 2013 nehru. All rights reserved.
//

#import "nViewController.h"

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


- (void)viewDidLoad
{
    [super viewDidLoad];
    txtPassword.text=@"";
    txtlastname.text=@"";
    txtEmailId.text=@"";
    txtConfirmPassword.text=@"";
    txtfirstname.text=@"";
    
    [btnSignImage setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"signin-hover-bg-text.png"]]];
    [btnSignUpImage setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@""]]];
    
    [btnSignImage setTitle:@"" forState:UIControlStateNormal];
    [btnSignUpImage setTitle:@"Register" forState:UIControlStateNormal];
    
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
//    Helvetica Bold 15.0
      btnSignUpImage.titleLabel.font=[UIFont fontWithName:@"Helvetica Bold 15.0" size:12.0f];
//      [btnSignUpImage setBackgroundColor:[UIFont fontWithName:@"Helvetica Bold 15.0" size:12.0f];
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
    if([txtConfirmPassword.text isEqualToString:@""]||[txtEmailId.text isEqualToString:@""]||[txtfirstname.text isEqualToString:@""]||[txtlastname.text isEqualToString:@""]||[txtPassword.text isEqualToString:@""]||[strGender isEqualToString:@""]||[strGender isEqualToString:@"null"])
    {
        // show alert on empty fields
        UIAlertView *showEmptyField=[[UIAlertView alloc]initWithTitle:@"nehru" message:@"Fields cannot be left blank" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [showEmptyField show];
    }
    else if(![self validateEmailWithString:txtEmailId.text])
    {
        UIAlertView *showEmptyField=[[UIAlertView alloc]initWithTitle:@"Wrong Information" message:@"Email Id is not in correct format" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [showEmptyField show];
    }
    else {
    PFQuery *validLoginQuery=[PFQuery queryWithClassName:@"NehruUser"];
    [validLoginQuery whereKey:@"emailId" equalTo:txtEmailId.text];
    [validLoginQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            if(objects.count==1){
                UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"" message:@"Email exists in the database" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
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
                            [userDefaults setObject:txtEmailId.text forKey:@"UserId"];
                            [userDefaults setObject:txtfirstname.text forKey:@"firstName"];
                            [userDefaults setObject:txtlastname.text forKey:@"lastName"];
                            [userDefaults setObject:txtEmailId.text forKey:@"emailId"];
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
                    UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Incorrect Information" message:@"Username or Password incorrect" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
                    [alertview show];
                }
                else if(objects.count==1){
                    PFObject *AppUser=[objects objectAtIndex:0];
                    NSLog(@"App User %@",AppUser);
                    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:AppUser[@"objectId"] forKey:@"UserId"];
                    [userDefaults setObject:AppUser[@"firstName"] forKey:@"firstName"];
                    [userDefaults setObject:AppUser[@"lastName"] forKey:@"lastName"];
                    [userDefaults setObject:AppUser[@"emailId"] forKey:@"emailId"];
                    [userDefaults synchronize];
                    //here getting the user Image back on the screen.
                    PFFile *userImageFile = AppUser[@"UserPhoto"];
                    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                        if (!error) {
                            
                            NSLog(@"Image Data %@",imageData);
                            //NSData *image = [imageData getData];
                            UIImage *image = [UIImage imageWithData:imageData];
                            NSLog(@"Image %@",image);
                            UserImgVIew.image = image;
                            NSLog(@"Image file %@",UserImgVIew.image);
                        }
                    }];
                    
                    UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Success" message:@"Successfull Login" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
                    alertview.tag=100867;
                    [alertview show];
                    signInPassword.text=@"";
                    signInEmailId.text=@"";
                }
                else{
                    UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:@"Incorrect Information" message:@"Username or Password incorrect" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:Nil, nil];
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
        // Get views. controllerIndex is passed in as the controller we want to go to.
        UIView * fromView = self.tabBarController.selectedViewController.view;
        UIView * toView = [[self.tabBarController.viewControllers objectAtIndex:0] view];
        
        // Transition using a page curl.
        [UIView transitionFromView:fromView
                            toView:toView
                          duration:1.0
                           options:(2 >self.tabBarController.selectedIndex ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationTransitionFlipFromLeft)
                        completion:^(BOOL finished) {
                            if (finished) {
                                self.tabBarController.selectedIndex = 0;
                            }
                        }];
    }
    }
    if(alertView.tag==34559)
    {
     if(buttonIndex ==0)
      {
          // Get views. controllerIndex is passed in as the controller we want to go to.
          UIView * fromView = self.tabBarController.selectedViewController.view;
          UIView * toView = [[self.tabBarController.viewControllers objectAtIndex:0] view];
          
          // Transition using a page curl.
          [UIView transitionFromView:fromView
                              toView:toView
                            duration:1.0
                             options:(2 >self.tabBarController.selectedIndex ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationTransitionFlipFromLeft)
                          completion:^(BOOL finished) {
                              if (finished) {
                                  self.tabBarController.selectedIndex = 0;
                              }
                          }];
         NSLog(@"Do Nothing");
      }
    }
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
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
