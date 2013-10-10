//
//  Sign-upViewController.h
//  Borkboon
//
//  Created by Relife on 9/5/56 BE.
//  Copyright (c) 2556 Relife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Sign_upViewController : UIViewController<UINavigationControllerDelegate ,UIActionSheetDelegate, UIImagePickerControllerDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UITextField *txtLastname;
@property (strong, nonatomic) IBOutlet UITextField *txtemail;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtBirthday;
- (IBAction)btAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btImg;
- (IBAction)Join:(id)sender;
- (IBAction)bgClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) NSString *byteArray;


- (IBAction)btBackAction:(id)sender;

@end
