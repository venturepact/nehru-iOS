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


- (IBAction)didChangeSegmentControl:(UISegmentedControl *)control {
if([segmentedControl selectedSegmentIndex]==0)
{
       [signInView setHidden:NO];
       [signUpView setHidden:YES];
}
    else if([segmentedControl selectedSegmentIndex]==1)
    {
        [signInView setHidden:YES];
        [signUpView setHidden:NO];
    }
}

-(IBAction)ClickedSignUp:(id)sender
{
    if([txtConfirmPassword.text isEqualToString:@""]||[txtEmailId.text isEqualToString:@""]||[txtfirstname.text isEqualToString:@""]||[txtlastname.text isEqualToString:@""]||[txtPassword.text isEqualToString:@""]||[strGender isEqualToString:@""])
    {
        // show alert on empty fields
        UIAlertView *showEmptyField=[[UIAlertView alloc]initWithTitle:@"nehru" message:@"Fields cannot be left blank" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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
                            [alert show];
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
//                    [userDefaults setObject:AppUser[@""] forKey:<#(NSString *)#>]
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
    if(textField==txtlastname)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelay:1.0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        
        self.view.frame=CGRectMake(0,0,-40,420);
        [UIView commitAnimations];
    }
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
