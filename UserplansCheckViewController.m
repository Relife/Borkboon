//
//  UserplansCheckViewController.m
//  Borkboon
//
//  Created by Relife on 9/19/56 BE.
//  Copyright (c) 2556 Relife. All rights reserved.
//

#import "UserplansCheckViewController.h"
#import "Prayer-basicDetailViewController1.h"
#import "UserplansViewController2.h"
#import "Sign-inViewController.h"
#import "SBJson.h"
#import "AppDelegate.h"

@interface UserplansCheckViewController ()
{
    NSMutableArray *allObject;
    NSMutableArray *displayObject;
    
    // A dictionary object
    NSDictionary *dict;
    
    // Define keys
    NSString *uId;
    NSString *titleName;
    int selectedIndex;
}

@end

@implementation UserplansCheckViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated{
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (app.loginState == LSTATE_LOGOUT || app.loginState == LSTATE_NOT_LOGIN) {
        
        // Create login view
        UIViewController* view = [self.storyboard instantiateViewControllerWithIdentifier:@"loginNavigationView"];
        [self presentViewController:view animated:YES completion:nil];
        
    }
    else if(app.loginState == LSTATE_LOGIN_EMAIL){
        self.userId = app.userID;
        [self LoadData];
    }
    else if(app.loginState == LSTATE_LOGIN_FACEBOOK){
        [self LoadData];
    }
}

- (void) LoadData{
    NSString *post =[[NSString alloc] initWithFormat:@"user_id=%@&method=select&id=&title=",_userId];
    NSLog(@"PostData: %@",post);
    
    NSURL *url=[NSURL URLWithString:@"http://codegears.co.th/borkboon/getMainstorage.php"];
    
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
    
    // Define keys
    uId = @"id";
    titleName = @"title";
    
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
        
        for (NSDictionary *get in jsonData)
        {
            NSString *row_id = [get objectForKey:@"row_id"];
            NSLog(@"%@",row_id);
            NSString *title = [get objectForKey:@"title"];
            NSLog(@"%@",title);
            
            dict = [NSDictionary dictionaryWithObjectsAndKeys:
                    row_id, uId,
                    title, titleName,
                    nil];
            [allObject addObject:dict];
        }
        displayObject =[[NSMutableArray alloc] initWithArray:allObject];
        [self.myTab reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    NSString *post =[[NSString alloc] initWithFormat:@"user_id=18&method=select&id=&title="];
//    NSLog(@"PostData: %@",post);
//    
//    NSURL *url=[NSURL URLWithString:@"http://codegears.co.th/borkboon/getMainstorage.php"];
//    
//    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//    
//    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
//    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:url];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    [request setHTTPBody:postData];
//    
//    //            [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
//    
//    NSError *error = [[NSError alloc] init];
//    NSHTTPURLResponse *response = nil;
//    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    
//    // Define keys
//    uId = @"id";
//    titleName = @"title";
//    
//    // Create array to hold dictionaries
//    allObject = [[NSMutableArray alloc] init];
//    
//    NSLog(@"Response code: %d", [response statusCode]);
//    if ([response statusCode] >=200 && [response statusCode] <300)
//    {
//        NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
//        //        NSLog(@"Response ==> %@", responseData);
//        
//        SBJsonParser *jsonParser = [SBJsonParser new];
//        NSDictionary *jsonData = (NSDictionary *) [jsonParser objectWithString:responseData error:nil];
//        NSLog(@"%@",jsonData);
//        
//        for (NSDictionary *get in jsonData)
//        {
//            NSString *row_id = [get objectForKey:@"row_id"];
//            NSLog(@"%@",row_id);
//            NSString *title = [get objectForKey:@"title"];
//            NSLog(@"%@",title);
//            
//            dict = [NSDictionary dictionaryWithObjectsAndKeys:
//                    row_id, uId,
//                    title, titleName,
//                    nil];
//            [allObject addObject:dict];
//        }
//        displayObject =[[NSMutableArray alloc] initWithArray:allObject];
//        [self.myTab reloadData];
//    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return displayObject.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // Use the default cell style.
        cell = [[UITableViewCell alloc] initWithStyle : UITableViewCellStyleSubtitle
                                      reuseIdentifier : CellIdentifier];
    }
    
    NSDictionary *tmpDict = [displayObject objectAtIndex:indexPath.row];
    
    NSString *cellValue = [tmpDict objectForKey:titleName];
    cell.textLabel.text = cellValue;
    
//    if(indexPath.row == selectedIndex)
//    {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    }
//    else
//    {
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }
    return cell;
}

//deleteRow
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
    //                     withRowAnimation:UITableViewRowAnimationFade];
    
    NSDictionary *tmpDict = [displayObject objectAtIndex:indexPath.row];
    NSString *ID = [tmpDict objectForKey:uId];
    NSLog(@"id:%@",ID);
    NSString *name = [tmpDict objectForKey:titleName];
    NSLog(@"name:%@",name);
    
    NSString *post =[[NSString alloc] initWithFormat:@"user_id=18&method=delete&id=%@&title=",ID];
    NSLog(@"PostData: %@",post);
    
    NSURL *url=[NSURL URLWithString:@"http://codegears.co.th/borkboon/getMainstorage.php"];
    
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
    
    // Define keys
    uId = @"id";
    titleName = @"title";
    
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
        
        for (NSDictionary *get in jsonData)
        {
            NSString *row_id = [get objectForKey:@"row_id"];
            NSLog(@"%@",row_id);
            NSString *title = [get objectForKey:@"title"];
            NSLog(@"%@",title);
            
            dict = [NSDictionary dictionaryWithObjectsAndKeys:
                    row_id, uId,
                    title, titleName,
                    nil];
            [allObject addObject:dict];
        }
        displayObject =[[NSMutableArray alloc] initWithArray:allObject];
        [self.myTab reloadData];
    }
}

//add cell
- (IBAction)addbt:(id)sender {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"ชื่อแผนการสวด"
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Save", nil];
    [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [message show];
}

//edit button
- (IBAction)editbt:(id)sender {
    [self.myTab setEditing:!self.myTab.editing animated:YES];
    
    
    //The if ... else part is optional.  You might need to make some change to fit your's.
    if (self.myTab.editing)
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
    else
        [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
}

-(void)alertView:(UIAlertView *)alertView
didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 1) {
        NSLog(@"Cancel");
        return;
    }
    UITextField* textfield = [alertView textFieldAtIndex:0];
    NSLog(@"Save. text: %@", textfield.text);
    
    NSString *post =[[NSString alloc] initWithFormat:@"user_id=18&method=insert&id=&title=%@",textfield.text];
    NSLog(@"PostData: %@",post);
    
    NSURL *url=[NSURL URLWithString:@"http://codegears.co.th/borkboon/getMainstorage.php"];
    
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
    
    // Define keys
    uId = @"id";
    titleName = @"title";
    
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
        
        for (NSDictionary *get in jsonData)
        {
            NSString *row_id = [get objectForKey:@"row_id"];
            NSLog(@"%@",row_id);
            NSString *title = [get objectForKey:@"title"];
            NSLog(@"%@",title);
            
            dict = [NSDictionary dictionaryWithObjectsAndKeys:
                    row_id, uId,
                    title, titleName,
                    nil];
            [allObject addObject:dict];
        }
        displayObject =[[NSMutableArray alloc] initWithArray:allObject];
        [self.myTab reloadData];
    }
}

//selectRow
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //check
    NSDictionary *tmpDict = [displayObject objectAtIndex:indexPath.row];
    _mainstorageId = [tmpDict objectForKey:uId];

    NSString *post =[[NSString alloc] initWithFormat:@"pray_script_id=%@&method=check&mainstorage_id=%@",_prayScriptId,_mainstorageId];
    NSLog(@"PostData: %@",post);
    
    NSURL *url=[NSURL URLWithString:@"http://codegears.co.th/borkboon/getSubstorage.php"];
    
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
    
    // Define keys
    uId = @"id";
    titleName = @"title";
    
    // Create array to hold dictionaries
    allObject = [[NSMutableArray alloc] init];
    
    NSLog(@"Response code: %d", [response statusCode]);
    if ([response statusCode] >=200 && [response statusCode] <300)
    {
        NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
            NSLog(@"Response ==> %@", responseData);
        
        SBJsonParser *jsonParser = [SBJsonParser new];
        NSDictionary *jsonData = (NSDictionary *) [jsonParser objectWithString:responseData error:nil];
        NSLog(@"%@",jsonData);
        _st = [jsonData objectForKey:@"status"];
        NSLog(@"status %@",_st);
    }
    
    if ([_st isEqual: @"yes"]) {
        NSDictionary *tmpDict = [displayObject objectAtIndex:indexPath.row];
        _mainstorageId = [tmpDict objectForKey:uId];
        
        NSString *post =[[NSString alloc] initWithFormat:@"pray_script_id=%@&user_id=18&method=insert_script&mainstorage_id=%@",_prayScriptId,_mainstorageId];
        NSLog(@"PostData: %@",post);
        
        NSURL *url=[NSURL URLWithString:@"http://codegears.co.th/borkboon/scriptToMainStorage.php"];
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        //[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
        
        NSError *error = [[NSError alloc] init];
        NSHTTPURLResponse *response = nil;
        NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        // Define keys
        uId = @"id";
        titleName = @"title";
        
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
            
            for (NSDictionary *get in jsonData)
            {
                NSString *row_id = [get objectForKey:@"row_id"];
                NSLog(@"%@",row_id);
                NSString *title = [get objectForKey:@"title"];
                NSLog(@"%@",title);
                
                dict = [NSDictionary dictionaryWithObjectsAndKeys:
                        row_id, uId,
                        title, titleName,
                        nil];
                [allObject addObject:dict];
            }
            displayObject =[[NSMutableArray alloc] initWithArray:allObject];
            [self.myTab reloadData];
        }
        [tableView reloadData];
    }
    else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"ไม่สามารถเพิ่มเข้ารายการได้"
                                                          message:@"มีบทสวดนี้อยู่ในรายการนี้อยู่แล้ว"
                                                         delegate:nil
                                                cancelButtonTitle:@"ตกลง"
                                                otherButtonTitles:nil];
        [message show];
    }
    [self.myTab reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
