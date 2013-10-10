//
//  PlansprayerViewController.h
//  Borkboon
//
//  Created by Relife on 8/30/56 BE.
//  Copyright (c) 2556 Relife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlansprayerViewController : UIViewController

- (IBAction)login:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btlogin;
- (IBAction)exitBt:(id)sender;

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *birthDay;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *fb_id;
@property (strong, nonatomic) NSArray *friendFb;

@end
