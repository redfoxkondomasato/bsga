//
//  GameDataManager.h
//  BSGA
//
//  Created by 近藤 雅人 on 12/05/26.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameDataEntity.h"

@interface GameDataManager : NSObject {
    
}


+ (BOOL)saveGameDataEntity:(GameDataEntity *)gameDataEntity;
+ (GameDataEntity *)getGameDataEntity;

@end
