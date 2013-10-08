//
//  CollectionCell.h
//  Borkboon
//
//  Created by Relife on 9/23/56 BE.
//  Copyright (c) 2556 Relife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *myImage;
@property (weak, nonatomic) IBOutlet UILabel *myDescriptionLabel;
- (IBAction)bgClick:(id)sender;
@end
