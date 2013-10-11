//
//  addPrayViewController.h
//  Borkboon
//
//  Created by Relife on 10/6/56 BE.
//  Copyright (c) 2556 Relife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addPrayViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSURLConnectionDelegate>
{
    __weak IBOutlet UIView* addPrayView;
}
@property (strong, nonatomic) IBOutlet UITableView *myTab;
@property (strong, nonatomic) IBOutlet UITableView *Tab;


@end
