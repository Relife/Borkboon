//
//  SettingViewController.m
//  Borkboon
//
//  Created by Relife on 9/20/56 BE.
//  Copyright (c) 2556 Relife. All rights reserved.
//

#import "SettingViewController.h"
#import "UserplansViewController2.h"
#import "AppDelegate.h"
#import "User.h"

@interface SettingViewController ()

@end

@implementation SettingViewController
AppDelegate *appDelegate;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
//    self.hidesBottomBarWhenPushed = NO;
}

- (void)viewDidLoad
{
    //valueSw
    NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
    if([userdefault boolForKey:@"yes"]) {
        _snoozeSw.on=YES;
        _switchValue = @"Yes";
    } else {
        _snoozeSw.on=NO;
        _switchValue = @"No";
    }
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sentValue:)
                                                 name:@"SentRepeat"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sentTime:)
                                                 name:@"SentTime"
                                               object:nil]; 

    appDelegate = [[AppDelegate alloc] init];
    if (_dataRecords == nil) {
        _dataRecords = [[NSMutableArray alloc] init];
    }
    else
    {
        [_dataRecords removeAllObjects];
    }
    
    NSArray *t = [self fetchData];
    
    
    for (int i=0; i < [t count]; i++) {
        [_dataRecords addObject:[t objectAtIndex:i]];
        User *p = _dataRecords[i];
        NSLog(@"uId = %@",p.uId);
        NSLog(@"planName = %@",p.planName);
        NSLog(@"prayName = %@",p.prayName);
        NSLog(@"startTime = %@",p.startTime);
        NSLog(@"repeat = %@",p.repeat);
        NSLog(@"snooze = %@",p.snooze);        
    }
    _nameLabel.text = _getName;
    _planNameLabel.text = _getPlanName;
    _timeStartLabel.text = _timeStart;
    _repeatLabel.text = _getRepeat;
}

-(NSArray *) fetchData
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:[appDelegate managedObjectContext]];
    
    request.entity = entity;
    
    NSArray *listData = [[appDelegate managedObjectContext
                          ] executeFetchRequest:request error:nil];

    return listData;
}

- (void)sentValue:(NSNotification *)notification {
    NSLog(@"%@", notification.object);
    NSLog(@"%@", [notification.object objectForKey:@"RepeatTime"]);
    _getRepeat = [notification.object objectForKey:@"RepeatTime"];
    _repeatLabel.text = _getRepeat;
}

- (void)sentTime:(NSNotification *)notification {
    NSLog(@"%@", notification.object);
    NSLog(@"%@", [notification.object objectForKey:@"Time"]);
    _timeStart = [notification.object objectForKey:@"Time"];
    _timeStartLabel.text = _timeStart;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    // Return the number of rows in the section.
//    return 0;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


- (IBAction)DoneBt:(id)sender {
    if (![_planNameLabel.text isEqualToString:@""] ) {
    AppDelegate *appDelegate = [[AppDelegate alloc] init];
    
    NSManagedObject *p = [NSEntityDescription
                          insertNewObjectForEntityForName:@"User" inManagedObjectContext:[appDelegate managedObjectContext]];
    [p setValue:_getUserId forKey:@"uId"];
    [p setValue:_planNameLabel.text forKey:@"planName"];
    [p setValue:_nameLabel.text forKey:@"prayName"];
    [p setValue:_repeatLabel.text forKey:@"repeat"];
    [p setValue:_switchValue forKey:@"snooze"];
    [p setValue:_timeStartLabel.text forKey:@"startTime"];

    [[appDelegate managedObjectContext] save:nil];
    }
}

- (IBAction)Swchang:(id)sender {
    NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
    if (_snoozeSw.on) {
        [userdefault setBool:YES forKey:@"yes"];
        _switchValue = @"Yes";
    } else {
        [userdefault setBool:NO forKey:@"no"];
        _switchValue = @"No";
    }
}
@end
