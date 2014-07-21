//
//  ViewController.m
//  iBible
//
//  Created by вадим on 7/6/14.
//  Copyright (c) 2014 вадим. All rights reserved.
//

#import "MainViewController.h"

@implementation NSString ( containsCategory )

- (BOOL) containsString: (NSString*) substring
{
    NSRange range = [self.lowercaseString rangeOfString : substring.lowercaseString];
    BOOL found = ( range.location != NSNotFound );
    return found;
}

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.innerViewHeight.constant = 44.5f;
    self.csHeight.constant = 37.5f;
    self.csWidth.constant = 53.5f;
    self.rusHeight.constant = 37.5f;
    self.rusWidth.constant = 53.5f;
    self.spaceBetweenRuCs.constant = 13.5f;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    self.curLanguage = [prefs integerForKey:LNG_USERDEF];
//    [self refreshUnderline];
    [self performSelector:@selector(refreshUnderline) withObject:nil afterDelay:0.2f];

 
    statusBarVisible = YES;
    
    [self parseJsons];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    openedChapts = -1;
}

- (void) refreshUnderline {

    switch (self.curLanguage) {
        default:
            [self langButtonPressed:self.buttonRus];
            break;
        case lngCs:
            [self langButtonPressed:self.buttonCs];
            break;
    }
}

-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    UIView* prev = [self.view viewWithTag:UNDERLINE_TAG];
    [prev removeFromSuperview];

}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {

    [self refreshUnderline];
}

- (float) getScreenHeight {
    
    CGFloat screenHeight;
    // it is important to do this after presentModalViewController:animated:
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortraitUpsideDown){
        screenHeight = [UIScreen mainScreen].applicationFrame.size.height;
    }
    else{
        screenHeight = [UIScreen mainScreen].applicationFrame.size.width;
    }
    
    return screenHeight;
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

- (NSString*) getBookShortNameForCode:(NSString*)code/* andChapter:(int)ch*/ {
    
    for(NSDictionary* d in [self.bookjson allValues]) {

        NSString* shortEn = [d objectForKey:JSON_BOOK_SHORTEN];
        if([shortEn isEqualToString:code]) {
            
            return [d objectForKey:JSON_BOOK_SHORTRU];
        }
    }
    
    return @"N/a";
}

- (NSArray*) searchBooks:(NSString*) title {

    NSMutableArray *filteredBooks = [NSMutableArray array];
    
    for(int i = 1; i <= self.bookjson.count; i++) {
        
        NSDictionary* d = [self.bookjson objectForKey:[NSString stringWithFormat:@"%d", i]];
        NSString* s = [d objectForKey:JSON_BOOK_DISPLAYNAME];
        if(!title.length || [s containsString:title]){
            
            [filteredBooks addObject:d];
        }
    }
//    if(title.length < 3) {//including ''
//        
//        filteredBooks = [self.bookjson allValues];
//        
//    }
//    else {
//        NSPredicate *filter = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ contains[c] %@", JSON_BOOK_DISPLAYNAME, title]];
//        filteredBooks = [[self.bookjson allValues] filteredArrayUsingPredicate:filter];
//    }

    NSLog(@"cnt = %d", filteredBooks.count);
    return filteredBooks;
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

//    float x, w;
    UIView* but;
    switch (((UIButton*)sender).tag) {
        default:
//            x = self.buttonRus.frame.origin.x;
//            w = self.buttonRus.frame.size.width;
            but = self.buttonRus;
            self.curLanguage = lngRu;
            break;
        case lngCs:
//            x = self.buttonCs.frame.origin.x;
//            w = self.buttonCs.frame.size.width;
            but = self.buttonCs;
            self.curLanguage = lngCs;
            break;
    }

//    float y = [self getScreenHeight] - 3.5f;
//    y = 300;
//    NSLog(@"y = %f", [self getScreenHeight]);
    UIView* prev = [self.view viewWithTag:UNDERLINE_TAG];
    [prev removeFromSuperview];
//    UIView* new = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, 3.5f)];
    UIView* new = [[UIView alloc] initWithFrame:CGRectMake(0, but.frame.size.height - 0.5f, but.frame.size.width, 3.5f)];
    new.tag = UNDERLINE_TAG;
    new.backgroundColor = [UIColor colorWithRed:102/255.0f green:76/255.0f blue:15/255.0f alpha:1];
//    [self.view addSubview:new];
    
    [but addSubview:new];
    
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
                         
                         [self setNeedsStatusBarAppearanceUpdate];

                     }];

}

- (void) showMenu {
    
    //    CGRect sb = [[UIApplication sharedApplication] statusBarFrame];
    //    NSLog(@"sbh = %f", sb.size.height);

    [self setNeedsStatusBarAppearanceUpdate];
  
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
    button.backgroundColor = MENU_FON_COLOR;
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
    scroll.backgroundColor = MENU_FON_COLOR;
    scroll.tag = SCROLL_TAG;
    
    self.innerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
//    innerView.backgroundColor = [UIColor redColor];
    [scroll addSubview:self.innerView];
    [self.innerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [scroll addConstraint:[NSLayoutConstraint constraintWithItem:self.self.innerView attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual toItem:scroll
                                                          attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0]];
    [scroll addConstraint:[NSLayoutConstraint constraintWithItem:self.innerView attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual toItem:scroll
                                                          attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0]];
    [scroll addConstraint:[NSLayoutConstraint constraintWithItem:self.innerView attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual toItem:scroll
                                                          attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    [scroll addConstraint:[NSLayoutConstraint constraintWithItem:self.innerView attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual toItem:scroll
                                                          attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];

    self.scrollHeight = [NSLayoutConstraint constraintWithItem:self.innerView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0
                                                      constant:3000.0];
    [scroll addConstraint:self.scrollHeight];
    [scroll addConstraint:[NSLayoutConstraint constraintWithItem:self.innerView
                                                       attribute:NSLayoutAttributeWidth
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:nil
                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                      multiplier:1.0
                                                        constant:303.0]];
    
    UITapGestureRecognizer *innerFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleInnerTap:)];
    [self.innerView addGestureRecognizer:innerFingerTap];
    
    //Razdels
    
    UILabel* rname = [[UILabel alloc] initWithFrame:CGRectMake(17.5f, 15.5f, 300, 50)];
    rname.backgroundColor = [UIColor clearColor];
    rname.textColor = [UIColor colorWithRed:0x72/255.0f green:0x58/255.0f blue:0x1d/255.0f alpha:1.0f];
    rname.font = FONT_RAZDEL_NAME;
    rname.text = FAST_TEXT_NAME;
//    rname.backgroundColor = [UIColor greenColor];
    rname.numberOfLines = 0;
    [rname sizeToFit];
    [self.innerView addSubview:rname];

    for(int i = 1; i <= self.grsjson.count; i++) {
        
        NSDictionary* gr = [self.grsjson objectForKey:[NSString stringWithFormat:@"%d", i]];
//        NSLog(@"i = %d, gr = %@", i, [gr objectForKey:JSON_BOOK_LASTCODE]);
        
        UIView* grview = [[UIView alloc] initWithFrame:CGRectMake(16.0f + (i - 1) * 95 - COVER_DELTAX, 40.5f, 80 + 2 * COVER_DELTAX, 100 + COVER_DELTAY)];
//        grview.backgroundColor = [UIColor greenColor];
        [self.innerView addSubview:grview];

        UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(COVER_DELTAX, 0, 80, 100)];
        iv.image = [UIImage imageNamed:[NSString stringWithFormat:@"group-%d", i]];
        [grview addSubview:iv];

        UILabel* cname = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, grview.frame.size.width, 25)];
        cname.backgroundColor = [UIColor clearColor];
//        cname.backgroundColor = [UIColor blueColor];
        cname.textColor = [UIColor colorWithRed:0x48/255.0f green:0x39/255.0f blue:0x0b/255.0f alpha:1.0f];
        cname.font = FONT_COVER_NAME;
        cname.text = [gr objectForKey:JSON_GROUP_NAME];
        [cname setTextAlignment:NSTextAlignmentCenter];
        [grview addSubview:cname];
        
        UILabel* cpart = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, grview.frame.size.width, 20)];
        cpart.backgroundColor = [UIColor clearColor];
//        cpart.backgroundColor = [UIColor blueColor];
        cpart.textColor = [UIColor colorWithRed:0xb4/255.0f green:0x94/255.0f blue:0x4f/255.0f alpha:1.0f];
        cpart.font = FONT_COVER_NAME;
        NSString* cn = [self getBookShortNameForCode:[gr objectForKey:JSON_BOOK_LASTCODE]];
        NSNumber* nn = [gr valueForKey:JSON_BOOK_LASTCHAPTER];
        cpart.text = [NSString stringWithFormat:@"%@. %d", cn, nn.intValue];
        [cpart setTextAlignment:NSTextAlignmentCenter];
        [grview addSubview:cpart];
        
        grview.tag = i;
        UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGroupTap:)];
        [grview addGestureRecognizer:singleFingerTap];

    }
    
    //Separator
    
    UIView* sepview = [[UIView alloc] initWithFrame:CGRectMake(0, 195, 303, 1)];
    sepview.backgroundColor = [UIColor colorWithRed:0xb4/255.0f green:0x94/255.0f blue:0x4f/255.0f alpha:1.0f];
    [self.innerView addSubview:sepview];

    //All books
    
    UILabel* bname = [[UILabel alloc] initWithFrame:CGRectMake(17.5f, sepview.frame.origin.y + 15.5f, 300, 50)];
    bname.backgroundColor = [UIColor clearColor];
    bname.textColor = [UIColor colorWithRed:0x72/255.0f green:0x58/255.0f blue:0x1d/255.0f alpha:1.0f];
    bname.font = FONT_RAZDEL_NAME;
    bname.text = ALLBOOKS_TEXT_NAME;
    //    rname.backgroundColor = [UIColor greenColor];
    bname.numberOfLines = 0;
    [bname sizeToFit];
    [self.innerView addSubview:bname];
   
    UISearchBar* sbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, bname.frame.origin.y + 20, 303, 44)];

    sbar.delegate = self;
    sbar.layer.borderWidth = 2;
    sbar.layer.borderColor = [MENU_FON_COLOR CGColor];
    sbar.barTintColor = MENU_FON_COLOR;
    sbar.placeholder = SEARCH_PLACEHOLDER;

    CGSize size = CGSizeMake(300, 30);
    UIGraphicsBeginImageContextWithOptions(size, NO, 1);
    [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 300, 30) cornerRadius:5.0] addClip];
    [SEARCHBAR_FON_COLOR setFill];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [sbar setSearchFieldBackgroundImage:image forState:UIControlStateNormal];
    sbar.tag = SEARCHBAR_TAG;
    [self.innerView addSubview:sbar];

    [self setSearchResults:@""];
    
    return menu;
}

- (void) setSearchResults:(NSString*) text {
    
//    self.res = [self searchBooks:[NSString stringWithFormat:@"'%@'", text]];
    self.res = [self searchBooks:text];
//    NSLog(@"res = %@", self.res);

    UIView* noresv = [self.innerView viewWithTag:NORESULTS_TAG];
    [noresv removeFromSuperview];

    UIView* sres = [self.innerView viewWithTag:SEARCHRESULTS_TAG];
    if(!self.res.count && text.length) {
        
        [sres removeFromSuperview];
        
        UILabel* nores = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 300, 50)];
        nores.backgroundColor = [UIColor clearColor];
        nores.textColor = [UIColor colorWithRed:0xb6/255.0f green:0xab/255.0f blue:0x92/255.0f alpha:1.0f];
        nores.font = FONT_NORES_NAME;
        nores.text = NORES_TEXT;
        nores.tag = NORESULTS_TAG;
        [nores setTextAlignment:NSTextAlignmentCenter];
        [self.innerView addSubview:nores];
        
        [self refreshNoRes:NO];

    }
    else {
        
        if(!sres) {
            
            sres = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 303, 0)];
            sres.backgroundColor = [UIColor whiteColor];
            sres.tag = SEARCHRESULTS_TAG;
//            sres.userInteractionEnabled = YES;
            [self.innerView addSubview:sres];
//            UITapGestureRecognizer *innerFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleInnerTap:)];
//            [self.innerView addGestureRecognizer:innerFingerTap];


        }
        
        for(UIView* c in sres.subviews) {
            
            [c removeFromSuperview];
        }
        
        UIView* sbar = [self.innerView viewWithTag:SEARCHBAR_TAG];
        CGRect f = sres.frame;
        sres.frame = CGRectMake(f.origin.x, sbar.frame.origin.y + 45, f.size.width, self.res.count * SEARCHRES_LINE_HEIGHT);
        for(int i = 0; i < self.res.count; i++) {
            
            NSDictionary* item = [self.res objectAtIndex:i];
            UIButton* button1 = [UIButton buttonWithType:UIButtonTypeCustom];
            [button1 addTarget:self action:@selector(btSelected:) forControlEvents:UIControlEventTouchUpInside];
            button1.frame = CGRectMake(19.0, SEARCHRES_LINE_HEIGHT * i, 280, SEARCHRES_LINE_HEIGHT);
            [button1 setTitle:[item objectForKey:JSON_BOOK_DISPLAYNAME] forState:UIControlStateNormal];
            button1.tag = i;
            [[button1 titleLabel] setFont:FONT_SEARCHRES_NAME];
            button1.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

            [sres addSubview:button1];
        }
        
        self.scrollHeight.constant = sbar.frame.origin.y + ((sres.frame.size.height > 460)?sres.frame.size.height:460) + 40;

    }
}

- (void) btSelected:(id)sender {

    UIButton* bt = (UIButton*)sender;
    NSLog(@"button %d pressed", bt.tag);

    [self closeChapts:bt.tag];

}

- (void) openChapts:(int)n {

    UIView* sres = [self.innerView viewWithTag:SEARCHRESULTS_TAG];
    UIView* curr = [sres viewWithTag:n];
    CGRect fcurr = curr.frame;

    NSDictionary* item = [self.res objectAtIndex:n];
    NSNumber* nch = [item valueForKey:JSON_BOOK_CHAPTERS_CNT];
    int nChapts = nch.intValue;
    int lines = nChapts / CHAPT_COLUMNS;
    if(nChapts % CHAPT_COLUMNS)
        lines++;
    
    NSLog(@"chapters = %d, lines = %d", nChapts, lines);
//    NSArray* col = [NSArray arrayWithObjects:[UIColor blueColor],[UIColor yellowColor],[UIColor greenColor],[UIColor grayColor],[UIColor redColor],[UIColor magentaColor],[UIColor cyanColor],[UIColor orangeColor],[UIColor purpleColor],[UIColor brownColor],[UIColor blackColor], nil];
    
    NSMutableArray* arrLines = [NSMutableArray arrayWithCapacity:lines];
    for(int j = lines; j >= 1; j--) {
        
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, fcurr.origin.y + 1 * SEARCHRES_LINE_HEIGHT, 300, SEARCHRES_LINE_HEIGHT)];
        line.tag = CHAPTER_LINE_TAG;
        [sres addSubview:line];
//        line.backgroundColor = (UIColor*)[col objectAtIndex:j];
        line.backgroundColor = [UIColor whiteColor];
        [arrLines addObject:line];
        
        float deltaY = (j == lines)?2.0f:0.0f;
        UIView* vert = [[UIView alloc] initWithFrame:CGRectMake(17.5f, 0, 2.5f, SEARCHRES_LINE_HEIGHT - deltaY)];
        vert.backgroundColor = VERTLINE_COLOR;
        [line addSubview:vert];
        
        for(int i = 0; i < CHAPT_COLUMNS; i++) {

            int num = (j - 1) * CHAPT_COLUMNS + 1 + i;
            if(num <= nChapts) {

                UIButton* button1 = [UIButton buttonWithType:UIButtonTypeCustom];
                [button1 addTarget:self action:@selector(cpSelected:) forControlEvents:UIControlEventTouchUpInside];
                
                button1.frame = CGRectMake(19.0f + i * 40, 0, 40, SEARCHRES_LINE_HEIGHT);
                [button1 setTitle:[NSString stringWithFormat:@"%d", num] forState:UIControlStateNormal];
                button1.tag = num;
                [[button1 titleLabel] setFont:(num > 99)?FONT_DIGITS_AFTER99_NAME:FONT_DIGITS_BEFORE99_NAME];
                [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                button1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                button1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//                button1.backgroundColor = (UIColor*)[col objectAtIndex:i];
                button1.backgroundColor = [UIColor clearColor];
                [line addSubview:button1];
            }
        }

    }
    
    [UIView animateWithDuration:SPREADLIST_DELAY * lines delay:0.0 options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionAllowUserInteraction|UIViewKeyframeAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         for (int i = (n + 1); i < self.res.count; i++) {
                             
                             UIView* bu = [sres viewWithTag:i];
                             CGRect f = bu.frame;
                             bu.frame = CGRectMake(f.origin.x, f.origin.y + lines * SEARCHRES_LINE_HEIGHT, f.size.width, f.size.height);
                         }
                         
                         for(int i = lines - 1; i >= 0; i--) {
                             
                             UIView* v = [arrLines objectAtIndex:i];
                             CGRect f = v.frame;
                             v.frame = CGRectMake(0, f.origin.y + (lines - i - 1) * SEARCHRES_LINE_HEIGHT, 300, f.size.height);
                         }


                     }
                     completion:^(BOOL finished) {
                         
                     }];

}

- (void) closeChapts:(int)n {

    if((openedChapts < 0) && (n >= 0)) {

        openedChapts = n;
        [self openChapts:n];
        return;
    }
    
    UIView* sres = [self.innerView viewWithTag:SEARCHRESULTS_TAG];
    UIView* curr = [sres viewWithTag:openedChapts];
    CGRect fcurr = curr.frame;
    
    NSDictionary* item = [self.res objectAtIndex:openedChapts];
    NSNumber* nch = [item valueForKey:JSON_BOOK_CHAPTERS_CNT];
    int nChapts = nch.intValue;
    int lines = nChapts / CHAPT_COLUMNS;
    if(nChapts % CHAPT_COLUMNS)
        lines++;

    [UIView animateWithDuration:SPREADLIST_DELAY * lines delay:0.0 options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionAllowUserInteraction|UIViewKeyframeAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         for (int i = (openedChapts + 1); i < self.res.count; i++) {
                             
                             UIView* bu = [sres viewWithTag:i];
                             CGRect f = bu.frame;
                             bu.frame = CGRectMake(f.origin.x, f.origin.y - lines * SEARCHRES_LINE_HEIGHT, f.size.width, f.size.height);
                         }

                         for(UIView* v in sres.subviews) {
                             if(v.tag == CHAPTER_LINE_TAG) {
                                 
                                 v.frame = CGRectMake(0, fcurr.origin.y + 1 * SEARCHRES_LINE_HEIGHT, 300, SEARCHRES_LINE_HEIGHT);
                             }
                             
                         }
                         
                     }
                     completion:^(BOOL finished) {

                         for(UIView* v in sres.subviews) {
                             
                             if(v.tag == CHAPTER_LINE_TAG) {
                                 
                                 [v removeFromSuperview];
                             }
                             
                         }
                         
                         if(openedChapts == n) {
                             
                             openedChapts = -1;
                             
                         }
                         else {
                             
                             openedChapts = n;
                             if(n >= 0)
                                 [self openChapts:n];
                         }

                         
                     }];

}

- (void) cpSelected:(id)sender {
    
    UIButton* bt = (UIButton*)sender;
    NSLog(@"chapter %d selected", bt.tag);
    
}

- (void) refreshNoRes:(BOOL)anim {

    UIView* nores = [self.innerView viewWithTag:NORESULTS_TAG];

    UIView* sbar = [self.innerView viewWithTag:SEARCHBAR_TAG];
    float y = ([self getScreenHeight] - keybHeight) / 2;
    y += sbar.frame.origin.y;
    y -= 20;
    
//    NSLog(@"y = %f %f", y, sres.frame.origin.y);

//    CGRect f = nores.frame;
//    nores.frame = CGRectMake(f.origin.x, 800, f.size.width, f.size.height);

    CGRect f = nores.frame;
    [UIView animateWithDuration:anim?0.1f:0.0f delay:0.0 options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionAllowUserInteraction|UIViewKeyframeAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         nores.frame = CGRectMake(f.origin.x, y, f.size.width, f.size.height);
                     }
                     completion:^(BOOL finished) {
                         
                     }];

    self.scrollHeight.constant = sbar.frame.origin.y - 40 + [self getScreenHeight];

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
 
    if(openedChapts > 0)
        [self closeChapts:-1];

//    NSLog(@"search: %@", searchText);
    [self setSearchResults:searchText];
    
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    [self performSelector:@selector(scrollToSearch) withObject:nil afterDelay:0.1f];

}

- (void) scrollToSearch {

    UIView* menu = [self.view viewWithTag:MENU_TAG];
    UIScrollView* scrollView = (UIScrollView*)[menu viewWithTag:SCROLL_TAG];
    [scrollView setContentOffset:CGPointMake(0, 230) animated:YES];

    [self closeChapts:-1];
}

- (void)handleInnerTap:(UITapGestureRecognizer *)recognizer {

    UIView* sb = [self.innerView viewWithTag:SEARCHBAR_TAG];
    [sb resignFirstResponder];
}

- (void)handleGroupTap:(UITapGestureRecognizer *)recognizer {

    [self handleInnerTap:nil];
    
    int n = recognizer.view.tag;
    NSLog(@"group %d tapped", n);
}

- (void) keyboardDidHide:(NSNotification*)notification {
    
    keybShow = NO;
}

- (void) keyboardDidShow:(NSNotification*)notification {

    keybShow = YES;
    
    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    NSLog(@"keyboard frame raw %@", NSStringFromCGRect(keyboardFrame));
    
    UIWindow *window = [[[UIApplication sharedApplication] windows]objectAtIndex:0];
    UIView *mainSubviewOfWindow = window.rootViewController.view;
    CGRect keyboardFrameConverted = [mainSubviewOfWindow convertRect:keyboardFrame fromView:window];
//    NSLog(@"keyboard frame converted %@", NSStringFromCGRect(keyboardFrameConverted));
    
    keybHeight = keyboardFrameConverted.size.height;
    [self refreshNoRes:YES];
}

- (IBAction)menuButtonPressed:(id)sender {
    
//    NSLog(@"menu pressed");
    inMenu = !inMenu;
    
    statusBarVisible = inMenu;
//    [self setNeedsStatusBarAppearanceUpdate];

    [self refreshUnderline];

    if(inMenu) {
        
        [self showMenu];
    }
    else {
    
        [self hideMenu];
    }
}

@end
