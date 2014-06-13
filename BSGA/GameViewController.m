//
//  GameViewController.m
//  BSGA
//
//  Created by 近藤 雅人 on 12/04/21.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import "GameViewController.h"


@implementation GameViewController
@synthesize stageEntity;
@synthesize level;
@synthesize stageNumber;
/************************************************
 破棄
 ************************************************/
- (void)dealloc {
    PrintLog();
        
    
}

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
    
    PrintLog();
    
    BSGAAppDelegate *appDelegate = (BSGAAppDelegate *)[[UIApplication sharedApplication] delegate];
    soundManager = appDelegate.soundManager;
    [directionKeyView setSoundManager:soundManager];
    [gameButtonView setSoundManager:soundManager];
    
    GameDataEntity *gameDataEntity = [GameDataManager getGameDataEntity];
    [directionKeyView setIsMute:[gameDataEntity customizeButtonSound]];
    [gameButtonView setIsMute:[gameDataEntity customizeButtonSound]];
    
    [gameButtonView setDelegate:self];
    
    // ゲームビューの初期化処理
    gameView = [[BSGAView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    [gameView setStageEntity:stageEntity];
    [gameView setLevel:level];
    [gameView setStageNumber:stageNumber];
    [gameView setSoundManager:soundManager];
    [gameView setDirectionKeyView:directionKeyView];
    [self.view addSubview:gameView];
    
    
    [self.view addSubview:directionKeyView];
    
    [gameButtonView setFrame:CGRectMake(172, 319, 148, 141)];
    [self.view addSubview:gameButtonView];
    
    stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [stopButton setImage:[UIImage imageNamed:@"window_bg3"] forState:UIControlStateNormal];
    [stopButton setFrame:CGRectMake(0, 0, 320, 156)];
    [stopButton setHighlighted:YES];
    [stopButton setShowsTouchWhenHighlighted:YES];
    [self.view addSubview:stopButton];

    leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"window_bg3"] forState:UIControlStateNormal];
    [leftButton setFrame:CGRectMake(140, 254, 90, 66)];
    [leftButton setHighlighted:YES];
    [leftButton setShowsTouchWhenHighlighted:YES];
    [self.view addSubview:leftButton];
    
    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"window_bg3"] forState:UIControlStateNormal];
    [rightButton setFrame:CGRectMake(230, 254, 90, 66)];
    [rightButton setHighlighted:YES];
    [rightButton setShowsTouchWhenHighlighted:YES];
    [self.view addSubview:rightButton];
    
    [stopButton setAlpha:0.9f];
    [leftButton setAlpha:0.9f];
    [rightButton setAlpha:0.9f];

    [UIView animateWithDuration:1.0f
                          delay:0.5f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [stopButton setAlpha:0.0f];
                         [leftButton setAlpha:0.0f];
                         [rightButton setAlpha:0.0f];
                     }completion:^(BOOL finished) {
                         [stopButton setImage:nil forState:UIControlStateNormal];
                         [leftButton setImage:nil forState:UIControlStateNormal];
                         [rightButton setImage:nil forState:UIControlStateNormal];
                         
                         [stopButton setAlpha:1.0f];
                         [leftButton setAlpha:1.0f];
                         [rightButton setAlpha:1.0f];
                     }
     ];
    
    [stopButton addTarget:self action:@selector(stopButtonPushed) forControlEvents:UIControlEventTouchDown];
    [leftButton addTarget:gameView action:@selector(leftButtonPushed) forControlEvents:UIControlEventTouchDown];
    [rightButton addTarget:gameView action:@selector(rightButtonPushed) forControlEvents:UIControlEventTouchDown];
    
    UIButton *special01Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [special01Button setFrame:CGRectMake(0, 156, 320/3.0f, 98)];
    [special01Button addTarget:gameView
                        action:@selector(special01ButtonPushed) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:special01Button];

    UIButton *special02Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [special02Button setFrame:CGRectMake(320/3.0f, 156, 320/3.0f, 98)];
    [special02Button addTarget:gameView 
                        action:@selector(special02ButtonPushed) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:special02Button];
    
    UIButton *special03Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [special03Button setFrame:CGRectMake(320*2/3.0f, 156, 320/3.0f, 98)];
    [special03Button addTarget:gameView
                        action:@selector(special03ButtonPushed) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:special03Button];

}

/************************************************
 ビュー表示後
 ************************************************/
- (void)viewDidAppear:(BOOL)animated {

/*
    [upperShadowView.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [upperShadowView.layer setShadowOpacity:1];
    [upperShadowView.layer setShadowRadius:12];
    [upperShadowView.layer setShadowOffset:CGSizeMake(0, 12)];
    upperShadowView.layer.shadowPath 
    = [UIBezierPath bezierPathWithRect:CGRectMake(0,
                                                  0,
                                                  upperShadowView.frame.size.width, 
                                                  upperShadowView.frame.size.height)].CGPath;
    
    [bottomShadowView.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [bottomShadowView.layer setShadowOpacity:1];
    [bottomShadowView.layer setShadowRadius:12];
    [bottomShadowView.layer setShadowOffset:CGSizeMake(0, -12)];
    bottomShadowView.layer.shadowPath 
    = [UIBezierPath bezierPathWithRect:CGRectMake(0,
                                                  0,
                                                  bottomShadowView.frame.size.width, 
                                                  bottomShadowView.frame.size.height)].CGPath;
 */
    
    [self performSelector:@selector(noHighlighted) withObject:nil afterDelay:0.4f];
}

/************************************************
 ビュー表示前
 ************************************************/
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    PrintLog();

    
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

    /*
     
    [[self view] setAlpha:0.0f];
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         [[self view] setAlpha:1.0f];
                     }
     ];
     */

}


/************************************************
 ビュー非表示前
 ************************************************/
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    /*
    [timer invalidate];
    timer = nil;
     */
}

/************************************************
 ハイライトを消す
 ************************************************/
- (void)noHighlighted {
 //   PrintLog();

    [stopButton setHighlighted:NO];
    [leftButton setHighlighted:NO];
    [rightButton setHighlighted:NO];
    
    /*
     YESだと重くなるので。
     */
    [leftButton setShowsTouchWhenHighlighted:NO];
    [rightButton setShowsTouchWhenHighlighted:NO];
}

/************************************************
 ループ
 ************************************************/
/*
- (void)process {
    
    unsigned long startTime = mach_absolute_time();
    mach_timebase_info_data_t startTimeBase;
    mach_timebase_info(&startTimeBase);
//    NSLog(@"startTime = %010lu", (startTime / startTimeBase.denom)* startTimeBase.numer);
    
    // 方向キーをゲーム画面へ渡す
    [gameView setDirectionX:[directionKeyView directionX]];
    [gameView setDirectionY:[directionKeyView directionY]];
    
//    [gameView setNeedsDisplay];
    [gameView updateProc:nil];
    
    // 攻撃ボタン
    if ([gameButtonView isPushed]) {
        [gameButtonImageView setAlpha:0.2f];
    } else {
        [gameButtonImageView setAlpha:0.6f];
    }
    // コントロールキー
    if ([directionKeyView isPushed]) {
        [directionKeyImageView setAlpha:0.2f];
    } else {
        [directionKeyImageView setAlpha:0.6f];
    }
    
    unsigned long endTime = mach_absolute_time();
    unsigned long calcTime = endTime - startTime;
    
    mach_timebase_info_data_t calcTimeBase;
    mach_timebase_info(&calcTimeBase);

    calcTime = (calcTime / calcTimeBase.denom) * calcTimeBase.numer;
//    NSLog(@"calcTime = %010lu", calcTime);

    int counter = 0;
    // 処理が早く終わった場合はある一定時間待機する。うまい時間を設定すること
    while (calcTime < 2500000) {// 1000000000=1秒, 2500000=0.0025秒, 60FPS=0.0167秒
        endTime = mach_absolute_time();
        calcTime = endTime - startTime;
        calcTime = (calcTime / calcTimeBase.denom) * calcTimeBase.numer;
        counter++;
    }
//    NSLog(@"待機カウント=[%d] [%010lu]", counter, calcTime);
}
*/
//-----------------------------------------------
//
// ボタン
//
//-----------------------------------------------

/************************************************
 ストップボタン押下
 ************************************************/
- (void)stopButtonPushed {
 //   PrintLog(@"gameState = %d", gameView.gameState);
    
    if (gameView.gameState == E_GAME_STATE_PLAY) {
        
        [soundManager play:E_SOUND_SELECT];
        
        [gameView setGameState:E_GAME_STATE_PAUSE];
        [[[UIAlertView alloc] initWithTitle:@"PAUSE"
                                     message:nil 
                                    delegate:self 
                           cancelButtonTitle:@"MENU"
                           otherButtonTitles:@"RESUME", nil] show];
        [directionKeyView resetTouch];
        [directionKeyView setNeedsDisplay];
    } 
    /*
     ゲームオーバーまたはステージクリアのとき
     ・メニューに戻る
     */
    else if (gameView.gameState == E_GAME_STATE_GAME_OVER || gameView.gameState == E_GAME_STATE_STAGE_CLEAR) {
        [soundManager play:E_SOUND_SELECT];
        
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
}

//-----------------------------------------------
//
// GameButtonViewDelegate
//
//-----------------------------------------------
- (void)gameButtonState:(BOOL)isPushed {
    [gameView setGameButtonState:isPushed];
    
    if (isPushed) {
        [gameButtonImageView setImage:[UIImage imageNamed:@"round_button_pushed"]];
//        [gameButtonImageView setAlpha:0.2f];
    } else {
        [gameButtonImageView setImage:[UIImage imageNamed:@"round_button"]];
//        [gameButtonImageView setAlpha:0.6f];
    }
}

//-----------------------------------------------
//
// DirectionKeyViewDelegate
//
//-----------------------------------------------

/*- (void)sendDirectionKeyWithX:(float)x y:(float)y {
    [gameView setDirectionX:x];
    [gameView setDirectionY:y];

    if ([directionKeyView isPushed]) {
        [directionKeyImageView setAlpha:0.2f];
    } else {
        [directionKeyImageView setAlpha:0.6f];
    }
}*/


//-----------------------------------------------
//
// UIAlertViewDelegate
//
//-----------------------------------------------
/************************************************
 アラートのボタン押下
 ************************************************/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [soundManager play:E_SOUND_SELECT];
        
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

        /*
        [UIView animateWithDuration:0.2
                         animations:^{
                             [[self view] setAlpha:0.0f];
                         } completion:^(BOOL finished) {
                             
                             [gameView stopAnime];
                             
                             [self dismissModalViewControllerAnimated:NO]; 
                         }
         ];        
         */
    } else {
        [gameView setGameState:E_GAME_STATE_PLAY];
        [soundManager play:E_SOUND_SELECT];

    }
    
    
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
        [gameView stopAnime];
        [layer removeAnimationForKey:@"transformAnimationBack"];
        //        [self.navigationController popViewControllerAnimated:NO];   
        [self.navigationController popToRootViewControllerAnimated:NO];
        
    } else if (anim == [layer animationForKey:@"transformAnimationAppear"]) {
        [layer removeAnimationForKey:@"transformAnimationAppear"];
    }
}
@end
