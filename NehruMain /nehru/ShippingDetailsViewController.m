//
//  ShippingDetailsViewController.m
//  nehru
//
//  Created by Raj on 09/01/14.
//  Copyright (c) 2014 nehru. All rights reserved.
//

#import "ShippingDetailsViewController.h"

@interface ShippingDetailsViewController ()
{
  CGPoint svos;
}
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
    
    self.backgScroll.contentSize=CGSizeMake(320, 600);
    
    svos = self.backgScroll.contentOffset;
}

-(IBAction)ClickedBtnSaveDetails:(id)sender
{
    if([txtCity.text isEqualToString:@""]||[txtCountry.text isEqualToString:@""]||[txtemailAddress.text isEqualToString:@""]||[txtFullName.text isEqualToString:@""]||[txtphone.text isEqualToString:@""]||[txtShippingaddress.text isEqualToString:@""]||[txtState.text isEqualToString:@""])
    {
        // show alert on empty fields
        UIAlertView *showEmptyField=[[UIAlertView alloc]initWithTitle:@"nehru" message:@"Fields cannot be left blank" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [showEmptyField show];
    }
    else if (![self phoneValidate:[txtphone text]]) {
            [txtphone becomeFirstResponder];
        UIAlertView *showEmptyField=[[UIAlertView alloc]initWithTitle:@"Invalid Phone Format" message:@"Use Country code with phone number" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [showEmptyField show];
        NSLog(@"Phone numbr not valid ");
    }
    else if(![self validateEmailWithString:txtemailAddress.text])
    {
        [txtemailAddress becomeFirstResponder];
        UIAlertView *showEmptyField=[[UIAlertView alloc]initWithTitle:@"Wrong Information" message:@"Email Id is not in correct format" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
                                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Successfull" message:@"Successfully saved Data" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                alert.tag=34559;
                                [alert show];
                                
                                txtemailAddress.text=@"";
                                txtCity.text=@"";
                                txtCountry.text=@"";
                                txtFullName.text=@"";
                                txtphone.text=@"";
                                txtShippingaddress.text=@"";
                                txtState.text=@"";
                                
                                NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
                                [userDefaults setObject:txtemailAddress.text forKey:@"shipEmailAddress"];
                                [userDefaults setObject:txtFullName.text forKey:@"shipFullName"];
                                [userDefaults setObject:txtShippingaddress.text forKey:@"ShipAddress"];
                                [userDefaults setObject:txtCity.text forKey:@"ShipCity"];
                                [userDefaults setObject:txtState.text forKey:@"ShipState"];
                                [userDefaults setObject:txtphone.text forKey:@"shipPhone"];
                                [userDefaults setObject:txtCountry.text forKey:@"shipCountry"];
                                [userDefaults synchronize];
                            }
                            else{
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==34559)
    {
  if(buttonIndex==0)
  {

      [self performSegueWithIdentifier:@"PushTocheckout" sender:self];}
  }}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField==txtCity||textField==txtState||textField==txtphone||textField==txtCountry)
    {
       CGRect rc = [textField bounds];
       rc = [textField convertRect:rc toView:self.backgScroll];
       rc.origin.x = 0 ;
       rc.origin.y = 100;
       rc.size.height = 500;
       CGPoint pt;
       pt = rc.origin;
       pt.x = 0;
       pt.y = 250;
       [self.backgScroll setContentOffset:pt animated:YES];
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
   
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.backgScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [self.backgScroll setContentOffset:CGPointMake(0, 0) animated:YES];

    
    [textView resignFirstResponder];
    return YES;
}

-(BOOL)textView :(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:( NSString *)text
{
    if([text isEqualToString:@"\n"])
        [textView resignFirstResponder];
    return YES;
}

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

-(IBAction)ClickedBackBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)phoneValidate:(NSString *)phoneNumber
{
    NSString *phoneNo =@"^((\\+)|(00))[0-9]{6,14}$";
    NSPredicate *phoneTest =[NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneNo];
    return [phoneTest evaluateWithObject: phoneNumber];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
