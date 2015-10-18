//
//  AppDelegate.h
//  AnyCloudZero
//
//  Created by Felix Xiao on 5/17/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "TestFlight.h"
#import <FacebookSDK/FacebookSDK.h>
#import <CommonCrypto/CommonDigest.h>
#import "Reachability.h"

@class MenuViewController;
extern NSString *const FBSessionStateChangedNotification;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    //private variables for accessing SQLite database
    sqlite3 *MyPhotos;
    NSString *databasePath;
    NSString *docsDir;
    NSArray *dirPaths;
}

//SQLite database properties
@property (nonatomic) sqlite3 *MyPhotos;
@property (strong,nonatomic) NSString *databasePath;
@property (strong,nonatomic) NSString *docsDir;
@property (strong,nonatomic) NSArray *dirPaths;

//general app properties
@property (strong,nonatomic) UIWindow *window;
@property (strong,nonatomic) NSString *device;
@property BOOL isFirstLaunch;

@property (strong,nonatomic) NSOperationQueue *uploadQueue;

//library-specfic properties

//internet interaction properties
@property (strong,nonatomic) NSString *webAppURL;
@property (strong,nonatomic) NSMutableDictionary *myDispositions;
@property int myUserID;



//api integration properties
@property (strong,nonatomic) FBSession *facebookSession;

//SQLite database methods
- (void)openDB;
- (void)closeDB;


//general app methods
- (NSString*)detectDevice;


//api integration methods
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (void)closeSession;

@end
