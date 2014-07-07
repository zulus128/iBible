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
    
    [self parseJsons];
}

- (void) parseJsons
{
    NSString* grPath = [[NSBundle mainBundle] pathForResource:@"groups" ofType:@"json"];
    NSString *grs= [NSString stringWithContentsOfFile:grPath encoding:NSUTF8StringEncoding error:nil];
    NSData* tardata = [grs dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error;
    self.grsjson = [NSJSONSerialization JSONObjectWithData:tardata options:NSDataReadingUncached error:&error];
    
    if (!self.grsjson) {
        
        NSLog(@"Error parsing groups: %@", error);
        
    } else {
        
        NSLog(@"Parsing groups: OK!");
        //        NSLog(@"Parsing groups: OK! %@", self.grsjson);
    }
    
    NSString* bkPath = [[NSBundle mainBundle] pathForResource:@"books" ofType:@"json"];
    NSString *bks= [NSString stringWithContentsOfFile:bkPath encoding:NSUTF8StringEncoding error:nil];
    tardata = [bks dataUsingEncoding:NSUTF8StringEncoding];
    self.bookjson = [NSJSONSerialization JSONObjectWithData:tardata options:NSDataReadingUncached error:&error];
    
    if (!self.bookjson) {
        
        NSLog(@"Error parsing books: %@", error);
        
    } else {
        
        NSLog(@"Parsing books: OK!");
//        NSLog(@"Parsing books: OK! %@", self.bookjson);
    }
    
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

- (void) hideMenu {
    
    UIView* blue = [self.view viewWithTag:BLUEFON_TAG];
    UIView* menu = [self.view viewWithTag:MENU_TAG];

    [UIView animateWithDuration:MENUFADE_DELAY delay:0.0 options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionAllowUserInteraction|UIViewKeyframeAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         blue.alpha = 0.01f;
                         menu.alpha = 0.01f;
                         
                     }
                     completion:^(BOOL finished) {
                         
                         [blue removeFromSuperview];
                         [menu removeFromSuperview];
                     }];

}

- (void) showMenu {
    
    //    CGRect sb = [[UIApplication sharedApplication] statusBarFrame];
    //    NSLog(@"sbh = %f", sb.size.height);
    
    UIView* blue = [self getBlueFon];
    UIView* menu = [self getMenu];
    
    blue.alpha = 0.01f;
    menu.alpha = 0.01f;
    [UIView animateWithDuration:MENUFADE_DELAY delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction|UIViewKeyframeAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         blue.alpha = 1;
                         menu.alpha = 1;
                         
                     }
                     completion:^(BOOL finished) {
                     }];
    
}

- (UIView*) getBlueFon {

    UIView* blue = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
    blue.tag = BLUEFON_TAG;
    blue.backgroundColor = [UIColor colorWithRed:0x0e/255.0f green:0x22/255.0f blue:0x33/255.0f alpha:0.9f];
    [self.view addSubview:blue];
    
    [blue setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:blue attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual toItem:self.view
                                                          attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:blue attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual toItem:self.view
                                                          attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:blue attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual toItem:self.view
                                                          attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:blue attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual toItem:self.view
                                                          attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    
    //    [self.buttonMenu removeFromSuperview];
    //    [blue addSubview:self.buttonMenu];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(menuButtonPressed:)
     forControlEvents:UIControlEventTouchUpInside];
    //    button.frame = CGRectMake(80.0, 210.0, 67, 44.0);
    [button setBackgroundImage:[UIImage imageNamed:@"bottom-menu-button"] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithRed:0xee/255.0f green:0xdf/255.0f blue:0xbe/255.0f alpha:1.0f];
    [blue addSubview:button];
    NSDictionary *viewsDictionary = @{@"view":button};
    [blue addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view(==67)]" options:0 metrics:nil views:viewsDictionary]];
    [blue addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(==44)]-0-|" options:0 metrics:nil views:viewsDictionary]];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];

    return blue;
}

- (UIView*) getMenu {
    
    UIView* menu= [[UIView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
    menu.tag = MENU_TAG;
//    menu.backgroundColor = [UIColor colorWithRed:0xee/255.0f green:0xdf/255.0f blue:0xbe/255.0f alpha:1.0f];
    [self.view addSubview:menu];
    [menu setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:menu attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view                                                          attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    
    if ([self respondsToSelector:@selector(topLayoutGuide)]) {
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:menu
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.topLayoutGuide
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1
                                                               constant:0]];
    }
    else
    {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:menu attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view                                                          attribute:NSLayoutAttributeTop multiplier:1.0 constant:20.0]];
    }
    
    NSDictionary *viewsDictionary = @{@"view":menu};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[view(==303)]" options:0 metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view]-44-|" options:0 metrics:nil views:viewsDictionary]];

    //scroll
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [menu addSubview:scroll];
    NSDictionary *viewsDictionary1 = @{@"layer":scroll};
    [menu addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[layer]-0-|" options:0 metrics:nil views:viewsDictionary1]];
    [menu addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[layer]-0-|" options:0 metrics:nil views:viewsDictionary1]];
    [scroll setTranslatesAutoresizingMaskIntoConstraints:NO];
    scroll.backgroundColor = [UIColor colorWithRed:0xee/255.0f green:0xdf/255.0f blue:0xbe/255.0f alpha:1.0f];

    UIView* innerView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
//    innerView.backgroundColor = [UIColor redColor];
    [scroll addSubview:innerView];
    [innerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [scroll addConstraint:[NSLayoutConstraint constraintWithItem:innerView attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual toItem:scroll
                                                          attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [scroll addConstraint:[NSLayoutConstraint constraintWithItem:innerView attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual toItem:scroll
                                                          attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    [scroll addConstraint:[NSLayoutConstraint constraintWithItem:innerView attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual toItem:scroll
                                                          attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [scroll addConstraint:[NSLayoutConstraint constraintWithItem:innerView attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual toItem:scroll
                                                          attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];

    
    [scroll addConstraint:[NSLayoutConstraint constraintWithItem:innerView
                                                       attribute:NSLayoutAttributeHeight
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:nil
                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                      multiplier:1.0
                                                        constant:3000.0]];
    [scroll addConstraint:[NSLayoutConstraint constraintWithItem:innerView
                                                       attribute:NSLayoutAttributeWidth
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:nil
                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                      multiplier:1.0
                                                        constant:303.0]];
    
//    for (int i = 0; i < 100; i++) {
//        
//        UIView* iView= [[UIView alloc] initWithFrame:CGRectMake(0, i * 20, 15, 15)];
//        iView.backgroundColor = [UIColor yellowColor];
//        [innerView addSubview:iView];
//    }
    
    
    //Razdels
    
    UILabel* rname = [[UILabel alloc] initWithFrame:CGRectMake(17.5f, 15.5f, 300, 50)];
    rname.backgroundColor = [UIColor clearColor];
    rname.textColor = [UIColor colorWithRed:0x72/255.0f green:0x58/255.0f blue:0x1d/255.0f alpha:1.0f];
    rname.font = FONT_RAZDEL_NAME;
    rname.text = FAST_TEXT_NAME;
//    rname.backgroundColor = [UIColor greenColor];
    rname.numberOfLines = 0;
    [rname sizeToFit];
    [innerView addSubview:rname];

    
    
    
    
    
    return menu;
}

- (IBAction)menuButtonPressed:(id)sender {
    
//    NSLog(@"menu pressed");
    inMenu = !inMenu;
    
    statusBarVisible = inMenu;
    [self setNeedsStatusBarAppearanceUpdate];
    
    if(inMenu) {
        
        [self showMenu];
    }
    else {
    
        [self hideMenu];
    }
}

@end
