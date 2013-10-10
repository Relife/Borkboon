//
//  Sign-inViewController.m
//  Borkboon
//
//  Created by Relife on 9/4/56 BE.
//  Copyright (c) 2556 Relife. All rights reserved.
//

#import "Sign-inViewController.h"
#import "SBJson.h"
#import "UserplansViewController1.h"
#import "AppDelegate.h"

@interface Sign_inViewController ()

@end

@implementation Sign_inViewController

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
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) alertStatus:(NSString *)msg :(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    
    [alertView show];
}

- (IBAction)sign_in:(id)sender {
    @try {
        
        if([[_email text] isEqualToString:@""] || [[_password text] isEqualToString:@""] ) {
            [self alertStatus:@"Please enter both Username and Password" :@"Login Failed!"];
        } else {
            NSString *post =[[NSString alloc] initWithFormat:@"email=%@&password=%@",[_email text],[_password text]];
            NSLog(@"PostData: %@",post);
            
            NSURL *url=[NSURL URLWithString:@"http://codegears.co.th/borkboon/signin.php"];
            
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
                NSString *status = [jsonData objectForKey:@"status"];
                NSLog(@"%@",status);
                NSString *uId = [[jsonData objectForKey:@"userinfo"] objectForKey:@"uid"];
                NSLog(@"uId=%@",uId);
        

                if([status isEqual:@"complete"])
                {
                    NSLog(@"Login SUCCESS");
                    [self alertStatus:@"Logged in Successfully." :@"Login Success!"];
                    //
                    //UserplansViewController1 *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"UserplansView1"];
                    
                    //tvc.userId = uId;
                    
                    //[self.navigationController pushViewController:tvc animated:YES];
                    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
                    [app setUserID:uId];
                    [app setLoginState:LSTATE_LOGIN_EMAIL];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
//                    [self presentViewController:tvc animated:YES completion:nil];
                } else {
                    
                    NSString *error_msg = (NSString *) [jsonData objectForKey:@"error_message"];
                    [self alertStatus:error_msg :@"Login Failed!"];
                }
                
            } else {
                if (error) NSLog(@"Error: %@", error);
                [self alertStatus:@"Connection Failed" :@"Login Failed!"];
            }
        }
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Login Failed." :@"Login Failed!"];
    }
    
}

- (IBAction)backgroundClick:(id)sender {
    [_password resignFirstResponder];
    [_email resignFirstResponder];
}

- (IBAction)btBackAction:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
}
@end
