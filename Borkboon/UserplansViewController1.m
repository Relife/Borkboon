//
//  UserplansViewController1.m
//  Borkboon
//
//  Created by Relife on 9/6/56 BE.
//  Copyright (c) 2556 Relife. All rights reserved.
//

#import "UserplansViewController1.h"
#import "UserplansViewController2.h"
#import "Sign-inViewController.h"
#import "SBJson.h"

#import <QuartzCore/QuartzCore.h>

@interface UserplansViewController1 ()
{
    NSMutableArray *allObject;
    NSMutableArray *displayObject;
    
    // A dictionary object
    NSDictionary *dict;
    
    // Define keys
    NSString *uId;
    NSString *titleName;    
}

@end

@implementation UserplansViewController1


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
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    NSLog(@"ID%@",_userId);
    
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
    
    if (tableView.isEditing) {
        UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        [lbl setText:@"edit"];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        [lbl setBackgroundColor:[UIColor orangeColor]];
        [lbl setTextColor:[UIColor whiteColor]];
        //lbl.layer.borderWidth = 1;
        [lbl.layer setCornerRadius:10];
        
        [cell setEditingAccessoryView:lbl];
    }
    
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
    
    NSString *post =[[NSString alloc] initWithFormat:@"user_id=%@&method=delete&id=%@&title=",_userId,ID];
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
    if (tableView.isEditing) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"เปลี่ยนชื่อ" message:@"" delegate:self cancelButtonTitle:@"CANCEL" otherButtonTitles:@"OK", nil];
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [alert show];
        alert = nil;
    }
    else{
        UserplansViewController2 *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"UserplansView2"];
        
        NSDictionary *tmpDict = [displayObject objectAtIndex:indexPath.row];
        tvc.getId = [tmpDict objectForKey:uId];
        tvc.getTitle = [tmpDict objectForKey:titleName];
        tvc.getUser = _userId;
        [self.navigationController pushViewController:tvc animated:YES];
    }
    
//    [self presentViewController:tvc animated:YES completion:nil];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    
    [self.myTab setAllowsSelectionDuringEditing:YES];
    [self.myTab reloadData];
    
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
    
    if (self.myTab.isEditing) {
        // Change name here
        UITextField* textfield = [alertView textFieldAtIndex:0];
        NSLog(@"change plan name. text: %@", textfield.text);
        
        
        
    }
    else{
        // Add new plan here
        UITextField* textfield = [alertView textFieldAtIndex:0];
        NSLog(@"Save. text: %@", textfield.text);
        
        NSString *post =[[NSString alloc] initWithFormat:@"user_id=%@&method=insert&id=&title=%@",_userId,textfield.text];
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
}

@end
