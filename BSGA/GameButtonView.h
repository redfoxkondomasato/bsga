//
//  GameButtonView.h
//  BSGA
//
//  Created by 近藤 雅人 on 12/04/30.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundManager.h"
@interface GameButtonView : UIView {
    
}

@property (nonatomic, weak) id delegate;
@property (nonatomic, weak) SoundManager *soundManager;
@property (nonatomic) BOOL isMute;

@end

@protocol GameButtonViewDelegate

- (void)gameButtonState:(BOOL)isPushed;

@end