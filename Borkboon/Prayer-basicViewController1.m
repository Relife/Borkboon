//
//  Prayer-basicViewController1.m
//  Borkboon
//
//  Created by Relife on 8/19/56 BE.
//  Copyright (c) 2556 Relife. All rights reserved.
//

#import "Prayer-basicViewController1.h"
#import "Prayer-basicDetailViewController1.h"
#import "MenuViewController.h"

@interface Prayer_basicViewController1 ()
{
    NSMutableArray *allObject;
    NSMutableArray *displayObject;
    NSMutableArray *idArr;
    NSMutableArray *titleArr;
    
    // A dictionary object
    NSDictionary *dict;

    // Define keys
    NSString *titleId;
    NSString *titleName;
    NSString *pic;
    NSString *isNew;
    
}
@property (nonatomic, strong) NSMutableData *responseData;


@end

@implementation Prayer_basicViewController1
@synthesize responseData = _responseData;


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
    self.title = _titletable;
    
    self.responseData = [NSMutableData data];
    
    NSURL *aUrl = [NSURL URLWithString:@"http://codegears.co.th/borkboon/getPrayGroup.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl];
    
    
    [request setHTTPMethod:@"POST"];
    NSString *postString = @"";
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request  delegate:self];
    if (connection) {
        _responseData = [NSMutableData data] ;
    } else {
        UIAlertView *connectFailMessage = [[UIAlertView alloc] initWithTitle:@"NSURLConnection " message:@"Failed in viewDidLoad"  delegate: self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [connectFailMessage show];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    //    NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    // Define keys
    titleId = @"id";
    titleName = @"name";
    pic = @"image";
    isNew = @"is_new";
    
    // Create array to hold dictionaries
    allObject = [[NSMutableArray alloc] init];
    idArr = [[NSMutableArray alloc] init];
    titleArr = [[NSMutableArray alloc] init];

    // extract specific value...
    _results = [res objectForKey:@"pray_group_list"];

        for (NSDictionary *praygroup in _results){
            NSDictionary *prg = [praygroup objectForKey:@"pray_group"];
            _prayGroup = [prg objectForKey:@"pray_script"];
            NSString *idprg = [prg objectForKey:@"id"];
//            NSLog(@">>>>>>%@",idprg);
            
                if ([idprg isEqual: _menu]) {
                for (NSDictionary *prs in _prayGroup){
                    NSString *strId = [prs objectForKey:@"id"];
//                    NSLog(@"%@",strId);
                    NSString *strTitlename = [prs objectForKey:@"name"];
                    NSString *strPicname = [prs objectForKey:@"image"];
                    NSString *strIsnew = [prs objectForKey:@"is_new"];
                    
                    [idArr addObject:strId];
                    [titleArr addObject:strTitlename];
                    
                    dict = [NSDictionary dictionaryWithObjectsAndKeys:
                            strId, titleId,
                            strTitlename, titleName,
                            strPicname, pic,
                            strIsnew, isNew,
                            nil];
                    [allObject addObject:dict];
                }
            }
        }
    displayObject =[[NSMutableArray alloc] initWithArray:allObject];
//    NSLog(@"%@",idArr);    
    [self.myTab reloadData];
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


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    
    if([searchString length] == 0)
    {
        [displayObject removeAllObjects];
        [displayObject addObjectsFromArray:allObject];
    }
    else
    {
        [displayObject removeAllObjects];
        for(NSDictionary *tmpDict in allObject)
        {
            NSString *val = [tmpDict objectForKey:titleName];
            
            NSRange r = [val rangeOfString:searchString options:NSCaseInsensitiveSearch];
            if(r.location != NSNotFound)
            {
                [displayObject addObject:tmpDict];
            }
        }
    }
    
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text=@"";
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

//select cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Prayer_basicDetailViewController1 *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"Prayer_basicDetail"];
    tvc.hidesBottomBarWhenPushed = YES;
    
    NSDictionary *tmpDict = [displayObject objectAtIndex:indexPath.row];
    tvc.titleId = [tmpDict objectForKey:titleId];
    tvc.titleName = [tmpDict objectForKey:titleName];
    tvc.getAllId = idArr;
    tvc.getAllTitle = titleArr;
    
    [tvc setIndexPath:indexPath.row];
    [self.navigationController pushViewController:tvc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
