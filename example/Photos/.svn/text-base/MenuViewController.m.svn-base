//
//  MenuViewController.m
//  AnyCloudZero
//
//  Created by Felix Xiao on 6/24/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import "MenuViewController.h"
#import "Photo.h"
#import "ASAssetsLibrary.h"
#import "GalleryViewController.h"
#import "ALAssetAdapter.h"
#import "DefaultViewController.h"
#import "ModalIntroViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController
@synthesize appDelegate;

//EMPTY - CUSTOM INITIALIZATION
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//EMPTY - WHAT HAPPENS BEFORE VIEWWILLAPPEAR
- (void)awakeFromNib
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = [[UIApplication sharedApplication] delegate];
    [self setLeftPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"leftViewController"]];
    
    [self setRightPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"rightViewController"]];
	// Do any additional setup after loading the view.
    
    UINavigationController *centerViewController;
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection"
                                                        message:@"AnyCloud requires an internet connection. Please connect and try again." delegate:nil cancelButtonTitle: @"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
        
        ModalIntroViewController *modalIntroViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"modalIntroViewController"];
        [self setCenterPanel:modalIntroViewController];
        
    } else {
        
        if (![FBSession openActiveSessionWithAllowLoginUI:NO]) {

        } else {

        }
    
        //IF A FACEBOOK LOGIN EXISTS, GO TO THIS PAGE
        if (!FBSession.activeSession.accessTokenData.accessToken) {
            ModalIntroViewController *modalIntroViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"modalIntroViewController"];
            [self setCenterPanel:modalIntroViewController];
        
        } else {
            centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"defaultViewController"];
            [self setCenterPanel:centerViewController];
    
        }
        
    }
}


//DONE - SHOWS POPUP FOR A LOGO TAP
- (void)promptReset
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm Reset"
                                                    message:@"Are you sure you want to reset AnyCloudZero?" delegate:self cancelButtonTitle: @"Cancel"
                                          otherButtonTitles:@"Continue", nil];
    [alert show];
}

#pragma mark UIAlertView Delegate Methods
//DONE PROCESSES ALERT VIEW
- (void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //nothing
        
    } else {
        [self resetACZ];
    }
}

//DONE - RESETS THE LOCAL DATABASE
- (void)resetACZ
{
    Photo *myPhoto = [Photo alloc];
    [myPhoto resetDB];
    
    [self showCenterPanelAnimated:YES];
    [self setCenterPanel:[self.storyboard instantiateViewControllerWithIdentifier:@"defaultViewController"]];
    [(DefaultViewController*)self.centerPanel viewDidLoad];
}

- (IBAction)sendTweet:(id)sender
{
    SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweetSheet setInitialText:@"I just got my camera roll to zero using #AnyCloud! "]; //Add here your text
        
    // Add an image
    //[tweetSheet addImage:[UIImage imageNamed:@"AnyCloud.co.png"]]; //Add here the name of your picture
    // Add a link
    [tweetSheet addURL:[NSURL URLWithString:@"http://www.anycloud.co"]]; //Add here your Link
    [self presentViewController: tweetSheet animated: YES completion: nil];

}

- (IBAction)sendFacebook:(id)sender
{
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [mySLComposerSheet setInitialText:@"I just got my camera roll to zero using Anycloud!"];
        
        //[mySLComposerSheet addImage:[UIImage imageNamed:@"AnyCloud.co.png"]];
        
        [mySLComposerSheet addURL:[NSURL URLWithString:@"http://www.facebook.com/AnyCloud"]];
        
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    
                    break;
                case SLComposeViewControllerResultDone:
                    
                    break;
                    
                default:
                    break;
            }
        }];
        
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end