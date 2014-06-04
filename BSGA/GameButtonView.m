//
//  GameButtonView.m
//  BSGA
//
//  Created by 近藤 雅人 on 12/04/30.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import "GameButtonView.h"

@implementation GameButtonView
@synthesize soundManager;
@synthesize delegate;
@synthesize isMute;
/************************************************
 破棄
 ************************************************/

/************************************************
 view生成時
 ************************************************/
- (void)awakeFromNib {

}




//-----------------------------------------------
//
// タッチ
//
//-----------------------------------------------

/************************************************
 タッチ開始
 ************************************************/
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!isMute) {
        [soundManager play:E_SOUND_BUTTON];
    }
    
    for (UITouch *touch in touches)
    {
        [delegate gameButtonState:YES];
        break;
    }
}

/************************************************
 タッチ移動
 ************************************************/
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
}

/************************************************
 タッチ終了
 ************************************************/
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [delegate gameButtonState:NO];
}

/************************************************
 タッチキャンセル
 ************************************************/
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [delegate gameButtonState:NO];
    NSLog(@"touchesCancelled");
}



@end
