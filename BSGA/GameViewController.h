//
//  GameViewController.h
//  BSGA
//
//  Created by 近藤 雅人 on 12/04/21.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <time.h>
#import <mach/mach_time.h>
#import <QuartzCore/QuartzCore.h>
#import "BSGAAppDelegate.h"
#import "DirectionKeyView.h"
#import "SoundManager.h"
#import "GameButtonView.h"
#import "BSGAView.h"
#import "StageEntity.h"
@interface GameViewController : UIViewController<UIAlertViewDelegate, GameButtonViewDelegate> {
//    IBOutlet GameView *gameView;
    BSGAView *gameView;
    IBOutlet DirectionKeyView *directionKeyView;
    IBOutlet GameButtonView *gameButtonView;
    
    IBOutlet UIImageView *gameButtonImageView;
    IBOutlet UIImageView *directionKeyImageView;
    
//    IBOutlet UIView *upperShadowView;
//    IBOutlet UIView *bottomShadowView;
    
    SoundManager *soundManager;
   
    UIButton *stopButton;
    UIButton *leftButton;
    UIButton *rightButton;
    
    NSTimer *timer;
}
@property(nonatomic, strong) StageEntity *stageEntity;
@property(nonatomic) int level;
@property(nonatomic) int stageNumber;

@end
