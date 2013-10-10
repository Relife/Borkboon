//
//  PlansprayerViewController.m
//  Borkboon
//
//  Created by Relife on 8/30/56 BE.
//  Copyright (c) 2556 Relife. All rights reserved.
//

#import "PlansprayerViewController.h"
#import "AppDelegate.h"

@interface PlansprayerViewController ()
- (void)updateView;


@end

@implementation PlansprayerViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
}

- (void) viewWillAppear:(BOOL)animated{
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (app.loginState == LSTATE_LOGOUT || app.loginState == LSTATE_NOT_LOGIN) {
        
        
        [self updateView];
        
        
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
        if (!appDelegate.session.isOpen) {
            // create a fresh session object
            appDelegate.session = [[FBSession alloc] init];
            
            // if we don't have a cached token, a call to open here would cause UX for login to
            // occur; we don't want that to happen unless the user clicks the login button, and so
            // we check here to make sure we have a token before calling open
            if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
                // even though we had a cached token, we need to login to make the session usable
                [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                                 FBSessionState status,
                                                                 NSError *error) {
                    // we recurse here, in order to update buttons and labels
                    
                    
                    [self updateView];
                    
                    
                }];
            }
        }
    }
    else if(app.loginState == LSTATE_LOGIN_EMAIL){
        
    }
    else if(app.loginState == LSTATE_LOGIN_FACEBOOK){
        [self updateView];
    }
}

- (void)updateView {
    // get the app delegate, so that we can reference the session property
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (appDelegate.session.isOpen) {
        // valid account UI is shown whenever the session is open
        
        [self.btlogin setTitle:@"  Log out" forState:UIControlStateNormal];
        [FBSession setActiveSession:appDelegate.session];
        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            
            NSString* uid = [[result objectForKey:@"id"] copy];
            [appDelegate setUserID:uid];
            [appDelegate setLoginState:LSTATE_LOGIN_FACEBOOK];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }];
        
        
    } else {
        // login-needed account UI is shown whenever the session is closed
        [self.btlogin setTitle:@"  SIGN IN WITH FACEBOOK" forState:UIControlStateNormal];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)login:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    // this button's job is to flip-flop the session from open to closed
    if (appDelegate.session.isOpen) {
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
        [appDelegate.session closeAndClearTokenInformation];
        
    } else {
        if (appDelegate.session.state != FBSessionStateCreated) {
            // Create a new, logged out session.
            appDelegate.session = [[FBSession alloc] init];
        }
        
        // if the session isn't open, let's open it now and present the login UX to the user
        [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error) {
            // and here we make sure to update our UX according to the new session state
            [self updateView];
        }];
    }
}

- (void)viewDidUnload
{
    self.btlogin = nil;
    
    [super viewDidUnload];
}
- (IBAction)exitBt:(id)sender {
    [self dismissViewControllerAnimated:YES completion: ^{
        
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EXIT_LOGIN" object:nil];
    
}
@end
