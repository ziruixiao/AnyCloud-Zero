//
//  DefaultViewController.h
//  AnyCloudZero
//
//  Created by Felix Xiao on 6/25/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface DefaultViewController : UIViewController
@property (strong,nonatomic) IBOutlet UIImageView *loadingImageView;
@property (strong,nonatomic) IBOutlet UILabel *loadingLabel;
@property (strong,nonatomic) AppDelegate *appDelegate;
@property BOOL galleryReady;
@property BOOL webReady;

- (void)setupInitialGallery;
- (void)populateDispositions;
- (void)connectToWebApp;
- (void)resumeUploads;

@end
