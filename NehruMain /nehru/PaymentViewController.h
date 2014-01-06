//
//  PaymentViewController.h
//  nehru
//
//  Created by ADMIN on 12/30/13.
//  Copyright (c) 2013 nehru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataMyCart.h"
#import "AFNetworking.h"
#import "AFJSONRequestOperation.h"
#import "Stripe.h"
#import "RWCheckoutInputCell.h"
#import "RWCheckoutDisplayCell.h"

#define STRIPE_TEST_PUBLIC_KEY @"pk_test_4AvLLKCDfU4ZyLDWiJnwjf7C"
#define STRIPE_TEST_POST_URL @"http://nehru.venturepact.com/stripe/pay.php"

@interface PaymentViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIAlertViewDelegate>
{
}
@property (strong, nonatomic) IBOutlet UITableView* tableView;
@property (strong, nonatomic) IBOutlet UIView* buttonView;
@property (strong, nonatomic) IBOutlet UIButton* completeButton;
@property (strong, nonatomic) UITextField* nameTextField;
@property (strong, nonatomic) UITextField* emailTextField;
@property (strong, nonatomic) UITextField* expirationDateTextField;
@property (strong, nonatomic) UITextField* cardNumber;
@property (strong, nonatomic) UITextField* CVCNumber;
@property (strong, nonatomic) NSArray* monthArray;
@property (strong, nonatomic) NSNumber* selectedMonth;
@property (strong, nonatomic) NSNumber* selectedYear;
@property (strong, nonatomic) UIPickerView *expirationDatePicker;

@property (strong, nonatomic) AFJSONRequestOperation* httpOperation;
@property (strong, nonatomic) STPCard* stripeCard;
@end
