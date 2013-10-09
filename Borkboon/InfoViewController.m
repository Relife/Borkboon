//
//  InfoViewController.m
//  Borkboon
//
//  Created by Relife on 9/10/56 BE.
//  Copyright (c) 2556 Relife. All rights reserved.
//

#import "InfoViewController.h"
#import "SBJson.h"
#import "InfoTableViewController.h"
#import "AppDelegate.h"

@interface InfoViewController ()
{
    NSString* uid;
}

@end

@implementation InfoViewController

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
    //UIButtonItem
 
}

- (void) viewWillAppear:(BOOL)animated{
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (app.loginState == LSTATE_LOGOUT || app.loginState == LSTATE_NOT_LOGIN) {
        
        // Create login view
        UIViewController* view = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNavigationView"];
        [self presentViewController:view animated:YES completion:nil];
        
    }
    else if(app.loginState == LSTATE_LOGIN_EMAIL){
        uid = app.userID;
        [self LoadData];
    }
    else if(app.loginState == LSTATE_LOGIN_FACEBOOK){
        [self LoadData];
    }
}

- (void) LoadData{
    UIImage* setting = [UIImage imageNamed:@"icon_setting.png"];
    CGRect frameimg = CGRectMake(0, 0, setting.size.width, setting.size.height);
    UIButton *ButtonSetting = [[UIButton alloc] initWithFrame:frameimg];
    [ButtonSetting setBackgroundImage:setting forState:UIControlStateNormal];
    [ButtonSetting addTarget:self action:@selector(setting)
            forControlEvents:UIControlEventTouchUpInside];
    [ButtonSetting setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *SettingBt =[[UIBarButtonItem alloc] initWithCustomView:ButtonSetting];
    self.navigationItem.rightBarButtonItem=SettingBt;
    
    
    NSString *post =[[NSString alloc] initWithFormat:@"uid=%@",uid];
    NSLog(@"PostData: %@",post);
    
    NSURL *url=[NSURL URLWithString:@"http://codegears.co.th/borkboon/getuserinfo.php"];
    
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
    
    NSLog(@"Response code: %d", [response statusCode]);
    if ([response statusCode] >=200 && [response statusCode] <300)
    {
        NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
        NSLog(@"Response ==> %@", responseData);
        
        SBJsonParser *jsonParser = [SBJsonParser new];
        NSDictionary *jsonData = (NSDictionary *) [jsonParser objectWithString:responseData error:nil];
        NSLog(@"%@",jsonData);
        
        NSString *first = [jsonData objectForKey:@"firstname"];
        NSLog(@"%@",first);
        NSString *img = [jsonData objectForKey:@"image_profile"];
        NSString *last = [jsonData objectForKey:@"lastname"];
        NSLog(@"%@",img);
        NSString *time = [jsonData objectForKey:@"time_pray"];
        NSString *friend = [jsonData objectForKey:@"time_pray_friend_percent"];
        NSString *me = [jsonData objectForKey:@"time_pray_me_percent"];
        NSString *top = [jsonData objectForKey:@"time_pray_top_percent"];
        
        [_txtfirstname setText:[NSString stringWithFormat:@"คุณ %@ %@",first,last]];
        //        [_txtlastname setText:[NSString stringWithFormat:@" %@",last]];
        [_txttime setText:[NSString stringWithFormat:@"ใช้เวลาสวดมนต์ %@ ชั่วโมง",time]];
        [_txtme setText:[NSString stringWithFormat:@"%@",me]];
        [_txtfriend setText:[NSString stringWithFormat:@"%@",friend]];
        [_txttop setText:[NSString stringWithFormat:@"%@",top]];
        
        NSString *picURL = [NSString stringWithFormat:@"http://www.codegears.co.th/borkboon/image/%@",img];
        NSURL *useUrl = [NSURL URLWithString:picURL];
        //    NSData *data = [NSData dataWithContentsOfURL:useUrl];
        //    cell.imageView.image = [UIImage imageWithData:data];
        NSURLRequest* request = [NSURLRequest requestWithURL:useUrl];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error) {
            
            _imgView.image = [UIImage imageWithData:data];
        }];
        
        //me
        float f= [me floatValue];
        _meInt = (int) (f);
        _txtme.text = [NSString stringWithFormat:@"%d",_meInt];
        if (_meInt >= 95) {
            _meStar1.image = [UIImage imageNamed:@"star_yellow.png"];
            _meStar2.image = [UIImage imageNamed:@"star_yellow.png"];
            _meStar3.image = [UIImage imageNamed:@"star_yellow.png"];
            _meStar4.image = [UIImage imageNamed:@"star_yellow.png"];
            _meStar5.image = [UIImage imageNamed:@"star_yellow.png"];
        }
        else if(_meInt >= 85) {
            _meStar1.image = [UIImage imageNamed:@"star_yellow.png"];
            _meStar2.image = [UIImage imageNamed:@"star_yellow.png"];
            _meStar3.image = [UIImage imageNamed:@"star_yellow.png"];
            _meStar4.image = [UIImage imageNamed:@"star_yellow.png"];
            _meStar5.image = [UIImage imageNamed:@"star_yellow-gray.png"];
        }
        else if(_meInt >= 75) {
            _meStar1.image = [UIImage imageNamed:@"star_yellow.png"];
            _meStar2.image = [UIImage imageNamed:@"star_yellow.png"];
            _meStar3.image = [UIImage imageNamed:@"star_yellow.png"];
            _meStar4.image = [UIImage imageNamed:@"star_yellow.png"];
            _meStar5.image = [UIImage imageNamed:@"star_gray.png"];    }
        else if(_meInt >= 65) {
            _meStar1.image = [UIImage imageNamed:@"star_yellow.png"];
            _meStar2.image = [UIImage imageNamed:@"star_yellow.png"];
            _meStar3.image = [UIImage imageNamed:@"star_yellow.png"];
            _meStar4.image = [UIImage imageNamed:@"star_yellow-gray.png"];
            _meStar5.image = [UIImage imageNamed:@"star_gray.png"];    }
        else if(_meInt >= 55) {
            _meStar1.image = [UIImage imageNamed:@"star_yellow.png"];
            _meStar2.image = [UIImage imageNamed:@"star_yellow.png"];
            _meStar3.image = [UIImage imageNamed:@"star_yellow.png"];
            _meStar4.image = [UIImage imageNamed:@"star_gray.png"];
            _meStar5.image = [UIImage imageNamed:@"star_gray.png"];    }
        else if(_meInt >= 45) {
            _meStar1.image = [UIImage imageNamed:@"star_yellow.png"];
            _meStar2.image = [UIImage imageNamed:@"star_yellow.png"];
            _meStar3.image = [UIImage imageNamed:@"star_yellow-gray.png"];
            _meStar4.image = [UIImage imageNamed:@"star_gray.png"];
            _meStar5.image = [UIImage imageNamed:@"star_gray.png"];    }
        else if(_meInt >= 35) {
            _meStar1.image = [UIImage imageNamed:@"star_yellow.png"];
            _meStar2.image = [UIImage imageNamed:@"star_yellow.png"];
            _meStar3.image = [UIImage imageNamed:@"star_gray.png"];
            _meStar4.image = [UIImage imageNamed:@"star_gray.png"];
            _meStar5.image = [UIImage imageNamed:@"star_gray.png"];    }
        else if(_meInt >= 25) {
            _meStar1.image = [UIImage imageNamed:@"star_yellow.png"];
            _meStar2.image = [UIImage imageNamed:@"star_yellow-gray.png"];
            _meStar3.image = [UIImage imageNamed:@"star_gray.png"];
            _meStar4.image = [UIImage imageNamed:@"star_gray.png"];
            _meStar5.image = [UIImage imageNamed:@"star_gray.png"];    }
        else if(_meInt >= 15) {
            _meStar1.image = [UIImage imageNamed:@"star_yellow.png"];
            _meStar2.image = [UIImage imageNamed:@"star_gray.png"];
            _meStar3.image = [UIImage imageNamed:@"star_gray.png"];
            _meStar4.image = [UIImage imageNamed:@"star_gray.png"];
            _meStar5.image = [UIImage imageNamed:@"star_gray.png"];    }
        else if(_meInt >= 5) {
            _meStar1.image = [UIImage imageNamed:@"star_yellow-gray.png"];
            _meStar2.image = [UIImage imageNamed:@"star_gray.png"];
            _meStar3.image = [UIImage imageNamed:@"star_gray.png"];
            _meStar4.image = [UIImage imageNamed:@"star_gray.png"];
            _meStar5.image = [UIImage imageNamed:@"star_gray.png"];    }
        else {
            _meStar1.image = [UIImage imageNamed:@"star_gray.png"];
            _meStar2.image = [UIImage imageNamed:@"star_gray.png"];
            _meStar3.image = [UIImage imageNamed:@"star_gray.png"];
            _meStar4.image = [UIImage imageNamed:@"star_gray.png"];
            _meStar5.image = [UIImage imageNamed:@"star_gray.png"];    }
        
        //friend
        float f2= [friend floatValue];
        _friendInt = (int) (f2);
        _txtfriend.text = [NSString stringWithFormat:@"%d",_friendInt];
        if (_friendInt >= 95) {
            _friendStar1.image = [UIImage imageNamed:@"star_yellow.png"];
            _friendStar2.image = [UIImage imageNamed:@"star_yellow.png"];
            _friendStar3.image = [UIImage imageNamed:@"star_yellow.png"];
            _friendStar4.image = [UIImage imageNamed:@"star_yellow.png"];
            _friendStar5.image = [UIImage imageNamed:@"star_yellow.png"];
        }
        else if(_friendInt >= 85) {
            _friendStar1.image = [UIImage imageNamed:@"star_yellow.png"];
            _friendStar2.image = [UIImage imageNamed:@"star_yellow.png"];
            _friendStar3.image = [UIImage imageNamed:@"star_yellow.png"];
            _friendStar4.image = [UIImage imageNamed:@"star_yellow.png"];
            _friendStar5.image = [UIImage imageNamed:@"star_yellow-gray.png"];
        }
        else if(_friendInt >= 75) {
            _friendStar1.image = [UIImage imageNamed:@"star_yellow.png"];
            _friendStar2.image = [UIImage imageNamed:@"star_yellow.png"];
            _friendStar3.image = [UIImage imageNamed:@"star_yellow.png"];
            _friendStar4.image = [UIImage imageNamed:@"star_yellow.png"];
            _friendStar5.image = [UIImage imageNamed:@"star_gray.png"];    }
        else if(_friendInt >= 65) {
            _friendStar1.image = [UIImage imageNamed:@"star_yellow.png"];
            _friendStar2.image = [UIImage imageNamed:@"star_yellow.png"];
            _friendStar3.image = [UIImage imageNamed:@"star_yellow.png"];
            _friendStar4.image = [UIImage imageNamed:@"star_yellow-gray.png"];
            _friendStar5.image = [UIImage imageNamed:@"star_gray.png"];    }
        else if(_friendInt >= 55) {
            _friendStar1.image = [UIImage imageNamed:@"star_yellow.png"];
            _friendStar2.image = [UIImage imageNamed:@"star_yellow.png"];
            _friendStar3.image = [UIImage imageNamed:@"star_yellow.png"];
            _friendStar4.image = [UIImage imageNamed:@"star_gray.png"];
            _friendStar5.image = [UIImage imageNamed:@"star_gray.png"];    }
        else if(_friendInt >= 45) {
            _friendStar1.image = [UIImage imageNamed:@"star_yellow.png"];
            _friendStar2.image = [UIImage imageNamed:@"star_yellow.png"];
            _friendStar3.image = [UIImage imageNamed:@"star_yellow-gray.png"];
            _friendStar4.image = [UIImage imageNamed:@"star_gray.png"];
            _friendStar5.image = [UIImage imageNamed:@"star_gray.png"];    }
        else if(_friendInt >= 35) {
            _friendStar1.image = [UIImage imageNamed:@"star_yellow.png"];
            _friendStar2.image = [UIImage imageNamed:@"star_yellow.png"];
            _friendStar3.image = [UIImage imageNamed:@"star_gray.png"];
            _friendStar4.image = [UIImage imageNamed:@"star_gray.png"];
            _friendStar5.image = [UIImage imageNamed:@"star_gray.png"];    }
        else if(_friendInt >= 25) {
            _friendStar1.image = [UIImage imageNamed:@"star_yellow.png"];
            _friendStar2.image = [UIImage imageNamed:@"star_yellow-gray.png"];
            _friendStar3.image = [UIImage imageNamed:@"star_gray.png"];
            _friendStar4.image = [UIImage imageNamed:@"star_gray.png"];
            _friendStar5.image = [UIImage imageNamed:@"star_gray.png"];    }
        else if(_friendInt >= 15) {
            _friendStar1.image = [UIImage imageNamed:@"star_yellow.png"];
            _friendStar2.image = [UIImage imageNamed:@"star_gray.png"];
            _friendStar3.image = [UIImage imageNamed:@"star_gray.png"];
            _friendStar4.image = [UIImage imageNamed:@"star_gray.png"];
            _friendStar5.image = [UIImage imageNamed:@"star_gray.png"];    }
        else if(_friendInt >= 5) {
            _friendStar1.image = [UIImage imageNamed:@"star_yellow-gray.png"];
            _friendStar2.image = [UIImage imageNamed:@"star_gray.png"];
            _friendStar3.image = [UIImage imageNamed:@"star_gray.png"];
            _friendStar4.image = [UIImage imageNamed:@"star_gray.png"];
            _friendStar5.image = [UIImage imageNamed:@"star_gray.png"];    }
        else {
            _friendStar1.image = [UIImage imageNamed:@"star_gray.png"];
            _friendStar2.image = [UIImage imageNamed:@"star_gray.png"];
            _friendStar3.image = [UIImage imageNamed:@"star_gray.png"];
            _friendStar4.image = [UIImage imageNamed:@"star_gray.png"];
            _friendStar5.image = [UIImage imageNamed:@"star_gray.png"];    }
        
        //top10
        float f3= [top floatValue];
        _top10Int = (int) (f3);
        _txttop.text = [NSString stringWithFormat:@"%d",_top10Int];
        if (_top10Int >= 95) {
            _top10Star1.image = [UIImage imageNamed:@"star_yellow.png"];
            _top10Star2.image = [UIImage imageNamed:@"star_yellow.png"];
            _top10Star3.image = [UIImage imageNamed:@"star_yellow.png"];
            _top10Star4.image = [UIImage imageNamed:@"star_yellow.png"];
            _top10Star5.image = [UIImage imageNamed:@"star_yellow.png"];
        }
        else if(_top10Int >= 85) {
            _top10Star1.image = [UIImage imageNamed:@"star_yellow.png"];
            _top10Star2.image = [UIImage imageNamed:@"star_yellow.png"];
            _top10Star3.image = [UIImage imageNamed:@"star_yellow.png"];
            _top10Star4.image = [UIImage imageNamed:@"star_yellow.png"];
            _top10Star5.image = [UIImage imageNamed:@"star_yellow-gray.png"];
        }
        else if(_top10Int >= 75) {
            _top10Star1.image = [UIImage imageNamed:@"star_yellow.png"];
            _top10Star2.image = [UIImage imageNamed:@"star_yellow.png"];
            _top10Star3.image = [UIImage imageNamed:@"star_yellow.png"];
            _top10Star4.image = [UIImage imageNamed:@"star_yellow.png"];
            _top10Star5.image = [UIImage imageNamed:@"star_gray.png"];    }
        else if(_top10Int >= 65) {
            _top10Star1.image = [UIImage imageNamed:@"star_yellow.png"];
            _top10Star2.image = [UIImage imageNamed:@"star_yellow.png"];
            _top10Star3.image = [UIImage imageNamed:@"star_yellow.png"];
            _top10Star4.image = [UIImage imageNamed:@"star_yellow-gray.png"];
            _top10Star5.image = [UIImage imageNamed:@"star_gray.png"];    }
        else if(_top10Int >= 55) {
            _top10Star1.image = [UIImage imageNamed:@"star_yellow.png"];
            _top10Star2.image = [UIImage imageNamed:@"star_yellow.png"];
            _top10Star3.image = [UIImage imageNamed:@"star_yellow.png"];
            _top10Star4.image = [UIImage imageNamed:@"star_gray.png"];
            _top10Star5.image = [UIImage imageNamed:@"star_gray.png"];    }
        else if(_top10Int >= 45) {
            _top10Star1.image = [UIImage imageNamed:@"star_yellow.png"];
            _top10Star2.image = [UIImage imageNamed:@"star_yellow.png"];
            _top10Star3.image = [UIImage imageNamed:@"star_yellow-gray.png"];
            _top10Star4.image = [UIImage imageNamed:@"star_gray.png"];
            _top10Star5.image = [UIImage imageNamed:@"star_gray.png"];    }
        else if(_top10Int >= 35) {
            _top10Star1.image = [UIImage imageNamed:@"star_yellow.png"];
            _top10Star2.image = [UIImage imageNamed:@"star_yellow.png"];
            _top10Star3.image = [UIImage imageNamed:@"star_gray.png"];
            _top10Star4.image = [UIImage imageNamed:@"star_gray.png"];
            _top10Star5.image = [UIImage imageNamed:@"star_gray.png"];    }
        else if(_top10Int >= 25) {
            _top10Star1.image = [UIImage imageNamed:@"star_yellow.png"];
            _top10Star2.image = [UIImage imageNamed:@"star_yellow-gray.png"];
            _top10Star3.image = [UIImage imageNamed:@"star_gray.png"];
            _top10Star4.image = [UIImage imageNamed:@"star_gray.png"];
            _top10Star5.image = [UIImage imageNamed:@"star_gray.png"];    }
        else if(_top10Int >= 15) {
            _top10Star1.image = [UIImage imageNamed:@"star_yellow.png"];
            _top10Star2.image = [UIImage imageNamed:@"star_gray.png"];
            _top10Star3.image = [UIImage imageNamed:@"star_gray.png"];
            _top10Star4.image = [UIImage imageNamed:@"star_gray.png"];
            _top10Star5.image = [UIImage imageNamed:@"star_gray.png"];    }
        else if(_top10Int >= 5) {
            _top10Star1.image = [UIImage imageNamed:@"star_yellow-gray.png"];
            _top10Star2.image = [UIImage imageNamed:@"star_gray.png"];
            _top10Star3.image = [UIImage imageNamed:@"star_gray.png"];
            _top10Star4.image = [UIImage imageNamed:@"star_gray.png"];
            _top10Star5.image = [UIImage imageNamed:@"star_gray.png"];    }
        else {
            _top10Star1.image = [UIImage imageNamed:@"star_gray.png"];
            _top10Star2.image = [UIImage imageNamed:@"star_gray.png"];
            _top10Star3.image = [UIImage imageNamed:@"star_gray.png"];
            _top10Star4.image = [UIImage imageNamed:@"star_gray.png"];
            _top10Star5.image = [UIImage imageNamed:@"star_gray.png"];    }
    }
}

-(void)setting{
    InfoTableViewController *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"InfoTable"];
    
    [self.navigationController pushViewController:tvc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
