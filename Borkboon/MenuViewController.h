//
//  MenuViewController.h
//  Borkboon
//
//  Created by Relife on 9/23/56 BE.
//  Copyright (c) 2556 Relife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,NSURLConnectionDelegate>
{
    NSMutableData *_responseData1;
}
@property (weak, nonatomic) IBOutlet UICollectionView *CollectionView;
@property (strong,nonatomic) NSArray *results1;

@end
