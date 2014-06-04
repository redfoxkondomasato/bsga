//
//  Koma.h
//  BSGA
//
//  Created by 近藤 雅人 on 12/04/30.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import <Foundation/Foundation.h>
enum E_GUN_BULLET {
    E_GUN_BULLET_NORMAL,    // 通常弾
    E_GUN_BULLET_OGOMA,      // 進行弾（飛車・角）
    E_GUN_BULLET_KYOSYA,    // 香車弾
    E_GUN_BULLET_KEIMA,     // 桂馬弾
};

enum E_DIRECTION {
    E_DIRECTION_UP,    // 0
    E_DIRECTION_LEFT,  // 1
    E_DIRECTION_RIGHT, // 2
    E_DIRECTION_DOWN,  // 3
};

enum E_KOMA_STATE {
    E_KOMA_STATE_NONE,   // 非表示
    E_KOMA_STATE_NORMAL, // 通常
    E_KOMA_STATE_DAMAGE, // ダメージ（点滅）
    E_KOMA_STATE_BREAK,  // 破壊（爆発）
    E_KOMA_STATE_SUPER,  // 溜め打ちモード
};

enum E_KOMA_TYPE {
    E_KOMA_TYPE_FU,   // 歩
    E_KOMA_TYPE_KYO,  // 香
    E_KOMA_TYPE_KEI,  // 桂
    E_KOMA_TYPE_GIN,  // 銀
    E_KOMA_TYPE_KIN,  // 金
    E_KOMA_TYPE_KAKU, // 角
    E_KOMA_TYPE_HI,   // 飛
    E_KOMA_TYPE_OU,   // 王
};

@interface Koma : NSObject {
    CGRect gunRect[8];
    int wallDamagingCounter[9][9];// 正の時は壁にダメージを与えない
    int wallAttackPower[8];// 各エリア毎の壁破壊有効値（１のとき壁攻撃可能、0は攻撃不可）
}
@property(nonatomic) float speed;
@property(nonatomic) int state;
@property(nonatomic) int type;
@property(nonatomic) int direction;
@property(nonatomic) int hitPoint;
@property(nonatomic) CGPoint pos;
@property(nonatomic) int damagingCounter;
@property(nonatomic) int deadExplosionCounter;

@property(nonatomic) BOOL isTame;
@property(nonatomic) float tameRange;// 飛距離
@property(nonatomic) BOOL isWeak;

@property(nonatomic) int gunType;// 攻撃時に駒タイプをセットする。
@property(nonatomic) int gunDirection; // 攻撃時に方向をセットする。
@property(nonatomic) CGPoint gunDefaultPos;
@property(nonatomic) int gunCounter;


// 向きを計算して返却する
- (int)calcDirectionWithDirectionX:(int)x directionY:(int)y;
- (float)checkOnBoard;
- (float)moveWithDirectionX:(float)x directionY:(float)y;
- (void)setPos:(CGPoint)point;
- (void)hitWithValue:(int)value;
- (void)setGunRectAtIndex:(int)index bullet:(int)bullet;
- (CGRect)getGunRectAtIndex:(int)index;
- (void)gunWork;

- (int)getWallDamagingCounterWithX:(int)x y:(int)y;
- (int)getWallAttackPowerWithArea:(int)area;
- (void)setWallDamagingCounterWithX:(int)x y:(int)y;
- (void)decreaseWallDamagingCounterWithX:(int)x y:(int)y;
- (void)decreaseWallAttackPowerWithArea:(int)area;
- (void)resetWallAttackPower;
@end
