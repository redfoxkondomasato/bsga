//
//  GameDataManager.m
//  BSGA
//
//  Created by 近藤 雅人 on 12/05/26.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import "GameDataManager.h"
@implementation GameDataManager

/************************************************
 ゲームデータの保存
 ・起動回数
 ・能力パラメータ、ポイント
 ・ステージクリア状況
 ・ガチャ関連
 ************************************************/
+ (BOOL)saveGameDataEntity:(GameDataEntity *)gameDataEntity {
        
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:gameDataEntity];
    BOOL isSuccess = [archivedData writeToFile:[NSHomeDirectory() stringByAppendingString:@"/Documents/system002"] atomically:YES];
    
    [archivedData writeToFile:[NSHomeDirectory() stringByAppendingString:@"/Documents/system000"] atomically:YES];// ダミー
    [archivedData writeToFile:[NSHomeDirectory() stringByAppendingString:@"/Documents/system003"] atomically:YES];// ダミー
    if (!isSuccess) {
        [[[UIAlertView alloc] initWithTitle:@"データ保存失敗"
                                    message:@"端末の容量が足りない場合にデータ保存が失敗する事があります"
                                   delegate:nil
                          cancelButtonTitle:@"alright"
                          otherButtonTitles:nil] show];
    }
    return isSuccess;
}

/************************************************
 ゲームデータの読み込み
 ・能力パラメータ、ポイント
 ・ステージクリア状況
 ************************************************/
+ (GameDataEntity *)getGameDataEntity {
    
    NSString *file = @"/Documents/system002";
    NSString *filePath = [NSHomeDirectory() stringByAppendingString:file];        
    NSData *data = [NSData dataWithContentsOfFile:filePath];
  //  PrintLog(@"data = %@", data);
    
    // 初期データ生成
    if (!data)
    {
        GameDataEntity *gameDataEntity;
        gameDataEntity = [[GameDataEntity alloc] init];
        
        [gameDataEntity setPoints:0];
        [gameDataEntity setHp:1];
        [gameDataEntity setSpecial:0];
        [gameDataEntity setReload:0];
        [gameDataEntity setFuel:0];
        [gameDataEntity setAttack:1];
        [gameDataEntity setBind:0];
        [gameDataEntity setSpeed:0];
        
        for (int level=0; level<4; level++) {
            for (int stage=0; stage<180; stage++) {
                [gameDataEntity setStageClearStatusWithLevel:level stage:stage value:-2];// 全ステージ選択不可
            }
        }
        [gameDataEntity setStageClearStatusWithLevel:0 stage:0 value:-1];// 初級の最初のステージは選択可
        
        [gameDataEntity setGachaPoints:300];
        
        for (int i=0; i<20; i++) {
            [gameDataEntity setGacha01Normal:i value:0];
        }
        for (int i=0; i<6; i++) {
            [gameDataEntity setGacha01Rare:i value:0];
        }
        for (int i=0; i<2; i++) {
            [gameDataEntity setGacha01SuperRare:i value:0];
        }
        
        for (int i=0; i<30; i++) {
            [gameDataEntity setGacha02Normal:i value:0];
        }
        for (int i=0; i<20; i++) {
            [gameDataEntity setGacha02Rare:i value:0];
        }
        for (int i=0; i<10; i++) {
            [gameDataEntity setGacha02SuperRare:i value:0];
        }
        
        for (int i=0; i<12; i++) {
            [gameDataEntity setGacha03Normal:i value:0];
        }
        for (int i=0; i<10; i++) {
            [gameDataEntity setGacha03Rare:i value:0];
        }
        for (int i=0; i<14; i++) {
            [gameDataEntity setGacha03SuperRare:i value:0];
        }
        
        
        BOOL isSuccess = [GameDataManager saveGameDataEntity:gameDataEntity];
        if (!isSuccess) {
            [[[UIAlertView alloc] initWithTitle:@"データ保存失敗"
                                        message:@"端末の容量が足りない場合にデータ保存が失敗する事があります"
                                       delegate:nil
                              cancelButtonTitle:@"alright"
                              otherButtonTitles:nil] show];
        } else {
  //          PrintLog(@"読み込み成功 length = %d", [data length]);
        }
        
        return gameDataEntity;
    } else {
        GameDataEntity *unarchivedGameDataEntity = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return unarchivedGameDataEntity;
    }    
}


@end
