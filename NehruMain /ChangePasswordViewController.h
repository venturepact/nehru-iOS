//
//  ChangePasswordViewController.h
//  nehru
//
//  Created by Raj on 08/01/14.
//  Copyright (c) 2014 nehru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UITextField *mTxtEmailID;

  
    IBOutlet UITextField *mTxtNewPassword;
    IBOutlet UITextField *mTxtConfrmPassword;
    
}

@property (nonatomic,strong)IBOutlet UITextField *mTxtNewPassword;
@property (nonatomic,strong)IBOutlet UITextField *mTxtConfrmPassword;
@property (nonatomic,strong)IBOutlet UITextField *mTxtEmailID;
-(IBAction)mClickedChangePassword:(id)sender;

@end
