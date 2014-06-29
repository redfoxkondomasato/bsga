//
//  CustomizeViewController.m
//  BSGA
//
//  Created by 近藤 雅人 on 12/05/18.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import "CustomizeViewController.h"

@interface CustomizeViewController ()

@end

@implementation CustomizeViewController
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
        // Custom initialization
    }
    return self;
}
/************************************************
 ビュー読み込み後
 ************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setGameDataEntity:[GameDataManager getGameDataEntity]];
    
    
    [backButton addTarget:self
                   action:@selector(backButtonPushed)
         forControlEvents:UIControlEventTouchUpInside];
    
    [infoButton addTarget:self
                   action:@selector(infoButtonPushed)
         forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [controllerModeSegmentedControl setSelectedSegmentIndex:[gameDataEntity customizeControllerMode]];
    [controllerModeSegmentedControl addTarget:self
                                       action:@selector(controllerModeSegmentedControlValueChanged:) 
                             forControlEvents:UIControlEventValueChanged];
    
    // 初級のステージ29をクリアすると出現
    if ([gameDataEntity getStageClearStatusWithLevel:0 stage:29] == -2) {
        [backgroundColorRandomSegmentedControl setHidden:YES];
    }
    
    [backgroundColorRandomSegmentedControl setSelectedSegmentIndex:[gameDataEntity customizeBackgroundColorRandom]];
    [backgroundColorRandomSegmentedControl addTarget:self
                                              action:@selector(backgroundColorRandomSegmentedControlValueChanged:)
                                    forControlEvents:UIControlEventValueChanged];
    
    // 中級のステージ10をクリアすると出現
    if ([gameDataEntity getStageClearStatusWithLevel:1 stage:10] == -2) {
        [soundSegmentedControl setHidden:YES];
    }
    
    [soundSegmentedControl setSelectedSegmentIndex:[gameDataEntity customizeButtonSound]];
    [soundSegmentedControl addTarget:self
                              action:@selector(soundSegmentedControlValueChanged:)
                    forControlEvents:UIControlEventValueChanged];
    
    // 上級のステージ40をクリアすると出現
    if ([gameDataEntity getStageClearStatusWithLevel:2 stage:40] == -2) {
        [blockSegmentedControl setHidden:YES];
    }
    
    [blockSegmentedControl setSelectedSegmentIndex:[gameDataEntity customizeBlock]];
    [blockSegmentedControl addTarget:self
                              action:@selector(blockSegmentedControlValueChanged:)
                    forControlEvents:UIControlEventValueChanged];
}

/************************************************
 ビュー表示前
 ************************************************/
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    CATransform3D transformFromFlip = CATransform3DMakeRotation(M_PI/2.0f, -1.0f, 0.0, 0.0f);
    transformFromFlip = CATransform3DScale(transformFromFlip, kFlipXAnimationScale, kFlipXAnimationScale, 1.0f);
    
    CATransform3D transformToFlip = CATransform3DMakeRotation(0.0f, 0.0f, 0.0f, 0.0f);
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
    
    CATransform3D transformFlip = CATransform3DMakeRotation(M_PI/2.0f, 1.0f, 0.0f, 0.0f);
    transformFlip = CATransform3DScale(transformFlip, kFlipXAnimationScale, kFlipXAnimationScale, 1.0f);
    
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
 インフォボタン
 ************************************************/
- (void)infoButtonPushed
{
    [[[UIAlertView alloc] initWithTitle:kAlertCustomizeInfoTitle
                               message:kAlertCustomizeInfoMessage
                              delegate:nil
                     cancelButtonTitle:@"x"
                       otherButtonTitles:nil] show];
    
    [AnimationManager basicAnimationWithView:infoButton
                                    duration:1.0f
                                       delay:0.0f
                                     options:UIViewAnimationOptionCurveEaseInOut
                                 fromToAlpha:CGPointMake(1.0f, 0.0f)
                                fromToRotate:CGPointZero
                                  beginScale:CGPointMake(1.0f, 1.0f)
                                 finishScale:CGPointMake(2.5f, 0.1f)
                              beginTranslate:CGPointZero
                             finishTranslate:CGPointZero];
}

/************************************************
 コントローラモードSegmentedControl
 ************************************************/
- (void)controllerModeSegmentedControlValueChanged:(UISegmentedControl *)segmentedControl
{
    [gameDataEntity setCustomizeControllerMode:[segmentedControl selectedSegmentIndex]];

    if ([segmentedControl selectedSegmentIndex] == 0) {
        [detailLabel setText:@"斜め方向キーの角度：30度"];        
    } else {
        [detailLabel setText:@"斜め方向キーの角度：45度"];   
    }
    
    [self customizeAnimationWithLabel:detailLabel component:segmentedControl];
}

/************************************************
 背景色ランダムSegmentedControl
 ************************************************/
- (void)backgroundColorRandomSegmentedControlValueChanged:(UISegmentedControl *)segmentedControl {
    [gameDataEntity setCustomizeBackgroundColorRandom:[segmentedControl selectedSegmentIndex]];
    
    if ([segmentedControl selectedSegmentIndex] == 0) {
        [detailLabel setText:@"背景色：黒"];        
    } else {
        [detailLabel setText:@"背景色：ランダム"];   
    }
    
    [self customizeAnimationWithLabel:detailLabel component:segmentedControl];

}

/************************************************
 ボタン音SegmentedControl
 ************************************************/
- (void)soundSegmentedControlValueChanged:(UISegmentedControl *)segmentedControl {
    [gameDataEntity setCustomizeButtonSound:[segmentedControl selectedSegmentIndex]];
    
    if ([segmentedControl selectedSegmentIndex] == 0) {
        [detailLabel setText:@"ボタン音：あり"];        
    } else {
        [detailLabel setText:@"ボタン音：なし"];   
    }
    
    [self customizeAnimationWithLabel:detailLabel component:segmentedControl];
    
}

/************************************************
 ブロックSegmentedControl
 ************************************************/
- (void)blockSegmentedControlValueChanged:(UISegmentedControl *)segmentedControl {
    [gameDataEntity setCustomizeBlock:[segmentedControl selectedSegmentIndex]];
    
    if ([segmentedControl selectedSegmentIndex] == 0) {
        [detailLabel setText:@"ブロック：通常"];        
    } else {
        [detailLabel setText:@"ブロック：特殊"];   
    }
    
    [self customizeAnimationWithLabel:detailLabel component:segmentedControl];
    
}


/************************************************
 設定画面のアニメーション
 ************************************************/
- (void)customizeAnimationWithLabel:(UILabel *)label component:(UIView *)component {
    [AnimationManager popAnimationWithView:label
                                  duration:0.4f
                                     delay:0.0f
                                     alpha:0.7f];
    [AnimationManager basicAnimationWithView:component
                                    duration:0.25f
                                       delay:0.0f
                                     options:UIViewAnimationCurveEaseIn
                                 fromToAlpha:CGPointMake(1.0f, 1.0f) 
                                fromToRotate:CGPointZero
                                  beginScale:CGPointMake(1.0f, 0.9f)
                                 finishScale:CGPointMake(1.0f, 1.0f)
                              beginTranslate:CGPointZero
                             finishTranslate:CGPointZero];
    
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
