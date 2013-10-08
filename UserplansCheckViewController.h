//
//  UserplansCheckViewController.h
//  Borkboon
//
//  Created by Relife on 9/19/56 BE.
//  Copyright (c) 2556 Relife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserplansCheckViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate,NSURLConnectionDelegate,UIAlertViewDelegate>

//@property (strong, nonatomic) NSString *uID;
@property (strong, nonatomic) IBOutlet UITableView *myTab;
- (IBAction)addbt:(id)sender;
- (IBAction)editbt:(id)sender;
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *prayScriptId;
@property (strong, nonatomic) NSString *mainstorageId;
@property (strong, nonatomic) NSString *st;

@end
