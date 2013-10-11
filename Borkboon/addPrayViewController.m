//
//  addPrayViewController.m
//  Borkboon
//
//  Created by Relife on 10/6/56 BE.
//  Copyright (c) 2556 Relife. All rights reserved.
//

#import "addPrayViewController.h"
#import "SBJson.h"
#import "UserplansViewController2.h"

@interface addPrayViewController ()
{
    NSMutableArray *allObject;
    NSMutableArray *displayObject;
    
    // A dictionary object
    NSDictionary *dict;
    
    // Define keys
    NSString *prayId;
    NSString *titleName;
    NSString *Image;
    NSString *isNew;
    
    NSArray *repeats;
}

@end

@implementation addPrayViewController

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
    NSLog(@"aaa");
    repeats = [NSArray arrayWithObjects:@"ไม่เตือน",@"ทุกวัน",@"ทุกสัปดาห์",@"ทุก 2 สัปดาห์",@"ทุกเดือน",@"ทุกปี", nil];
//    
//    NSString *post =[[NSString alloc] initWithFormat:@"page=1"];
//    NSLog(@"PostData: %@",post);
//    
//    NSURL *url=[NSURL URLWithString:@"http://codegears.co.th/borkboon/getAllPrayScript.php"];
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
//    NSError *error = [[NSError alloc] init];
//    NSHTTPURLResponse *response = nil;
//    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    
//    // Define keys
//    prayId = @"id";
//    titleName = @"name";
//    Image = @"image";
//    isNew = @"is_new";
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
//            NSString *prayid = [get objectForKey:@"id"];
//            NSLog(@"%@",prayid);
//            NSString *name = [get objectForKey:@"name"];
//            NSLog(@"%@",name);
//            NSString *image = [get objectForKey:@"image"];
//            NSLog(@"%@",image);
//            NSString *is_new = [get objectForKey:@"is_new"];
//            NSLog(@"%@",is_new);
//            
//            
//            dict = [NSDictionary dictionaryWithObjectsAndKeys:
//                    prayid, prayId,
//                    name, titleName,
//                    image, Image,
//                    is_new, isNew,
//                    nil];
//            [allObject addObject:dict];
//        }
//        displayObject =[[NSMutableArray alloc] initWithArray:allObject];
//        [self.myTab reloadData];
//    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [repeats count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cellpray";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // Use the default cell style.
        cell = [[UITableViewCell alloc] initWithStyle : UITableViewCellStyleSubtitle
                                      reuseIdentifier : CellIdentifier];
    }
    
//    NSDictionary *tmpDict = [displayObject objectAtIndex:indexPath.row];
//    
//    NSString *cellValue = [tmpDict objectForKey:titleName];
//    cell.textLabel.text = cellValue;
    
    cell.textLabel.text = [repeats objectAtIndex:indexPath.row];

    return cell;
}

//selectRow
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *value = [repeats objectAtIndex:indexPath.row];
//    NSLog(@"%@",value);
//    UserplansViewController2 *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"UserplansView2"];
//    tvc.getValue = value;
//    [self presentViewController:tvc animated:YES completion:nil];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
