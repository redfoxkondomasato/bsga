//
//  SoundManager.m
//  BSGA
//
//  Created by 近藤 雅人 on 12/04/28.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "SoundManager.h"

@implementation SoundManager
/************************************************
 破棄
 ************************************************/

/************************************************
 初期化
 ************************************************/
- (id)init {
    self = [super init];
    if (self) {
        
        NSArray *pathArray = [NSArray arrayWithObjects:
                              @"select.caf", 
                              @"enemy_explosion.caf",
                              @"player_explosion.caf",
                              @"attack.caf",
                              @"laser1.caf",
                              @"laser2.caf",
                              @"disable.caf",
                              @"button.caf",
                              @"damage.caf",
                              @"block.caf",
                              @"block2.caf",
                              nil];

        
        for (int i=0; i<E_SOUND_MAX; i++) {
            NSString *filePath
            = [[NSBundle mainBundle] pathForResource:[pathArray objectAtIndex:i] ofType:@""];
            
//            NSLog(@"filePath[%d] = %@ %@", i, filePath, [pathArray objectAtIndex:i]);
            
            NSURL *url = [NSURL fileURLWithPath:filePath];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &sound[i]);
        }
    }
    return self;
}

/************************************************
 再生
 ************************************************/
- (void)play:(int)number {
    AudioServicesPlaySystemSound(sound[number]);
}


@end
