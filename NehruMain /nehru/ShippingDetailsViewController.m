//
//  ShippingDetailsViewController.m
//  nehru
//
//  Created by Raj on 09/01/14.
//  Copyright (c) 2014 nehru. All rights reserved.
//

#import "ShippingDetailsViewController.h"

@interface ShippingDetailsViewController ()

@end

@implementation ShippingDetailsViewController
@synthesize backgScroll;

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
    
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nehru-logo.png"]];
    self.navigationItem.titleView=imageView;
    
       self.backgScroll.contentSize=CGSizeMake(320, 500);
}

-(IBAction)ClickedBtnSaveDetails:(id)sender
{
    if([txtCity.text isEqualToString:@""]||[txtCountry.text isEqualToString:@""]||[txtemailAddress.text isEqualToString:@""]||[txtFullName.text isEqualToString:@""]||[txtphone.text isEqualToString:@""]||[txtShippingaddress.text isEqualToString:@""]||[txtState.text isEqualToString:@""])
    {
        // show alert on empty fields
        UIAlertView *showEmptyField=[[UIAlertView alloc]initWithTitle:@"nehru" message:@"Fields cannot be left blank" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [showEmptyField show];
    }
    else if(![self validateEmailWithString:txtemailAddress.text])
    {
        UIAlertView *showEmptyField=[[UIAlertView alloc]initWithTitle:@"Wrong Information" message:@"Email Id is not in correct format" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [showEmptyField show];
    }
    else {
                    PFObject *usrSignUp=[PFObject objectWithClassName:@"NehruShippingAddress"];
                    [usrSignUp setObject:txtemailAddress.text forKey:@"EmailAddress"];
                    [usrSignUp setObject:txtFullName.text forKey:@"FullName"];
                    [usrSignUp setObject:txtShippingaddress.text forKey:@"ShippingAddress"];
                    [usrSignUp setObject:txtCity.text forKey:@"City"];
                    [usrSignUp setObject:txtState.text forKey:@"State"];
                    [usrSignUp setObject:txtCountry.text forKey:@"Country"];
                    [usrSignUp setObject:txtphone.text forKey:@"Phone"];
                    
                    [usrSignUp saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (!error) {
                            // The find succeeded.
                            if(succeeded){
                                NSLog(@"Successfull additin of shipping address");
                                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Successfull" message:@"Successfully saved Data" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                alert.tag=34559;
                                [alert show];
                                
                                NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
                                //                            [userDefaults setObject:txtEmailId.text forKey:@"UserId"];
                                [userDefaults setObject:txtemailAddress.text forKey:@"shipEmailAddress"];
                                [userDefaults setObject:txtFullName.text forKey:@"shipFullName"];
                                [userDefaults setObject:txtShippingaddress.text forKey:@"ShipAddress"];
                                [userDefaults setObject:txtCity.text forKey:@"ShipCity"];
                                [userDefaults setObject:txtState.text forKey:@"ShipState"];
                                [userDefaults setObject:txtphone.text forKey:@"shipPhone"];
                                [userDefaults setObject:txtCountry.text forKey:@"shipCountry"];
                                [userDefaults synchronize];
                                
                                
//                               [self ResignKeys];
                            }
                            else{
                                //NSLog(@"Sorry we were not able to sign up");
                                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Not able to Save details" message:@"Not able to save details" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
