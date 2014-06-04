//
//  SendDataManager.m
//  BSGA
//
//  Created by 近藤 雅人 on 12/06/16.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import "SendDataManager.h"

@implementation SendDataManager

/************************************************
 データ送信
 ************************************************/
+ (void)sendData {
 //   PrintLog(@"");
    
    
    // 日時
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    // 言語（国）
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    // デバイス名
    NSString *device = [[UIDevice currentDevice] model];
    NSString *deviceName = [[UIDevice currentDevice] name];

    
    // 保存データ（戦績、起動回数）
    GameDataEntity *gameDataEntity = [GameDataManager getGameDataEntity];
    int shokyu = 0;
    int chukyu = 0;
    int jokyu = 0;
    int chokyu = 0;
    for (int i=0; i<180; i++) {
        if ([gameDataEntity getStageClearStatusWithLevel:0 stage:i] > -2) {
            shokyu = i+1;
        }
        if ([gameDataEntity getStageClearStatusWithLevel:1 stage:i] > -2) {
            chukyu = i+1;
        }
        if ([gameDataEntity getStageClearStatusWithLevel:2 stage:i] > -2) {
            jokyu = i+1;
        }
        if (i<10) {
            if ([gameDataEntity getStageClearStatusWithLevel:3 stage:i] > -2) {
                chokyu = i+1;
            }
        }
    }
    
    int gacha01rate = 0;
    int gacha02rate = 0;
    int gacha03rate = 0;
    for (int i=0; i<20; i++) {
        gacha01rate += [gameDataEntity getGacha01Normal:i];
    }
    for (int i=0; i<6; i++) {
        gacha01rate += [gameDataEntity getGacha01Rare:i];
    }
    for (int i=0; i<2; i++) {
        gacha01rate += [gameDataEntity getGacha01SuperRare:i];
    }
    for (int i=0; i<30; i++) {
        gacha02rate += [gameDataEntity getGacha02Normal:i];
    }
    for (int i=0; i<20; i++) {
        gacha02rate += [gameDataEntity getGacha02Rare:i];
    }
    for (int i=0; i<10; i++) {
        gacha02rate += [gameDataEntity getGacha02SuperRare:i];
    }
    for (int i=0; i<12; i++) {
        gacha03rate += [gameDataEntity getGacha03Normal:i];
    }
    for (int i=0; i<10; i++) {
        gacha03rate += [gameDataEntity getGacha03Rare:i];
    }
    for (int i=0; i<14; i++) {
        gacha03rate += [gameDataEntity getGacha03SuperRare:i];
    }
    
    gacha01rate *= 100;
    gacha02rate *= 100;
    gacha03rate *= 100;
    gacha01rate /= 28;
    gacha02rate /= 60;
    gacha03rate /= 36;
    
    NSString *requestText 
    = [NSString stringWithFormat:@"%@,%3d,%@,%10@,%3d,%3d,%3d,%2d, %2d, %2d, %2d, %2d, %2d, %@, %5d", 
       dateString,
       [gameDataEntity launchCount], 
       language,
       device,
       shokyu, chukyu, jokyu, chokyu,
       gacha01rate, gacha02rate, gacha03rate,
       [gameDataEntity payCountPoint],
       [gameDataEntity payCountGacha],
       deviceName,
       [gameDataEntity score]
       ];
//    PrintLog("%@", requestText);
    
    NSURL *url = [NSURL URLWithString:@"http://ocogamas.sitemix.jp/bsga/log.php"];
    NSData *requestData = [requestText dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setHTTPBody:requestData];
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    [NSURLConnection sendSynchronousRequest:request
                          returningResponse:&response
                                      error:&error];
//    PrintLog(@"%d", [response statusCode]);
//PrintLog(@"%@", error);
}



@end
