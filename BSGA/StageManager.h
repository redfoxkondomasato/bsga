//
//  StageManager.h
//  BSGA
//
//  Created by 近藤 雅人 on 12/05/02.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StageEntity.h"
#import "EnemyDataEntity.h"

enum E_STAGE_LEVEL {
    E_STAGE_LEVEL_SHOKYU,
    E_STAGE_LEVEL_CHUKYU,
    E_STAGE_LEVEL_JOKYU,
    E_STAGE_LEVEL_CHOKYU,
};


@interface StageManager : NSObject {
    
}


+ (void)loadAllStage;
+ (StageEntity *)getStageEntityAtIndex:(int)index;

+ (int)getStageNumber;
@end
