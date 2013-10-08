//
//  InfoTableViewController.h
//  Borkboon
//
//  Created by Relife on 9/10/56 BE.
//  Copyright (c) 2556 Relife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface InfoTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *myTable;
@property (nonatomic,strong) NSArray *listData;

@end
