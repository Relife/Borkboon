//
//  User.h
//  Borkboon
//
//  Created by Relife on 10/8/56 BE.
//  Copyright (c) 2556 Relife. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * uId;
@property (nonatomic, retain) NSString * user;

@end
