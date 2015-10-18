//
//  ErrorViewController.m
//  AnyCloudZero
//
//  Created by Felix Xiao on 7/15/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import "ErrorViewController.h"
#import "UIViewController+JASidePanel.h"
#import "MenuViewController.h"

@interface ErrorViewController ()

@end

@implementation ErrorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)tryAgain:(id)sender
{
    DefaultViewController *centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"defaultViewController"];
    [self.sidePanelController setCenterPanel:centerViewController];
    [centerViewController setupInitialGallery];
}

- (BOOL)shouldAutorotate {
    return NO;
}

// iOS 6 interface orientation support. Only rotate on iPad.
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
