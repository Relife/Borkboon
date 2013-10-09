//
//  AppDelegate.h
//  Borkboon
//
//  Created by Relife on 8/19/56 BE.
//  Copyright (c) 2556 Relife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

enum LOGIN_STATE {
    LSTATE_LOGOUT = -1,
    LSTATE_NOT_LOGIN = 0,
    LSTATE_LOGIN_EMAIL = 1,
    LSTATE_LOGIN_FACEBOOK = 2
    };


@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) FBSession *session;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

// 0 not login
// 1 email
// 2 facebook
// -1 log out
@property (nonatomic, readwrite ) int loginState;
@property (nonatomic, retain ) NSString* userID;


@end
