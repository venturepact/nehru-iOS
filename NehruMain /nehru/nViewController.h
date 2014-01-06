//
//  nViewController.h
//  nehru
//
//  Created by ADMIN on 11/27/13.
//  Copyright (c) 2013 nehru. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface nViewController : UIViewController<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    // thread delay
    dispatch_time_t bckgTime;
    NSArray *bckgImages;
    IBOutlet UIImageView *bckgImage;
    dispatch_source_t nTimer;
    // check if view coming back
    BOOL isComingBack;
    
    NSString *strGender;
    
    IBOutlet UIView *signInView;
    IBOutlet UIView *signUpView;
    
    IBOutlet UISegmentedControl *segmentedControl;
    
    IBOutlet UITextField *txtfirstname;
    IBOutlet UITextField *txtlastname;
    IBOutlet UITextField *txtPassword;
    IBOutlet UITextField *txtConfirmPassword;
    IBOutlet UITextField *txtEmailId;
     IBOutlet UIButton * choosePhotoBtn;
    
    IBOutlet UIButton *btnMale;
    IBOutlet UIButton *btnFemale;
    
    IBOutlet UIButton *btnRegister;
    IBOutlet UIButton *btnSignIn;
    
    IBOutlet UITextField *signInEmailId;
    IBOutlet UITextField *signInPassword;
    
    IBOutlet UIImageView *UserImgVIew;
}

-(IBAction)goToBrowse:(id)sender;
-(IBAction)ClickedSignIn:(id)sender;
-(IBAction)ClickedSignUp:(id)sender;
@end
