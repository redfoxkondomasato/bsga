//
//  EnemyDataEntity.h
//  BSGA
//
//  Created by 近藤 雅人 on 12/05/03.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Koma.h"

enum E_DOPPEL {
    E_DOPPEL_NONE,
    E_DOPPEL_1,
    E_DOPPEL_2,
};

enum E_RANDOM {
    E_RANDOM_NONE,
    E_RANDOM_1,
    E_RANDOM_2,
};

@interface EnemyDataEntity : Koma<NSCoding> {
    
}
@property(nonatomic) int type;// 駒の種類
@property(nonatomic) int x;// 初期位置のマス
@property(nonatomic) int y;// 初期位置のマス
@property(nonatomic) int life;// 0〜9の値が入るだけ。実際のHPはKomaが管理する
@property(nonatomic) int attackInterval;
@property(nonatomic) int personality;

@property(nonatomic) int moveCounter;  // 移動カウンタ（負数:停止 0:向き設定 正数:0になるまで動く）
@property(nonatomic) int attackCounter;// 攻撃カウンタ（0:攻撃 正数:0になるまで攻撃しない）

@property(nonatomic) int dropFuel;// 落とす燃料

@property(nonatomic) int doppel;// ドッペル
@property(nonatomic) int random;// ランダム駒

@property(nonatomic) int poison;
@property(nonatomic) int poisonCounter;
@property(nonatomic) int bindCounter;
@property(nonatomic) float defaultSpeed;


@end
