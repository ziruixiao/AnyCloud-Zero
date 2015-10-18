//
//  DefaultViewController.m
//  AnyCloudZero
//
//  Created by Felix Xiao on 6/25/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import "DefaultViewController.h"
#import "Photo.h"
#import "ASAssetsLibrary.h"
#import "GalleryViewController.h"
#import "ALAssetAdapter.h"
#import "UIViewController+JASidePanel.h"
#import "MenuViewController.h"
#import "NSURLConnection+Tag.h"
#import "UploadOperation.h"

@interface DefaultViewController ()

@end

@implementation DefaultViewController

@synthesize appDelegate,loadingImageView,loadingLabel,galleryReady;

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
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    
    self.loadingImageView.animationImages = [NSArray arrayWithObjects:
                                             [UIImage imageNamed:@"0.gif"],
                                             [UIImage imageNamed:@"1.gif"],
                                             [UIImage imageNamed:@"2.gif"],
                                             [UIImage imageNamed:@"3.gif"],
                                             [UIImage imageNamed:@"4.gif"], nil];
    self.loadingImageView.animationDuration = 0.5f;
    self.loadingImageView.tag = 998;
    self.loadingImageView.animationRepeatCount = 0;
    [self.loadingImageView startAnimating];
    [self.view addSubview: self.loadingImageView];
    
    [self connectToWebApp];
    
    [[ASAssetsLibrary sharedInstance] addObserver:self forKeyPath:@"groups" options:0 context:nil];
    

	// Do any additional setup after loading the view.
    UINavigationBar *myNavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 44)];
    myNavBar.tag = 12345;
    //myNavBar.barTintColor = [UIColor blackColor];
    
    UIButton *menuBarButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuBarButton setImage:[UIImage imageNamed:@"menubars.png"] forState:UIControlStateNormal];
    menuBarButton.tag = 1011;
    CGRect menuBarButtonFrame = CGRectMake(0, 0, 44, 44);
    [menuBarButton setFrame:menuBarButtonFrame];
    [menuBarButton addTarget:self action:@selector(showMenuPanel:) forControlEvents:UIControlEventTouchUpInside];
    [myNavBar addSubview:menuBarButton];
    
    UILabel *centerTitleLabel = [[UILabel alloc] init];
    centerTitleLabel.text = @"AnyCloud";
    centerTitleLabel.textColor = [UIColor blackColor];
    centerTitleLabel.backgroundColor = [UIColor clearColor];
    centerTitleLabel.textAlignment = NSTextAlignmentCenter;
    centerTitleLabel.tag = 2000;
    
    
    myNavBar.translatesAutoresizingMaskIntoConstraints = NO;
    [myNavBar addSubview:centerTitleLabel];
    [self.view addSubview:myNavBar];
    
    //myNavBar Constraints
    NSLayoutConstraint *myNavBarTopConstraint = [NSLayoutConstraint
                                                 constraintWithItem:myNavBar attribute:NSLayoutAttributeTop
                                                 relatedBy:NSLayoutRelationEqual toItem:self.view
                                                 attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0f];
    NSLayoutConstraint *myNavBarLeftConstraint = [NSLayoutConstraint
                                                  constraintWithItem:myNavBar attribute:NSLayoutAttributeLeft
                                                  relatedBy:NSLayoutRelationEqual toItem:self.view attribute:
                                                  NSLayoutAttributeLeft multiplier:1.0 constant:0.0f];
    NSLayoutConstraint *myNavBarRightConstraint = [NSLayoutConstraint
                                                   constraintWithItem:myNavBar attribute:NSLayoutAttributeRight
                                                   relatedBy:NSLayoutRelationEqual toItem:self.view attribute:
                                                   NSLayoutAttributeRight multiplier:1.0 constant:0.0f];
    [self.view addConstraints:@[myNavBarTopConstraint,myNavBarLeftConstraint,myNavBarRightConstraint]];
    [self changeFrames];
    
}

- (IBAction)showMenuPanel:(id)sender
{
    if (self.sidePanelController.state == JASidePanelCenterVisible) {
        [self.sidePanelController showLeftPanelAnimated:YES];
    }
    else {
        [self.sidePanelController showCenterPanelAnimated:YES];
    }
}

- (void)resumeUploads
{
    NSMutableDictionary *resumeOperations = [NSMutableDictionary dictionary];
    Photo *toolPhoto = [[Photo alloc] init];
    [toolPhoto getIncompletePhotos:resumeOperations];
    
    //check to see that it doesn't already exist in the array
    for (int x = 0; x < resumeOperations.allKeys.count; x++) {
        NSLog(@"found something that wasn't done");
        UploadOperation *operation = [[UploadOperation alloc] initWithPhotoData:[NSString stringWithFormat:@"%@|%@",[resumeOperations valueForKey:[[resumeOperations allKeys] objectAtIndex:x]],[[resumeOperations allKeys] objectAtIndex:x]]];
        [self.appDelegate.uploadQueue addOperation:operation];
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    self.galleryReady = YES;
    if (self.webReady==YES) {
        [self setupInitialGallery];
    }
}

- (void)setupInitialGallery
{
    self.loadingLabel.text = @"Building your AnyCloud...";
    
    NSMutableArray* assets = [NSMutableArray array];
    //edit methods here
    ALAssetsGroup* group = [ASAssetsLibrary sharedInstance].groups[0];
    if (group == nil) {
         self.sidePanelController.centerPanel = [self.storyboard instantiateViewControllerWithIdentifier:@"photoErrorViewController"];
        [self.sidePanelController showCenterPanelAnimated:NO];
        
    } else {
    [group setAssetsFilter:[ALAssetsFilter allAssets]];
    int photoCount = [group numberOfAssets];
    Photo *myPhoto = [Photo alloc];
    NSLog(@"There are %i photos found.",photoCount);
    //instantiate myDatabaseURLs so that it may be populated
    NSMutableArray *myDatabaseURLs = [[NSMutableArray alloc] init];
    
    //populate myDatabaseURLs with the URL from each row of the database
    [myPhoto getCurrentPhotos:myDatabaseURLs];
    
    [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,photoCount)] options:0 usingBlock:^(ALAsset *result,NSUInteger index,BOOL *innerStop) {
        
        if (result){
            //check the ALAsset here?
            
            /////////////////////////////////////////////////////
            NSArray *assetKeys = [[result valueForProperty:ALAssetPropertyURLs] allKeys]; //all data keys for ALAsset
            
            //if the ALAsset is a photo (redundant check, also done above)
            if ([[result valueForProperty:ALAssetPropertyType]isEqualToString:ALAssetTypePhoto]) {
                //
                
                NSURL *myURL = [[result valueForProperty:ALAssetPropertyURLs] objectForKey:[assetKeys objectAtIndex:0]];
                //create new Photo class instance
                myPhoto.photoTimestamp = [[result valueForProperty:ALAssetPropertyDate] timeIntervalSince1970];
                myPhoto.photoLocation = @"camera_roll";
                myPhoto.photoURL = [myURL absoluteString];
                myPhoto.photoCategory = @"none";
                myPhoto.photoAction = @"none";
                
                //if url doesn't exist in current array
                if (![myPhoto alreadyExists:myPhoto.photoURL]) {
                    [myDatabaseURLs addObject:myPhoto.photoURL]; //add the url to the array so that the array contains it
                    [myPhoto insertPhoto:myPhoto]; //adds this as a new row to the database
                    
                }
                
                //TODO: IF MYDATABASEURLS CONTAINS IT
                if ([myDatabaseURLs containsObject:myPhoto.photoURL]) {
                    ALAssetAdapter* asset = [[ALAssetAdapter alloc] init];
                    asset.asset = result;
                    
                    [assets addObject:asset];
                }
                
            }
            
            /////////////////////////////////////////////////////
            
        }else{
            
            [self.loadingImageView stopAnimating];
            [self.loadingImageView removeFromSuperview];
           
            GalleryViewController* galleryViewController = [[GalleryViewController alloc] init];
            galleryViewController.assets = assets;
            
            self.sidePanelController.centerPanel = galleryViewController;
        
        }
        
        
        
    }];
    }
}

- (void)changeFrames
{
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if ((orientation == 0) || (orientation == UIInterfaceOrientationPortrait)) {
        //nav bar title and spinner view
        [self.view viewWithTag:2000].frame = CGRectMake(0, 7, [[UIScreen mainScreen] bounds].size.width, 30);
        
    } else if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        //nav bar title and spinner view
        [self.view viewWithTag:2000].frame = CGRectMake(0, 7, [[UIScreen mainScreen] bounds].size.height, 30);
    }
    
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self changeFrames];
}

- (void)connectToWebApp
{
    self.loadingLabel.text = @"Connecting to AnyCloud...";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://staging.anycloud.co/api"]];
    //[request setURL:[NSURL URLWithString:@"http://www.anycloud.co/api"]];
    //[request setURL:[NSURL URLWithString:@"http://10.0.1.44:8080/api"]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLConnection *myConnection = [[NSURLConnection alloc] init];
    myConnection.tag = 1110;
    (void)[myConnection initWithRequest:request delegate:self];
    
}

- (void)populateDispositions
{
    self.loadingLabel.text = @"Loading your accounts...";
    NSString *secret = @"888fe04088f29c8462c3195359e15d26";
    NSString *post =[[NSString alloc] initWithFormat:@"aczsecret=%@&accessToken=%@",secret,FBSession.activeSession.accessTokenData.accessToken];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[self.appDelegate webAppURL]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:postData];
    
    
    NSURLConnection *myConnection = [[NSURLConnection alloc] init];
    myConnection.tag = 2110;
    (void)[myConnection initWithRequest:request delegate:self];
}

#pragma mark NSURLConnection Delegate Methods
//TENTATIVE - WHAT HAPPENS WHEN THE CONNECTION FIRST RECEIVES DATA
- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{

}

//TENTATIVE - WHAT HAPPENS AS THE CONNECTION BEGINS RECEIVING DATA
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    
    if (connection.tag.intValue == 1110) {
        // Append the new data to the instance variable you declared
        //[responseData appendData:data];
        
        NSError* error;
        NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        //NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
        NSString *theReply = [dictionary objectForKey:@"aczEndpoint"];
        
        NSLog(@"The ACZ Endpoint is: %@",theReply);
        if (theReply)
            appDelegate.webAppURL = theReply;
        
        //NOW CHANGE THE TEXT
        
        
        [self populateDispositions];
        
    } else if (connection.tag.intValue == 2110) {
        
        NSError* error;
        NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        NSString *theReply = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding: NSASCIIStringEncoding];
        
        NSLog(@"My accounts are:%@",theReply);
        
        //POPULATE DISPOSITIONS ARRAY BASED ON ACCOUNTS RETRIEVED HERE
        NSArray *reply_accounts = [dictionary objectForKey:@"accounts"]; //array of all accounts
        self.appDelegate.myDispositions = [NSMutableDictionary dictionary];
        
        for (int x = 0; x < [reply_accounts count]; x++) {
            if (([[reply_accounts[x] objectForKey:@"can_upload"] boolValue] == YES)|| ([[reply_accounts[x] objectForKey:@"display"] isEqualToString:@"Facebook"])) {
            [self.appDelegate.myDispositions setObject:[reply_accounts[x] objectForKey:@"aid"] forKey:[reply_accounts[x] objectForKey:@"display"]];
            }
        }
        
        //USER ID INSTANCE VARIABLE, SWITCH TO KEYCHAIN IN THE FUTURE
        self.appDelegate.myUserID = [[dictionary objectForKey:@"id"] integerValue]; //user ID
        
        self.loadingLabel.text = @"Finding your photos...";
        self.webReady = YES;
        
        [self resumeUploads];
        //done with this stuff
        if (galleryReady==YES) {
            [self setupInitialGallery];
        }
    }
}

//EMPTY - WHAT HAPPENS WHEN A RESPONSE IS CACHED
- (NSCachedURLResponse*)connection:(NSURLConnection*)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

//TENTATIVE - WHAT HAPPENS AFTER THE CONNECTION SUCCEEDS
- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    
}

//TENTATIVE - WHAT HAPPENS IF THE CONNECTION FAILS
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"A connection has failed with the error %@",error);
}

- (void)dealloc
{
    [[ASAssetsLibrary sharedInstance] removeObserver:self forKeyPath:@"groups"];
}

@end
