//
//  InfoViewController.h
//  Borkboon
//
//  Created by Relife on 9/10/56 BE.
//  Copyright (c) 2556 Relife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *txtfirstname;
@property (weak, nonatomic) IBOutlet UILabel *txtlastname;
@property (weak, nonatomic) IBOutlet UILabel *txttime;
@property (weak, nonatomic) IBOutlet UILabel *txtme;
@property (weak, nonatomic) IBOutlet UILabel *txtfriend;
@property (weak, nonatomic) IBOutlet UILabel *txttop;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (assign, nonatomic) NSInteger meInt;
@property (assign, nonatomic) NSInteger friendInt;
@property (assign, nonatomic) NSInteger top10Int;


@property (weak, nonatomic) IBOutlet UIImageView *meStar1;
@property (weak, nonatomic) IBOutlet UIImageView *meStar2;
@property (weak, nonatomic) IBOutlet UIImageView *meStar3;
@property (weak, nonatomic) IBOutlet UIImageView *meStar4;
@property (weak, nonatomic) IBOutlet UIImageView *meStar5;

@property (weak, nonatomic) IBOutlet UIImageView *friendStar1;
@property (weak, nonatomic) IBOutlet UIImageView *friendStar2;
@property (weak, nonatomic) IBOutlet UIImageView *friendStar3;
@property (weak, nonatomic) IBOutlet UIImageView *friendStar4;
@property (weak, nonatomic) IBOutlet UIImageView *friendStar5;

@property (weak, nonatomic) IBOutlet UIImageView *top10Star1;
@property (weak, nonatomic) IBOutlet UIImageView *top10Star2;
@property (weak, nonatomic) IBOutlet UIImageView *top10Star3;
@property (weak, nonatomic) IBOutlet UIImageView *top10Star4;
@property (weak, nonatomic) IBOutlet UIImageView *top10Star5;
@end
