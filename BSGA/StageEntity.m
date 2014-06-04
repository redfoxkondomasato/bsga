//
//  StageEntity.m
//  BSGA
//
//  Created by 近藤 雅人 on 12/05/02.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import "StageEntity.h"

@implementation StageEntity
/************************************************
 破棄
 ************************************************/
/************************************************
 初期化（デコード）
 ************************************************/
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {

        NSArray *array = [aDecoder decodeObjectForKey:@"enemyArray"];
        
        enemyDataEntityArray = [[NSMutableArray alloc] initWithArray:array];
        
        for (int i=0; i<9; i++) {
            for (int j=0; j<9; j++) {
                map[i][j] = [aDecoder decodeIntegerForKey:[NSString stringWithFormat:@"map%d%d", i, j]];
            }
        }
        
    }
    return self;
}
/************************************************
 初期化
 ************************************************/
- (id)init {
    self = [super init];
    if (self) {
        enemyDataEntityArray = [[NSMutableArray alloc] init];
    }
    return self;
}
/************************************************
 エンコード
 ************************************************/
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:enemyDataEntityArray forKey:@"enemyArray"];
    for (int i=0; i<9; i++) {
        for (int j=0; j<9; j++) {
            [aCoder encodeInteger:map[i][j] forKey:[NSString stringWithFormat:@"map%d%d", i, j]];
        }
    }
    
}
/************************************************
 マップに値を代入
 ************************************************/
- (void)setMapWithValue:(int)value x:(int)x y:(int)y {
    map[x][y] = value;
}
/************************************************
 マップの値
 ************************************************/
- (int)getMapValueWithX:(int)x y:(int)y {
    return map[x][y];
}

/************************************************
 敵データを追加
 ************************************************/
- (void)addEnemyDataWithType:(int)type 
                           x:(int)x 
                           y:(int)y 
                        life:(int)life 
              attackInterval:(int)attackInterval 
                 personality:(int)personality {
   
    EnemyDataEntity *enemyDataEntity = [[EnemyDataEntity alloc] init];
    [enemyDataEntity setType:type];
    [enemyDataEntity setX:x];
    [enemyDataEntity setY:y];
    [enemyDataEntity setLife:life];
    [enemyDataEntity setAttackInterval:attackInterval];
    [enemyDataEntity setPersonality:personality];
    [enemyDataEntityArray addObject:enemyDataEntity];
}
/************************************************
 敵データ配列を返却
 ************************************************/
- (NSMutableArray *)getEnemyDataEntityArray {
    return enemyDataEntityArray;
}


@end
