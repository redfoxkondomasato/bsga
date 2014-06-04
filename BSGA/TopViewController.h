//
//  TopViewController.h
//  BSGA
//
//  Created by 近藤 雅人 on 12/04/21.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BSGAAppDelegate.h"
#import "GameViewController.h"
#import "AbilityViewController.h"
#import "CustomizeViewController.h"
#import "TipsViewController.h"
#import "MemoViewController.h"
#import "StageSelectViewController.h"
#import "GameDataManager.h"
#import "GameDataEntity.h"
#import "SendDataManager.h"

#import "StageEntity.h"
#import "StageManager.h"
#import "SoundManager.h"

#import "CustomWebViewController.h"
#import "LogTableViewController.h"



enum E_TRANSITION_TYPE {
    E_TRANSITION_TYPE_ALPHA,
    E_TRANSITION_TYPE_FLIP,
    E_TRANSITION_TYPE_FLIP_X,
    E_TRANSITION_TYPE_FLIP_YZ,
    E_TRANSITION_TYPE_FLIP_XZ,
};

@interface TopViewController : UIViewController<UIAlertViewDelegate> {
    
    int transitionType;
    IBOutlet UIImageView *titleImageView;
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UIView *contentView;
    IBOutlet UILabel *launchCountLabel;
    
    IBOutlet UIButton *startButton;
    IBOutlet UIButton *abilityButton;
    IBOutlet UIButton *customizeButton;
    IBOutlet UIButton *tipsButton;
    IBOutlet UIButton *memoButton;
    
    IBOutlet UIButton *bsgaButton;
    IBOutlet UIButton *twitterButton;
    IBOutlet UIButton *logButton;
    IBOutlet UIButton *memoDebugButton;
    
    IBOutlet UIButton *blogButton;
    IBOutlet UIButton *appstoreButton;
    
    UIViewController *nextPage;
    
    SoundManager *soundManager;
}

@end
