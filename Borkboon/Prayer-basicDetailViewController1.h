//
//  Prayer-basicDetailViewController1.h
//  Borkboon
//
//  Created by Relife on 8/25/56 BE.
//  Copyright (c) 2556 Relife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Prayer_basicDetailViewController1 : UIViewController<NSURLConnectionDelegate,UIScrollViewDelegate,UIWebViewDelegate>
{
    NSMutableData *_responseData;
}

@property (strong,nonatomic) NSArray *results;
@property (strong,nonatomic) NSArray *prayscript;


@property (strong, nonatomic) NSString *titleName;
@property (strong,nonatomic) NSString *titleId;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentcontrol;
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIView *view3;
- (IBAction)segmentValuechange:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *textView1;
@property (strong, nonatomic) IBOutlet UITextView *textView2;
@property (strong, nonatomic) IBOutlet UITextView *textView3;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property(nonatomic, copy) NSArray *rightBarButtonItems;
@property (weak, nonatomic) IBOutlet UIWebView *webView1;
@property (weak, nonatomic) IBOutlet UIWebView *webView2;
@property (weak, nonatomic) IBOutlet UIWebView *webView3;
- (IBAction)smBt:(id)sender;
- (IBAction)LBt:(id)sender;
- (IBAction)playBt:(id)sender;
- (IBAction)slowBT:(id)sender;
- (IBAction)mediumBt:(id)sender;
- (IBAction)fastBt:(id)sender;
- (IBAction)pauseBt:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btPlay;
@property (strong, nonatomic) IBOutlet UIButton *btPause;
@property (strong, nonatomic) IBOutlet UIButton *smClick;
@property (strong, nonatomic) IBOutlet UIButton *laClick;
@property (strong, nonatomic) IBOutlet UIButton *slowClick;
@property (strong, nonatomic) IBOutlet UIButton *mediumClick;
@property (strong, nonatomic) IBOutlet UIButton *fastClick;

@property (strong,nonatomic) NSString *stateFont;
@property (strong,nonatomic) NSString *stateSpeed;

@property (strong,nonatomic) NSString *loop
;

@property (strong, nonatomic) NSMutableArray *getAllId;
@property (strong, nonatomic) NSMutableArray *getAllTitle;
@property (assign) int indexPath;


@end
