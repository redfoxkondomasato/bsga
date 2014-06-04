//
//  GameDataEntity.h
//  BSGA
//
//  Created by 近藤 雅人 on 12/05/26.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameDataEntity : NSObject<NSCoding> {
    
    /*
     ステージクリア状況
     -2:選択不可
     -1:未クリア 
      0:ノーダメージクリア    
      1:１ダメージクリア
      2:２ダメージクリア
     　　　　・
     　　　　・
     　　　　・
     */
    int stageClearStatus[4][180];// [難易度][ステージ]
    
    int gacha01Normal[20];
    int gacha01Rare[6];
    int gacha01SuperRare[2];
    
    
    int gacha02Normal[30];
    int gacha02Rare[20];
    int gacha02SuperRare[10];
    
    
    int gacha03Normal[12];
    int gacha03Rare[10];
    int gacha03SuperRare[14];
}

@property(nonatomic) int launchCount;
@property(nonatomic) int score;
/*
 ポイント関連
 */
@property(nonatomic) int points;

@property(nonatomic) int hp;
@property(nonatomic) int special;
@property(nonatomic) int reload;
@property(nonatomic) int fuel;
@property(nonatomic) int attack;
@property(nonatomic) int bind;
@property(nonatomic) int speed;

@property(nonatomic) int customizeControllerMode;
@property(nonatomic) int customizeBackgroundColorRandom;
@property(nonatomic) int customizeButtonSound;
@property(nonatomic) int customizeBlock;

@property(nonatomic) int gachaPoints;

@property(nonatomic) int payCountPoint;// 課金回数（ポイント）
@property(nonatomic) int payCountGacha;// 課金回数（ガチャ）

- (void)setStageClearStatusWithLevel:(int)level stage:(int)stage value:(int)value;
- (int)getStageClearStatusWithLevel:(int)level stage:(int)stage;

- (void)setGacha01Normal:(int)index value:(int)value;
- (int)getGacha01Normal:(int)index;
- (void)setGacha01Rare:(int)index value:(int)value;
- (int)getGacha01Rare:(int)index;
- (void)setGacha01SuperRare:(int)index value:(int)value;
- (int)getGacha01SuperRare:(int)index;

- (void)setGacha02Normal:(int)index value:(int)value;
- (int)getGacha02Normal:(int)index;
- (void)setGacha02Rare:(int)index value:(int)value;
- (int)getGacha02Rare:(int)index;
- (void)setGacha02SuperRare:(int)index value:(int)value;
- (int)getGacha02SuperRare:(int)index;

- (void)setGacha03Normal:(int)index value:(int)value;
- (int)getGacha03Normal:(int)index;
- (void)setGacha03Rare:(int)index value:(int)value;
- (int)getGacha03Rare:(int)index;
- (void)setGacha03SuperRare:(int)index value:(int)value;
- (int)getGacha03SuperRare:(int)index;


@end
