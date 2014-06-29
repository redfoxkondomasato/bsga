//
//  DirectionKeyView.m
//  BSGA
//
//  Created by 近藤 雅人 on 12/04/22.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import "DirectionKeyView.h"

@implementation DirectionKeyView
@synthesize soundManager;
@synthesize isPushed;
@synthesize x, y;
@synthesize baseX, baseY;
@synthesize posX, posY;
@synthesize isMute;
@synthesize directionX, directionY;

- (void)resetWithX:(float)defaultX y:(float)defaultY
{
    // 位置固定
    if (kControllerStyle == 0) {
        baseX = defaultX;
        baseY = defaultY;
        x = defaultX;// 70
        y = defaultY;// 390
    }
}



/************************************************
 タッチ位置をコントローラの中心にリセットする（停止状態にする）
 ************************************************/
- (void)resetTouch {
    x = baseX;
    y = baseY;
}

//-----------------------------------------------
//
// タッチ
//
//-----------------------------------------------

/************************************************
 タッチ開始
 ************************************************/
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!isMute) {
        [soundManager play:E_SOUND_BUTTON];
    }
    isPushed = YES;
    
    for (UITouch *touch in touches) {
        CGPoint point = [touch locationInView:self];
        x = point.x;
        y = point.y - 20; // todokondo 調整
        
        // 位置固定
        if (kControllerStyle == 0) {
        } else {
            baseX = x;
            baseY = y;
        }
        break;
    }
}

/************************************************
 タッチ移動
 ************************************************/
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint point = [touch locationInView:self];
        x = point.x;
        y = point.y - 20;
        break;
    }
}

/************************************************
 タッチ終了
 ************************************************/
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    isPushed = NO;

    x = baseX;
    y = baseY;
}

/************************************************
 タッチキャンセル
 ************************************************/
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    isPushed = NO;
}


@end
