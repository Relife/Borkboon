//
//  Sign-inViewController.h
//  Borkboon
//
//  Created by Relife on 9/4/56 BE.
//  Copyright (c) 2556 Relife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Sign_inViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *password;
- (IBAction)sign_in:(id)sender;
- (IBAction)backgroundClick:(id)sender;

@end
