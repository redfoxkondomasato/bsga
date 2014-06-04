//
//  StageManager.m
//  BSGA
//
//  Created by 近藤 雅人 on 12/05/02.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import "StageManager.h"

@implementation StageManager

static int stageNumber;

/************************************************
 全ステージ読み込み
 ・全ステージを読み込む
 ・全ステージをバイナリ化して保存する
 ・読み込みテストをする
 ※実運用上は使わないメソッド
 ************************************************/
+ (void)loadAllStage {
 
    NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
    
    NSMutableArray *stageEntityArray = [[NSMutableArray alloc] init];
    
    
    for (int i=1; i<=190; i++) {

        NSString *file = [NSString stringWithFormat:@"%03d.txt", i];
        NSString *filePath = [bundlePath stringByAppendingPathComponent:file];        
        NSString *dataString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        
//        NSLog(@"dataString[%03d.txt] = %@", i, dataString);
        
        NSArray *lines = [dataString componentsSeparatedByString:@"\n"];
        
        // マップ
        StageEntity *stage = [[StageEntity alloc] init];
        for (int j=0; j<9; j++) {
            NSString *line = [lines objectAtIndex:j];
            for (int k=0; k<9; k++) {    
                
                [stage setMapWithValue:[line characterAtIndex:k]-48 x:k y:j];
                
//                printf("%d ", [stageEntity getMapValueWithX:k y:j]);
            }
//            printf("\n");
        }
        
        // 敵データ
        int enemyCount = [[lines objectAtIndex:9] intValue];
        for (int j=0; j<enemyCount; j++) {
            NSString *line = [lines objectAtIndex:j+10];
            [stage addEnemyDataWithType:[line characterAtIndex:0]-48
                                            x:[line characterAtIndex:1]-48
                                            y:[line characterAtIndex:2]-48
                                         life:[line characterAtIndex:3]-48
                               attackInterval:[line characterAtIndex:4]-48
                                  personality:[line characterAtIndex:5]-48];
            
            EnemyDataEntity *enemyDataEntity = [[stage getEnemyDataEntityArray] objectAtIndex:j];
            NSLog(@"%d %d %d %d %d %d", [enemyDataEntity type], 
                  [enemyDataEntity x], [enemyDataEntity y],
                  [enemyDataEntity life], [enemyDataEntity attackInterval], [enemyDataEntity personality]);
        
        
        }
        
        [stageEntityArray addObject:stage];
        
    }
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:stageEntityArray];

    [archivedData writeToFile:[NSHomeDirectory() stringByAppendingString:@"/Documents/system001"] atomically:YES];

    
    NSData *data = [NSData dataWithContentsOfFile:[NSHomeDirectory() stringByAppendingString:@"/Documents/system001"]];
    NSMutableArray *unarchivedArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    for (int x=0; x<190; x++) {
        StageEntity *entity = [unarchivedArray objectAtIndex:x];
        
        
        for (int i=0; i<9; i++) {
            for (int j=0; j<9; j++) {
                printf("%d ", [entity getMapValueWithX:j y:i]);
            }
            printf("\n");
        }
        for (int i=0; i<[[entity getEnemyDataEntityArray] count]; i++) {
            EnemyDataEntity *enemy = [[entity getEnemyDataEntityArray] objectAtIndex:i];
            NSLog(@"%d %d %d %d %d %d", [enemy type], [enemy x], [enemy y], [enemy life], [enemy attackInterval], [enemy personality]);
        }        
    }
    
}

/************************************************
 ステージ読み込み
 ************************************************/
+ (StageEntity *)getStageEntityAtIndex:(int)index {
    
    stageNumber = index;
    
    NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
    NSString *file = @"system001";
    NSString *filePath = [bundlePath stringByAppendingPathComponent:file];        
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
 //   PrintLog(@"filePath = %@", filePath);
//    PrintLog(@"data length = %d", [data length]);
    NSMutableArray *unarchivedArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    StageEntity *stageEntity = [unarchivedArray objectAtIndex:index];
    return stageEntity;
}

/************************************************
 ステージ数を返す
 ************************************************/
+ (int)getStageNumber {
    return stageNumber;
}

@end
