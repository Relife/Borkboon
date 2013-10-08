//
//  ViewControllerTest.m
//  Borkboon
//
//  Created by Relife on 10/6/56 BE.
//  Copyright (c) 2556 Relife. All rights reserved.
//

#import "ViewControllerTest.h"
#import "UserplansViewController2.h"
#import "SBJson.h"

@interface ViewControllerTest ()
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
@property (nonatomic, strong) NSMutableData *responseData;

@end

@implementation ViewControllerTest

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
    // Do any additional setup after loading the view from its nib.
    repeats = [NSArray arrayWithObjects:@"ไม่เตือน",@"ทุกวัน",@"ทุกสัปดาห์",@"ทุก 2 สัปดาห์",@"ทุกเดือน",@"ทุกปี", nil];
    
    NSString *post =[[NSString alloc] initWithFormat:@"page=1"];
    NSLog(@"PostData: %@",post);
    
    NSURL *url=[NSURL URLWithString:@"http://codegears.co.th/borkboon/getAllPrayScript.php"];
    
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
    prayId = @"id";
    titleName = @"name";
    Image = @"image";
    isNew = @"is_new";
    
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
        
        _results = [[jsonData objectForKey:@"all_pray_script_data"] objectForKey:@"pray_script_data"];
        
        for (NSDictionary *get in _results) {
            NSString *prayid = [get  objectForKey:@"id"];
            NSString *name = [get objectForKey:@"name"];
            NSString *image = [get objectForKey:@"image"];
            NSString *is_new = [get objectForKey:@"is_new"];            
            NSLog(@"id: %@", prayid);
            NSLog(@"namepray: %@", name);
            NSLog(@"pic %@", image);
            NSLog(@"isNew: %@", is_new);

            dict = [NSDictionary dictionaryWithObjectsAndKeys:
                    prayid, prayId,
                    name, titleName,
                    image, Image,
                    is_new, isNew,
                    nil];
            [allObject addObject:dict];
        }
        displayObject =[[NSMutableArray alloc] initWithArray:allObject];
        [self.myTab reloadData];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [displayObject count];
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
    
        NSDictionary *tmpDict = [displayObject objectAtIndex:indexPath.row];
    
        NSString *cellValue = [tmpDict objectForKey:titleName];
        cell.textLabel.text = cellValue;
    
    return cell;
}

//selectRow
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tmpDict = [displayObject objectAtIndex:indexPath.row];
    NSString *Name = [tmpDict objectForKey:titleName];
    NSString *idPray = [tmpDict objectForKey:prayId];

//    NSString *value = [displayObject objectAtIndex:indexPath.row];
//    NSLog(@">>>>>>%@",value);
    
    [self.view setHidden:YES];

    NSDictionary *itemDetails = [[NSDictionary alloc] initWithObjectsAndKeys:idPray, @"idPray", Name,@"Name", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Touchedtable" object:itemDetails];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)CloseBt:(id)sender {
    [self.view setHidden:YES];
}
@end
