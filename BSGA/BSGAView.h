//
//  BSGAView.h
//  BSGA
//
//  Created by 近藤 雅人 on 12/05/04.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Canvas.h"
#import "Graphics.h"
#import "Image.h"
#import "Koma.h"
#import "PlayerKoma.h"
#import "StageManager.h"
#import "SoundManager.h"
#import "DirectionKeyView.h"
#import "GameDataManager.h"
#import "GameDataEntity.h"
#import "AnimationManager.h"

enum E_GAME_STATE {
    E_GAME_STATE_LAUNCH_ANIMATION,  // 開始アニメーション
    E_GAME_STATE_MAPPING_ANIMATION, // マップ配置アニメーション
    E_GAME_STATE_PLAY,              // プレイ
    E_GAME_STATE_PAUSE,             // 一時停止
    E_GAME_STATE_GAME_OVER,         // ゲームオーバー
    E_GAME_STATE_STAGE_CLEAR,       // ステージクリア
    
};

enum E_BLOCK {
    E_BLOCK_NONE,
    E_BLOCK_HARD,
    E_BLOCK_SOFT1,
    E_BLOCK_SOFT2,
    E_BLOCK_SOFT3,
    E_BLOCK_SOFT4,
    E_BLOCK_SOFT5,
};

typedef struct starStruct {
    float x;
    float y;
    float ax;// 傾き
    float ay;// 傾き
} Star;

typedef struct starOptionStruct {
    int count;
    int type;
    int r, g, b;    
} StarOption;

typedef struct colorStruct {
    int r, g, b;
} RGBColor;

@interface BSGAView : Canvas {
    
    BOOL isOmakeMap;
    
    Star star[1025];
    StarOption starOption;
    RGBColor boardColor;
    RGBColor bgColor;
    
    BOOL isCleared;// クリア処理完了フラグ
    
    float tame;
    Graphics *g;
    Image    *image;
    NSArray *enemyDataEntityArray;
    int map[9][9];
    PlayerKoma *playerKoma;
    int launchAnimationCounter;
    
    BOOL item[8];// 持っている駒（処理速度を軽くするためゲーム画面が持つ）
    
    BOOL canPlaySound[E_SOUND_MAX];
    
    float fps;
    
    float launchAnimationCount;
    int controllerMode;
    float controllerAngleLarge;
    float controllerAngleSmall;
    float controllerDrawLarge;
    float controllerDrawSmall;
}
@property (nonatomic, weak) StageEntity *stageEntity;
@property (nonatomic) int level;
@property (nonatomic) int stageNumber;
@property (nonatomic) int gameState;
@property (nonatomic) BOOL gameButtonState;
@property (nonatomic) float directionX;
@property (nonatomic) float directionY;
@property (nonatomic, strong) SoundManager *soundManager;
@property (nonatomic, strong) DirectionKeyView *directionKeyView;
@property (nonatomic, strong) GameDataEntity *gameDataEntity;

- (void)calcGame;
- (void)draw;
- (void)drawStar;
- (void)drawBoard;
- (void)drawMap;
- (void)drawEnemy;
- (void)drawPlayer;
- (void)drawAttackExplosion;
- (void)drawAttackExplosionWithKoma:(Koma *)koma;
- (void)drawDeadExplosionWithKoma:(Koma *)koma;
- (void)drawPlayerInfo;
- (void)drawEnemyInfo;
- (void)drawStageInfo;
- (void)drawDirectionKey;

- (void)playerWorks;
- (void)enemyAction;
- (void)checkHitBodyWithEnemy:(EnemyDataEntity *)enemy;
- (int)getEnemyNextDirection:(int)direction;
- (float)moveWithKoma:(Koma *)koma directionX:(float)dirX directionY:(float)dirY;

- (void)attackCheckWithKoma:(Koma *)koma;


- (float)wallCheckWithKoma:(Koma *)koma directionX:(float)dirX directionY:(float)dirY;
- (void)wallAttackCheckWithKoma:(Koma *)koma;

- (void)playSound:(int)sound;

- (void)drawHP:(int)hp x:(float)x y:(float)y;
@end
