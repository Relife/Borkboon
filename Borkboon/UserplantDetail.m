//
//  UserplantDetail.m
//  Borkboon
//
//  Created by Relife on 9/19/56 BE.
//  Copyright (c) 2556 Relife. All rights reserved.
//

#import "UserplantDetail.h"
#import "SettingViewController.h"
#import <Social/Social.h>

@interface UserplantDetail ()
{
    NSMutableArray *allObject;
    NSMutableArray *displayObject;
    
    // A dictionary object
    NSDictionary *dict;
    
    // Define keys
    NSString *Bali;
    NSString *ThaiAndBali;
    NSString *History;
    NSString *Prayloop;
    
}
@property (nonatomic, strong) NSMutableData *responseData;

@end

@implementation UserplantDetail

@synthesize responseData = _responseData;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //UIButtonItem
    UIImage* share = [UIImage imageNamed:@"icon_sharefb.png"];
    CGRect frameimg = CGRectMake(0, 0, share.size.width, share.size.height);
    UIButton *ButtonShare = [[UIButton alloc] initWithFrame:frameimg];
    [ButtonShare setBackgroundImage:share forState:UIControlStateNormal];
    [ButtonShare addTarget:self action:@selector(sharefb)
          forControlEvents:UIControlEventTouchUpInside];
    [ButtonShare setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *ShareBt =[[UIBarButtonItem alloc] initWithCustomView:ButtonShare];
    
    UIImage* setting = [UIImage imageNamed:@"icon_setting.png"];
    CGRect frame = CGRectMake(0, 0, setting.size.width, setting.size.height);
    UIButton *ButtonSetting = [[UIButton alloc] initWithFrame:frame];
    [ButtonSetting setBackgroundImage:setting forState:UIControlStateNormal];
    [ButtonSetting addTarget:self action:@selector(setting)
             forControlEvents:UIControlEventTouchUpInside];
    [ButtonSetting setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *SettingBt =[[UIBarButtonItem alloc] initWithCustomView:ButtonSetting];
    
    self.navigationItem.rightBarButtonItems =
    [NSArray arrayWithObjects:SettingBt,ShareBt,nil];
    
    
    self.title = _titleName;
    //    NSLog(@"%@",_titleId);
    self.responseData = [NSMutableData data];
    
    NSURL *aUrl = [NSURL URLWithString:@"http://codegears.co.th/borkboon/getPrayScript.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl];
    
    [request setHTTPMethod:@"POST"];
    NSString *postString = [NSString stringWithFormat:@"id=%@", _titleId];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request  delegate:self];
    if (connection) {
        _responseData = [NSMutableData data] ;
    } else {
        UIAlertView *connectFailMessage = [[UIAlertView alloc] initWithTitle:@"NSURLConnection " message:@"Failed in viewDidLoad"  delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [connectFailMessage show];
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    //    NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    // Define keys
    Bali = @"bali";
    ThaiAndBali = @"thai_and_bali";
    History = @"history";
    Prayloop = @"pray_loop";
    
    // Create array to hold dictionaries
    allObject = [[NSMutableArray alloc] init];
    
    // extract specific value...
    _results = [[res objectForKey:@"pray_script_detail_list"] objectForKey:@"pray_script_detail"];
    
    for (NSDictionary *result in _results) {
        NSString *strBali = [result objectForKey:@"bali"];
        NSString *strThaiAndBali = [result objectForKey:@"thai_and_bali"];
        NSString *strHistory = [result objectForKey:@"history"];
        NSString *strPrayloop = [result objectForKey:@"pray_loop"];
        NSLog(@"bali: %@", strBali);
        //        NSLog(@"thai_and_bali: %@", thai_and_bali);
        //        NSLog(@"history %@", history);
        //        NSLog(@"prayloop %@", prayloop);
//        _textView1.text = strBali;
//        _textView2.text = strThaiAndBali;
//        _textView3.text = strHistory;
        [_webView1 loadHTMLString:strBali baseURL:nil];
        [_webView2 loadHTMLString:strThaiAndBali baseURL:nil];
        [_webView3 loadHTMLString:strHistory baseURL:nil];
        dict = [NSDictionary dictionaryWithObjectsAndKeys:
                strBali, Bali,
                strThaiAndBali, ThaiAndBali,
                strHistory, History,
                strPrayloop, Prayloop,
                nil];
        [allObject addObject:dict];
    }
    displayObject =[[NSMutableArray alloc] initWithArray:allObject];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segmentValuechange:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.view1.hidden = NO;
            self.view2.hidden = YES;
            self.view3.hidden = YES;
            break;
            
        case 1:
            self.view1.hidden = YES;
            self.view2.hidden = NO;
            self.view3.hidden = YES;
            break;
            
        case 2:
            self.view1.hidden = YES;
            self.view2.hidden = YES;
            self.view3.hidden = NO;
            break;
            
        default:
            break;
    }
}

-(void)setting{
    SettingViewController *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingView"];
    tvc.getName = _titleName;
    tvc.getPlanName = _getPlan;
    
    [self.navigationController pushViewController:tvc animated:YES];
}
- (IBAction)smBt:(id)sender {
    int fontSize = 100;
    
    NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", fontSize];
    
    [_webView1 stringByEvaluatingJavaScriptFromString:jsString];
}

-(void)sharefb{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:@""];
        [controller addURL:[NSURL URLWithString:@"http://www.appcoda.com"]];
        
        [self presentViewController:controller animated:YES completion:Nil];
        
    }
}

- (IBAction)LBt:(id)sender {
    int fontSize = 130;
    
    NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", fontSize];
    
    [_webView1 stringByEvaluatingJavaScriptFromString:jsString];
}

- (IBAction)slowBt:(id)sender {
}

- (IBAction)mediumBt:(id)sender {
}

- (IBAction)fastBt:(id)sender {
}

- (IBAction)playBt:(id)sender {
}
@end
