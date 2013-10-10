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
@property (nonatomic, retain) NSString * planName;
@property (nonatomic, retain) NSString * prayName;
@property (nonatomic, retain) NSString * repeat;
@property (nonatomic, retain) NSString * snooze;
@property (nonatomic, retain) NSString * startTime;

@end
