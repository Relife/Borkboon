//
//  UserplansViewController2.m
//  Borkboon
//
//  Created by Relife on 9/6/56 BE.
//  Copyright (c) 2556 Relife. All rights reserved.
//

#import "UserplansViewController2.h"
#import "UserplantDetail.h"
#import "SBJson.h"

@interface UserplansViewController2 ()
{
    NSMutableArray *allObject;
    NSMutableArray *displayObject;
    
    // A dictionary object
    NSDictionary *dict;
    
    // Define keys
    NSString *prayscriptId;
    NSString *titleName;
    NSString *rowId;
    NSString *mainstorageId;
    NSString *uId;
    
    NSDictionary *itemDetails;
}

@end

@implementation UserplansViewController2


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
    
    //self.viewTest = self;
    self.title = _getTitle;
    
    NSLog(@"%@",_getValue);

    NSString *post =[[NSString alloc] initWithFormat:@"mainstorage_id=%@&method=select",_getId];
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
        
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *response = nil;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // Define keys
    prayscriptId = @"id";
    titleName = @"title";
    rowId = @"rowid";
    mainstorageId = @"mainstorageid";
    
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
            NSString *pray_script_id = [get objectForKey:@"pray_script_id"];
            NSLog(@"%@",pray_script_id);
            NSString *mainstorage_id = [get objectForKey:@"mainstorage_id"];
            NSLog(@"%@",mainstorage_id);
            _getMainId = mainstorage_id;
            
            dict = [NSDictionary dictionaryWithObjectsAndKeys:
                    row_id, rowId,
                    title, titleName,
                    pray_script_id, prayscriptId,
                    mainstorage_id, mainstorageId,
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
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addbt:(id)sender {
   // [self presentModalViewController:self.viewTest animated:nil];
    _viewTest = [[ViewControllerTest alloc] initWithNibName:@"ViewControllerTest" bundle:nil];
    [self.view addSubview:_viewTest.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sentValue:)
                                                 name:@"Touchedtable"
                                               object:nil];
    
//    addPrayViewController *viewController=[[addPrayViewController alloc]initWithNibName:@"addPray" bundle:nil];
//    
//    [self presentViewController:viewController animated:YES completion:nil];

//    [[NSBundle mainBundle] loadNibNamed:@"addPray" owner:self options:nil];
//    [self.view addSubview:addPrayView];
//    addPrayViewController *addprayViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"addPrayView"];
//    [self.view addSubview:addprayViewController.view];
}

- (void)sentValue:(NSNotification *)notification {
    NSLog(@"%@", notification.object);
    NSLog(@"%@", [notification.object objectForKey:@"idPray"]);
    NSLog(@"%@", [notification.object objectForKey:@"Name"]);
    NSString *idPray = [notification.object objectForKey:@"idPray"];
    
    //check    
    NSString *post =[[NSString alloc] initWithFormat:@"pray_script_id=%@&method=check&mainstorage_id=%@",idPray,_getId];
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
    
    //show alert
    if ([_st isEqual: @"no"]){
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"ไม่สามารถเพิ่มเข้ารายการได้"
                                                          message:@"มีบทสวดนี้อยู่ในรายการนี้อยู่แล้ว"
                                                         delegate:nil
                                                cancelButtonTitle:@"ตกลง"
                                                otherButtonTitles:nil];
        [message show];
    }
    //Add pray
    else if([_st isEqual: @"yes"]){
        NSString *post =[[NSString alloc] initWithFormat:@"pray_script_id=%@&method=insert&mainstorage_id=%@",idPray,_getId];
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
        
        NSError *error = [[NSError alloc] init];
        NSHTTPURLResponse *response = nil;
        NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        // Define keys
        prayscriptId = @"id";
        titleName = @"title";
        rowId = @"rowid";
        mainstorageId = @"mainstorageid";
        
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
                NSString *pray_script_id = [get objectForKey:@"pray_script_id"];
                NSLog(@"%@",pray_script_id);
                NSString *mainstorage_id = [get objectForKey:@"mainstorage_id"];
                NSLog(@"%@",mainstorage_id);
                _getMainId = mainstorage_id;
                
                dict = [NSDictionary dictionaryWithObjectsAndKeys:
                        row_id, rowId,
                        title, titleName,
                        pray_script_id, prayscriptId,
                        mainstorage_id, mainstorageId,
                        nil];
                [allObject addObject:dict];
            }
            displayObject =[[NSMutableArray alloc] initWithArray:allObject];
            [self.myTab reloadData];
        }
    }
}

- (IBAction)editbt:(id)sender {
    [self.myTab setEditing:!self.myTab.editing animated:YES];
    if (self.myTab.editing)
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
    else
        [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
}
//
//- (IBAction)closeSubview:(id)sender {
//    [addPrayView setHidden:YES];
//}

//selectRow
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserplantDetail *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"UserplantDetail"];
    tvc.hidesBottomBarWhenPushed = YES;
    
    NSDictionary *tmpDict = [displayObject objectAtIndex:indexPath.row];
    tvc.titleId = [tmpDict objectForKey:prayscriptId];
    tvc.titleName = [tmpDict objectForKey:titleName];
    tvc.getPlan = _getTitle;
    tvc.getuId = _getUser;
    [self.navigationController pushViewController:tvc animated:YES];
//    [self presentViewController:tvc animated:YES completion:nil];
}

//deleteRow
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
    //                     withRowAnimation:UITableViewRowAnimationFade];
    
    NSDictionary *tmpDict = [displayObject objectAtIndex:indexPath.row];
    NSString *ID = [tmpDict objectForKey:rowId];
    NSLog(@"id:%@",ID);
    NSString *Mainstorage = [tmpDict objectForKey:mainstorageId];
    NSLog(@"mainstorage:%@",Mainstorage);
    
    NSString *post =[[NSString alloc] initWithFormat:@"id=%@&method=delete&mainstorage_id=%@",ID,Mainstorage];
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
    prayscriptId = @"id";
    titleName = @"title";
    rowId = @"rowid";
    mainstorageId = @"mainstorageid";
    
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
            NSString *pray_script_id = [get objectForKey:@"pray_script_id"];
            NSLog(@"%@",pray_script_id);
            NSString *mainstorage_id = [get objectForKey:@"mainstorage_id"];
            NSLog(@"%@",mainstorage_id);
            
            
            dict = [NSDictionary dictionaryWithObjectsAndKeys:
                    row_id, rowId,
                    title, titleName,
                    pray_script_id, prayscriptId,
                    mainstorage_id, mainstorageId,
                    nil];
            [allObject addObject:dict];
        }
        displayObject =[[NSMutableArray alloc] initWithArray:allObject];
        [self.myTab reloadData];
    }
}

@end
