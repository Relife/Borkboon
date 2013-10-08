//
//  RepeatTimeViewController.m
//  Borkboon
//
//  Created by Relife on 10/3/56 BE.
//  Copyright (c) 2556 Relife. All rights reserved.
//

#import "RepeatTimeViewController.h"
#import "SettingViewController.h"

@interface RepeatTimeViewController ()

@end

@implementation RepeatTimeViewController
{
    NSArray *repeats;
    NSUInteger selectedIndex;
    NSString *theRepeat;
}

//@synthesize delegate;
//@synthesize repeat;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    repeats = [NSArray arrayWithObjects:@"ไม่เตือน",@"ทุกวัน",@"ทุกสัปดาห์",@"ทุก 2 สัปดาห์",@"ทุกเดือน",@"ทุกปี", nil];
    selectedIndex = [repeats indexOfObject:self.repeat];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [repeats count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [repeats objectAtIndex:indexPath.row];
    if (indexPath.row == selectedIndex)
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	else
		cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
	if (selectedIndex != NSNotFound)
	{
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
    
	selectedIndex = indexPath.row;
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
	theRepeat = [repeats objectAtIndex:indexPath.row];
    
//    NSDictionary *itemDetails = [[NSDictionary alloc] initWithObjectsAndKeys:theRepeat, @"RepeatTime", nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"SentRepeat" object:itemDetails];
}

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


- (IBAction)DoneBt:(id)sender {
    
    NSDictionary *itemDetails = [[NSDictionary alloc] initWithObjectsAndKeys:theRepeat, @"RepeatTime", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SentRepeat" object:itemDetails];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
