//
//  DirectionKeyView.h
//  BSGA
//
//  Created by 近藤 雅人 on 12/04/22.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundManager.h"
@interface DirectionKeyView : UIView
{
    
}
@property (nonatomic) BOOL isPushed;
@property (nonatomic) float x;
@property (nonatomic) float y;
@property (nonatomic) float baseX;
@property (nonatomic) float baseY;
@property (nonatomic) float posX;
@property (nonatomic) float posY;

@property (nonatomic) float directionX;
@property (nonatomic) float directionY;

@property (nonatomic) BOOL isMute;



@property (nonatomic, strong) SoundManager *soundManager;

- (void)resetWithX:(float)defaultX y:(float)defaultY;
- (void)resetTouch;

@end
