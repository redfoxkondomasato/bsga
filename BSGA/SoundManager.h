//
//  SoundManager.h
//  BSGA
//
//  Created by 近藤 雅人 on 12/04/28.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>

enum E_SOUND {
    E_SOUND_SELECT,
    E_SOUND_ENEMY_EXPLOSION,
    E_SOUND_PLAYER_EXPLOSION,
    E_SOUND_ATTACK,
    E_SOUND_LASER1,
    E_SOUND_LASER2,
    E_SOUND_DISABLE,
    E_SOUND_BUTTON,
    E_SOUND_DAMAGE,
    E_SOUND_BLOCK,
    E_SOUND_BLOCK2,
    
    E_SOUND_MAX,
};

@interface SoundManager : NSObject {
    SystemSoundID sound[E_SOUND_MAX];
}

- (void)play:(int)number;

@end
