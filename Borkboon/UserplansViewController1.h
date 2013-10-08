//
//  UserplansViewController1.h
//  Borkboon
//
//  Created by Relife on 9/6/56 BE.
//  Copyright (c) 2556 Relife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserplansViewController1 : UIViewController
    <UITableViewDataSource,UITableViewDelegate,NSURLConnectionDelegate,UIAlertViewDelegate>

//@property (strong, nonatomic) NSString *uID;
@property (strong, nonatomic) IBOutlet UITableView *myTab;
- (IBAction)addbt:(id)sender;
- (IBAction)editbt:(id)sender;

@property (strong, nonatomic) NSString *userId;
@end
