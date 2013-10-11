//
//  UserplantDetail.h
//  Borkboon
//
//  Created by Relife on 9/19/56 BE.
//  Copyright (c) 2556 Relife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserplantDetail : UIViewController<NSURLConnectionDelegate>
{
    NSMutableData *_responseData;
}

@property (strong,nonatomic) NSArray *results;
@property (strong,nonatomic) NSArray *prayscript;


@property (strong, nonatomic) NSString *titleName;
@property (strong,nonatomic) NSString *titleId;
@property (strong, nonatomic) NSString *getPlan;
@property (strong, nonatomic) NSString *getuId;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentcontrol;
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIView *view3;
- (IBAction)segmentValuechange:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *textView1;
@property (strong, nonatomic) IBOutlet UITextView *textView2;
@property (strong, nonatomic) IBOutlet UITextView *textView3;

@property(nonatomic, copy) NSArray *rightBarButtonItems;
@property (weak, nonatomic) IBOutlet UIWebView *webView1;
@property (weak, nonatomic) IBOutlet UIWebView *webView2;
@property (weak, nonatomic) IBOutlet UIWebView *webView3;
- (IBAction)smBt:(id)sender;
- (IBAction)LBt:(id)sender;
- (IBAction)slowBt:(id)sender;
- (IBAction)mediumBt:(id)sender;
- (IBAction)fastBt:(id)sender;
- (IBAction)playBt:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btPlay;


@end
