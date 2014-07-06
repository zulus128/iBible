//
//  ViewController.m
//  iBible
//
//  Created by вадим on 7/6/14.
//  Copyright (c) 2014 вадим. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.innerViewHeight.constant = 44.5f;
    self.csHeight.constant = 37.5f;
    self.csWidth.constant = 53.5f;
    self.spaceBetweenRuCs.constant = 13.5f;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    self.curLanguage = [prefs integerForKey:LNG_USERDEF];
    switch (self.curLanguage) {
        default:
            [self langButtonPressed:self.buttonRus];
            break;
        case lngCs:
            [self langButtonPressed:self.buttonCs];
            break;
    }
 
    statusBarVisible = YES;
}

- (BOOL)prefersStatusBarHidden
{
    return !statusBarVisible;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)langButtonPressed:(id)sender {

    float x, w;
    switch (((UIButton*)sender).tag) {
        default:
            x = self.buttonRus.frame.origin.x;
            w = self.buttonRus.frame.size.width;
            self.curLanguage = lngRu;
            break;
        case lngCs:
            x = self.buttonCs.frame.origin.x;
            w = self.buttonCs.frame.size.width;
            self.curLanguage = lngCs;
            break;
    }

    float y = self.view.frame.size.height - 3.5f;
//    float y = 300;
    UIView* prev = [self.view viewWithTag:UNDERLINE_TAG];
    [prev removeFromSuperview];
    
    UIView* new = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, 3.5f)];
    new.tag = UNDERLINE_TAG;
    new.backgroundColor = [UIColor colorWithRed:102/255.0f green:76/255.0f blue:15/255.0f alpha:1];
    [self.view addSubview:new];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:self.curLanguage forKey:LNG_USERDEF];
    [prefs synchronize];
}

- (IBAction)menuButtonPressed:(id)sender {
    
    statusBarVisible = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    
    CGRect f = self.view.frame;
    UIView* blue = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
    blue.tag = BLUEFON_TAG;
    blue.backgroundColor = [UIColor colorWithRed:0x0e/255.0f green:0x22/255.0f blue:0x33/255.0f alpha:0.9f];
    [self.view addSubview:blue];
 
    [NSLayoutConstraint constraintWithItem:blue attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationEqual toItem:self.view
                                 attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
    [NSLayoutConstraint constraintWithItem:blue attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual toItem:self.view
                                 attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
    [NSLayoutConstraint constraintWithItem:blue attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual toItem:self.view
                                 attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    [NSLayoutConstraint constraintWithItem:blue attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual toItem:self.view
                                 attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];

}

@end
