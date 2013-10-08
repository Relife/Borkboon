//
//  Info2ViewController.m
//  Borkboon
//
//  Created by Relife on 9/10/56 BE.
//  Copyright (c) 2556 Relife. All rights reserved.
//

#import "Info2ViewController.h"

@interface Info2ViewController ()

@end

@implementation Info2ViewController

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
    self.title = @"เกี่ยวกับผู้พัฒนา";
    [_txtView setText:@"คุณพฤกษ์ มณีเลิศประเสริฐสุข\nคุณศุภชัย มณีเลิศประเสริฐสุข\nคุณธีระ มณีเลิศประเสริฐสุข\nคุณสุขาวดี มณีเลิศประเสริฐสุข\nคุณปรียา มณีเลิศประเสริฐสุข\nคุณกาญจน์ มณีเลิศประเสริฐสุข\nคุณปรีชา มณีเลิศประเสริฐสุข\nคุณรุ่งฟ้า มณีเลิศประเสริฐสุข"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
