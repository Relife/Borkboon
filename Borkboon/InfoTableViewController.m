//
//  InfoTableViewController.m
//  Borkboon
//
//  Created by Relife on 9/10/56 BE.
//  Copyright (c) 2556 Relife. All rights reserved.
//

#import "InfoTableViewController.h"
#import "Info1ViewController.h"
#import "Info2ViewController.h"
#import <Social/Social.h>
#import <FacebookSDK/FacebookSDK.h>

@interface InfoTableViewController ()

@end

@implementation InfoTableViewController

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
    self.title = @"ข้อมูลเพิ่มเติม";
    _listData = @[@"รายชื่อผู้สนับสนุน",@"เกี่ยวกับผู้พัฒนา",@"บอกต่อเพื่อน",@"Log out"];}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = _listData[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        Info1ViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"Info1"];
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
    }
    else if (indexPath.row == 1) { 
        Info2ViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"Info2"];
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
    }
    else if (indexPath.row == 2){
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"บอกต่อเพื่อนของคุณเกี่ยวกับ\nBorkboon Praybook App ผ่านทาง"
                                      delegate:self
                                      cancelButtonTitle:@"Cancel"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"Mail", @"Facebook",nil];        
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        [actionSheet setTag:1];
        [actionSheet showInView:self.view];
    }
    else if (indexPath.row == 3){
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                     initWithTitle:@"คุณต้องการออกจากระบบการใช้งาน \nBorkboon Praybook Appหรือ?"
                                     delegate:self
                                     cancelButtonTitle:@"Cancel"
                                     destructiveButtonTitle:nil
                                     otherButtonTitles:@"Log out",nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        [actionSheet setTag:2];
        [actionSheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 1){
    switch (buttonIndex) {
        case 0:
            if ([MFMailComposeViewController canSendMail])
            {
                MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
                mailer.mailComposeDelegate = self;
                [mailer setSubject:@"Borkboon"];
                NSArray *toRecipients = [NSArray arrayWithObjects:@"relife.atomos1@gmail.com", nil];
                [mailer setToRecipients:toRecipients];
                NSString *emailBody = @"Message here";
                [mailer setMessageBody:emailBody isHTML:NO];
                [self presentModalViewController:mailer animated:YES];
            }
            else
            {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                                message:@"Your device doesn't support the composer sheet"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
                [alert show];
            }
            break;
        case 1:
//            if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
//                
//                SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
//                
//                [controller setInitialText:@"Invite borkboon"];
//                [controller addURL:[NSURL URLWithString:@"https://www.facebook.com/borkboon"]];
//                
//                [self presentViewController:controller animated:YES completion:Nil];
//                
//            }
            {
            NSMutableDictionary* params =   [NSMutableDictionary dictionaryWithObjectsAndKeys:nil];
            
            [FBWebDialogs presentRequestsDialogModallyWithSession:nil
                                                          message:[NSString stringWithFormat:@"Invite Borkboon Praybook App..."]
                                                            title:nil
                                                       parameters:params
                                                          handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                              
                                                          }];
            }
            break;
        }
    }
    else if (actionSheet.tag == 2){
        switch (buttonIndex) {
            case 0:
                break;
            case 1:
                break;
        }
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    // Remove the mail view
    [self dismissModalViewControllerAnimated:YES];
}

@end
