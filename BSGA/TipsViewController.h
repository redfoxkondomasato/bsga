//
//  TipsViewController.h
//  BSGA
//
//  Created by 近藤 雅人 on 12/05/18.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BSGAAppDelegate.h"
#import "AnimationManager.h"
#import "GameDataManager.h"
#import "GameDataEntity.h"
#import "Misc.h"
@interface TipsViewController : UIViewController<PaymentDoneDelegate> {
    IBOutlet UIButton *backButton;
    IBOutlet UILabel *pointsLabel;
    IBOutlet UIButton *buyButton;
    
    // ガチャ１
    IBOutlet UIButton *messageGachaButton;
    IBOutlet UIButton *messageGachaCollectionButton;
    
    NSArray *messageGachaArray;
    NSArray *messageGachaRareArray;
    NSArray *messageGachaSuperRareArray;

    // ガチャ２
    IBOutlet UIButton *message2GachaButton;
    IBOutlet UIButton *message2GachaCollectionButton;
    
    NSArray *message2GachaArray;
    NSArray *message2GachaRareArray;
    NSArray *message2GachaSuperRareArray;

    // ガチャ３
    IBOutlet UIButton *message3GachaButton;
    IBOutlet UIButton *message3GachaCollectionButton;
    
    NSArray *message3GachaArray;
    NSArray *message3GachaRareArray;
    NSArray *message3GachaSuperRareArray;

    
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *messageLabel;
}
@property (nonatomic, strong) GameDataEntity *gameDataEntity;

@end
