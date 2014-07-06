//
//  ViewController.h
//  iBible
//
//  Created by вадим on 7/6/14.
//  Copyright (c) 2014 вадим. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LNG_USERDEF @"cur_lng_save"
#define UNDERLINE_TAG 1122
#define BLUEFON_TAG 1123

enum {lngRu, lngCs};

@interface MainViewController : UIViewController {
    
    BOOL statusBarVisible;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *innerViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *csHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *csWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceBetweenRuCs;
@property (weak, nonatomic) IBOutlet UIButton *buttonRus;
@property (weak, nonatomic) IBOutlet UIButton *buttonCs;
- (IBAction)langButtonPressed:(id)sender;
- (IBAction)menuButtonPressed:(id)sender;

@property (assign, readwrite) int curLanguage;

@end
