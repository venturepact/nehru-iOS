//
//  ShippingDetailsViewController.h
//  nehru
//
//  Created by Raj on 09/01/14.
//  Copyright (c) 2014 nehru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShippingDetailsViewController : UIViewController<UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    IBOutlet UITextField *txtemailAddress;
    IBOutlet UITextField *txtFullName;
    IBOutlet UITextView *txtShippingaddress;
    IBOutlet UITextField *txtCity;
    IBOutlet UITextField *txtphone;
    IBOutlet UITextField *txtState;
    IBOutlet UITextField *txtCountry;
    
    IBOutlet UIButton *btnsave;
}
@property (strong, nonatomic) IBOutlet UIScrollView *backgScroll;
-(IBAction)ClickedBtnSaveDetails:(id)sender;
-(IBAction)ClickedBackBtn:(id)sender;

@end
