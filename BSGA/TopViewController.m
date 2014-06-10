//
//  TopViewController.m
//  BSGA
//
//  Created by 近藤 雅人 on 12/04/21.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import "TopViewController.h"
@implementation TopViewController

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
    
    PrintLog();
    

//    PrintLog(@"viewDidLoad");
    
    GameDataEntity *gameDataEntity = [GameDataManager getGameDataEntity];
    
    // 初回起動
    if ([gameDataEntity launchCount]==0) {
        [[[UIAlertView alloc] initWithTitle:@"初回起動ボーナス！"
                                   message:@"おまけポイント\n300pointプレゼント！"
                                  delegate:nil
                         cancelButtonTitle:@"え、よくわかんない"
                           otherButtonTitles:@"なるほど", @"興味ないな", nil] show];
    }
    
    [gameDataEntity setLaunchCount:[gameDataEntity launchCount]+1];// 起動回数カウントアップ
    [GameDataManager saveGameDataEntity:gameDataEntity];
    
    [self performSelectorInBackground:@selector(sendData) withObject:nil];
    
    [launchCountLabel setText:[NSString stringWithFormat:@"%d", [gameDataEntity launchCount]]];
    
    
    srand(time(NULL));
    
    BSGAAppDelegate *appDelegate = (BSGAAppDelegate *)[[UIApplication sharedApplication] delegate];
    soundManager = appDelegate.soundManager;

    [scrollView addSubview:contentView];
    [scrollView setContentSize:CGSizeMake([contentView frame].size.width, 
                                          [contentView frame].size.height)];
    
    [startButton addTarget:self
                    action:@selector(startButtonPushed)
          forControlEvents:UIControlEventTouchUpInside];
    [startButton setExclusiveTouch:YES];
    
    [abilityButton addTarget:self
                      action:@selector(abilityButtonPushed)
            forControlEvents:UIControlEventTouchUpInside];
    [abilityButton setExclusiveTouch:YES];
 
    
    [customizeButton addTarget:self
                        action:@selector(customizeButtonPushed)
              forControlEvents:UIControlEventTouchUpInside];
    [customizeButton setExclusiveTouch:YES];

    
    [tipsButton addTarget:self 
                   action:@selector(tipsButtonPushed)
         forControlEvents:UIControlEventTouchUpInside];
    
    [memoButton addTarget:self
                   action:@selector(memoButtonPushed)
         forControlEvents:UIControlEventTouchUpInside];
    [memoButton setExclusiveTouch:YES];

    
    [bsgaButton addTarget:self
                   action:@selector(bsgaButtonPushed)
         forControlEvents:UIControlEventTouchUpInside];
    [bsgaButton setExclusiveTouch:YES];
    
    [blogButton addTarget:self
                   action:@selector(blogButtonPushed)
         forControlEvents:UIControlEventTouchUpInside];
    
    [appstoreButton addTarget:self
                       action:@selector(appstoreButtonPushed)
             forControlEvents:UIControlEventTouchUpInside];

    
    int launchCount = [gameDataEntity launchCount];
    
#if DEBUG_MODE
    [logButton setHidden:NO];
    [logButton addTarget:self
                  action:@selector(logButtonPushed)
        forControlEvents:UIControlEventTouchUpInside];
    
    [memoDebugButton setHidden:NO];
    [memoDebugButton addTarget:self
                        action:@selector(memoDebugButtonPushed)
              forControlEvents:UIControlEventTouchUpInside];
    launchCount = 500;
#endif
    
    // 起動回数が10の倍数のとき
    if (launchCount % 10 == 0 && launchCount > 0) {
        
        // 0.0f - 3.0f
        float scale = (rand()%31)/10.0f;
        [AnimationManager basicAnimationWithView:titleImageView
                                        duration:1.0f
                                           delay:0.2f
                                         options:UIViewAnimationOptionCurveEaseIn
                                     fromToAlpha:CGPointMake(0.6f, 1.0f)
                                    fromToRotate:CGPointZero
                                      beginScale:CGPointMake(scale, scale)
                                     finishScale:CGPointMake(1.0f, 1.0f)
                                  beginTranslate:CGPointZero
                                 finishTranslate:CGPointZero];
    }
}

/************************************************
 ビュー非表示前
 ************************************************/
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}

/************************************************
 ビュー表示前
 ************************************************/
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    GameDataEntity *gameDataEntity = [GameDataManager getGameDataEntity];
    if ([gameDataEntity getStageClearStatusWithLevel:E_STAGE_LEVEL_SHOKYU stage:3] == -2) {
        [customizeButton setHidden:YES];
    } else {
        [customizeButton setHidden:NO];
    }
    if ([gameDataEntity getStageClearStatusWithLevel:E_STAGE_LEVEL_SHOKYU stage:19] == -2) {
        [memoButton setHidden:YES];
    } else {
        [memoButton setHidden:NO];
    }
    
    

    
    if (transitionType == E_TRANSITION_TYPE_FLIP) {
        CATransform3D transformFromFlip = CATransform3DMakeRotation(M_PI/2.0f, -1.0f, 1.0f, 0.0f);
        transformFromFlip = CATransform3DScale(transformFromFlip, kFlipAnimationScale, kFlipAnimationScale, 1.0f);
        
        CATransform3D transformToFlip = CATransform3DMakeRotation(0.0f, 0.0f, 1.0f, 0.0f);
        transformToFlip.m34 = kM34;
        
        CALayer *layer = self.view.layer;
        
        // アニメーション後の形をセット
        [layer setTransform:transformToFlip];
        
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
    } else if (transitionType == E_TRANSITION_TYPE_FLIP_X) {
        CATransform3D transformFromFlip = CATransform3DMakeRotation(M_PI/2.0f, -1.0f, 0.0f, 0.0f);
        transformFromFlip = CATransform3DScale(transformFromFlip, kFlipXAnimationScale, kFlipXAnimationScale, 1.0f);
        
        CATransform3D transformToFlip = CATransform3DMakeRotation(0.0f, 0.0f, 1.0f, 0.0f);
        transformToFlip.m34 = kM34;
        
        CALayer *layer = self.view.layer;
        
        // アニメーション後の形をセット
        [layer setTransform:transformToFlip];
        
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
 
    } else if (transitionType == E_TRANSITION_TYPE_FLIP_YZ) {
        CATransform3D transformFromFlip = CATransform3DMakeRotation(M_PI-0.05f, 0.0f, 1.0f, 1.0f);
        transformFromFlip = CATransform3DScale(transformFromFlip, kFlipAnimationScale, kFlipAnimationScale, 1.0f);
        
        CATransform3D transformToFlip = CATransform3DMakeRotation(0.0f, 0.0f, 0.0f, 0.0f);
        transformToFlip.m34 = kM34;
        
        CALayer *layer = self.view.layer;
        
        // アニメーション後の形をセット
        [layer setTransform:transformToFlip];
        
        CABasicAnimation* animation;
        animation = [CABasicAnimation animationWithKeyPath:@"transform"];
        [animation setDelegate:self];
        [animation setDuration:kLong2AnimationDuration];
        [animation setRepeatCount:0];
        [animation setRemovedOnCompletion:NO];
        [animation setFromValue:[NSValue valueWithCATransform3D:transformFromFlip]];
        [animation setToValue:[NSValue valueWithCATransform3D:transformToFlip]];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];    
        [layer addAnimation:animation forKey:@"transformAnimationAppear"];
        
    } else if (transitionType == E_TRANSITION_TYPE_FLIP_XZ) {
        CATransform3D transformFromFlip = CATransform3DMakeRotation(M_PI-0.05f, -1.0f, 0.0f, 1.0f);
        transformFromFlip = CATransform3DScale(transformFromFlip, kFlipAnimationScale, kFlipAnimationScale, 1.0f);
        
        CATransform3D transformToFlip = CATransform3DMakeRotation(0.0f, 0.0f, 0.0f, 0.0f);
        transformToFlip.m34 = kM34;
        
        CALayer *layer = self.view.layer;
        
        // アニメーション後の形をセット
        [layer setTransform:transformToFlip];
        
        CABasicAnimation* animation;
        animation = [CABasicAnimation animationWithKeyPath:@"transform"];
        [animation setDelegate:self];
        [animation setDuration:kLong2AnimationDuration];
        [animation setRepeatCount:0];
        [animation setRemovedOnCompletion:NO];
        [animation setFromValue:[NSValue valueWithCATransform3D:transformFromFlip]];
        [animation setToValue:[NSValue valueWithCATransform3D:transformToFlip]];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];    
        [layer addAnimation:animation forKey:@"transformAnimationAppear"];
        
    }
    
}

/************************************************
 開始ボタン
 ************************************************/
- (void)startButtonPushed {
    transitionType = E_TRANSITION_TYPE_ALPHA;
    [soundManager play:E_SOUND_SELECT];
        
    transitionType = E_TRANSITION_TYPE_FLIP;
    nextPage = nil;    
    
    nextPage = [[StageSelectViewController alloc] initWithNibName:@"StageSelectViewController" bundle:nil];
    
    
    CALayer *layer = self.view.layer;
    
    CATransform3D transformFlip = CATransform3DMakeRotation(M_PI/2.0f, 1.0f, -1.0f, 0.0f);
    transformFlip = CATransform3DScale(transformFlip, kFlipAnimationScale, kFlipAnimationScale, 1.0f);
    
    // アニメーション後の形をセット
    [layer setTransform:transformFlip];
    
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
    [layer addAnimation:animation forKey:@"transformAnimationNext"];

}

/************************************************
 能力ボタン
 ************************************************/
- (void)abilityButtonPushed {
//    PrintLog(@"押下");
    [soundManager play:E_SOUND_SELECT];
    transitionType = E_TRANSITION_TYPE_FLIP;
    nextPage = nil;
    nextPage = [[AbilityViewController alloc] initWithNibName:@"AbilityViewController" bundle:nil];
    
    CALayer *layer = self.view.layer;

    CATransform3D transformFlip = CATransform3DMakeRotation(M_PI/2.0f, 1.0f, -1.0f, 0.0f);
    transformFlip = CATransform3DScale(transformFlip, kFlipAnimationScale, kFlipAnimationScale, 1.0f);

    // アニメーション後の形をセット
    [layer setTransform:transformFlip];

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
    [layer addAnimation:animation forKey:@"transformAnimationNext"];
}

/************************************************
 設定ボタン
 ************************************************/
- (void)customizeButtonPushed {
    [soundManager play:E_SOUND_SELECT];
//    PrintLog(@"押下");
    
    nextPage = nil;
    nextPage = [[CustomizeViewController alloc] initWithNibName:@"CustomizeViewController" bundle:nil];

    transitionType = E_TRANSITION_TYPE_FLIP_X;
    
    CALayer *layer = self.view.layer;
    
    CATransform3D transformFlip = CATransform3DMakeRotation(M_PI/2.0f, 1.0f, 0.0f, 0.0f);
    transformFlip = CATransform3DScale(transformFlip, kFlipXAnimationScale, kFlipXAnimationScale, 1.0f);
    
    // アニメーション後の形をセット
    [layer setTransform:transformFlip];
    
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
    [layer addAnimation:animation forKey:@"transformAnimationNext"];

}

/************************************************
 TIPSボタン
 ************************************************/
- (void)tipsButtonPushed { 
    [soundManager play:E_SOUND_SELECT];
    
 //   PrintLog(@"押下");
    nextPage = nil;
    nextPage = [[TipsViewController alloc] initWithNibName:@"TipsViewController" bundle:nil];

    transitionType = E_TRANSITION_TYPE_FLIP_YZ;
    
    CALayer *layer = self.view.layer;
    
    CATransform3D transformFlip = CATransform3DMakeRotation(M_PI, 0.0f, -1.0f, 1.0f);
    transformFlip = CATransform3DScale(transformFlip, kFlipAnimationScale, kFlipAnimationScale, 1.0f);
    
    // アニメーション後の形をセット
    [layer setTransform:transformFlip];
    
    CATransform3D transform;    
    transform = CATransform3DIdentity;
    transform.m34 = kM34;// 奥行き
    
    CABasicAnimation* animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    [animation setDelegate:self];
    [animation setDuration:kLong2AnimationDuration];
    [animation setRepeatCount:0];
    [animation setRemovedOnCompletion:NO];
    [animation setFromValue:[NSValue valueWithCATransform3D:transform]];
    [animation setToValue:[NSValue valueWithCATransform3D:transformFlip]];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];    
    [layer addAnimation:animation forKey:@"transformAnimationNext"];
    

}


/************************************************
 MEMOボタン
 ************************************************/
- (void)memoButtonPushed {
  //  PrintLog(@"押下");

    [soundManager play:E_SOUND_SELECT];
    
    nextPage = nil;
    nextPage = [[MemoViewController alloc] initWithNibName:@"MemoViewController" bundle:nil];
    
//    [self.navigationController pushViewController:nextPage animated:YES];
    

    transitionType = E_TRANSITION_TYPE_FLIP_XZ;
    
    CALayer *layer = self.view.layer;
    
    CATransform3D transformFlip = CATransform3DMakeRotation(M_PI, 1.0f, 0.0f, 1.0f);
    transformFlip = CATransform3DScale(transformFlip, kFlipAnimationScale, kFlipAnimationScale, 1.0f);
    
    // アニメーション後の形をセット
    [layer setTransform:transformFlip];
    
    CATransform3D transform;    
    transform = CATransform3DIdentity;
    transform.m34 = kM34;// 奥行き
    
    CABasicAnimation* animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    [animation setDelegate:self];
    [animation setDuration:kLong2AnimationDuration];
    [animation setRepeatCount:0];
    [animation setRemovedOnCompletion:NO];
    [animation setFromValue:[NSValue valueWithCATransform3D:transform]];
    [animation setToValue:[NSValue valueWithCATransform3D:transformFlip]];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];    
    [layer addAnimation:animation forKey:@"transformAnimationNext"];
    

}


/************************************************
 BSGAボタン（販促）
 ************************************************/
- (void)bsgaButtonPushed {
    
    NSURL *url = [NSURL URLWithString:@"http://ocogamas.blog.fc2.com/blog-entry-1.html"];
    [[UIApplication sharedApplication] openURL:url];
}



/************************************************
 logボタン
 ************************************************/
- (void)logButtonPushed {
    
    nextPage = [[LogTableViewController alloc] initWithNibName:@"LogTableViewController" bundle:nil];
    
    [self.navigationController pushViewController:nextPage animated:YES];
    nextPage = nil;
    
}

/************************************************
 Blogボタン
 ************************************************/
- (void)blogButtonPushed {
    NSURL *url = [NSURL URLWithString:@"http://ocogamas.blog.fc2.com/"];
    [[UIApplication sharedApplication] openURL:url];
}

/************************************************
 AppStoreボタン
 ************************************************/
- (void)appstoreButtonPushed {
    NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=535470278&mt=8"];
    [[UIApplication sharedApplication] openURL:url];
}


/************************************************
 メモDEBUGボタン
 ************************************************/
- (void)memoDebugButtonPushed {
    
    nextPage = [[MemoViewController alloc] initWithNibName:@"MemoViewController" bundle:nil];
    [self.navigationController pushViewController:nextPage animated:YES];
    nextPage = nil;
    
}
//-----------------------------------------------
//
// UIAlertViewDelegate
//
//-----------------------------------------------
/************************************************
 アラートビューのボタン
 ************************************************/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
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
    
    if (anim == [layer animationForKey:@"transformAnimationNext"]) {
        if (nextPage) {
            [self.navigationController pushViewController:nextPage animated:NO];
            nextPage = nil;
        }
        [layer removeAnimationForKey:@"transformAnimationNext"];
    } else if (anim == [layer animationForKey:@"transformAnimationAppear"]) {
        [layer removeAnimationForKey:@"transformAnimationAppear"];
    }
}

//-----------------------------------------------
//
// スレッド
//
//-----------------------------------------------
/************************************************
 データ送信
 ************************************************/
- (void)sendData {
    [SendDataManager sendData];
}
@end
