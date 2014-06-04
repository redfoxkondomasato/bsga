//
//  StageEntity.h
//  BSGA
//
//  Created by 近藤 雅人 on 12/05/02.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnemyDataEntity.h"
@interface StageEntity : NSObject<NSCoding> {
    int map[9][9];
    NSMutableArray *enemyDataEntityArray;
}

- (void)setMapWithValue:(int)value x:(int)x y:(int)y;
- (int)getMapValueWithX:(int)x y:(int)y;
- (void)addEnemyDataWithType:(int)type 
                           x:(int)x 
                           y:(int)y 
                        life:(int)life 
              attackInterval:(int)attackInterval 
                 personality:(int)personality;
- (NSMutableArray *)getEnemyDataEntityArray;
@end
