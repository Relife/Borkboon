//
//  PrayerViewController.m
//  Borkboon
//
//  Created by Relife on 8/19/56 BE.
//  Copyright (c) 2556 Relife. All rights reserved.
//

#import "PrayerViewController.h"
#import "Prayer-basicViewController1.h"

@interface PrayerViewController ()
@property (nonatomic, strong) NSMutableData *responseData1;

@end

@implementation PrayerViewController
@synthesize responseData1 = _responseData1;


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
    self.responseData1 = [NSMutableData data];
    
    NSURL *aUrl = [NSURL URLWithString:@"http://codegears.co.th/borkboon/getPrayGroup.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl];
    
    
    [request setHTTPMethod:@"POST"];
    NSString *postString = @"";
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request  delegate:self];
    if (connection) {
        _responseData1 = [NSMutableData data] ;
    } else {
        UIAlertView *connectFailMessage = [[UIAlertView alloc] initWithTitle:@"NSURLConnection " message:@"Failed in viewDidLoad"  delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [connectFailMessage show];
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    [self.responseData1 setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData1 appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    //    NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data",[self.responseData1 length]);
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData1 options:NSJSONReadingMutableLeaves error:&myError];

    // show all values
//        for(id key in res) {
//    
//           id value = [res objectForKey:key];
//    
//            NSString *keyAsString = (NSString *)key;
//            NSString *valueAsString = (NSString *)value;
//    
//            NSLog(@"key: %@", keyAsString);
//            NSLog(@"value: %@", valueAsString);
//        }
    
    // extract specific value...
    _results1 = [res objectForKey:@"pray_group_list"];

    for (NSDictionary *result in _results1) {
        NSString *idpray_group = [[result objectForKey:@"pray_group"] objectForKey:@"id"];
        NSString *name = [[result objectForKey:@"pray_group"] objectForKey:@"name"];
        NSString *image = [[result objectForKey:@"pray_group"] objectForKey:@"image"];
        NSLog(@"id: %@", idpray_group);
        NSLog(@"namepray_group: %@", name);
        NSLog(@"url %@", image);
        }
    

        for (NSDictionary *result2 in _results1) {
            _results1_1 = [[result2 objectForKey:@"pray_group"] objectForKey:@"pray_script"];

            
            for (NSDictionary *result3 in _results1_1) {
                NSString *idpray = [result3 objectForKey:@"id"];
                NSLog(@"idpray: %@", idpray);
                NSString *name = [result3 objectForKey:@"name"];
                NSLog(@"name: %@", name);
            }
        }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menu1:(id)sender {
    Prayer_basicViewController1 *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"Prayer_basicView"];
    tvc.menu = @"11";
    tvc.titletable = @"บทสวดพื้นฐาน";
    [self.navigationController pushViewController:tvc animated:YES];
    
}

- (IBAction)menu2:(id)sender {
    Prayer_basicViewController1 *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"Prayer_basicView"];
    tvc.menu = @"7";
    tvc.titletable = @"บทสวดพิเศษ";
    [self.navigationController pushViewController:tvc animated:YES];
}

- (IBAction)menu3:(id)sender {
    Prayer_basicViewController1 *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"Prayer_basicView"];
    tvc.menu = @"8";
    tvc.titletable = @"บทแผ่เมตตา";
    [self.navigationController pushViewController:tvc animated:YES];
}

- (IBAction)menu4:(id)sender {
    Prayer_basicViewController1 *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"Prayer_basicView"];
    tvc.menu = @"9";
    tvc.titletable = @"บทสวดทำวัตรเช้า";
    [self.navigationController pushViewController:tvc animated:YES];
}

- (IBAction)menu5:(id)sender {
    Prayer_basicViewController1 *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"Prayer_basicView"];
    tvc.menu = @"13";
    tvc.titletable = @"ชุดบทสวดทั่วไป";
    [self.navigationController pushViewController:tvc animated:YES];
}

- (IBAction)menu6:(id)sender {
    Prayer_basicViewController1 *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"Prayer_basicView"];
    tvc.menu = @"15";
    tvc.titletable = @"ชุดบทสวดเจาะจง";
    [self.navigationController pushViewController:tvc animated:YES];
}
@end
