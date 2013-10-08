//
//  MenuViewController.m
//  Borkboon
//
//  Created by Relife on 9/23/56 BE.
//  Copyright (c) 2556 Relife. All rights reserved.
//

#import "MenuViewController.h"
#import "CollectionCell.h"
#import "SBJson.h"
#import "Prayer-basicViewController1.h"

@interface MenuViewController ()
{
    NSMutableArray *arrImage;
    NSMutableArray *arrDes;
    
    NSMutableArray *allObject;
    NSMutableArray *displayObject;
    
    // A dictionary object
    NSDictionary *dict;
    
    // Define keys
    NSString *IdPray_group;
    NSString *titleName;
    NSString *Image;
}
@property (nonatomic, strong) NSMutableData *responseData1;

@end

@implementation MenuViewController
@synthesize responseData1 = _responseData1;

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
    
    [[self CollectionView]setDataSource:self];
    [[self CollectionView]setDelegate:self];
    
//    arrDes = [[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4",nil];
//    arrImage = [[NSArray alloc]initWithObjects:@"pic_chapter-prayers.png",@"pic_compassionate.png",@"pic_prayer-basis.png",@"pic_psalm.png", nil];
    
    //get Data
    NSString *post =[[NSString alloc] initWithFormat:@""];
    NSLog(@"PostData: %@",post);
    
    NSURL *url=[NSURL URLWithString:@"http://codegears.co.th/borkboon/getPrayGroup.php"];
    
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
    IdPray_group = @"id";
    Image = @"image";
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
        
        
        _results1 = [jsonData objectForKey:@"pray_group_list"];
        
        for (NSDictionary *result in _results1) {
            NSString *idpray_group = [[result objectForKey:@"pray_group"] objectForKey:@"id"];
            NSString *name = [[result objectForKey:@"pray_group"] objectForKey:@"name"];
            NSString *image = [[result objectForKey:@"pray_group"] objectForKey:@"image"];
            NSLog(@"id: %@", idpray_group);
            NSLog(@"namepray_group: %@", name);
            NSLog(@"url %@", image);
            
            dict = [NSDictionary dictionaryWithObjectsAndKeys:
                    idpray_group, IdPray_group,
                    name, titleName,
                    image,Image,
                    nil];
            [allObject addObject:dict];
        }
        displayObject =[[NSMutableArray alloc] initWithArray:allObject];
    }
}

//DataSource and delegate method
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [displayObject count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *tmpDict = [displayObject objectAtIndex:indexPath.item];
    
    NSString *cellDes = [tmpDict objectForKey:titleName];
    NSString *cellImg = [tmpDict objectForKey:Image];
    NSString *picURL = [NSString stringWithFormat:@"http://www.codegears.co.th/borkboon/image/%@",cellImg];
    
    NSURL *useUrl = [NSURL URLWithString:picURL];
    //    NSData *data = [NSData dataWithContentsOfURL:useUrl];
    //    cell.imageView.image = [UIImage imageWithData:data];
    NSURLRequest* request = [NSURLRequest requestWithURL:useUrl];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error) {
        
        UIImage* img = [UIImage imageWithData:data];
    
    [[cell myImage]setImage:img];
    [[cell myDescriptionLabel]setText:cellDes];
    }];

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Prayer_basicViewController1 *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"Prayer_basicView"];
    NSDictionary *tmpDict = [displayObject objectAtIndex:indexPath.item];
    tvc.menu = [tmpDict objectForKey:IdPray_group];
    tvc.titletable = [tmpDict objectForKey:titleName];    
    [self.navigationController pushViewController:tvc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
