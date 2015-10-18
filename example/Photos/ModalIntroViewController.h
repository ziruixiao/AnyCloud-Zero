//
//  ModalIntroViewController.h
//  AnyCloudZero
//
//  Created by Felix Xiao on 7/3/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ModalIntroViewController : UIViewController

@property (strong,nonatomic) AppDelegate *appDelegate;
@property (strong,nonatomic) IBOutlet UIImageView *introImageView;
@property BOOL shouldShowError;
- (IBAction)authButtonAction;
- (void)showFBLogin;
- (void)moveToDefault;

@end
