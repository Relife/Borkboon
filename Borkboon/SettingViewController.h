//
//  SettingViewController.h
//  Borkboon
//
//  Created by Relife on 9/20/56 BE.
//  Copyright (c) 2556 Relife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RepeatTimeViewController.h"

@interface SettingViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *planNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeStartLabel;
@property (weak, nonatomic) IBOutlet UILabel *repeatLabel;

@property (strong, nonatomic) NSString *getName;
@property (strong, nonatomic) NSString *getPlanName;
@property (strong, nonatomic) NSString *getRepeat;
@property (strong, nonatomic) NSString *timeStart;
@property (strong, nonatomic) NSString *getUserId;


- (IBAction)DoneBt:(id)sender;

@property (nonatomic,strong) NSMutableArray *dataRecords;

@end
