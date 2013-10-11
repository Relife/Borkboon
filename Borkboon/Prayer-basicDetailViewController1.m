//
//  Prayer-basicDetailViewController1.m
//  Borkboon
//
//  Created by Relife on 8/25/56 BE.
//  Copyright (c) 2556 Relife. All rights reserved.
//

#import "Prayer-basicDetailViewController1.h"
#import "UserplansCheckViewController.h"
#import <Social/Social.h>

@interface Prayer_basicDetailViewController1 ()
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
    NSTimer *Timer;
    NSString *stopt;
    
}
@property (nonatomic,weak) IBOutlet UIButton *sathuButton;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, weak) IBOutlet UISlider *slider;
@property (nonatomic, weak) IBOutlet UILabel *labelNumRemain;
@end

@implementation Prayer_basicDetailViewController1
static float testOffset = 0;
float speed = 1.0;
float current;
float scrollViewHeight = 790;
int numPrayRemain = 2;
@synthesize responseData = _responseData;
Boolean isPlaying = NO;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //set speed
//    speed = 1.0;
    testOffset = 0;
    
    //UIButtonItem
    UIImage* share = [UIImage imageNamed:@"icon_sharefb.png"];
    CGRect frameimg = CGRectMake(0, 0, share.size.width, share.size.height);
    UIButton *ButtonShare = [[UIButton alloc] initWithFrame:frameimg];
    [ButtonShare setBackgroundImage:share forState:UIControlStateNormal];
    [ButtonShare addTarget:self action:@selector(sharefb)
            forControlEvents:UIControlEventTouchUpInside];
    [ButtonShare setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *ShareBt =[[UIBarButtonItem alloc] initWithCustomView:ButtonShare];
    
    UIImage* praylist = [UIImage imageNamed:@"icon_mypraylist.png"];
    CGRect frame = CGRectMake(0, 0, praylist.size.width, praylist.size.height);
    UIButton *ButtonPraylist = [[UIButton alloc] initWithFrame:frame];
    [ButtonPraylist setBackgroundImage:praylist forState:UIControlStateNormal];
    [ButtonPraylist addTarget:self action:@selector(praylist)
          forControlEvents:UIControlEventTouchUpInside];
    [ButtonPraylist setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *PraylistBt =[[UIBarButtonItem alloc] initWithCustomView:ButtonPraylist];
    
    self.navigationItem.rightBarButtonItems =
    [NSArray arrayWithObjects:PraylistBt,ShareBt,nil];
    
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
    self.webView1.scrollView.delegate = self;
    self.webView1.delegate = self;
    [self updateSliderValue:0.0];
    [_slider addTarget:self
                  action:@selector(sliderDrag:)
        forControlEvents:(UIControlEventTouchDown)];
    [_slider addTarget:self
                action:@selector(sliderStopDrag:)
      forControlEvents:(UIControlEventTouchUpInside)];

    
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
        //NSLog(@"bali: %@", strBali);
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
    //scrollViewHeight = self.webView1.scrollView.contentSize.height - self.webView1.scrollView.bounds.size.height;
   // NSLog(@"Scroll View Height %f",scrollViewHeight);
    //CGFloat newHeight = [[_webView1 stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight;"] floatValue];
    
       //NSLog(@"size: %f, %f", fittingSize.width, fittingSize.height);
    [_slider setMaximumValue:scrollViewHeight];
    
    
    CGRect rect = _sathuButton.frame;
    rect.origin.y = 750;
    _sathuButton.frame = rect;
    [_webView1.scrollView addSubview:_sathuButton];
    
    [self updateLabelRemainPray];
}

//-(void)webViewDidFinishLoad:(UIWebView *)webView1{
//    
//    int fontSize = 200;
//    
//    NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", fontSize];
//    
//    [_webView1 stringByEvaluatingJavaScriptFromString:jsString];
//        
//}

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

-(void)praylist{
    UserplansCheckViewController *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"UserplansCheck"];
    
    tvc.prayScriptId = _titleId;
    
    [self.navigationController pushViewController:tvc animated:YES];
}

-(void)sharefb{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [controller setInitialText:[[NSString alloc] initWithFormat:@"กำลังสวดมนต์ %@", _titleName]];
        [controller addURL:[NSURL URLWithString:@""]];
        [controller addImage:[UIImage imageNamed:@"logo_app.png"]];
        
        [self presentViewController:controller animated:YES completion:Nil];
    }
}


- (IBAction)smBt:(id)sender {
    int fontSize = 100;
    
    NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", fontSize];
    
    [_webView1 stringByEvaluatingJavaScriptFromString:jsString];
}

- (IBAction)LBt:(id)sender {
    int fontSize = 130;
    
    NSString *jsString = [[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", fontSize];
    
    [_webView1 stringByEvaluatingJavaScriptFromString:jsString];
}

- (IBAction)playBt:(id)sender {
//    CGPoint bottomOffset = CGPointMake(0, self.webView1.scrollView.contentSize.height - self.webView1.scrollView.bounds.size.height);
//    [self.webView1.scrollView setContentOffset:bottomOffset animated:YES];
//    _btPlay.hidden = YES;
    
    NSLog(@"is Playing : %d",isPlaying);
    
    if(!isPlaying) {
        [_btPlay setImage:[UIImage imageNamed:@"button_stop"] forState:UIControlStateNormal];
        Timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(scrollWebview) userInfo:nil repeats:YES];
       
    }else{
        [_btPlay setImage:[UIImage imageNamed:@"button_play"] forState:UIControlStateNormal];
         [self pausePray];
    }
    isPlaying = !isPlaying;
}


- (IBAction)slowBT:(id)sender {
    speed = 5.0;
}

- (IBAction)mediumBt:(id)sender {
    speed = 10.0;
}

- (IBAction)fastBt:(id)sender {
    speed = 15.0;
}

- (IBAction)pauseBt:(id)sender {
    [self pausePray];
}

//scroll view delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    testOffset = self.webView1.scrollView.contentOffset.y;
    NSLog(@"testOffset %f and height %f",testOffset,scrollViewHeight);
    if(testOffset >= scrollViewHeight)
    {
        [self stopPray ];
        
    }
    [self updateSliderValue:testOffset];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    testOffset=self.webView1.scrollView.contentOffset.y;
    NSLog(@"scrollViewDidEndDecelerating : testOffset %f",testOffset);
}
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    testOffset=self.webView1.scrollView.contentOffset.y;
    if(testOffset>=scrollViewHeight)
    {
        [self stopPray ];
        [self.webView1.scrollView setContentOffset:CGPointMake(0, self.webView1.scrollView.contentOffset.y) animated:YES];
    }
    else if(testOffset<=0){
        testOffset=0;
    }
    testOffset=self.webView1.scrollView.contentOffset.y;
    NSLog(@" scrollViewWillEndDragging : testOffset %f",testOffset);
    
}

-(void) scrollWebview{
    //CGPoint bottomOffset = CGPointMake(0, self.webView1.scrollView.contentSize.height - self.webView1.scrollView.bounds.size.height);
//    static float testOffset = 0;
    
    CGPoint bottomOffset = CGPointMake(0, testOffset+=speed);
    [self.webView1.scrollView setContentOffset:bottomOffset animated:YES];
    if (testOffset >= scrollViewHeight) {
        
        if (Timer) {
            [Timer invalidate];
            Timer = nil;
            testOffset = 0;
        }
        return;
    }
   
    
    NSLog(@"point to stop %f",self.webView1.scrollView.contentSize.height - self.webView1.scrollView.bounds.size.height);
    NSLog(@"offset %f",testOffset);
    
//    [_btPause addTarget:self action:@selector(pauseBt:) forControlEvents:UIControlEventTouchUpInside];
    

}

-(void)stopPray{
    
    //CGPoint OffsetStart = CGPointMake(0, 0);
    //[self.webView1.scrollView setContentOffset:OffsetStart animated:YES];
    //isPlaying = NO;
    if(numPrayRemain > 0) numPrayRemain -=1;
    [self updateLabelRemainPray];
    [_btPlay setImage:[UIImage imageNamed:@"button_play"] forState:UIControlStateNormal];
    if (Timer) {
        [Timer invalidate];
        Timer = nil;
    }
}

-(void)pausePray{
   // speed = 0.0;
    //    _btPlay.hidden = NO;
    //    _btPause.hidden = YES;
    //isPlaying = NO;
    [_btPlay setImage:[UIImage imageNamed:@"button_play"] forState:UIControlStateNormal];
    if (Timer) {
        [Timer invalidate];
        Timer = nil;
    }
}


-(void) viewDidDisappear:(BOOL)animated{
    // stop pray when view disappear
    [self stopPray];
}

-(void) updateScrollView{

}
-(void)updateSliderValue:(float)value{
    _slider.value = value;
}


#pragma - mark slider delegate
-(IBAction)sliderValueChanged:(UISlider *)sender
{
    NSLog(@"slider value = %f", sender.value);
    [_webView1.scrollView setContentOffset:CGPointMake(0.0, sender.value)];
}

- (void)sliderDrag:(NSNotification *)notification {
    
    if(isPlaying)
        [self pausePray];
}

- (void)sliderStopDrag:(NSNotification *)notification {
    
    if(isPlaying)
        [_btPlay sendActionsForControlEvents:UIControlEventTouchUpInside];
}

-(void)updateLabelRemainPray{
    NSString *str = [NSString stringWithFormat:@"%d",numPrayRemain];
    //[_labelNumRemain setText:str];
}
-(IBAction)sathuButtonClick:(id)sender{
    NSLog(@"sathuButtonClick");
    [self updateLabelRemainPray];
}

#pragma - mark webview delegate 
- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"%@",webView);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"%@",error);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"%@",webView);
    testOffset = webView.scrollView.contentSize.height;
}

@end
