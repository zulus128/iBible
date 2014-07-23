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
#define CURCHAP_USERDEF @"book%d"
#define CURBOOK_USERDEF @"last_book"
#define GROUPBOOK_USERDEF @"group%d_book"
//#define GROUPCHAP_USERDEF @"group%d_chap"

#define UNDERLINE_TAG 1122
#define BLUEFON_TAG 1123
#define MENU_TAG 1124
#define SEARCHBAR_TAG 1125
#define SEARCHRESULTS_TAG 1126
#define NORESULTS_TAG 1127
#define SCROLL_TAG 1128
#define CHAPTER_LINE_TAG 5000

#define MENUFADE_DELAY 0.2f

#define COVER_DELTAX 7.0f
#define COVER_DELTAY 40.0f

#define SEARCHRES_LINE_HEIGHT 37.5f
//#define SEARCHRES_LINE_HEIGHT 75.0f

#define JSON_GROUP_NAME @"name"
#define JSON_GROUP_LASTCODE @"default_last_book_code"
#define JSON_GROUP_LASTCHAPTER @"default_last_book_chapter"
#define JSON_BOOK_SHORTRU @"ShortRu"
#define JSON_BOOK_SHORTEN @"ShortEn"
#define JSON_BOOK_DISPLAYNAME @"DisplayName"
#define JSON_BOOK_CHAPTERS_CNT @"NChapters"
#define JSON_BOOK_GROUPNUM @"Group"

#define CHAPT_COLUMNS 7
#define SPREADLIST_DELAY 0.03f

enum {lngRu, lngCs};

@interface NSString ( containsCategory )
- (BOOL) containsString: (NSString*) substring;
@end

@interface MainViewController : UIViewController <UISearchBarDelegate> {
    
    BOOL statusBarVisible;
    BOOL inMenu;
    BOOL keybShow;
    float keybHeight;
    int openedChapts;
    int closedLines;
    BOOL closeAffectsPos;
    int last;
    UIButton* lastb;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rusWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rusHeight;

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
@property (weak, nonatomic) IBOutlet UIWebView *ruWebView;
@property (weak, nonatomic) IBOutlet UIWebView *csWebView;

@property (nonatomic, strong) NSDictionary* grsjson;
@property (nonatomic, strong) NSDictionary* bookjson;
@property (nonatomic, strong) UIView* innerView;
@property (nonatomic, strong) NSArray* res;
@property (nonatomic, strong) NSLayoutConstraint* scrollHeight;

@property (nonatomic, retain) NSString * viewPath;
@property (nonatomic, retain) NSString * viewPos;

@end
