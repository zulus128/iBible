//
//  ViewController.h
//  iBible
//
//  Created by вадим on 7/6/14.
//  Copyright (c) 2014 вадим. All rights reserved.
//
// http://stackoverflow.com/questions/15583077/how-does-scrollview-work-with-autolayout-and-why-does-setting-the-bottom-vertic/18404262#18404262

#import <UIKit/UIKit.h>

#define LNG_USERDEF @"cur_lng_save"
#define UNDERLINE_TAG 1122
#define BLUEFON_TAG 1123
#define MENU_TAG 1124
#define MENUFADE_DELAY 0.2f

enum {lngRu, lngCs};

@interface MainViewController : UIViewController {
    
    BOOL statusBarVisible;
    BOOL inMenu;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *innerViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *csHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *csWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceBetweenRuCs;
@property (weak, nonatomic) IBOutlet UIButton *buttonRus;
@property (weak, nonatomic) IBOutlet UIButton *buttonCs;
- (IBAction)langButtonPressed:(id)sender;
- (IBAction)menuButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonMenu;

@property (assign, readwrite) int curLanguage;

@property (nonatomic, strong) NSDictionary* grsjson;
@property (nonatomic, strong) NSDictionary* bookjson;

@end
