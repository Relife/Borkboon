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
#import "DAAutoScroll.h"
#import "SBJson.h"

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
@property (nonatomic, weak) IBOutlet UILabel *labelTimePray;
@end

@implementation Prayer_basicDetailViewController1
static float testOffset = 0;
float timePray = 0.0;
float lastOffset = 0;
float speed = 1.0;
float current;
float scrollViewHeight = 0;
int numPrayRemain = 0;
NSString *strWebWithBr = @"";
@synthesize responseData = _responseData;
Boolean isPlaying = NO;
Boolean playWhenSliderFinish = NO;

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

    // add number pray remain in code
    [_view1 bringSubviewToFront:_labelNumRemain];
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
        NSLog(@"prayloop %@", strPrayloop);
        numPrayRemain =  [strPrayloop intValue];
        //        _textView1.text = strBali;
//        _textView2.text = strThaiAndBali;
//        _textView3.text = strHistory;
       strWebWithBr = [NSString stringWithFormat:@"%@<br><br><br>",strBali];
        [_webView1 loadHTMLString:strWebWithBr baseURL:nil];
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
    [_slider setMaximumValue:scrollViewHeight];
    
    // add sathu button 
    [self updateLabelRemainPray];
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
    int fontSize = 14;
    _stateFont = @"small";
    
    NSString *str_web = [[NSString alloc] initWithFormat:@"<style>body{font-size:%dpx;}</style>%@", fontSize,strWebWithBr];
   // [_webView1 reload];
    [_webView1 loadHTMLString:str_web baseURL:nil];
    lastOffset = testOffset;
    
    if([_stateFont isEqual: @"small"]) {
        
        [_smClick setImage:[UIImage imageNamed:@"button_font_small_02"] forState:UIControlStateNormal];
        [_laClick setImage:[UIImage imageNamed:@"button_font_big_01"] forState:UIControlStateNormal];
    }else{
        [_smClick setImage:[UIImage imageNamed:@"button_font_small_01"] forState:UIControlStateNormal];
    }

}

- (IBAction)LBt:(id)sender {
    _stateFont = @"big";
    
    int fontSize = 25;
    NSString *str_web = [[NSString alloc] initWithFormat:@"<style>body{font-size:%dpx;}</style>%@", fontSize,strWebWithBr];
    [_webView1 loadHTMLString:str_web baseURL:nil];
    lastOffset = testOffset;
    
    if([_stateFont isEqual: @"big"]) {
        
        [_laClick setImage:[UIImage imageNamed:@"button_font_big_02"] forState:UIControlStateNormal];
        [_smClick setImage:[UIImage imageNamed:@"button_font_small_01"] forState:UIControlStateNormal];
    }else{
        [_laClick setImage:[UIImage imageNamed:@"button_font_big_01"] forState:UIControlStateNormal];
    }
}

- (IBAction)playBt:(id)sender {
    [self playPray];
}


- (IBAction)slowBT:(id)sender {
    _stateSpeed = @"slow";
    speed = 1.0;
    [_webView1.scrollView setScrollPointsPerSecond:15.0f];
    if(isPlaying)
    [_webView1.scrollView startScrolling];
    
    if([_stateSpeed isEqual: @"slow"]) {
        
        [_slowClick setImage:[UIImage imageNamed:@"button_slow_02"] forState:UIControlStateNormal];
        [_mediumClick setImage:[UIImage imageNamed:@"button_middle_01"] forState:UIControlStateNormal];
        [_fastClick setImage:[UIImage imageNamed:@"button_quick_01"] forState:UIControlStateNormal];
    }
}

- (IBAction)mediumBt:(id)sender {
    _stateSpeed = @"medium";
   [_webView1.scrollView setScrollPointsPerSecond:20.0f];
    if(isPlaying)
        [_webView1.scrollView startScrolling];
    if([_stateSpeed isEqual: @"medium"]) {
        
        [_slowClick setImage:[UIImage imageNamed:@"button_slow_01"] forState:UIControlStateNormal];
        [_mediumClick setImage:[UIImage imageNamed:@"button_middle_02"] forState:UIControlStateNormal];
        [_fastClick setImage:[UIImage imageNamed:@"button_quick_01"] forState:UIControlStateNormal];
    }
}

- (IBAction)fastBt:(id)sender {
    _stateSpeed = @"fast";
    [_webView1.scrollView setScrollPointsPerSecond:25.0f];
    if(isPlaying)
        [_webView1.scrollView startScrolling];
    if([_stateSpeed isEqual: @"fast"]) {
        
        [_slowClick setImage:[UIImage imageNamed:@"button_slow_01"] forState:UIControlStateNormal];
        [_mediumClick setImage:[UIImage imageNamed:@"button_middle_01"] forState:UIControlStateNormal];
        [_fastClick setImage:[UIImage imageNamed:@"button_quick_02"] forState:UIControlStateNormal];
    }
}

- (IBAction)pauseBt:(id)sender {
    //[self pausePray];
    [_webView1.scrollView stopScrolling];
}

//scroll view delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    testOffset = self.webView1.scrollView.contentOffset.y;
    NSLog(@"testOffset %f and scrollViewHeight %f",testOffset,scrollViewHeight);
    if(testOffset+2 >= scrollViewHeight)
    {
        [self stopPray ];
        playWhenSliderFinish = NO;
    }
    [self updateSliderValue:testOffset];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  //  testOffset=self.webView1.scrollView.contentOffset.y;
    NSLog(@"scrollViewDidEndDecelerating : testOffset %f",testOffset);
}
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    [self.webView1.scrollView setContentOffset:CGPointMake(0, testOffset) animated:YES];    
}

-(void) scrollWebview{
    
    CGPoint bottomOffset = CGPointMake(0, testOffset+=speed);
    [self.webView1.scrollView setContentOffset:bottomOffset animated:YES];
    if (testOffset+2 >= scrollViewHeight) {
        [self stopPray];
        if (Timer) {
            [Timer invalidate];
            Timer = nil;
        }
        return;
    }    
}

-(void)playPray{
    NSLog(@"is Playing : %d",isPlaying);
    
    if(testOffset+2 >= scrollViewHeight) return;
    
    if(isPlaying) {
        
         [_btPlay setImage:[UIImage imageNamed:@"button_play"] forState:UIControlStateNormal];
        [_webView1.scrollView stopScrolling];
        
    }else{
       [_btPlay setImage:[UIImage imageNamed:@"button_stop"] forState:UIControlStateNormal];
        if(!Timer){
            Timer = [NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(updateTimeLabel) userInfo:nil repeats:YES];
        }
        [_webView1.scrollView startScrolling];
    }
    isPlaying = !isPlaying;
}

-(void)stopPray{
    
    //CGPoint OffsetStart = CGPointMake(0, 0);
    //[self.webView1.scrollView setContentOffset:OffsetStart animated:YES];
    isPlaying = NO;
    [_webView1.scrollView stopScrolling];
    [_btPlay setImage:[UIImage imageNamed:@"button_play"] forState:UIControlStateNormal];
    if (Timer) {
        [Timer invalidate];
        Timer = nil;
    }
}

-(void) viewDidDisappear:(BOOL)animated{
    // stop pray when view disappear
   //[self stopPray];
    [_webView1.scrollView stopScrolling];
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
    
    if(playWhenSliderFinish)
        [self stopPray];
}

- (void)sliderStopDrag:(NSNotification *)notification {
    if(playWhenSliderFinish)
        [self playPray];
}

-(void)updateLabelRemainPray{
    NSString *str = [NSString stringWithFormat:@"%d",numPrayRemain];
    [_labelNumRemain setText:str];
}

-(IBAction)sathuButtonClick:(id)sender{
    NSLog(@"sathuButtonClick");
    
    if(numPrayRemain > 1){
        numPrayRemain -=1;
        [self updateLabelRemainPray];
        [self stopPray];
        [_webView1.scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
        [self playPray];
        //[_btPlay sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    else{
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"สวดครบแล้ว" message:@"ไปยังหน้าถัดไป" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
        
        //get arrID, index
        NSLog(@"%@",_titleId);
        NSLog(@"idArr %@",_getAllId);
        NSLog(@"next view %i", _indexPath);
        NSLog(@"titleArr %@",_getAllTitle);
        
        _indexPath++;
        testOffset = 0;
        
        if (_indexPath<_getAllId.count) {
            //Next title
            NSString *Title = [_getAllTitle objectAtIndex:_indexPath];
            self.title = Title;
            
            NSString *idNext = [_getAllId objectAtIndex:_indexPath];
            
            //post next pray
            NSString *post =[[NSString alloc] initWithFormat:@"id=%@",idNext];
            NSLog(@"PostData: %@",post);
            
            NSURL *url=[NSURL URLWithString:@"http://codegears.co.th/borkboon/getPrayScript.php"];
            
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            
            NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:url];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
            
            //            [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
            
            NSError *error = [[NSError alloc] init];
            NSHTTPURLResponse *response = nil;
            NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            self.webView1.scrollView.delegate = self;
            self.webView1.delegate = self;
            [self updateSliderValue:0.0];
            [_slider addTarget:self
                        action:@selector(sliderDrag:)
              forControlEvents:(UIControlEventTouchDown)];
            [_slider addTarget:self
                        action:@selector(sliderStopDrag:)
              forControlEvents:(UIControlEventTouchUpInside)];
            
            // add number pray remain in code
            [_view1 bringSubviewToFront:_labelNumRemain];
            
            // Define keys
            Bali = @"bali";
            ThaiAndBali = @"thai_and_bali";
            History = @"history";
            Prayloop = @"pray_loop";
            
            // Create array to hold dictionaries
            allObject = [[NSMutableArray alloc] init];
            
            
            NSLog(@"Response code: %d", [response statusCode]);
            if ([response statusCode] >=200 && [response statusCode] <300)
            {
                NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
                //        NSLog(@"Response ==> %@", responseData);
                
                SBJsonParser *jsonParser = [SBJsonParser new];
                NSDictionary *jsonData = (NSDictionary *) [jsonParser objectWithString:responseData error:nil];
                NSLog(@"%@",jsonData);
                
                // extract specific value...
                _results = [[jsonData objectForKey:@"pray_script_detail_list"] objectForKey:@"pray_script_detail"];
                
                for (NSDictionary *result in _results) {
                    NSString *strBali = [result objectForKey:@"bali"];
                    NSString *strThaiAndBali = [result objectForKey:@"thai_and_bali"];
                    NSString *strHistory = [result objectForKey:@"history"];
                    NSString *strPrayloop = [result objectForKey:@"pray_loop"];
                    NSLog(@"bali: %@", strBali);
                    //        NSLog(@"thai_and_bali: %@", thai_and_bali);
                    //        NSLog(@"history %@", history);
                    NSLog(@"prayloop %@", strPrayloop);
                    numPrayRemain =  [strPrayloop intValue];
                    //        _textView1.text = strBali;
                    //        _textView2.text = strThaiAndBali;
                    //        _textView3.text = strHistory;
                    strWebWithBr = [NSString stringWithFormat:@"%@<br><br><br>",strBali];
                    [_webView1 loadHTMLString:strWebWithBr baseURL:nil];
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
                [_slider setMaximumValue:scrollViewHeight];
                
                // add sathu button 
                [self updateLabelRemainPray];
                
            }
        }
        
        else{
            [self.navigationController popViewControllerAnimated: YES];
        }
    }
}

#pragma - mark webview delegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"%@",webView);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"%@",error);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    CGRect frame = webView.frame;
    frame.size.height = webView.scrollView.contentSize.height;
    CGRect rect = _sathuButton.frame;
    float height_screen = [ [ UIScreen mainScreen ] bounds ].size.height;
    if(height_screen == 568){
     // iphone 5
    scrollViewHeight = frame.size.height - 402;
    rect.origin.y = scrollViewHeight + 350;
    }
    else {
    // iphone 4
    scrollViewHeight = frame.size.height - 312.0;
    rect.origin.y = scrollViewHeight + 260;
    
    }
//
     _sathuButton.frame = rect;
     NSLog(@"_sathuButton y : %f",_sathuButton.frame.origin.y);
    [_webView1.scrollView addSubview:_sathuButton];
    [_slider setMaximumValue:scrollViewHeight];
    [self.webView1.scrollView setContentOffset:CGPointMake(0.0, lastOffset) animated:NO];
    testOffset = 0;
    timePray = 0.0f;
}

-(void) layoutSubviews {
    [self.view layoutSubviews];
    [_webView1 stringByEvaluatingJavaScriptFromString:
     [NSString stringWithFormat:
      @"document.querySelector('meta[name=viewport]').setAttribute('content', 'width=%d;', false); ",
      (int)_webView1.frame.size.width]];
}

-(void)updateTimeLabel{
    timePray += (3.07f/10.6f);
    NSString *str_time = [NSString stringWithFormat:@"%.2f",timePray];
    [_labelTimePray setText:str_time];
}

@end
