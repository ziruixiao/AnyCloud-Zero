//
//  LeftViewController.m
//  AnyCloudZero
//
//  Created by Felix Xiao on 6/25/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import "LeftViewController.h"
#import "ASAssetsLibrary.h"
#import "GalleryViewController.h"
#import "ALAssetAdapter.h"
#import "UIViewController+JASidePanel.h"
#import "MenuViewController.h"
#import "DefaultViewController.h"
#import "TDBadgedCell.h"
#import "TutorialViewController.h"

@interface LeftViewController ()
@end


@implementation LeftViewController
//SYNTHESIZE PROPERTIES
@synthesize appDelegate,tableView;

//TENTATIVE - WHAT HAPPENS BEFORE THE VIEW IS SHOWN
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

//TENTATIVE - WHAT HAPPENS AFTER THE VIEW IS SHOWN
- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:FBSessionStateChangedNotification
     object:nil];
    
    [[ASAssetsLibrary sharedInstance] addObserver:self forKeyPath:@"groups" options:0 context:nil];
}

//DONE - SHOWS POPUP FOR A LOGO TAP
- (IBAction)logoTapDetected
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm Reset"
                                                    message:@"Are you sure you want to reset AnyCloudZero?" delegate:self cancelButtonTitle: @"Cancel"
                                          otherButtonTitles:@"Continue", nil];
    [alert show];
}

#pragma mark UIAlertView Delegate Methods
//DONE PROCESSES ALERY VIEW
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
    [self showSpinner];
    //basically make everything
    Photo *myPhoto = [Photo alloc];
    [myPhoto resetDB];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"AnyClouZero"
                                                    message:@"Your app has been completely reset!"
                                                   delegate:self
                                          cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:nil];
    [alert show];
}

//DONE - RELOADS THE TABLE VIEW
- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
    [self.tableView reloadData];
}

#pragma mark - Table view data source
//DONE - NUMBER OF SECTIONS IN THE TABLE
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    // Return the number of sections.
    return 3;
}

//DONE - NUMBER OF ROWS IN THE TABLE
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return [[ASAssetsLibrary sharedInstance].groups count]+2;
    if (section == 0 || section == 2)
        return 1;
    else
        return 3;
}

//TENTATIVE - SHOWS THE ACTUAL CELLS AND LOADS THEM WITH CONTENT
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    Photo *toolPhoto = [[Photo alloc] init];
    int myArray[3] = {0,0,0};
    
    [toolPhoto getMenuCounts:myArray];
    
    static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    TDBadgedCell *cell = [[TDBadgedCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    if (indexPath.section==0) {
        UIImageView *leftMenuImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"anycloud_logo_256.png"]];
        leftMenuImage.frame = CGRectMake(0,0,256,44);
        [cell addSubview:leftMenuImage];
        return cell;
    }
    
    if (indexPath.section==2) {
        cell.textLabel.text = @"Tutorial";
        return cell;
    }
    
    // Configure the cell...
    // Load future sources
    cell.badge.radius = 12;
    cell.badge.fontSize = 18;
    cell.badge.badgeTextColor = [UIColor blackColor];
    cell.badge.showShadow = NO;
    
    if (indexPath.row==1000) {
        cell.imageView.image = [UIImage imageNamed:@"left_shared.png"];
        cell.textLabel.text = @"Uploaded";
        cell.badgeString = [NSString stringWithFormat:@"%i",myArray[2]];
        cell.badgeColor = [UIColor colorWithRed:102/255.0 green:255/255.0 blue:102/255.0 alpha:1.000];
        
    }
    
    if (indexPath.row==2) {
        //reset button
        cell.imageView.image = [UIImage imageNamed:@"left_reset.png"];
        cell.textLabel.text = @"Reset";
        cell.detailTextLabel.text = @"Clear Data";
    }
    
    if (indexPath.row==0) {
        cell.textLabel.text = @"Camera Roll";
        cell.imageView.image = [UIImage imageNamed:@"left_cameraroll.png"];
        cell.badgeString = [NSString stringWithFormat:@"%i",myArray[0]];
        [UIApplication sharedApplication].applicationIconBadgeNumber = myArray[0];
        cell.badgeColor = [UIColor colorWithRed:102/255.0 green:204/255.0 blue:255/255.0 alpha:1.000];
    }
    
    if (indexPath.row==1) {
        
        cell.textLabel.text = @"Hidden";
        cell.imageView.image = [UIImage imageNamed:@"left_hidden.png"];
        cell.badgeString = [NSString stringWithFormat:@"%i",myArray[1]];
        cell.badgeColor = [UIColor colorWithRed:255/255.0 green:102/255.0 blue:102/255.0 alpha:1.000];
    }
    
    return cell;
}

#pragma mark - Table view delegate
//TENTATIVE - LOADS PHOTOS FROM THE CAMERA ROLL AND INSTANTIATES GALLERYVIEWCONTROLLER
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    if (indexPath.section==0) {
        return;
    }
    
    if (indexPath.section==2) {
        //if (appDelegate.isFirstLaunch) {
        TutorialViewController *tutorialViewController = (TutorialViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"tutorialViewController"];
        
        [self presentViewController:tutorialViewController animated:NO completion:nil];
        self.appDelegate.isFirstLaunch = NO;
        //}
    }
    if (indexPath.row==2) {
        
        //reset stuff
        [(MenuViewController*)self.sidePanelController promptReset];
        
        
    } else {
    
    
    NSMutableArray* assets = [NSMutableArray array];
    //edit methods here
    ALAssetsGroup* group = [ASAssetsLibrary sharedInstance].groups[0];
    [group setAssetsFilter:[ALAssetsFilter allPhotos]];
    int photoCount = [group numberOfAssets];
    Photo *myPhoto = [Photo alloc];
    
    //instantiate myDatabaseURLs so that it may be populated
    NSMutableArray *myDatabaseURLs = [[NSMutableArray alloc] init];
    
    //populate myDatabaseURLs with the URL from each row of the database
        
        if (indexPath.row==0) {
            [myPhoto getCurrentPhotos:myDatabaseURLs];
        } else if (indexPath.row==1) {
            [myPhoto getHiddenPhotos:myDatabaseURLs];
        } else if (indexPath.row==100) {
            [myPhoto getDispositionPhotos:myDatabaseURLs];
        }
    [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,photoCount)] options:0 usingBlock:^(ALAsset *result,NSUInteger index,BOOL *innerStop) {
        
        if (result){
            //check the ALAsset here?
            
            /////////////////////////////////////////////////////
            NSArray *assetKeys = [[result valueForProperty:ALAssetPropertyURLs] allKeys]; //all data keys for ALAsset
            
            //if the ALAsset is a photo (redundant check, also done above)
            if ([[result valueForProperty:ALAssetPropertyType]isEqualToString:ALAssetTypePhoto]) {

                
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
                
                if ([myDatabaseURLs containsObject:myPhoto.photoURL]) {
                    ALAssetAdapter* asset = [[ALAssetAdapter alloc] init];
                    asset.asset = result;
                    
                    [assets addObject:asset];
                }
                
            }
            
            
        }else{
            for (UIImageView *myImage in self.view.subviews) {
                if (myImage.tag == 998) {
                    [myImage removeFromSuperview];
                }
            }
            
            GalleryViewController* galleryViewController = [[GalleryViewController alloc] init];
            galleryViewController.assets = assets;
            
            if (indexPath.row==1) {
                galleryViewController.sources = [NSArray arrayWithObject:@"hide"];
            } else if (indexPath.row == 2){
                galleryViewController.sources = [NSArray arrayWithObject:@"dispositioned"];
                
            } else {
                
            }
            self.sidePanelController.centerPanel = galleryViewController;
            [self.sidePanelController showCenterPanelAnimated:YES];

        }
        
    }];
    }
}

//DONE - SHOWS ANYCLOUD SPINNER
- (void)showSpinner
{
    UIImageView* animatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(130,254,60,60)];
    animatedImageView.animationImages = [NSArray arrayWithObjects:
                                         [UIImage imageNamed:@"0.gif"],
                                         [UIImage imageNamed:@"1.gif"],
                                         [UIImage imageNamed:@"2.gif"],
                                         [UIImage imageNamed:@"3.gif"],
                                         [UIImage imageNamed:@"4.gif"], nil];
    animatedImageView.animationDuration = 0.5f;
    animatedImageView.tag = 998;
    animatedImageView.animationRepeatCount = 0;
    [animatedImageView startAnimating];
    [self.view addSubview: animatedImageView];
}


//OPTIONAL - RELEASE NECESSARY INSTANCES
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[ASAssetsLibrary sharedInstance] removeObserver:self forKeyPath:@"groups"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

@end
