//
//  AbilityViewController.m
//  BSGA
//
//  Created by 近藤 雅人 on 12/05/18.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import "AbilityViewController.h"

@interface AbilityViewController ()

@end

@implementation AbilityViewController
@synthesize gameDataEntity;
/************************************************
 破棄
 ************************************************/

/************************************************
 初期化
 ************************************************/
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

/************************************************
 ビュー読み込み後
 ************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 能力パラメータ情報取得
    [self setGameDataEntity:[GameDataManager getGameDataEntity]];
    [pointsLabel setText:[Misc intToString:[gameDataEntity points]]];
    [hpLabel setText:[Misc intToString:[gameDataEntity hp]]];
    [specialLabel setText:[Misc intToString:[gameDataEntity special]]];
    [reloadLabel setText:[Misc intToString:[gameDataEntity reload]]];
    [fuelLabel setText:[Misc intToString:[gameDataEntity fuel]]];
    [attackLabel setText:[Misc intToString:[gameDataEntity attack]]];
    [bindLabel setText:[Misc intToString:[gameDataEntity bind]]];
    [speedLabel setText:[Misc intToString:[gameDataEntity speed]]];
    
    // デフォルトセレクト
    [attackButton setTitleColor:[UIColor colorWithRed:0.3f green:0.8f blue:1.0f alpha:1.0f]
                 forState:UIControlStateNormal];
 

    BSGAAppDelegate *appDelegate = (BSGAAppDelegate *)[[UIApplication sharedApplication] delegate];
    soundManager = [appDelegate soundManager];
    
    [backButton addTarget:self
                   action:@selector(backButtonPushed)
         forControlEvents:UIControlEventTouchUpInside];
    
    abilityButtons[0] = hpButton;
    abilityButtons[1] = specialButton;
    abilityButtons[2] = reloadButton;
    abilityButtons[3] = fuelButton;
    abilityButtons[4] = attackButton;
    abilityButtons[5] = bindButton;
    abilityButtons[6] = speedButton;
    
    for (int i=0; i<7; i++) {
        [abilityButtons[i] addTarget:self action:@selector(abilityButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
        [abilityButtons[i] setExclusiveTouch:NO];
    }
    
    for (int i=0; i<7; i++) {
        selectedButtonTag = i;
        [self calcNeedPoints];
    }
    selectedButtonTag = [attackButton tag];
    [self calcNeedPoints];

    
    [upButton addTarget:self action:@selector(upButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    [upSuperButton addTarget:self action:@selector(upButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    [downButton addTarget:self action:@selector(downButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    [downSuperButton addTarget:self action:@selector(downButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [buyButton addTarget:self action:@selector(buyButtonPushed)
        forControlEvents:UIControlEventTouchUpInside];
}

/************************************************
 ビュー表示前
 ************************************************/
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CATransform3D transformFromFlip = CATransform3DMakeRotation(M_PI/2.0f, -1.0f, 1.0f, 0.0f);
    transformFromFlip = CATransform3DScale(transformFromFlip, kFlipAnimationScale, kFlipAnimationScale, 1.0f);
    
    CATransform3D transformToFlip = CATransform3DMakeRotation(0.0f, 0.0f, 1.0f, 0.0f);
    transformToFlip.m34 = kM34;
    
    CALayer *layer = self.view.layer;
    
    CABasicAnimation* animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    [animation setDelegate:self];
    [animation setDuration:kLongAnimationDuration];
    [animation setRepeatCount:0];
    [animation setRemovedOnCompletion:NO];
    [animation setFromValue:[NSValue valueWithCATransform3D:transformFromFlip]];
    [animation setToValue:[NSValue valueWithCATransform3D:transformToFlip]];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];    
    [layer addAnimation:animation forKey:@"transformAnimationAppear"];
}

/************************************************
 戻るボタン
 ************************************************/
- (void)backButtonPushed {
    
    [GameDataManager saveGameDataEntity:gameDataEntity];
        
    CALayer *layer = self.view.layer;
    
    CATransform3D transformFlip = CATransform3DMakeRotation(M_PI/2.0f, 1.0f, -1.0f, 0.0f);
    transformFlip = CATransform3DScale(transformFlip, kFlipAnimationScale, kFlipAnimationScale, 1.0f);

    // アニメーション後の形をセット
    layer.transform = transformFlip;

    CATransform3D transform;
    transform = CATransform3DIdentity;
    transform.m34 = kM34;// 奥行き
    
    CABasicAnimation* animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    [animation setDelegate:self];
    [animation setDuration:kLongAnimationDuration];
    [animation setRepeatCount:0];
    [animation setRemovedOnCompletion:NO];
    [animation setFromValue:[NSValue valueWithCATransform3D:transform]];
    [animation setToValue:[NSValue valueWithCATransform3D:transformFlip]];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];    
    [layer addAnimation:animation forKey:@"transformAnimationBack"];
}

/************************************************
 必要ポイントの計算と表示
 ************************************************/
- (void)calcNeedPoints {
    int needPoints = 0;
    
    UIColor *normalColor = [UIColor colorWithRed:102.0f/255.0f green:203.0f/255.0f blue:250.0f/255.0f alpha:1.0f];
    UIColor *highColor   = [UIColor colorWithRed:50.0f/255.0f green:160.0f/255.0f blue:1.0f alpha:1.0f];
    UIColor *maxColor    = [UIColor colorWithRed:0.0f/255.0f green:120.0f/255.0f blue:1.0f alpha:1.0f];
    
    // 体力
    if (selectedButtonTag == 0) {
        if ([gameDataEntity hp] < 5) {
            needPoints = 6;
            sellPoints = 6;
            [hpLabel setTextColor:normalColor];
        } else {
            needPoints = 7;
            sellPoints = 7;
            [hpLabel setTextColor:highColor];
        }
        if ([gameDataEntity hp] == 5) {
            [hpLabel setTextColor:normalColor];
            sellPoints = 6;
        }
        if ([gameDataEntity hp] == 30) {
            [hpLabel setTextColor:maxColor];
        }
    } 
    // 特殊
    else if (selectedButtonTag == 1) {
        needPoints = 2;
        sellPoints = 2;
        [specialLabel setTextColor:normalColor];
        if ([gameDataEntity special] == 100) {
            [specialLabel setTextColor:maxColor];
        }
    }
    // 装填
    else if (selectedButtonTag == 2) {
        if ([gameDataEntity reload] < 30) {
            needPoints = 2;
            sellPoints = 2;
            [reloadLabel setTextColor:normalColor];
        } else {
            needPoints = 6;
            sellPoints = 6;
            [reloadLabel setTextColor:highColor];
        }
        if ([gameDataEntity reload] == 30) {
            [reloadLabel setTextColor:normalColor];
            sellPoints = 2;
        }
        if ([gameDataEntity reload] == 40) {
            [reloadLabel setTextColor:maxColor];
        }
    } 
    // 燃料
    else if (selectedButtonTag == 3) {
        needPoints = 1;
        sellPoints = 1;
        [fuelLabel setTextColor:normalColor];
        if ([gameDataEntity fuel] == 240) {
            [fuelLabel setTextColor:maxColor];
        }
    } 
    // 破壊
    else if (selectedButtonTag == 4) {
        if ([gameDataEntity attack] < 180) {
            needPoints = 1;  
            sellPoints = 1;
            [attackLabel setTextColor:normalColor];
        } else {
            needPoints = 2;
            sellPoints = 2;
            [attackLabel setTextColor:highColor];
        }
        if ([gameDataEntity attack] == 180) {
            [attackLabel setTextColor:normalColor];
            sellPoints = 1;
        }
        if ([gameDataEntity attack] == 250) {
            [attackLabel setTextColor:maxColor];
        }
    } 
    // 束縛
    else if (selectedButtonTag == 5) {
        if ([gameDataEntity bind] < 5) {
            needPoints = 1;            
            sellPoints = 1;
            [bindLabel setTextColor:normalColor];
        } else {
            needPoints = 2;
            sellPoints = 2;
            [bindLabel setTextColor:highColor];
        }
        if ([gameDataEntity bind] == 5) {
            [bindLabel setTextColor:normalColor];
            sellPoints = 1;
        }
        if ([gameDataEntity bind] == 10) {
            [bindLabel setTextColor:maxColor];
        }
        
    } 
    // 速度
    else if (selectedButtonTag == 6) {
        needPoints = 2;
        sellPoints = 2;
        [speedLabel setTextColor:normalColor];
        if ([gameDataEntity speed] == 6) {
            [speedLabel setTextColor:maxColor];
        }
    }
    
    [needPointsLabel setText:[Misc intToString:needPoints]];
}

/************************************************
 abilityボタン
 ************************************************/
- (void)abilityButtonPushed:(UIButton *)button {
    
    [soundManager play:E_SOUND_BUTTON];
    
    for (int i=0; i<7; i++) {
        [abilityButtons[i] setTitleColor:[UIColor groupTableViewBackgroundColor]
                     forState:UIControlStateNormal];
    }
    [button setTitleColor:[UIColor colorWithRed:0.3f green:0.8f blue:1.0f alpha:1.0f]
                 forState:UIControlStateNormal];
    selectedButtonTag = [button tag];
        
    [self calcNeedPoints];    
    [AnimationManager popAnimationWithView:needPointsLabel
                                  duration:0.5f
                                     delay:0.05f
                                     alpha:0.5f];
}

/************************************************
 能力上げボタン
 ************************************************/
- (void)upButtonPushed:(UIButton *)button {
    
    [soundManager play:E_SOUND_BUTTON];// TODO 変えられたら良いな
    
    int count = [button tag];
    
    for (int i=0; i<count; i++) {
        
        int needPoints = [[needPointsLabel text] intValue];
        if (needPoints <= [gameDataEntity points]) {
            
            BOOL isSuccess = NO;
            
            // 体力
            if (selectedButtonTag == 0 && [gameDataEntity hp]<30) {
                isSuccess = YES;
                [gameDataEntity setHp:[gameDataEntity hp]+1];
                [hpLabel setText:[Misc intToString:[gameDataEntity hp]]];
            } 
            // 特殊
            else if (selectedButtonTag == 1 && [gameDataEntity special]<100) {
                isSuccess = YES;
                [gameDataEntity setSpecial:[gameDataEntity special]+1];
                [specialLabel setText:[Misc intToString:[gameDataEntity special]]];
            }
            // 装填
            else if (selectedButtonTag == 2 && [gameDataEntity reload]<40) {
                isSuccess = YES;
                [gameDataEntity setReload:[gameDataEntity reload]+1];
                [reloadLabel setText:[Misc intToString:[gameDataEntity reload]]];
            } 
            // 燃料
            else if (selectedButtonTag == 3 && [gameDataEntity fuel]<240) {
                isSuccess = YES;
                [gameDataEntity setFuel:[gameDataEntity fuel]+3];
                [fuelLabel setText:[Misc intToString:[gameDataEntity fuel]]];
            } 
            // 破壊
            else if (selectedButtonTag == 4 && [gameDataEntity attack]<250) {
                isSuccess = YES;
                [gameDataEntity setAttack:[gameDataEntity attack]+1];
                [attackLabel setText:[Misc intToString:[gameDataEntity attack]]];
            } 
            // 束縛
            else if (selectedButtonTag == 5 && [gameDataEntity bind]<10) {
                isSuccess = YES;
                [gameDataEntity setBind:[gameDataEntity bind]+1];
                [bindLabel setText:[Misc intToString:[gameDataEntity bind]]];
            } 
            // 速度
            else if (selectedButtonTag == 6 && [gameDataEntity speed]<6) {
                isSuccess = YES;
                [gameDataEntity setSpeed:[gameDataEntity speed]+1];
                [speedLabel setText:[Misc intToString:[gameDataEntity speed]]];
            }            
            
            if (isSuccess) {
                [gameDataEntity setPoints:[gameDataEntity points]-needPoints];
                [pointsLabel setText:[Misc intToString:[gameDataEntity points]]];                
            }
            
        } else {
            // ポイント不足
        }
        
        
        [self calcNeedPoints];
    }
 
                 
    [AnimationManager popAnimationWithView:pointsLabel duration:0.5f delay:0.0f alpha:0.5f];
 
                 
            
#if DEBUG_MODE
    // TODO testcode
    if (count > 2) {
        [gameDataEntity setPoints:[gameDataEntity points]+10];
        [pointsLabel setText:[Misc intToString:[gameDataEntity points]]];
    }
    [AnimationManager popAnimationWithView:needPointsLabel
                                  duration:0.5f
                                     delay:0.05f
                                     alpha:0.5f];
#endif

}
/************************************************
 能力下げボタン
 ************************************************/
- (void)downButtonPushed:(UIButton *)button {
    
    [soundManager play:E_SOUND_BUTTON];

    int count = [button tag];

    for (int i=0; i<count; i++) {
                    
        BOOL isSuccess = NO;
        
        // 体力
        if (selectedButtonTag == 0 && [gameDataEntity hp]>1) {
            isSuccess = YES;
            [gameDataEntity setHp:[gameDataEntity hp]-1];
            [hpLabel setText:[Misc intToString:[gameDataEntity hp]]];
        } 
        // 特殊
        else if (selectedButtonTag == 1 && [gameDataEntity special]>0) {
            isSuccess = YES;
            [gameDataEntity setSpecial:[gameDataEntity special]-1];
            [specialLabel setText:[Misc intToString:[gameDataEntity special]]];
        }
        // 装填
        else if (selectedButtonTag == 2 && [gameDataEntity reload]>0) {
            isSuccess = YES;
            [gameDataEntity setReload:[gameDataEntity reload]-1];
            [reloadLabel setText:[Misc intToString:[gameDataEntity reload]]];
        } 
        // 燃料
        else if (selectedButtonTag == 3 && [gameDataEntity fuel]>0) {
            isSuccess = YES;
            [gameDataEntity setFuel:[gameDataEntity fuel]-3];
            [fuelLabel setText:[Misc intToString:[gameDataEntity fuel]]];
        } 
        // 破壊
        else if (selectedButtonTag == 4 && [gameDataEntity attack]>1) {
            isSuccess = YES;
            [gameDataEntity setAttack:[gameDataEntity attack]-1];
            [attackLabel setText:[Misc intToString:[gameDataEntity attack]]];
        } 
        // 束縛
        else if (selectedButtonTag == 5 && [gameDataEntity bind]>0) {
            isSuccess = YES;
            [gameDataEntity setBind:[gameDataEntity bind]-1];
            [bindLabel setText:[Misc intToString:[gameDataEntity bind]]];
        } 
        // 速度
        else if (selectedButtonTag == 6 && [gameDataEntity speed]>0) {
            isSuccess = YES;
            [gameDataEntity setSpeed:[gameDataEntity speed]-1];
            [speedLabel setText:[Misc intToString:[gameDataEntity speed]]];
        }            
        
        if (isSuccess) {
            [gameDataEntity setPoints:[gameDataEntity points]+sellPoints];
            [pointsLabel setText:[Misc intToString:[gameDataEntity points]]];                
        }
        [self calcNeedPoints];    
    }
    
    
    [AnimationManager popAnimationWithView:pointsLabel duration:0.5f delay:0.0f alpha:0.5f];

    [AnimationManager popAnimationWithView:needPointsLabel
                                  duration:0.5f
                                     delay:0.05f
                                     alpha:0.5f];

    

}

/************************************************
 購入ボタン押下
 ************************************************/
- (void)buyButtonPushed {
    BSGAAppDelegate *appDelegate = (BSGAAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate setDelegate:self];
    [appDelegate payEasyMode];
}

//-----------------------------------------------
//
// PaymentDoneDelegate
//
//-----------------------------------------------
/************************************************
 購入処理完了
 ************************************************/
- (void)paymentDone {
    [gameDataEntity setPoints:[gameDataEntity points]+1];
    [gameDataEntity setPayCountPoint:[gameDataEntity payCountPoint]+1];
    [pointsLabel setText:[Misc intToString:[gameDataEntity points]]];

    [AnimationManager popAnimationWithView:pointsLabel duration:0.5f delay:0.0f alpha:0.5f];
    
    [AnimationManager popAnimationWithView:self.view
                                  duration:0.5f
                                     delay:0.0f
                                     alpha:1.0f];
    
    [GameDataManager saveGameDataEntity:gameDataEntity];
    
}


//-----------------------------------------------
//
// CAAnimationDelegate
//
//-----------------------------------------------
/************************************************
 CAAnimation停止
 ************************************************/
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    CALayer *layer = self.view.layer;
    
    if (anim == [self.view.layer animationForKey:@"transformAnimationBack"]) {
        [self.navigationController popViewControllerAnimated:NO];        
        [layer removeAnimationForKey:@"transformAnimationBack"];
    } else if (anim == [layer animationForKey:@"transformAnimationAppear"]) {
        [layer removeAnimationForKey:@"transformAnimationAppear"];
    }
}

@end
