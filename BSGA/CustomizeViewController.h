//
//  CustomizeViewController.h
//  BSGA
//
//  Created by 近藤 雅人 on 12/05/18.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GameDataManager.h"
#import "AnimationManager.h"
#import "CustomAlertView.h"
@interface CustomizeViewController : UIViewController {
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *infoButton;
    
    IBOutlet UILabel *detailLabel;
    
    IBOutlet UISegmentedControl *controllerModeSegmentedControl;
    IBOutlet UISegmentedControl *backgroundColorRandomSegmentedControl;
    
    IBOutlet UISegmentedControl *soundSegmentedControl;
    IBOutlet UISegmentedControl *blockSegmentedControl;
}
@property (nonatomic, strong) GameDataEntity *gameDataEntity;

- (void)customizeAnimationWithLabel:(UILabel *)label component:(UIView *)component;

@end
