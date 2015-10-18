//
//  TutorialViewController.m
//  AnyCloudZero
//
//  Created by Felix Xiao on 8/5/13.
//  Copyright (c) 2013 Felix Xiao. All rights reserved.
//

#import "TutorialViewController.h"

@interface TutorialViewController ()

@end

@implementation TutorialViewController

@synthesize view1,screenView,view2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setupScreenView
{
    UIImageView *tutorialImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,255,353)];
    tutorialImageView.tag = 999;
    tutorialImageView.image = [UIImage imageNamed:@"anycloud_photo1.png"];
    [self.screenView addSubview:tutorialImageView];
    
    UIButton *buttonFB = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect topButtonFrame = CGRectMake(173,0,80,80);
    buttonFB.frame = topButtonFrame;
    [buttonFB setImage:[UIImage imageNamed:@"facebook_circle_B.png"] forState:UIControlStateNormal];
    [buttonFB addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    buttonFB.adjustsImageWhenHighlighted = NO;
    buttonFB.tag = 101;
    buttonFB.alpha = 0.7;
    [self.screenView addSubview:buttonFB];
}

- (IBAction)transitionToTutorial:(id)sender
{
    [UIView animateWithDuration:1.0f
                     animations:^{
                         [view2 setCenter:CGPointMake(view1.center.x,view1.center.y)];
                         [view1 setCenter:CGPointMake(160, -284)];
                         [self setupScreenView];
                         
                         
                     }
     ];
}

- (IBAction)nextStep:(id)sender
{
    UIButton *pressedButton = (UIButton*)sender;
    if (pressedButton.tag == 101) {
        //remove FB button
        [pressedButton removeFromSuperview];
        
        ((UIImageView*)[self.view viewWithTag:999]).image = [UIImage imageNamed:@"anycloud_photo2.png"];
        
        //show next one
        UIButton *buttonFB = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect topButtonFrame = CGRectMake(88,0,80,80);
        buttonFB.frame = topButtonFrame;
        [buttonFB setImage:[UIImage imageNamed:@"dropbox_circle_B.png"] forState:UIControlStateNormal];
        [buttonFB addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
        buttonFB.adjustsImageWhenHighlighted = NO;
        buttonFB.tag = 102;
        buttonFB.alpha = 0.7;
        [self.screenView addSubview:buttonFB];
    
    } else if (pressedButton.tag == 102) {
        //remove Dropbox button
        [pressedButton removeFromSuperview];
        
        //show alert that they can add more accounts at any time on the anycloud.co site
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connect Accounts"
                                                        message:@"You can connect more accounts at AnyCloud.co." delegate:self cancelButtonTitle: @"Later"
                                              otherButtonTitles:@"Now", nil];
        [alert show];
        
        //stuff for hidden
        ((UIImageView*)[self.view viewWithTag:999]).image = [UIImage imageNamed:@"anycloud_photo3.png"];
        
        //show next one
        UIButton *buttonFB = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect topButtonFrame = CGRectMake(88,240,80,80);
        buttonFB.frame = topButtonFrame;
        [buttonFB setImage:[UIImage imageNamed:@"trash_circle_B.png"] forState:UIControlStateNormal];
        [buttonFB addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
        buttonFB.adjustsImageWhenHighlighted = NO;
        buttonFB.tag = 103;
        buttonFB.alpha = 0.7;
        [self.screenView addSubview:buttonFB];
    } else if (pressedButton.tag == 103) {
        //done
        ((UIImageView*)[self.view viewWithTag:999]).image = [UIImage imageNamed:@"anycloud_photo4.png"];
        [self.view viewWithTag:701].hidden = NO;
    }
}

- (IBAction)dismiss:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}





#pragma mark UIAlertView Delegate Methods
//DONE PROCESSES ALERT VIEW
- (void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //nothing
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.anycloud.co"]];
    }
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
