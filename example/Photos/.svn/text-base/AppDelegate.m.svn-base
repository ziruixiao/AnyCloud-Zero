//
//  AppDelegate.m
//  AnyCloudZero
//
//  Created by Felix Xiao on 5/17/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//
/*
 
 */

#import "AppDelegate.h"
#import "GalleryViewController.h"

NSString *const FBSessionStateChangedNotification =
@"AnyCloud.co.AnyCloudZero.Login:FBSessionStateChangedNotification";

@interface AppDelegate ()
@end

@implementation AppDelegate
//SYNTHESIZE PROPERTIES
@synthesize MyPhotos,databasePath,dirPaths,docsDir;
@synthesize device,isFirstLaunch;
@synthesize webAppURL,facebookSession,uploadQueue,myDispositions,myUserID;

//TENTATIVE - PERFORM TASKS WHEN APP IS LAUNCHED
- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    [TestFlight takeOff:@"d7d5cb60-e410-4513-94b8-d7dfd76df068"];
    [self createEditableCopyOfDatabaseIfNeeded];
    [self createDefaultCopyOfDatabaseIfNeeded];
    [self openDB];
    self.uploadQueue = [[NSOperationQueue alloc] init];
    [self.uploadQueue setMaxConcurrentOperationCount:1];
    
    
    //[self connectToWebApp];
    device = [self detectDevice];
    return YES;
}

#pragma mark SQLite Database Methods
//DONE - CREATES WRITEABLE COPY OF DATABASE IN THE DOCUMENTS FOLDER OF THE APP (IF NEEDED)
- (void)createEditableCopyOfDatabaseIfNeeded
{
    //check for existance of MyPhotos database
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"MyPhotos.sqlite"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success)
        return;
    
    //a writable MyPhotos database does not exist, so copy the default to the appropriate location
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"MyPhotos.sqlite"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0,@"Failed to create writable database file with message '%@'.",[error localizedDescription]);
    }
}

//DONE - CREATES A DEFAULT COPY OF DATABASE IN THE DOCUMENTS FOLDER OF THE APP (IF NEEDED)
- (void)createDefaultCopyOfDatabaseIfNeeded
{
    //check for existance of MyPhotos_Default database
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"MyPhotos_Default.sqlite"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success)
        return;
    
    //a writable MyPhotos_Default database does not exist, so copy the default to the appropriate location
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"MyPhotos.sqlite"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0,@"Failed to create writable database file with message '%@'.",[error localizedDescription]);
    }
}

//DONE - OPENS THE LOCAL DATABASE
- (void)openDB
{
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:@"MyPhotos.sqlite"]];
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open_v2(dbpath,&MyPhotos,SQLITE_OPEN_READWRITE,NULL) == SQLITE_OK) {
        NSLog(@"The local database has been opened.");
    } else {
        NSLog(@"The local database could not be opened.");
    }
    
}

//DONE - CLOSES THE LOCAL DATABASE
- (void)closeDB
{
    sqlite3_close(MyPhotos);
    NSLog(@"The local database has been closed.");
}

#pragma mark General Setup Methods
//DONE - GETS THE CURRENT DEVICE
- (NSString*)detectDevice
{
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    /*Device resolutions:
     (1) 320x480: iPod Touch 1-3, iPhone 1-3
     (2) 640x960: iPhone 4+4S, iPod Touch 4
     (3) 640x1136: iPhone 5, iPod Touch 5
     (4) 768x1024: iPad 1+2, iPad Mini
     (5) 1536x2048: iPad 3+4
     */
    if ((screenWidth + screenHeight)==(320+480)) {
        return @"iPhone";
    } else if ((screenWidth + screenHeight)==(320+568)) {
        return @"iPhone5";
    } else if ((screenWidth + screenHeight)==(768+1024)) {
        return @"iPad";
    } else {
        return @"iPhone";
    }
}

//CONNECTS TO ANYCLOUD WEB APP AND STORES THE ACCESS URL


//OPTIONAL - What happens when the app is interrupted by a call, text, or exit
- (void)applicationWillResignActive:(UIApplication*)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

//OPTIONAL - What happens when the app enters the background, if anything at all
- (void)applicationDidEnterBackground:(UIApplication*)application
{
    UIApplication* myApplication = [UIApplication sharedApplication];
    [myApplication beginBackgroundTaskWithExpirationHandler:^{
        // Clean up any unfinished task business by marking where you
        // stopped or ending the task outright.
        
        // Bring up your NSOperation queue instance here and block this thread until it is complete
        [self.uploadQueue waitUntilAllOperationsAreFinished];
        NSLog(@"AnyCloudZero is no longer active. Existing uploads will be completed.");
    }];
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

//OPTIONAL - What happens when the app exits the background, if anything at all
- (void)applicationWillEnterForeground:(UIApplication*)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

//OPTIONAL - What happens when the app becomes active again
- (void)applicationDidBecomeActive:(UIApplication*)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    // We need to properly handle activation of the app with regards to Facebook Login
    // (e.g., returning from iOS 6.0 Login Dialog or from fast app switching).
    [FBSession.activeSession handleDidBecomeActive];
}

//OPTIONAL - What happens when the app is terminated
- (void)applicationWillTerminate:(UIApplication*)application
{
    [self closeDB];
    [FBSession.activeSession close];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//FACEBOOK - Monitors when a session changes
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // We have a valid session
                NSLog(@"A valid Facebook session has been found.");
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

//FACEBOOK - Opens the login screen.
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI
{
    NSArray *permissions = @[
                             @"email",
                             @"user_photos",
                             @"friends_photos"];
    return [FBSession openActiveSessionWithReadPermissions:permissions
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session,
                                                             FBSessionState state,
                                                             NSError *error) {
                                             [self sessionStateChanged:session
                                                                 state:state
                                                                 error:error];
                                         }];
}

//FACEBOOK - Switches to the proper URL
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    // attempt to extract a token from the url
    return [FBSession.activeSession handleOpenURL:url];
}

//FACEBOOK - Closes the current session
- (void)closeSession
{
    [FBSession.activeSession closeAndClearTokenInformation];
}


@end