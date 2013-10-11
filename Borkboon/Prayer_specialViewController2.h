//
//  Prayer_specialViewController2.h
//  Borkboon
//
//  Created by Relife on 8/25/56 BE.
//  Copyright (c) 2556 Relife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Prayer_specialViewController2 : UIViewController<UITableViewDataSource,UITableViewDelegate,NSURLConnectionDelegate,UISearchBarDelegate>
{
    NSMutableData *_responseData;
}
@property (strong,nonatomic) NSArray *results;
@property (strong,nonatomic) NSArray *prayGroup;

//@property (strong, nonatomic) NSString *titleNameSecond;
//@property (nonatomic, strong) NSString *contentId;
@property (weak, nonatomic) IBOutlet UITableView *myTab;
@property (strong, nonatomic) NSMutableArray *Title;


@end
