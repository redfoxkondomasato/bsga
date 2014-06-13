//
//  StageSelectViewController.h
//  BSGA
//
//  Created by 近藤 雅人 on 12/05/21.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GameViewController.h"
#import "StageEntity.h"
#import "SoundManager.h"
#import "GameDataManager.h"
#import "GameDataEntity.h"
#import "Misc.h"

@interface StageSelectViewController : UIViewController {
    IBOutlet UIButton *backButton;
    
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UIView *contentView;
    
    IBOutlet UIScrollView *shokyuScrollView;
    IBOutlet UIScrollView *chukyuScrollView;
    IBOutlet UIScrollView *jokyuScrollView;
    IBOutlet UIScrollView *chokyuScrollView;
    
    IBOutlet UIButton *scrollLeftButton;
    IBOutlet UIButton *scrollRightButton;
    
    UIViewController *nextPage;
    
    StageEntity *stageEntity;
    SoundManager *soundManager;
    
    IBOutlet UILabel *displayLevelLabel;
    IBOutlet UILabel *displayMessageLabel;
    IBOutlet UILabel *displayRankLabel;
    
    IBOutlet UILabel *rankSLabel;
    IBOutlet UILabel *rankALabel;
    IBOutlet UILabel *rankBLabel;
    IBOutlet UILabel *rankCLabel;
    IBOutlet UILabel *rankDLabel;
    IBOutlet UILabel *rankELabel;
    IBOutlet UILabel *rankFLabel;
    IBOutlet UILabel *rankGLabel;
    
    int selectedLevel;
    int selectedStage;

}
@property (nonatomic, strong) GameDataEntity *gameDataEntity;
- (void)startGameWithStage:(int)stage level:(int)level;
- (void)setupScrollViewWithScrollView:(UIScrollView *)aScrollView maxStage:(int)maxStage;
@end
