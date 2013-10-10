//
//  ViewControllerTest.h
//  Borkboon
//
//  Created by Relife on 10/6/56 BE.
//  Copyright (c) 2556 Relife. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewControllerTest : UIViewController<UITableViewDataSource,UITableViewDelegate,NSURLConnectionDelegate>
{
    NSMutableData *_responseData;

}
- (IBAction)CloseBt:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *myTab;
@property (strong,nonatomic) NSArray *results;
@property (strong,nonatomic) NSString *totalPage;

- (IBAction)readMore:(id)sender;
- (IBAction)Back:(id)sender;


@end
