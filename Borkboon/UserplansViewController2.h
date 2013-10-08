//
//  UserplansViewController2.h
//  Borkboon
//
//  Created by Relife on 9/6/56 BE.
//  Copyright (c) 2556 Relife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewControllerTest.h"
@interface UserplansViewController2 : UIViewController <UITableViewDataSource,UITableViewDelegate,NSURLConnectionDelegate,UIAlertViewDelegate>
{
UIButton *pickerButton;
UIPickerView *myPickerView;

NSMutableArray *array_from;
UILabel *fromButton;

UIButton *doneButton ;
UIButton *backButton ;
//    __weak IBOutlet UIView* addPrayView;
}
@property (strong, nonatomic) ViewControllerTest *viewTest;
@property (strong, nonatomic) NSString *getId;
@property (strong, nonatomic) NSString *getTitle;
@property (strong, nonatomic) NSString *getValue;
@property (strong, nonatomic) NSString *getMainId;
@property (strong, nonatomic) NSString *st;
@property (strong, nonatomic) NSString *getUser;

@property (strong, nonatomic) IBOutlet UITableView *myTab;
- (IBAction)addbt:(id)sender;
- (IBAction)editbt:(id)sender;
//- (IBAction)closeSubview:(id)sender;

@end
