//
//  PrayerViewController.h
//  Borkboon
//
//  Created by Relife on 8/19/56 BE.
//  Copyright (c) 2556 Relife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrayerViewController : UIViewController<NSURLConnectionDelegate>
{
    NSMutableData *_responseData1;
}

@property (strong,nonatomic) NSArray *results1;
@property (strong,nonatomic) NSArray *results1_1;
- (IBAction)menu1:(id)sender;
- (IBAction)menu2:(id)sender;
- (IBAction)menu3:(id)sender;
- (IBAction)menu4:(id)sender;
- (IBAction)menu5:(id)sender;
- (IBAction)menu6:(id)sender;

@end
