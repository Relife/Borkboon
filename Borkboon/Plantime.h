//
//  Plantime.h
//  Borkboon
//
//  Created by Relife on 9/24/56 BE.
//  Copyright (c) 2556 Relife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Plantime : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *editStartDate;
@property (weak, nonatomic) IBOutlet UIDatePicker *Picker;

- (IBAction)bgClick:(id)sender;
- (IBAction)DoneBt:(id)sender;
@property (strong, nonatomic) NSString *Date;

@end
