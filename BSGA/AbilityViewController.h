//
//  AbilityViewController.h
//  BSGA
//
//  Created by 近藤 雅人 on 12/05/18.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AnimationManager.h"
#import "BSGAAppDelegate.h"
#import "SoundManager.h"
#import "GameDataManager.h"
#import "Misc.h"
#import "GameDataEntity.h"

@interface AbilityViewController : UIViewController<PaymentDoneDelegate> {
    
    SoundManager *soundManager;
    
    IBOutlet UIButton *backButton;

    IBOutlet UIButton *hpButton;
    IBOutlet UIButton *specialButton;
    IBOutlet UIButton *reloadButton;
    IBOutlet UIButton *fuelButton;
    IBOutlet UIButton *attackButton;
    IBOutlet UIButton *bindButton;
    IBOutlet UIButton *speedButton;
    
    IBOutlet UIButton *upButton;
    IBOutlet UIButton *upSuperButton;
    
    IBOutlet UIButton *downButton;
    IBOutlet UIButton *downSuperButton;
    
    IBOutlet UILabel *pointsLabel;
    IBOutlet UILabel *needPointsLabel;
    
    IBOutlet UILabel *hpLabel;
    IBOutlet UILabel *specialLabel;
    IBOutlet UILabel *reloadLabel;
    IBOutlet UILabel *fuelLabel;
    IBOutlet UILabel *attackLabel;
    IBOutlet UILabel *bindLabel;
    IBOutlet UILabel *speedLabel;
    
    UIButton *abilityButtons[7];
    int selectedButtonTag;
    int sellPoints;
    
    IBOutlet UIButton *buyButton;

}
@property (nonatomic, strong) GameDataEntity *gameDataEntity;
- (void)calcNeedPoints;

@end


