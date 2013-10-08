//
//  Prayer-basicViewController1.h
//  Borkboon
//
//  Created by Relife on 8/19/56 BE.
//  Copyright (c) 2556 Relife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Prayer_basicViewController1 : UIViewController<UITableViewDataSource,UITableViewDelegate,NSURLConnectionDelegate,UISearchBarDelegate>
{
    NSMutableData *_responseData;
}
@property (strong,nonatomic) NSArray *results;
@property (strong,nonatomic) NSArray *prayGroup;

//@property (strong, nonatomic) NSString *titleNameSecond;
//@property (nonatomic, strong) NSString *contentId;
@property (weak, nonatomic) IBOutlet UITableView *myTab;
//@property (strong, nonatomic) NSMutableArray *Title;

@property (strong, nonatomic) NSString *menu;
@property (strong, nonatomic) NSString *titletable;



@end
