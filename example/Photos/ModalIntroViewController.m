//
//  ModalIntroViewController.m
//  AnyCloudZero
//
//  Created by Felix Xiao on 7/3/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import "ModalIntroViewController.h"
#import "UIViewController+JASidePanel.h"
#import "MenuViewController.h"

@interface ModalIntroViewController ()

@end

@implementation ModalIntroViewController

@synthesize appDelegate,introImageView,shouldShowError;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = [[UIApplication sharedApplication] delegate];

    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus == NotReachable) {
        [self.view viewWithTag:444].userInteractionEnabled = NO;
    } else {
        [self.view viewWithTag:444].userInteractionEnabled = YES;
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(sessionStateChanged:)
         name:FBSessionStateChangedNotification
         object:nil];
    }
	// Do any additional setup after loading the view.
}

//EMPTY - WHAT HAPPENS AFTER VIEWDIDLOAD
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (IBAction)authButtonAction
{
    [self showFBLogin];
}

#define IOS_NEWER_OR_EQUAL_TO_6 ( [ [ [ UIDevice currentDevice ] systemVersion ] floatValue ] >= 6.0 )

- (void)showFBLogin
{
        NSArray *permissions = [NSArray arrayWithObjects:@"email, user_photos, friends_photos", nil];
        
#ifdef IOS_NEWER_OR_EQUAL_TO_6
        permissions = [NSArray arrayWithObjects:@"email", @"user_photos",@"friends_photos",nil];
#endif
        
    
        [FBSession openActiveSessionWithReadPermissions:permissions
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session,
           FBSessionState state, NSError *error) {
             appDelegate.facebookSession = FBSession.activeSession;
             //NSLog(@"%@",FBSession.activeSession.accessTokenData.accessToken);
             NSLog(@"\nfb sdk error = %@", error);
             
             if (error.fberrorCategory == FBErrorCategoryUserCancelled) {
                 NSLog(@"The user has cancelled the login, therefore I don't need to do anything.");
             } else {
                 switch (state) {
                     {case FBSessionStateOpen:
                         [[FBRequest requestForMe] startWithCompletionHandler:
                          ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
                            if (!error) {
                                //success
                                self.appDelegate.isFirstLaunch = YES;
                                [self.view viewWithTag:176].hidden = NO;
                                [self.view viewWithTag:177].hidden = NO;
                                [self.view viewWithTag:154].hidden = YES;
                                [self.view viewWithTag:126].hidden = NO;
                                [self moveToDefault];
                            }
                          }];
                        break; }
                    case FBSessionStateClosed:
                        break;
                    case FBSessionStateClosedLoginFailed:
                         NSLog(@"here");
                        [self.view viewWithTag:126].hidden = YES;
                        [self.view viewWithTag:154].hidden = NO;
                         [self.view viewWithTag:151].hidden = NO;
                         [self.view viewWithTag:152].hidden = NO;
                         [self.view viewWithTag:176].hidden = YES;
                         [self.view viewWithTag:177].hidden = YES;
                        break;
                    default:
                        break;
                }
             }
         }];
}

- (void)moveToDefault
{
    [self.sidePanelController setCenterPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"defaultViewController"]];
}

- (BOOL)shouldAutorotate {
        return NO;
}

// iOS 6 interface orientation support. Only rotate on iPad.
- (NSUInteger)supportedInterfaceOrientations {
        return UIInterfaceOrientationMaskPortrait;
}

- (void)sessionStateChanged:(NSNotification*)notification
{
    if (appDelegate.facebookSession.isOpen) {
        //NSLog(@"Logged In");
    } else {
        //NSLog(@"Logged Out");
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
