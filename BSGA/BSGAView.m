//
//  BSGAView.m
//  BSGA
//
//  Created by 近藤 雅人 on 12/05/04.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import "BSGAView.h"

#define kAdjustOldMobileValue 2.25f
#define kStarTypeNumber 3
@implementation BSGAView
@synthesize gameState;
@synthesize level;
@synthesize stageNumber;
@synthesize gameButtonState;
@synthesize directionX;
@synthesize directionY;
@synthesize stageEntity;
@synthesize soundManager;
@synthesize directionKeyView;
@synthesize gameDataEntity;
/************************************************
 初期化
 ************************************************/
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        directionX = 0.0f;
        directionY = 0.0f;
        
        gameState = E_GAME_STATE_LAUNCH_ANIMATION;
        g = [[Graphics alloc] init];
        image = nil;
        
        [self setContentScaleFactor:2.0f];
        
        playerKoma = [[PlayerKoma alloc] init];
            
    }
    return self;
}

/************************************************
 破棄
 ************************************************/
- (void)dealloc {
    PrintLog();
    
}

/************************************************
 セットアップ
 ************************************************/
- (void)setup {
    // ゲームデータ読み込み
    [self setGameDataEntity:[GameDataManager getGameDataEntity]];

    srand(time(NULL));
    
    fps =  500;
    [self startAnime:fps];
    
    {// ===========================================
        // 方向キーモードを設定
        controllerMode = [gameDataEntity customizeControllerMode];
        
        // 斜め範囲30度モード
        if (controllerMode == 0) {
            controllerAngleLarge = 1.7320508; // 60度　（2.41421356 67.5度）
            controllerAngleSmall = 0.57735027;// 30度　（0.41423562 22.5度）
            controllerDrawSmall = 30;
            controllerDrawLarge = 52;
        }
        // 斜め範囲45度モード
        else if (controllerMode == 1) {
            controllerAngleLarge = 2.41421356;
            controllerAngleSmall = 0.41423562;
            controllerDrawSmall = 23;
            controllerDrawLarge = 55;
        }
    }// ===========================================

    
    launchAnimationCount = 10.0f + (rand()%21)*2.0f;
    
    //グラフィックスのセットアップ
    [g initSize:CGSizeMake(self.bgWidth, self.bgHeight)];
    
    //イメージの読み込み
    image=[Image makeImage:[UIImage imageNamed:@"image01.png"]];
    
    // おまけマップ
    isOmakeMap = NO;
    if (rand()%200 == 0) {// 0.5%
        isOmakeMap = YES;
    }
    if ([gameDataEntity customizeBlock] == 1) {
        isOmakeMap = YES;
    }

    bgColor.r = 0;
    bgColor.g = 0;
    bgColor.b = 0;
    
    if ([gameDataEntity customizeBackgroundColorRandom] == 1) {
        bgColor.r = rand()%256;
        bgColor.g = rand()%256;
        bgColor.b = rand()%256;
    }

    // 初級
    if (level == E_STAGE_LEVEL_SHOKYU) {
        starOption.count = rand()%11;    // ランダム星数
        starOption.type = 0;
        starOption.r = rand()%256;// 赤、緑、黄色、オレンジ多め
        starOption.g = rand()%256;
        starOption.b = rand()%128;
        
        // 盤の色設定
        boardColor.r = rand()%128;// 青、緑、シアン多め
        boardColor.g = rand()%256;
        boardColor.b = rand()%256;

    }
    // 中級
    else if (level == E_STAGE_LEVEL_CHUKYU) {
        starOption.count = rand()%61;    // ランダム星数        
        starOption.type = rand()%3;
        starOption.r = rand()%128;// 青、緑、シアン多め
        starOption.g = rand()%256;
        starOption.b = rand()%256;
        
        // 盤の色設定
        boardColor.r = rand()%256;// 赤、緑、黄色、オレンジ多め
        boardColor.g = rand()%256;
        boardColor.b = rand()%128;

    } 
    // 上級、超級
    else {
        // おまけマップ
        if (rand()%100 == 0) {// 1.0%
            isOmakeMap = YES;
        }
        starOption.count = rand()%129;    // ランダム星数        
        starOption.type = rand()%kStarTypeNumber;
        starOption.r = rand()%256;
        starOption.g = rand()%256;
        starOption.b = rand()%256;
        
        // 盤の色設定
        boardColor.r = rand()%256;
        boardColor.g = rand()%256;
        boardColor.b = rand()%256;

    }
    
}

/************************************************
 定期処理
 ************************************************/
- (void)onTick {
    
    // サウンドをフレーム内で再生可能にする（一度再生すると同一フレーム内で再生不可となる）
    for (int i=0; i<E_SOUND_MAX; i++) {
        canPlaySound[i] = YES;
    }
    
    /*
     計算をしてから描画するのが本来の流れ
     テスト時には計算メソッド内で描画をしたいために順番を入れ替えている場合がある
     */
//    [self calcGame];
    [self draw];    
}

/************************************************
 描画
 ・定期処理
 ************************************************/
- (void)draw {
    [g clear];
    
    // 塗りつぶし
    [g setColor:rgb(bgColor.r, bgColor.g, bgColor.b)];
    [g fillRect_x:0 y:0 w:640 h:960];
    
    // 星を描画
    [self drawStar];
    
    // 盤を描画
    [self drawBoard];
    
    // マップを描画
    [self drawMap];
    
    // 敵を描画
    [self drawEnemy];
    
    // プレイヤーを描画
    [self drawPlayer];
    
    // 攻撃爆発を描画
    [self drawAttackExplosion];
    
    // プレイヤー情報を描画（HP、リロード、駒）
    [self drawPlayerInfo];
    
    // 敵情報を描画（敵HP）
    [self drawEnemyInfo];
    
    // ステージ情報を描画（難易度、ステージNo）
    [self drawStageInfo];
    
    // 方向キーの描画（ロジック含む）
    [self drawDirectionKey];
    
}

/************************************************
 星の描画
 ************************************************/
- (void)drawStar {
    [g setColor:rgb(starOption.r, starOption.g, starOption.b)];
    [g setLineWidth:1];
    
    // 拡散
    if (starOption.type == 0) {
        for (int i=0; i<starOption.count; i++) {

            star[i].x += star[i].ax;
            star[i].y += star[i].ay;
            if (star[i].x > 549 || star[i].x < 11 || star[i].y > 549 || star[i].y < 11) {
                star[i].x = 280 - 8 + rand()%17;
                star[i].y = 280 - 8 + rand()%17;
                star[i].ax = 6 - rand()%13;
                star[i].ay = 6 - rand()%13;
            }
            // 中心で止まる星の場合、生成しなおし
            if (star[i].ax == 0 && star[i].ay == 0) {
                star[i].x = 0;
            }
            [g drawPoint_x:star[i].x y:star[i].y];
        }
    } 
    // うねうね
    else if (starOption.type == 1) {
        for (int i=0; i<starOption.count; i++) {
            
            star[i].x += star[i].ax;
            star[i].y += star[i].ay;
            if (star[i].x > 549 || star[i].x < 11 || star[i].y > 549 || star[i].y < 11) {
                star[i].x = 280 - 8 + rand()%17;
                star[i].y = 280 - 8 + rand()%17;
                star[i].ax = 0;
                star[i].ay = 0;
            }
            
            float a = 1 - rand()%3; // -1, 0, 1
            if (a !=0) {
                star[i].ax += a*0.4f;
            } else {
                a = -2*(rand()%2) + 1;// 1 or -1
                star[i].ay += a*0.4f;
            }    
            [g drawPoint_x:star[i].x y:star[i].y];
        }
    }
    // 雨
    else if (starOption.type == 2) {
        for (int i=0; i<starOption.count; i++) {
            
            star[i].x += star[i].ax;
            star[i].y += star[i].ay;
            if (star[i].x > 549 || star[i].x < 11 || star[i].y > 549) {
                star[i].x = 11 + rand()%538;
                star[i].y = -rand()%64;
                star[i].ax = 0;
                star[i].ay = 1 + rand()%8;
            } else if (star[i].ay == 0 || star[i].y < 1) {
                star[i].ay = 1 + rand()%8;
            }
                
            [g drawPoint_x:star[i].x y:star[i].y];
        }
    }
    
    
}

/************************************************
 盤の描画
 ************************************************/
- (void)drawBoard {
    [g setColor:rgb(boardColor.r, boardColor.g, boardColor.b)];
    [g setLineWidth:2.0f];

    if (gameState == E_GAME_STATE_LAUNCH_ANIMATION) {
        float animationStaticSize = launchAnimationCount*8;
        float animationStaticSmallSize = launchAnimationCount;
        float animationSize = launchAnimationCounter*8;
        float animationSmallSize = launchAnimationCounter;
        
        float typeA = 540 + animationSize - animationStaticSize;
        float typeB = 60 + animationSmallSize - animationStaticSmallSize;

        [g drawRect_x:10 y:10 w:typeA h:typeA];
        [g drawRect_x:10 y:70 w:typeA h:typeB];
        [g drawRect_x:10 y:190 w:typeA h:typeB];
        [g drawRect_x:10 y:310 w:typeA h:typeB];
        [g drawRect_x:10 y:430 w:typeA h:typeB];
        [g drawRect_x:70 y:10 w:typeB h:typeA];
        [g drawRect_x:190 y:10 w:typeB h:typeA];
        [g drawRect_x:310 y:10 w:typeB h:typeA];
        [g drawRect_x:430 y:10 w:typeB h:typeA];
        
        [g setLineWidth:1.0f];
        float countDown = 1 - (launchAnimationCount-launchAnimationCounter)/launchAnimationCount;
        
        [g fillCircle_x:190.0f*countDown y:190.0f*countDown r:6.0f];
        [g fillCircle_x:370.0f*countDown y:190.0f*countDown r:6.0f];
        [g fillCircle_x:190.0f*countDown y:370.0f*countDown r:6.0f];
        [g fillCircle_x:370.0f*countDown y:370.0f*countDown r:6.0f];
        
        typeA = 560 + animationSize - animationStaticSize;
        
        [g setColor:rgb(0, 64, 255)];
        [g drawLine_x0:0 y0:typeA x1:640 y1:typeA];
        [g drawLine_x0:typeA y0:0 x1:typeA y1:640];        


    } else {
        [g drawRect_x:10 y:10 w:540 h:540];
        [g drawRect_x:10 y:70 w:540 h:60];
        [g drawRect_x:10 y:190 w:540 h:60];
        [g drawRect_x:10 y:310 w:540 h:60];
        [g drawRect_x:10 y:430 w:540 h:60];
        [g drawRect_x:70 y:10 w:60 h:540];
        [g drawRect_x:190 y:10 w:60 h:540];
        [g drawRect_x:310 y:10 w:60 h:540];
        [g drawRect_x:430 y:10 w:60 h:540];
        
        [g setLineWidth:1.0f];
        
        [g fillCircle_x:190.0f y:190.0f r:6.0f];
        [g fillCircle_x:370.0f y:190.0f r:6.0f];
        [g fillCircle_x:190.0f y:370.0f r:6.0f];
        [g fillCircle_x:370.0f y:370.0f r:6.0f];

        [g setColor:rgb(0, 64, 255)];
        [g drawLine_x0:0 y0:560 x1:640 y1:560];
        [g drawLine_x0:560 y0:0 x1:560 y1:640];        
        
    }
}

/************************************************
 マップの描画
 ************************************************/
- (void)drawMap {
    float offset = 0.0f;
    if (isOmakeMap) {
        offset = 22.0f*6;
    }
    
    for (int y=0; y<9; y++) {
        for (int x=0; x<9; x++) {
            int mapObject = map[x][y];
            if (mapObject == E_BLOCK_NONE) {
                
            } else if (mapObject == E_BLOCK_HARD) {
                
                
                [g drawScaledImage:image 
                                 x:11.0f+60.0f*x y:11.0f+60.0f*y w:58.0f h:58.0f
                                sx:offset sy:0.0f sw:22.0f sh:22.0f angle:0];
                
            } else {
                [g drawScaledImage:image 
                                 x:11.0f+60.0f*x y:11.0f+60.0f*y w:58.0f h:58.0f
                                sx:offset + 22.0f*(mapObject-1) sy:0.0f sw:22.0f sh:22.0f angle:0];
                
            }
        }
    }
}

/************************************************
 敵の描画
 ************************************************/
- (void)drawEnemy {
    
    if (gameState == E_GAME_STATE_PLAY ||
        gameState == E_GAME_STATE_GAME_OVER ||
        gameState == E_GAME_STATE_PAUSE ||
        gameState == E_GAME_STATE_STAGE_CLEAR) {
        
        for (EnemyDataEntity *enemy in enemyDataEntityArray) {
            
            // 死んでいるとき
            if ([enemy hitPoint] <= 0) {
                
                // 爆発アニメーション
                if ([enemy deadExplosionCounter] > 0) {
                    [self drawDeadExplosionWithKoma:enemy];
                }
                
                continue;
            }

            
            // 点滅。(0, 1)=表示, (2, 3)=非表示
            if ([enemy damagingCounter] %4 > 1) {
                continue;
            }

            
            if ([enemy hitPoint] > 0) {
                
                int enemyType = 0;
                // 歩から王まで
                if ([enemy type] < 8) {
                    enemyType = [enemy type];
                }
                
                int enemyPersonality = [enemy personality];
                int enemyPersonalityNumber = 0;
                // 通常（青）
                if (enemyPersonality < 2) {
                    enemyPersonalityNumber = 2;
                }
                // 追いかけ（赤）
                else if (enemyPersonality < 4) {
                    enemyPersonalityNumber = 1;
                }
                // 逃げ腰（緑）
                else if (enemyPersonality < 6) {
                    enemyPersonalityNumber = 0;
                }
                // その他
                else {
                    
                }
                
                float angle = [self getAngleWithDirection:[enemy direction]];
                float size = 44.0f;
                float type = 18.0f*enemyType;
                float type2 = 120.0f - 19.0f*enemyPersonalityNumber;
                [g drawScaledImage:image 
                                 x:[enemy pos].x y:[enemy pos].y
                                 w:size h:size
                                sx:type sy:type2
                                sw:18.0f sh:18.0f angle:angle];
            }
        }
    }
}

/************************************************
 プレイヤーの描画
 ************************************************/
- (void)drawPlayer {
    
    // 死んでいるとき
    if ([playerKoma hitPoint] <= 0) {
        
        // 爆発アニメーション
        if ([playerKoma deadExplosionCounter] > 0) {
            [self drawDeadExplosionWithKoma:playerKoma];
        }
        
        return;
    }
    
    // 点滅。(0, 1)=表示, (2, 3)=非表示
    if ([playerKoma damagingCounter] %4 > 1) {
        return;
    }
    
    // プレイヤー
    if (gameState == E_GAME_STATE_PLAY || 
        gameState == E_GAME_STATE_PAUSE ||
        gameState == E_GAME_STATE_STAGE_CLEAR) {
        int playerDirection = [playerKoma calcDirectionWithDirectionX:directionX directionY:directionY];
        
        float angle = [self getAngleWithDirection:playerDirection];
        float size = 44.0f;
        float type = 18.0f*[playerKoma type];
        float type2 = 139.0f - 19.0f*0;

        float feverType = 0;
        
        if ([playerKoma superGunGauge] >= [playerKoma gunGaugeMax]) {
            playerKoma.fever ++;
            if (playerKoma.fever >= 0 && playerKoma.fever < 3) {
                feverType = 19;
            } else if (playerKoma.fever == 3) {
                playerKoma.fever = -3;
            }
        }
        

        [g drawScaledImage:image 
                         x:[playerKoma pos].x y:[playerKoma pos].y
                         w:size h:size
                        sx:type sy:type2 - feverType
                        sw:18.0f sh:18.0f angle:angle];        
    }        
}

/************************************************
 攻撃爆発アニメーション
 ************************************************/
- (void)drawAttackExplosion {
    
    // 敵の攻撃爆発アニメーション
    for (EnemyDataEntity *enemy in enemyDataEntityArray) {
        [self drawAttackExplosionWithKoma:enemy];
    }
    
    // プレイヤーの攻撃爆発アニメーション
    [self drawAttackExplosionWithKoma:playerKoma];
}

/************************************************
 攻撃爆発アニメーション（駒ごと）
 ************************************************/
- (void)drawAttackExplosionWithKoma:(Koma *)koma {
    
    int counter = 21 - [koma gunCounter];// 0から始まり、19に到達する
    counter = counter/2;// 0, 0, 1, 1, 2, 2, ... 9, 9
    counter = counter*14;// 画像の位置
    
    for (int i=0; i<8; i++) {
        CGRect gunRect = [koma getGunRectAtIndex:i];
        
        // 爆発が存在する
        if (gunRect.size.width + gunRect.size.height > 0) {
            
            int gunType = [koma gunType];
            
            // 通常弾
            if (gunType == E_KOMA_TYPE_FU ||
                gunType == E_KOMA_TYPE_KEI ||
                gunType == E_KOMA_TYPE_GIN ||
                gunType == E_KOMA_TYPE_KIN ||
                gunType == E_KOMA_TYPE_OU) {
                [g drawScaledImage:image
                                 x:gunRect.origin.x
                                 y:gunRect.origin.y
                                 w:gunRect.size.width
                                 h:gunRect.size.height
                                sx:counter sy:24 sw:14 sh:14 angle:0];
                
            }
            // 進行弾（香車、飛車、角）
            else {
                [g drawScaledImage:image
                                 x:gunRect.origin.x
                                 y:gunRect.origin.y
                                 w:gunRect.size.width
                                 h:gunRect.size.height
                                sx:counter sy:40 sw:14 sh:14 angle:0];
                
            }
            
            
            /*
             
            [g setColor:rgb(30, 255, 255)];
            [g drawRect_x:gunRect.origin.x
                        y:gunRect.origin.y
                        w:gunRect.size.width
                        h:gunRect.size.height];
             */
        }
    }
    
}

/************************************************
 死亡爆発アニメーション
 ************************************************/
- (void)drawDeadExplosionWithKoma:(Koma *)koma {
    
    [g drawScaledImage:image 
                     x:[koma pos].x-7.0f y:[koma pos].y-7.0f
                     w:58.0f h:58.0f
                    sx:(9.0f - ([koma deadExplosionCounter]+1)/2)*24.0f sy:56.0f 
                    sw:24.0f sh:24.0f angle:0];        

    [koma setDeadExplosionCounter:[koma deadExplosionCounter]-1];

}

/************************************************
 プレイヤー情報の描画
 ************************************************/
- (void)drawPlayerInfo {
    [g setFontSize:26];
    [g setLineWidth:1.0f];
    
    // 燃料表示
    NSString *fuel = [NSString stringWithFormat:@"%d", [playerKoma fuel]];
    float fuelRectX = 16;
    float fuelRectY = 596;
    [g setColor:rgb(255,255,0)];
    [g drawString:fuel x:16.0f y:566.0f];
    
    [g setColor:rgb(0,0,255)];
    [g drawRect_x:fuelRectX y:fuelRectY w:100 h:17];
    
    [g setColor:rgb(32,190,255)];
    [g fillRect_x:fuelRectX+1 y:fuelRectY+1 w:100*[playerKoma fuel]/240.0f h:14 ];
    
    // リロード表示
    float reloadRectX = 16;
    float reloadRectY = 618;
    [g setColor:rgb(0,0,255)];
    [g drawRect_x:reloadRectX y:reloadRectY w:100 h:17];
    
    [g setColor:rgb(32,190,255)];
    [g fillRect_x:reloadRectX+1.0f
                y:reloadRectY+1.0f
                w:(int)(97.0f*[playerKoma gunGauge]/[playerKoma gunGaugeMax])
                h:14 ];
    
    [g setColor:rgb(0, 172,64)];
    if (playerKoma.superGunGauge >= playerKoma.gunGaugeMax) {
        [g setColor:rgb(255, 120, 64)];
    }
    [g fillRect_x:reloadRectX+1.0f
                y:reloadRectY+1.0f
                w:(int)(97.0f*[playerKoma superGunGauge]/[playerKoma gunGaugeMax])
                h:14 ];

    
    // HP表示
    int maxHP = [playerKoma maxHP];
    NSString *hp = [NSString stringWithFormat:@"HP %d", [playerKoma hitPoint]];  
    float hpX = 130.0f;
    float hpY = 588.0f;
    float hpRectX = 130;
    float hpRectY = 618;
    
    [g setColor:rgb(255,255,0)];
    [g drawString:hp x:hpX y:hpY];

    [g setColor:rgb(0,0,255)];
    [g drawRect_x:hpRectX y:hpRectY w:3+13*maxHP h:17];

    [g setColor:rgb(32,190,255)];
    [g fillRect_x:hpRectX+1 y:hpRectY+1 w:13*[playerKoma hitPoint] h:14 ];
    
    // 駒表示
    [g setFontSize:30];
    [g setColor:rgb(0,64,255)];
    float fuX = 226;
    float komaWidth = 39;
    float fuY = 572;
    [g drawString:@"歩" x:fuX y:fuY];
    [g drawString:@"香" x:fuX+komaWidth y:fuY];
    [g drawString:@"桂" x:fuX+komaWidth*2 y:fuY];
    [g drawString:@"銀" x:fuX+komaWidth*3 y:fuY];
    [g drawString:@"金" x:fuX+komaWidth*4 y:fuY];
    [g drawString:@"角" x:fuX+komaWidth*5 y:fuY];
    [g drawString:@"飛" x:fuX+komaWidth*6 y:fuY];
    [g drawString:@"王" x:fuX+komaWidth*7 y:fuY];
    
    fuY++;
    // 持ってない場合と持っている場合
    [self setColorWithKomaType:E_KOMA_TYPE_FU];
    [g drawString:@"歩" x:fuX y:fuY];
    [self setColorWithKomaType:E_KOMA_TYPE_KYO];
    [g drawString:@"香" x:fuX+komaWidth y:fuY];
    [self setColorWithKomaType:E_KOMA_TYPE_KEI];
    [g drawString:@"桂" x:fuX+komaWidth*2 y:fuY];
    [self setColorWithKomaType:E_KOMA_TYPE_GIN];
    [g drawString:@"銀" x:fuX+komaWidth*3 y:fuY];
    [self setColorWithKomaType:E_KOMA_TYPE_KIN];
    [g drawString:@"金" x:fuX+komaWidth*4 y:fuY];
    [self setColorWithKomaType:E_KOMA_TYPE_KAKU];
    [g drawString:@"角" x:fuX+komaWidth*5 y:fuY];
    [self setColorWithKomaType:E_KOMA_TYPE_HI];
    [g drawString:@"飛" x:fuX+komaWidth*6 y:fuY];
    [self setColorWithKomaType:E_KOMA_TYPE_OU];
    [g drawString:@"王" x:fuX+komaWidth*7 y:fuY];
    
    
    // 現在選択している駒
    [g setColor:rgb(16, 255, 160)];
    int playerType = [playerKoma type];
    if (playerType == E_KOMA_TYPE_FU) {
        [g drawString:@"歩" x:fuX y:fuY];        
    } else if (playerType == E_KOMA_TYPE_KYO) {
        [g drawString:@"香" x:fuX+komaWidth y:fuY];        
    } else if (playerType == E_KOMA_TYPE_KEI) {
        [g drawString:@"桂" x:fuX+komaWidth*2 y:fuY];        
    } else if (playerType == E_KOMA_TYPE_GIN) {
        [g drawString:@"銀" x:fuX+komaWidth*3 y:fuY];        
    } else if (playerType == E_KOMA_TYPE_KIN) {
        [g drawString:@"金" x:fuX+komaWidth*4 y:fuY];        
    } else if (playerType == E_KOMA_TYPE_KAKU) {
        [g drawString:@"角" x:fuX+komaWidth*5 y:fuY];        
    } else if (playerType == E_KOMA_TYPE_HI) {
        [g drawString:@"飛" x:fuX+komaWidth*6 y:fuY];        
    } else if (playerType == E_KOMA_TYPE_OU) {
        [g drawString:@"王" x:fuX+komaWidth*7 y:fuY];        
    }
}
/************************************************
 敵情報の描画
 ************************************************/
- (void)drawEnemyInfo {
    
    float x = 560.0f;
    float y = -14.0f;
    [g setFontSize:22];

    for (EnemyDataEntity *enemy in enemyDataEntityArray) {
        y += 26.0f;

        // 死んでいる場合は表示しない
        if ([enemy hitPoint] <= 0) {
                
            // HP爆発アニメーション
            if ([enemy deadExplosionCounter] > 0) {
                [g drawScaledImage:image 
                                 x:x+24 y:y-14
                                 w:50.0f h:50.0f
                                sx:(9.0f - ([enemy deadExplosionCounter]+1)/2)*24.0f sy:56.0f 
                                sw:24.0f sh:24.0f angle:0];        
            }
            
            continue;
        }
        
        // ダメージの点滅中は表示しない
        if ([enemy damagingCounter]%4 > 1) {// (0, 1)=表示, (2, 3)=非表示
            continue;
        }
        
        
        
        int enemyType = [enemy type];
        if (enemyType == E_KOMA_TYPE_FU) {
            [g setColor:rgb(255, 170, 0)];

        } else if (enemyType == E_KOMA_TYPE_KYO) {
            [g setColor:rgb(255, 0, 0)];
            
        } else if (enemyType == E_KOMA_TYPE_KEI) {
            [g setColor:rgb(0, 255, 0)];

        } else if (enemyType == E_KOMA_TYPE_GIN) {
            [g setColor:rgb(170, 170, 170)];

        } else if (enemyType == E_KOMA_TYPE_KIN) {
            [g setColor:rgb(255, 255, 0)];

        } else if (enemyType == E_KOMA_TYPE_KAKU) {
            [g setColor:rgb(0, 255, 255)];

        } else if (enemyType == E_KOMA_TYPE_HI) {
            [g setColor:rgb(233, 0, 255)];
            
        } else if (enemyType == E_KOMA_TYPE_OU) {
            [g setColor:rgb(0, 0, 255)];

        }
        
        
        int hitPoint = [enemy hitPoint];
        
       /* 
        
        NSString *tmp = [NSString stringWithFormat:@"%d", hitPoint];
        NSMutableString *hp = [NSMutableString stringWithString:@""];

        int count = 8 - [tmp length];
        for (int i=0; i<count; i++) {
            [hp appendString:@" "];
        }
        [hp appendFormat:@"%5d", hitPoint];
        [g drawString:hp x:x y:y];
        */
        [g setLineWidth:1];

        [self drawHP:hitPoint x:x y:y];
        
        // 毒表示
        [g setLineWidth:2];
        if ([enemy poisonCounter] > 0) {
            [g setColor:rgb(0, 175, 40)];
            [g drawLine_x0:x+6 y0:y+14 x1:x+6+[enemy poisonCounter]/(2.0f + 0.5f*level) y1:y+14];
            
            if ([gameDataEntity special] > 4) {
                [g setColor:rgb(195, 30, 30)];
                [g drawLine_x0:x+6 y0:y+17 x1:x+6+[enemy attackCounter]/3.0f y1:y+17];
            }
            
            if ([gameDataEntity special] > 9) {
                CGPoint ePos = [enemy pos];
                [g setColor:rgb(0, 175, 40)];
                [g drawLine_x0:ePos.x-8
                            y0:ePos.y+47
                            x1:ePos.x-8+[enemy poisonCounter]/(2.0f + 0.5f*level) 
                            y1:ePos.y+47];
                [g setColor:rgb(195, 30, 30)];
                [g drawLine_x0:ePos.x-8
                            y0:ePos.y+50
                            x1:ePos.x-8+[enemy attackCounter]/3.0f 
                            y1:ePos.y+50];
                
            }
            
        }
        
    }
    
}

/************************************************
 ステージ情報の描画
 ************************************************/
- (void)drawStageInfo {
    
    [g setFontSize:26];
    [g setColor:rgb(255, 255, 255)];
    [g drawString:[NSString stringWithFormat:@"%3d", 1+[StageManager getStageNumber]] x:580 y:570];
/*
    [g setFontSize:26];
    [g setColor:rgb(150, 230, 255)];
    [g drawString:[NSString stringWithFormat:@"%3.0f", fps] x:580 y:598];
*/
}

/************************************************
 方向キーの描画
 ************************************************/
- (void)drawDirectionKey {
    
    float baseX = [directionKeyView baseX];
    float baseY = [directionKeyView baseY];
    float x = [directionKeyView x];
    float y = [directionKeyView y];
//    float baseAlpha = [directionKeyView baseAlpha];
//    float keyAlpha = [directionKeyView keyAlpha];
    
    float baseSizeX = 70.0f;
    float baseSizeY = 70.0f;
    float distanceX = fabs(baseX-x);
    float distanceY = fabs(baseY-y);
    float distance = sqrt(distanceX*distanceX + distanceY*distanceY);
    
    float distanceLimit = 80;
    if (distance > distanceLimit) {
        baseSizeX -= (distance - distanceLimit);
        baseSizeY -= (distance - distanceLimit);
        if (baseSizeX < 0) {
            baseSizeX = 0;
        }
        if (baseSizeY < 0) {
            baseSizeY = 0;
        }
    } else {
    }
    [directionKeyView setPosX:x - baseSizeX/2.0f];
    [directionKeyView setPosY:y - baseSizeY/2.0f];        
    
    
        
    float small = controllerDrawSmall;
    float large = controllerDrawLarge;

    // ベースライン 
    [g setLineWidth:1.0f];
    [g setColor:rgb(32, 64, 64)];
    
    float baseLineX = baseX*2;
    float baseLineY = baseY*2;
    small *= 2;
    large *= 2;
    
    [g drawLine_x0:baseLineX-small y0:baseLineY-large x1:baseLineX+small y1:baseLineY+large];
    [g drawLine_x0:baseLineX-large y0:baseLineY-small x1:baseLineX+large y1:baseLineY+small];
    [g drawLine_x0:baseLineX+large y0:baseLineY-small x1:baseLineX-large y1:baseLineY+small];
    [g drawLine_x0:baseLineX+small y0:baseLineY-large x1:baseLineX-small y1:baseLineY+large];
        
    
    
    float posX = [directionKeyView posX];
    float posY = [directionKeyView posY];
    
    // コントロールキー
    [g setLineWidth:3.0f];
    
    float color = 128 + 2*distance;
    if (color > 255) {
        color = 255;
    }
    [g setColor:rgb(25, color, 170)];
    [g drawCircle_x:posX*2+baseSizeX y:posY*2+baseSizeY r:baseSizeX];    
    
    [g setColor:rgb(25, 170, color)];
    [g drawCircle_x:posX*2+baseSizeX y:posY*2+baseSizeY r:baseSizeX-20];
    
    
    float relativeX = x-baseX;
    float relativeY = y-baseY;
    
    float inclination = relativeY/relativeX;
    //    NSString *direction = @"停止";
    
    float beforeDirectionX = directionX;
    float beforeDirectionY = directionY;
    
    directionX = 0;
    directionY = 0;
    
    if (distance < kControllerStopDistance) {
        // 幅が小さいときは動かない
    } else {
        
        if (relativeX==0 && relativeY==0) {
            //        direction = @"停止";
        } else if (relativeX==0 && relativeY<0) {
            //        direction = @"真上";
            directionY = kDirectionUp;
        } else if (relativeX==0 && relativeY>0) {
            //        direction = @"真下";
            directionY = kDirectionDown;
        } else if (relativeY==0 && relativeX<0) {
            //        direction = @"真左";
            directionX = -1;
        } else if (relativeY==0 && relativeX>0) {
            //        direction = @"真右";
            directionX = 1;
        } else {
            float large = controllerAngleLarge;
            float small = controllerAngleSmall; 
            if (relativeX>0) { 
                if (inclination <= -large) {
                    //                direction = @"上";
                    directionY = kDirectionUp;
                } else if (inclination < -small && inclination > -large) {
                    //                direction = @"右上";
                    directionX = 1;
                    directionY = kDirectionUp;
                } else if (inclination >= -large && inclination <= small) {
                    //                direction = @"右";
                    directionX = 1;
                } else if (inclination > small && inclination < large) {
                    //                direction = @"右下";
                    directionX = 1;
                    directionY = kDirectionDown;
                } else if (inclination >= large) {
                    //                direction = @"下";
                    directionY = kDirectionDown;
                }
            } else {
                if (inclination <= -large) {
                    //                direction = @"下";
                    directionY = kDirectionDown;
                } else if (inclination < -small && inclination > -large) {
                    //                direction = @"左下";
                    directionX = -1;
                    directionY = kDirectionDown;
                } else if (inclination >= -large && inclination <= small) {
                    //                direction = @"左";
                    directionX = -1;
                } else if (inclination > small && inclination < large) {
                    //                direction = @"左上";
                    directionX = -1;
                    directionY = kDirectionUp;
                } else if (inclination >= large) {
                    //                direction = @"上";
                    directionY = kDirectionUp;
                }
            }
        }
        
    }
    
    if ((beforeDirectionX*10 + beforeDirectionY != directionX*10 + directionY)
        && !(directionX==0 && directionY==0)) {
    }
    
    if ([directionKeyView isPushed]) {
        [((UIImageView *)[[directionKeyView subviews] objectAtIndex:0]) setImage:[UIImage imageNamed:@"round_button_pushed"]];
        
//        [[[directionKeyView subviews] objectAtIndex:0] setAlpha:0.2f];
    } else {
        [((UIImageView *)[[directionKeyView subviews] objectAtIndex:0]) setImage:[UIImage imageNamed:@"round_button"]];
  //      [[[directionKeyView subviews] objectAtIndex:0] setAlpha:0.6f];
    }
}

/************************************************
 ゲーム処理
 ・定期処理
 ************************************************/
- (void)calcGame {
    
    // 開始 =======================================================
    if (gameState == E_GAME_STATE_LAUNCH_ANIMATION) {
        
        if (launchAnimationCounter < launchAnimationCount) {
            launchAnimationCounter++;
        } else {
            gameState = E_GAME_STATE_MAPPING_ANIMATION;
        }        
    } 
    // マップ読み込み =======================================================
    else if (gameState == E_GAME_STATE_MAPPING_ANIMATION) {
        gameState = E_GAME_STATE_PLAY;
        
        
        // プレイヤー情報をセット
        [playerKoma setState:E_KOMA_STATE_NORMAL];
        [playerKoma setPos:CGPointMake(258, 498)];
        [playerKoma setMaxHP:[gameDataEntity hp]];
        [playerKoma setHitPoint:[playerKoma maxHP]];
        [playerKoma setFuel:[gameDataEntity fuel]];
        [playerKoma setAttackPower:[gameDataEntity attack]];
        [playerKoma setGunGaugeMax:(54 + level - [gameDataEntity reload]) * (kAdjustOldMobileValue + 0.75f) ];
        [playerKoma setDeadExplosionCounter:18];
        [playerKoma setSpeed:1.8f + [gameDataEntity speed]*0.2f];// 能力値を加算 1.8, 2.0, 2.2, 2.4, 2.6, 2.8, 3.0
        
        item[E_KOMA_TYPE_FU] = YES;// 歩は始めから所有しているものとする

        // マップ情報をセット
        for (int y=0; y<9; y++) {
            for (int x=0; x<9; x++) {
                map[x][y] = [stageEntity getMapValueWithX:x y:y];
                
            }
        }
        
        
        // 敵の速度
        float enemySpeed = 0.0f;
        if (level == E_STAGE_LEVEL_SHOKYU) {
            enemySpeed = 1.8f;
        } else if (level == E_STAGE_LEVEL_CHUKYU) {
            enemySpeed = 1.9f;
        } else if (level == E_STAGE_LEVEL_JOKYU) {
            enemySpeed = 2.0f;
        } else if (level == E_STAGE_LEVEL_CHOKYU) {
            enemySpeed = 2.1f;
        }
        // 敵情報をセット
        enemyDataEntityArray = [stageEntity getEnemyDataEntityArray];
        for (EnemyDataEntity *enemy in enemyDataEntityArray) {
            [enemy setMoveCounter:-(80*kAdjustOldMobileValue)+rand()%93];// 敵の初期停止時間
            [enemy setPos:CGPointMake(18.0f + [enemy x]*60.0f, 17.0f + [enemy y]*60.0f)];
            [enemy setDirection:E_DIRECTION_DOWN];
            
            [enemy setHitPoint:(1+[enemy life])*(1 + stageNumber/3 + stageNumber/5 +
                                                 stageNumber/12 + stageNumber/30 + 
                                                 stageNumber/50 + 2*(stageNumber/100) +
                                                 3*(stageNumber/150) + [enemy type]) + 
             level*(stageNumber/7 + 24*(1+[enemy life]))];// 敵ライフ設定アルゴリズム
            
            [enemy setDeadExplosionCounter:18];
            [enemy setAttackCounter:50*kAdjustOldMobileValue + rand()%125];// 攻撃カウンタ
            [enemy setAttackInterval:[enemy attackInterval]+2-level];// 攻撃間隔（高いほど遅い）
            [enemy setDropFuel:[enemy life]+1];// 落とす燃料

            [enemy setSpeed:enemySpeed];
            [enemy setDefaultSpeed:enemySpeed];// デフォルトスピード　束縛した後に戻すための値
            
            [enemy setPoison:0];
            [enemy setPoisonCounter:-1];
            
            if ([enemy type] == 8) {
                [enemy setDoppel:E_DOPPEL_NONE];
                [enemy setRandom:E_RANDOM_1];
                [enemy setType:rand()%8];
                [enemy setSpeed:enemySpeed+1];
                [enemy setDefaultSpeed:enemySpeed+1];
            } else if ([enemy type] == 9) {
                [enemy setDoppel:E_DOPPEL_1];
                [enemy setRandom:E_RANDOM_NONE];
                [enemy setType:[playerKoma type]];
            }
            
        
        }
    }
    // プレイ =======================================================
    else if (gameState == E_GAME_STATE_PLAY) {

        // プレイヤーの処理
        [self playerWorks];
        
        // 敵の行動（攻撃／移動）
        [self enemyAction];
        
        
        
    }   
    // 一時停止 =======================================================
    else if (gameState == E_GAME_STATE_PAUSE) {
        
    } 
    // ゲームオーバー =======================================================
    else if (gameState == E_GAME_STATE_GAME_OVER) {

         // 敵の行動（攻撃／移動）
        [self enemyAction];
        
    }
    // ステージクリア =======================================================
    else if (gameState == E_GAME_STATE_STAGE_CLEAR) {
        
        // プレイヤーの処理
        [self playerWorks];

        // 敵の行動（攻撃／移動）
        [self enemyAction];

        if (!isCleared) {
            if (level == E_STAGE_LEVEL_CHOKYU) {
                stageNumber -= 180;
            }
            
            if ([gameDataEntity getStageClearStatusWithLevel:level stage:stageNumber] == -1) {// 未クリア
                int getPoints = 1;
                if (level == E_STAGE_LEVEL_CHOKYU) {
                    getPoints = 3;
                }
                if (stageNumber == 179) {
                    if (level == E_STAGE_LEVEL_SHOKYU) {
                        getPoints = 5;
                    } else if (level == E_STAGE_LEVEL_CHUKYU) {
                        getPoints = 10;
                    } else if (level == E_STAGE_LEVEL_JOKYU) {
                        getPoints = 30;
                    }
                } else {
                    
                    [gameDataEntity setStageClearStatusWithLevel:level
                                                           stage:stageNumber+1 value:-1];
                    
                    if (level == E_STAGE_LEVEL_CHOKYU) {
                        if (stageNumber == 9) {
                            [gameDataEntity setStageClearStatusWithLevel:level
                                                                   stage:stageNumber+1 value:-2];
                        }
                    } 
                }
                
                if (level == E_STAGE_LEVEL_SHOKYU) {
                    if (stageNumber == 24) {
                        [gameDataEntity setStageClearStatusWithLevel:E_STAGE_LEVEL_CHUKYU
                                                               stage:0
                                                               value:-1];
                    }
                }
                if (level == E_STAGE_LEVEL_CHUKYU) {
                    if (stageNumber == 37) {
                        [gameDataEntity setStageClearStatusWithLevel:E_STAGE_LEVEL_JOKYU
                                                               stage:0
                                                               value:-1];
                    }
                }
                if (level == E_STAGE_LEVEL_JOKYU) {
                    if (stageNumber == 149) {
                        [gameDataEntity setStageClearStatusWithLevel:E_STAGE_LEVEL_CHOKYU
                                                               stage:0
                                                               value:-1];
                    }
                }
                
                [gameDataEntity setPoints:[gameDataEntity points] + getPoints];
                [gameDataEntity setStageClearStatusWithLevel:level 
                                                        stage:stageNumber
                                                        value:[playerKoma maxHP] - [playerKoma hitPoint]];
                
            
                // 保存
                if (![GameDataManager saveGameDataEntity:gameDataEntity]) {
                    // 保存に失敗した時
                    [[[UIAlertView alloc] initWithTitle:@"保存失敗"
                                                message:@"容量不足などが原因でござる"
                                               delegate:nil
                                      cancelButtonTitle:@"とじる"
                                      otherButtonTitles:nil] show];

                }
            }
            // クリア済み
            else {
                int savedRank = [gameDataEntity getStageClearStatusWithLevel:level stage:stageNumber];
                int nowRank = [playerKoma maxHP] - [playerKoma hitPoint];

                // 成績が良くなったときに保存
                if (nowRank < savedRank) {
                    [gameDataEntity setStageClearStatusWithLevel:level
                                                           stage:stageNumber
                                                           value:nowRank];
                    [GameDataManager saveGameDataEntity:gameDataEntity];
                    
                }
                
                
            }
            isCleared = YES;
            // 中級以上でクリアアニメーション
            if (level > E_STAGE_LEVEL_SHOKYU) {
                UIViewAnimationOptions options = (UIViewAnimationOptions)(UIViewAnimationOptionRepeat
                                                                          | UIViewAnimationOptionAllowUserInteraction
                                                                          | UIViewAnimationOptionAutoreverse);
                float angle = M_PI*((rand()%11)/10.0f);
                if (rand()%100 < 60) {
                    angle = 0;
                } else if (rand()%100 < 50) {
                    angle = -angle;
                }
                [AnimationManager basicAnimationWithView:self
                                                duration:0.3f + (rand()%16)/10.0f // 0.3 - 1.8
                                                   delay:0.0f
                                                 options:options
                                             fromToAlpha:CGPointMake(1.0f, 1.0f)
                                            fromToRotate:CGPointMake(0.0f, angle)
                                              beginScale:CGPointMake(1.0f, 1.0f)
                                             finishScale:CGPointMake(0.2f + (rand()%17)/10.0f, 0.2f + (rand()%17)/10.0f)// 0.2 - 1.8
                                          beginTranslate:CGPointZero
                                         finishTranslate:CGPointMake(20 - rand()%41, 20 - rand()%41)]; 
            }
        }
    }
}
/************************************************
 プレイヤーの処理
 ************************************************/
- (void)playerWorks {
    
    // 死亡判定
    if ([playerKoma hitPoint] <= 0) {
        gameState = E_GAME_STATE_GAME_OVER;
        [playerKoma setGunCounter:0];// 爆発を強制終了
        [playerKoma setHitPoint:0];
        return;
    }
    
    // ダメージカウンタ（点滅カウンタ）
    if ([playerKoma damagingCounter] > 0) {
        [playerKoma setDamagingCounter:[playerKoma damagingCounter]-1];        
    }
    
    // ガンゲージ
    float gunGauge = [playerKoma gunGauge];
    if (gunGauge < [playerKoma gunGaugeMax]) {
        [playerKoma setGunGauge:gunGauge+1.0f];
    }
    /*
     溜め打ちゲージ
     ・初級クリア
     ・動いていないこと
    */
    else if ([gameDataEntity getStageClearStatusWithLevel:0 stage:179] > -1
               && [playerKoma superGunGauge] < [playerKoma gunGaugeMax]
             && directionX==0 && directionY==0) {
        playerKoma.superGunGauge += 1.0f;
    }
    
        
    // ガンゲージが満タン
    if ([playerKoma gunGauge] >= [playerKoma gunGaugeMax]) {
        // 攻撃ボタンがタップされている
        if (gameButtonState) {
            
            if (playerKoma.superGunGauge >= playerKoma.gunGaugeMax) {
                tame = playerKoma.attackPower;
                [playerKoma setIsTame:YES];
                [playerKoma setTameRange:[gameDataEntity special]/20];
            } else {
                tame = 0;
                [playerKoma setIsTame:NO];
                [playerKoma setTameRange:0];
            }
            
            
            int fuel = [playerKoma fuel];
            int type = [playerKoma type];
            
            // 燃料消費
            if (type == E_KOMA_TYPE_FU) {
                
            } else if (type == E_KOMA_TYPE_KYO) {
                if (fuel >= 4) {
                    [playerKoma setFuel:fuel-4];
                } else {
                    [playerKoma setType:E_KOMA_TYPE_FU];
                }
            } else if (type == E_KOMA_TYPE_KEI) {
                if (fuel >= 3) {
                    [playerKoma setFuel:fuel-3];
                } else {
                    [playerKoma setType:E_KOMA_TYPE_FU];
                }
            } else if (type == E_KOMA_TYPE_GIN) {
                if (fuel >= 2) {
                    [playerKoma setFuel:fuel-2];
                } else {
                    [playerKoma setType:E_KOMA_TYPE_FU];
                }
            } else if (type == E_KOMA_TYPE_KIN) {
                if (fuel >= 2) {
                    [playerKoma setFuel:fuel-2];
                } else {
                    [playerKoma setType:E_KOMA_TYPE_FU];
                }
            } else if (type == E_KOMA_TYPE_KAKU) {
                if (fuel >= 6) {
                    [playerKoma setFuel:fuel-6];
                } else {
                    [playerKoma setType:E_KOMA_TYPE_FU];
                }
            } else if (type == E_KOMA_TYPE_HI) {
                if (fuel >= 6) {
                    [playerKoma setFuel:fuel-6];
                } else {
                    [playerKoma setType:E_KOMA_TYPE_FU];
                }
            } else if (type == E_KOMA_TYPE_OU) {
                if (fuel >= 3) {
                    [playerKoma setFuel:fuel-3];
                } else {
                    [playerKoma setType:E_KOMA_TYPE_FU];
                }
            }
            
            
            
            
            // 攻撃準備
            [playerKoma setGunType:[playerKoma type]];// 攻撃タイプをセットする（駒を切り替えても変わらない）
            [playerKoma setGunDirection:[playerKoma direction]];// 攻撃方向をセットする（向きを変えても変わらない）
            [playerKoma setGunDefaultPos:[playerKoma pos]];// 攻撃時の初期位置をセットする（移動しても変わらない）
            [playerKoma setGunCounter:21];            
            [playerKoma setGunGauge:0.0f];
            [playerKoma setSuperGunGauge:0.0f];

            
            [playerKoma resetWallAttackPower];
            
            int gunType = [playerKoma gunType];
            if (gunType == E_KOMA_TYPE_FU ||
                gunType == E_KOMA_TYPE_KEI ||
                gunType == E_KOMA_TYPE_GIN ||
                gunType == E_KOMA_TYPE_KIN ||
                gunType == E_KOMA_TYPE_OU) {
                [self playSound:E_SOUND_ATTACK];                
            } else if (gunType == E_KOMA_TYPE_KYO) {
                [self playSound:E_SOUND_LASER2];
            } else if (gunType == E_KOMA_TYPE_HI ||
                       gunType == E_KOMA_TYPE_KAKU) {
                [self playSound:E_SOUND_LASER1];
            }
        }
    }
    
    // 壁のダメージカウンタを減らす（駒に対する）
    for (int x=0; x<9; x++) {
        for (int y=0; y<9; y++) {
            if ([playerKoma getWallDamagingCounterWithX:x y:y] > 0) {                
                [playerKoma decreaseWallDamagingCounterWithX:x y:y];
            }
        }
    }
    
    // 攻撃（攻撃ボタン押下後）
    if ([playerKoma gunCounter] > 0) {
        
        
        [playerKoma gunWork];
        
        // 攻撃エリア毎に敵攻撃チェック
        [self attackCheckWithKoma:playerKoma];
        
        // 攻撃エリア毎に壁攻撃チェック
        [self wallAttackCheckWithKoma:playerKoma];
    } 
    
    // プレイヤーの移動
    [self moveWithKoma:playerKoma directionX:directionX directionY:directionY];

}

/************************************************
 敵の行動
 ・攻撃
 ・移動
 ・衝突判定
 ************************************************/
- (void)enemyAction {
    
    int enemyCount = 0;
    int enemyId = -1;
    for (EnemyDataEntity *enemy in enemyDataEntityArray) {
        enemyId++;
    
        // 死亡判定
        if ([enemy hitPoint] <= 0) {
            [enemy setGunCounter:0];// 爆発を強制終了
            [enemy setHitPoint:0];
            continue;
        }
        
        // 以下、敵が生きている場合
        enemyCount++;
        
        // ダメージカウンタ（点滅カウンタ）
        if ([enemy damagingCounter] > 0) {
            [enemy setDamagingCounter:[enemy damagingCounter]-1];      
        }
        
        // 攻撃開始
        int attackCounter = [enemy attackCounter];
        if (attackCounter == 0) {
            [enemy setAttackCounter:kAdjustOldMobileValue*(14 + [enemy attackInterval]*5 + rand()%46)];
            
            // 攻撃準備
            [enemy setGunType:[enemy type]];// 攻撃タイプをセットする（駒を切り替えても変わらない）
            [enemy setGunDirection:[enemy direction]];// 攻撃方向をセットする（向きを変えても変わらない）
            [enemy setGunDefaultPos:[enemy pos]];// 攻撃時の初期位置をセットする（移動しても変わらない）
            [enemy setGunCounter:21];            
            [enemy resetWallAttackPower];
            
            int gunType = [enemy gunType];
            if (gunType == E_KOMA_TYPE_FU ||
                gunType == E_KOMA_TYPE_KEI ||
                gunType == E_KOMA_TYPE_GIN ||
                gunType == E_KOMA_TYPE_KIN ||
                gunType == E_KOMA_TYPE_OU) {
                [self playSound:E_SOUND_ATTACK];                
            } else if (gunType == E_KOMA_TYPE_KYO) {
                [self playSound:E_SOUND_LASER2];
            } else if (gunType == E_KOMA_TYPE_HI ||
                       gunType == E_KOMA_TYPE_KAKU) {
                [self playSound:E_SOUND_LASER1];
            }
            
            if ([enemy random] > E_RANDOM_NONE) {
                [enemy setHitPoint:[enemy hitPoint] + stageNumber/(float)(3.0f + rand()%4) + (1+level)*(rand()%4)];
            }
            
        } 
        // 攻撃していないとき
        else {
            [enemy setAttackCounter:attackCounter-1];
        }
        
        // 壁のダメージカウンタを減らす（駒に対する）
        for (int x=0; x<9; x++) {
            for (int y=0; y<9; y++) {
                if ([enemy getWallDamagingCounterWithX:x y:y] > 0) {                
                    [enemy decreaseWallDamagingCounterWithX:x y:y];
                }
            }
        }
        
        // 攻撃中（爆発が存在する）
        if ([enemy gunCounter] > 0) {
            
            if (enemy.poison > 0 && [gameDataEntity special] >= 15) {
                [enemy setIsWeak:YES];
            } else {
                [enemy setIsWeak:NO];
            }
            
            [enemy gunWork];
            
            // 攻撃エリア毎にプレイヤー攻撃チェック
            [self attackCheckWithKoma:enemy];
            
            // 攻撃エリア毎に壁攻撃チェック
            [self wallAttackCheckWithKoma:enemy];
        } 
        

        // 駒ランダム処理
        if ([enemy attackCounter] == 28 + [enemy attackInterval]*5) {
            if ([enemy gunCounter] == 0 && [enemy random] == E_RANDOM_1) {
                [enemy setRandom:E_RANDOM_2];
            }
        }
        
        // ドッペル駒変化
        if ([enemy attackCounter] == 14) {
            if ([enemy gunCounter] == 0 && [enemy doppel] == E_DOPPEL_1) {
                [enemy setDoppel:E_DOPPEL_2];
            }
        }

        // 束縛処理
        if ([enemy bindCounter] > 0) {
            [enemy setSpeed:[enemy defaultSpeed] - 1.0f];
            enemy.bindCounter--;
        } else {
            [enemy setSpeed:[enemy defaultSpeed]];
        }
        
        // 毒性処理
        if ([enemy poisonCounter] == 0) {
            enemy.hitPoint -= [enemy poison];
            enemy.damagingCounter += 9;
            
            if ([enemy hitPoint] > 0) {            
                // 敵ダメージサウンド
                [self playSound:E_SOUND_DAMAGE];
            } else {
                // 敵死亡サウンド
                [self playSound:E_SOUND_ENEMY_EXPLOSION];
                
                item[[enemy type]] = YES;// 駒を獲得
                int dropFuel =  [enemy dropFuel] + ([enemy type]+1)/2;
                if (stageNumber > 90) {
                    dropFuel--;
                }
                
                [playerKoma setFuel:[playerKoma fuel] + dropFuel];// 燃料の獲得
                if ([playerKoma fuel] > 240) {
                    [playerKoma setFuel:240];
                }
            }
            
            if (rand()%100 < (6 + level*3)) {// 6%, 9%, 12%, 15%で毒自然治癒
                enemy.poisonCounter = -2;// 免疫
                [enemy setPoison:0];
            }
        }
        if ([enemy poison] > 0 && [enemy poisonCounter] <= 0 && [enemy hitPoint] > 0) {
            [enemy setPoisonCounter:kAdjustOldMobileValue*(56 + level*14)];
        }


        /*
         撃つ直前は止まってくれる
         */
        // 初級：長く止まる
        if (attackCounter == 26 && level == E_STAGE_LEVEL_SHOKYU) {
            [enemy setMoveCounter:-58-(rand()%12)];
        }
        // 中級：少し止まる
        else if (attackCounter == 18 && level == E_STAGE_LEVEL_CHUKYU) {
            [enemy setMoveCounter:-44-(rand()%12)];
        }
        
        int moveCounter = [enemy moveCounter];
        
        if ([enemy doppel] == E_DOPPEL_NONE) {
            // 向きを設定する
            if (moveCounter == 0) {
                int enemyPersonality = [enemy personality];
                
                /*
                 行動性質設定
                 */
                // 停止タイプ
                if (enemyPersonality > 5) {
                    [enemy setMoveCounter:-999];
                    [enemy setDirection:enemyPersonality-6];// 固定の向きを設定
                }
                // 冒険タイプ
                else if (enemyPersonality%2 == 1) {
                    [enemy setMoveCounter:kAdjustOldMobileValue*(21 - rand()%34)];
                }
                // 直進タイプ
                else {
                    [enemy setMoveCounter:kAdjustOldMobileValue*(31 - rand()%40)];
                }
                
                /*
                 向き設定
                 */
                if ([enemy moveCounter] > 0) {
                    
                    // 今の向き
                    int direction = [enemy direction];
                    // ランダムな向き
                    int randomDirection = [self getEnemyNextDirection:direction];
                    
                    // 通常（青）
                    if (enemyPersonality < 2) {
                        [enemy setDirection:randomDirection];
                    }
                    // 追いかけ（赤）
                    else if (enemyPersonality < 4) {
                        // 確率1/3でランダム
                        if (rand()%3 == 0) {
                            [enemy setDirection:randomDirection];
                        }
                        // 確率1/3で横方向追尾
                        else if (rand()%2 == 0) {
                            if ([enemy pos].x > [playerKoma pos].x) {
                                if (direction==E_DIRECTION_RIGHT) {
                                    [enemy setDirection:randomDirection];
                                } else {
                                    [enemy setDirection:E_DIRECTION_LEFT];
                                }
                            } else {
                                if (direction==E_DIRECTION_LEFT) {
                                    [enemy setDirection:randomDirection];
                                } else {
                                    [enemy setDirection:E_DIRECTION_RIGHT];
                                }
                            }
                        } 
                        // 確率1/3で縦方向追尾
                        else {
                            if ([enemy pos].y > [playerKoma pos].y) {
                                if (direction==E_DIRECTION_DOWN) {
                                    [enemy setDirection:randomDirection];
                                } else {
                                    [enemy setDirection:E_DIRECTION_UP];
                                }
                            } else {
                                if (direction==E_DIRECTION_UP) {
                                    [enemy setDirection:randomDirection];
                                } else {
                                    [enemy setDirection:E_DIRECTION_DOWN];
                                }
                            }
                        }
                    }
                    // 逃げ腰（緑）
                    else if (enemyPersonality < 6) {
                        // 確率1/2でランダム
                        if (rand()%2 == 0) {
                            [enemy setDirection:randomDirection];
                        }
                        // 確率1/4で横方向逃げ
                        else if (rand()%2 == 0) {
                            if ([enemy pos].x > [playerKoma pos].x) {
                                if (direction==E_DIRECTION_LEFT) {
                                    [enemy setDirection:randomDirection];
                                } else {
                                    [enemy setDirection:E_DIRECTION_RIGHT];
                                }
                            } else {
                                if (direction==E_DIRECTION_RIGHT) {
                                    [enemy setDirection:randomDirection];
                                } else {
                                    [enemy setDirection:E_DIRECTION_LEFT];
                                }
                            }
                        } 
                        // 確率1/4で縦方向逃げ
                        else {
                            if ([enemy pos].y > [playerKoma pos].y) {
                                if (direction==E_DIRECTION_UP) {
                                    [enemy setDirection:randomDirection];
                                } else {
                                    [enemy setDirection:E_DIRECTION_DOWN];
                                }
                            } else {
                                if (direction==E_DIRECTION_DOWN) {
                                    [enemy setDirection:randomDirection];
                                } else {
                                    [enemy setDirection:E_DIRECTION_UP];
                                }
                            }
                        }
                        
                    }
                    
                }
                
            }
            // 移動する
            else if (moveCounter > 0) {
                float eDirectionX = 0;// 停止
                float eDirectionY = 0;// 停止
                int enemyDirection = [enemy direction];
                if (enemyDirection == E_DIRECTION_UP) {
                    eDirectionY = -1.0f;
                } else if (enemyDirection == E_DIRECTION_LEFT) {
                    eDirectionX = -1.0f;
                } else if (enemyDirection == E_DIRECTION_RIGHT) {
                    eDirectionX = 1.0f;
                } else if (enemyDirection == E_DIRECTION_DOWN) {
                    eDirectionY = 1.0f;
                }
                // 行き止まりの際はmoveCounterをリセットする
                if ([self moveWithKoma:enemy directionX:eDirectionX directionY:eDirectionY] == 0) {
                    [enemy setMoveCounter:0];
                } else {
                    [enemy setMoveCounter:moveCounter-1];
                }            
            }
            // 停止
            else if (moveCounter < 0) {
                [enemy setMoveCounter:moveCounter+1];
            }
            
        // ドッペル
        } else {
            int tmp = 0;
            if ([enemy personality] < 2) {
                [enemy setDirection:[playerKoma direction]];
                if ([enemy personality] == 1) {
                    [enemy setSpeed:3.0f];
                }
                tmp += [self moveWithKoma:enemy directionX:directionX directionY:directionY];
            } else if ([enemy personality] < 4) {
                if ([enemy personality] == 3) {
                    [enemy setSpeed:3.0f];
                }
                if ([playerKoma direction] == E_DIRECTION_UP) {
                    [enemy setDirection:E_DIRECTION_DOWN];
                } else if ([playerKoma direction] == E_DIRECTION_LEFT) {
                    [enemy setDirection:E_DIRECTION_RIGHT];
                } else if ([playerKoma direction] == E_DIRECTION_RIGHT) {
                    [enemy setDirection:E_DIRECTION_LEFT];
                } else {
                    [enemy setDirection:E_DIRECTION_UP];
                }
                tmp += [self moveWithKoma:enemy directionX:-directionX directionY:-directionY];
            } else if ([enemy personality] < 6) {
                if ([enemy personality] == 5) {
                    [enemy setSpeed:3.0f];
                }
                if (enemyId%2 == 0) {
                    if ([playerKoma direction] == E_DIRECTION_UP) {
                        [enemy setDirection:E_DIRECTION_LEFT];
                    } else if ([playerKoma direction] == E_DIRECTION_LEFT) {
                        [enemy setDirection:E_DIRECTION_DOWN];
                    } else if ([playerKoma direction] == E_DIRECTION_RIGHT) {
                        [enemy setDirection:E_DIRECTION_UP];
                    } else {
                        [enemy setDirection:E_DIRECTION_RIGHT];
                    }

                    tmp += [self moveWithKoma:enemy directionX:directionY directionY:-directionX];
                } else {
                    if ([playerKoma direction] == E_DIRECTION_UP) {
                        [enemy setDirection:E_DIRECTION_RIGHT];
                    } else if ([playerKoma direction] == E_DIRECTION_LEFT) {
                        [enemy setDirection:E_DIRECTION_UP];
                    } else if ([playerKoma direction] == E_DIRECTION_RIGHT) {
                        [enemy setDirection:E_DIRECTION_DOWN];
                    } else {
                        [enemy setDirection:E_DIRECTION_LEFT];
                    }

                    tmp += [self moveWithKoma:enemy directionX:-directionY directionY:directionX];
                    
                }
            }
            if ([enemy hitPoint] > 0 && tmp > 0) {
                [enemy setHitPoint:[enemy hitPoint]+level+1];
            }
        }
        
        // ランダム
        if ([enemy gunCounter] == 0 && [enemy random] == E_RANDOM_2) {
            [enemy setType:rand()%8];
            [enemy setRandom:E_RANDOM_1];
        }
        // ドッペル
        else if ([enemy gunCounter]==0 && [enemy doppel]==E_DOPPEL_2) {
            if ([playerKoma type] >= 0) {
                [enemy setType:[playerKoma type]];
                [enemy setDoppel:E_DOPPEL_1];
            }
        }
        
        // プレイヤーと敵がダメージを受けていない（いずれかが点滅中である）
        if ([playerKoma damagingCounter] + [enemy damagingCounter] == 0) {
            [self checkHitBodyWithEnemy:enemy];
        }
        
    } 
    
    
    // ステージクリア判定
    if (enemyCount == 0 && [playerKoma hitPoint]>0) {
        gameState = E_GAME_STATE_STAGE_CLEAR;
    }
}

/************************************************
 ボディの当たり判定
 ************************************************/
- (void)checkHitBodyWithEnemy:(EnemyDataEntity *)enemy {
    [g setColor:rgb(32,190,255)];
    
    int direction = [enemy direction];
    
    int x, y;
    x = [enemy pos].x;
    y = [enemy pos].y;
    CGRect rect1, rect2, rect3;
    
    if (direction == E_DIRECTION_UP) {
        rect1 = CGRectMake(x+3, y+22, 38, 20);
        rect2 = CGRectMake(x+10, y+11, 24, 11);
        rect3 = CGRectMake(x+16, y+3, 12, 10);
    } else if (direction == E_DIRECTION_LEFT) {
        rect1 = CGRectMake(x+22, y+3, 20, 38);
        rect2 = CGRectMake(x+11, y+10, 11, 24);
        rect3 = CGRectMake(x+3, y+16, 10, 12);
        
    } else if (direction == E_DIRECTION_RIGHT) {
        rect1 = CGRectMake(x+3, y+3, 20, 38);
        rect2 = CGRectMake(x+22, y+10, 11, 24);
        rect3 = CGRectMake(x+30, y+16, 11, 12);
        
    } else if (direction == E_DIRECTION_DOWN) {
        rect1 = CGRectMake(x+3, y+3, 38, 20);
        rect2 = CGRectMake(x+10, y+22, 24, 11);
        rect3 = CGRectMake(x+16, y+30, 12, 11);
    }
    
/*
    [g drawRect_x:rect1.origin.x y:rect1.origin.y w:rect1.size.width h:rect1.size.height];
    [g drawRect_x:rect2.origin.x y:rect2.origin.y w:rect2.size.width h:rect2.size.height];
    [g drawRect_x:rect3.origin.x y:rect3.origin.y w:rect3.size.width h:rect3.size.height];

    */
    direction = [playerKoma direction];
    x = [playerKoma pos].x;
    y = [playerKoma pos].y;
    
//    CGRect pRect1, pRect2, pRect3;// プレイヤーの判定矩形
    CGPoint pPoint[12];
    if (direction == E_DIRECTION_UP) {
        pPoint[0] = CGPointMake(x+16, y+3);
        pPoint[1] = CGPointMake(x+28, y+3);
        pPoint[2] = CGPointMake(x+10, y+11);
        pPoint[3] = CGPointMake(x+34, y+11);
        pPoint[4] = CGPointMake(x+3, y+22);
        pPoint[5] = CGPointMake(x+41, y+22);
        pPoint[6] = CGPointMake(x+3, y+42);
        pPoint[7] = CGPointMake(x+41, y+42);
        pPoint[8] = CGPointMake(x+3, y+32);
        pPoint[9] = CGPointMake(x+41, y+32);
        pPoint[10] = CGPointMake(x+16, y+42);// 駒の底辺
        pPoint[11] = CGPointMake(x+28, y+42);// 駒の底辺
        

        /*
        pRect1 = CGRectMake(x+3, y+22, 38, 20);
        pRect2 = CGRectMake(x+10, y+11, 24, 11);
        pRect3 = CGRectMake(x+16, y+3, 12, 10);
         */
    } else if (direction == E_DIRECTION_LEFT) {
        pPoint[0] = CGPointMake(x+3, y+16);
        pPoint[1] = CGPointMake(x+3, y+28);
        pPoint[2] = CGPointMake(x+11, y+10);
        pPoint[3] = CGPointMake(x+11, y+34);
        pPoint[4] = CGPointMake(x+22, y+3);
        pPoint[5] = CGPointMake(x+22, y+41);
        pPoint[6] = CGPointMake(x+42, y+3);
        pPoint[7] = CGPointMake(x+42, y+41);
        pPoint[8] = CGPointMake(x+32, y+3);
        pPoint[9] = CGPointMake(x+32, y+41);
        pPoint[10] = CGPointMake(x+42, y+16);// 駒の底辺
        pPoint[11] = CGPointMake(x+42, y+28);// 駒の底辺


        /*
        pRect1 = CGRectMake(x+22, y+3, 20, 38);
        pRect2 = CGRectMake(x+11, y+10, 11, 24);
        pRect3 = CGRectMake(x+3, y+16, 10, 12);
         */
    } else if (direction == E_DIRECTION_RIGHT) {
        pPoint[0] = CGPointMake(x+41, y+16);
        pPoint[1] = CGPointMake(x+41, y+28);
        pPoint[2] = CGPointMake(x+33, y+10);
        pPoint[3] = CGPointMake(x+33, y+34);
        pPoint[4] = CGPointMake(x+23, y+3);
        pPoint[5] = CGPointMake(x+23, y+41);
        pPoint[6] = CGPointMake(x+3, y+3);
        pPoint[7] = CGPointMake(x+3, y+41);
        pPoint[8] = CGPointMake(x+13, y+3);
        pPoint[9] = CGPointMake(x+13, y+41);
        pPoint[10] = CGPointMake(x+3, y+16);// 駒の底辺
        pPoint[11] = CGPointMake(x+3, y+28);// 駒の底辺


        /*
        pRect1 = CGRectMake(x+3, y+3, 20, 38);
        pRect2 = CGRectMake(x+22, y+10, 11, 24);
        pRect3 = CGRectMake(x+30, y+16, 11, 12);
         */
    } else if (direction == E_DIRECTION_DOWN) {
        pPoint[0] = CGPointMake(x+16, y+41);
        pPoint[1] = CGPointMake(x+28, y+41);
        pPoint[2] = CGPointMake(x+10, y+33);
        pPoint[3] = CGPointMake(x+34, y+33);
        pPoint[4] = CGPointMake(x+3, y+23);
        pPoint[5] = CGPointMake(x+41, y+23);
        pPoint[6] = CGPointMake(x+3, y+3);
        pPoint[7] = CGPointMake(x+41, y+3);
        pPoint[8] = CGPointMake(x+3, y+13);
        pPoint[9] = CGPointMake(x+41, y+13);
        pPoint[10] = CGPointMake(x+16, y+3);// 駒の底辺
        pPoint[11] = CGPointMake(x+28, y+3);// 駒の底辺


       /*
        pRect1 = CGRectMake(x+3, y+3, 38, 20);
        pRect2 = CGRectMake(x+10, y+22, 24, 11);
        pRect3 = CGRectMake(x+16, y+30, 12, 11);
        */
    }

    /*
    [g drawRect_x:pRect1.origin.x y:pRect1.origin.y w:pRect1.size.width h:pRect1.size.height];
    [g drawRect_x:pRect2.origin.x y:pRect2.origin.y w:pRect2.size.width h:pRect2.size.height];
    [g drawRect_x:pRect3.origin.x y:pRect3.origin.y w:pRect3.size.width h:pRect3.size.height];
   */
    // 体当たり判定
    /*
     敵の駒を３つの矩形に分け、
     それぞれの矩形内にプレイヤーの頂点（１２個）が１つでも含まれていれば接触とする
     */
    BOOL isDamage = NO;
    for (int i=0; i<12; i++) {
        if (CGRectContainsPoint(rect1, pPoint[i]) ||
            CGRectContainsPoint(rect2, pPoint[i]) ||
            CGRectContainsPoint(rect3, pPoint[i])) {
            isDamage = YES;
            break;
        }
    }
    if (isDamage) {
        [playerKoma hitWithValue:1];
        
        if ([playerKoma hitPoint] > 0) {            
            // ダメージサウンド
            [self playSound:E_SOUND_DAMAGE];
        } else {
            // プレイヤー死亡サウンド
            [self playSound:E_SOUND_PLAYER_EXPLOSION];
        }
 
       

        [self damageAnimation];
    }

}

/************************************************
 敵の向きをランダムで決める
 ・ただし真後ろは向かない
 ************************************************/
- (int)getEnemyNextDirection:(int)direction {
    int random = rand()%3;// 0, 1, 2 (up left right)
    
    if (direction==E_DIRECTION_LEFT && random==E_DIRECTION_RIGHT) {
        random = E_DIRECTION_DOWN;
    } else if (direction==E_DIRECTION_RIGHT && random==E_DIRECTION_LEFT) {
        random = E_DIRECTION_DOWN;
    } else if (direction==E_DIRECTION_UP && random==E_DIRECTION_DOWN) {
        random = E_DIRECTION_UP;
    }
    /*
     direction==下向き の時はrandomが0, 1, 2（上、左、右）なので問題なし
     */
    return random;
}

/************************************************
 駒の移動
 ・直進不可の場合、0を返却する
 ************************************************/
- (float)moveWithKoma:(Koma *)koma directionX:(float)dirX directionY:(float)dirY {
    float moveX = dirX*[koma speed];
    float moveY = dirY*[koma speed];
    if (moveX != 0.0f && moveY != 0.0f) {
        moveX *= 0.70710678;
        moveY *= 0.70710678;
    }
    moveX = [self wallCheckWithKoma:koma directionX:moveX directionY:0.0f];
    moveY = [self wallCheckWithKoma:koma directionX:0.0f directionY:moveY];
    float isWall = [koma moveWithDirectionX:moveX directionY:moveY];
    
    // 盤の外に行こうとしたとき
    if (isWall == 0) {
        return 0;
    }
    // ブロックに直進したとき
    else if (moveX + moveY == 0) {
        return 0;
    }
    
    // 敵の場合のみ
    if ([koma isKindOfClass:[EnemyDataEntity class]]) {
        if (((EnemyDataEntity *)koma).poisonCounter > 0) {
            ((EnemyDataEntity *)koma).poisonCounter--;
        }
    }
    
    return 1.0f;

}


/************************************************
 壁あたり判定（移動）
 ・x、y成分毎に判定し、直進不可であれば当該成分を０にして返す
 ・ブロックの端を直進する場合はスリップ処理を行う
 ************************************************/
- (float)wallCheckWithKoma:(Koma *)koma directionX:(float)dirX directionY:(float)dirY {
    
    float wallSize = 58.0f;
    float komaSize = 44.0f;
    
    CGPoint point1 = CGPointMake([koma pos].x+dirX,          [koma pos].y+dirY);
    CGPoint point2 = CGPointMake([koma pos].x+dirX+komaSize, [koma pos].y+dirY);
    CGPoint point3 = CGPointMake([koma pos].x+dirX,          [koma pos].y+dirY+komaSize);
    CGPoint point4 = CGPointMake([koma pos].x+dirX+komaSize, [koma pos].y+dirY+komaSize);
    
    for (int y=0; y<9; y++) {
        for (int x=0; x<9; x++) {
            int mapObject = map[x][y];
            
            // 壁の場合
            if (mapObject > 0) {
                float wallX = 11.0f + 60.0f*x;
                float wallY = 11.0f + 60.0f*y;
                
                CGRect rect = CGRectMake(wallX, wallY, wallSize, wallSize);
                
                if (CGRectContainsPoint(rect, point1) ||
                    CGRectContainsPoint(rect, point2) ||
                    CGRectContainsPoint(rect, point3) ||
                    CGRectContainsPoint(rect, point4)) {
                    
                    float slipValue = 34.0f;
                    float slipSpeed = [playerKoma speed]/2.0f;
                    // 横方向直進の場合
                    if ([koma speed] == fabs(dirX)) {
                        
                        float playerCenterY = [koma pos].y + komaSize/2.0f;
                        
                        // 上側にいる
                        if (playerCenterY < wallY+wallSize/2.0f-slipValue) {
                            int upperObject = E_BLOCK_HARD;
                            if (y>0) {
                                upperObject = map[x][y-1];
                            }
                            if (upperObject == E_BLOCK_NONE) { 
                                [koma moveWithDirectionX:0.0f directionY:-slipSpeed];
                            }
                        } 
                        // 下側にいる
                        else if (playerCenterY > wallY+wallSize/2.0f+slipValue) {
                            int underObject = E_BLOCK_HARD;
                            if (y<8) {
                                underObject = map[x][y+1];
                            }
                            if (underObject == E_BLOCK_NONE) {
                                [koma moveWithDirectionX:0.0f directionY:slipSpeed];
                            }
                            
                        }
                        
                    } 
                    // 縦方向直進の場合
                    else if ([koma speed] == fabs(dirY)) {
                        
                        float playerCenterX = [koma pos].x + komaSize/2.0f;
                        
                        // 左側にいる
                        if (playerCenterX < wallX+wallSize/2.0f-slipValue) {
                            int leftObject = E_BLOCK_HARD;
                            if (x>0) {
                                leftObject = map[x-1][y];
                            }
                            if (leftObject == E_BLOCK_NONE) {
                                [koma moveWithDirectionX:-slipSpeed directionY:0.0f];
                            }
                        }
                        // 右側にいる
                        else if (playerCenterX > wallX+wallSize/2.0f+slipValue) {
                            int rightObject = E_BLOCK_HARD;
                            if (x<8) {
                                rightObject = map[x+1][y];
                            }
                            if (rightObject == E_BLOCK_NONE) {
                                [koma moveWithDirectionX:slipSpeed directionY:0.0f];
                            }
                        }
                    }
                    
                    return 0.0f;
                }
            }
        }        
    }
    return dirX + dirY;
}

/************************************************
 攻撃当たり判定
 ************************************************/
- (void)attackCheckWithKoma:(Koma *)koma {
    
    BOOL isPlayerAttack = [koma isKindOfClass:[PlayerKoma class]];
    
    // プレイヤーの攻撃
    if (isPlayerAttack) {
        for (int area=0; area<8; area++) {
            CGRect gunRect = [koma getGunRectAtIndex:area];
            
            // 当該エリアに攻撃爆発が無いときは処理しない
            if (gunRect.size.width + gunRect.size.height == 0) {
                continue;
            }
            
            float gx = gunRect.origin.x;
            float gy = gunRect.origin.y;
            float gw = gunRect.size.width;
            float gh = gunRect.size.height;
            /*
             攻撃が小さすぎて当たりにくすぎるのを修正
             ver1.0.0: smaller = 9.0f
             ver1.0.1: smaller = 7.0f
             */
            float smaller = 7.0f;
            if ([koma gunType] == E_KOMA_TYPE_KAKU) {
                smaller = 12.0f;
            }
            CGPoint point1 = CGPointMake(gx + smaller, gy + smaller);
            CGPoint point2 = CGPointMake(gx + gw - smaller, gy + smaller);
            CGPoint point3 = CGPointMake(gx + smaller, gy + gh - smaller);
            CGPoint point4 = CGPointMake(gx + gw - smaller, gy + gh - smaller);
            
            for (EnemyDataEntity *enemy in enemyDataEntityArray) {
                
                // ダメージを受けているときは処理をとばす（点滅中）
                if ([enemy damagingCounter] > 0) {
                    continue;
                }
                
                CGRect enemyRect = CGRectMake([enemy pos].x+2, [enemy pos].y+2, 40, 40);
                
                BOOL isDamage = NO;
                if (CGRectContainsPoint(enemyRect, point1) ||
                    CGRectContainsPoint(enemyRect, point2) ||
                    CGRectContainsPoint(enemyRect, point3) ||
                    CGRectContainsPoint(enemyRect, point4)) {
                    isDamage = YES;
                }
                if (isDamage) {
                    
                    int power = [playerKoma attackPower];
                    
                    power += ([playerKoma fuel]/80)*[gameDataEntity special] + tame;// 燃料が多い時は特殊攻撃力アップ
                    
                    [enemy hitWithValue:power];// プレイヤーの攻撃力でダメージを与える
                    
                    // 束縛
                    [enemy setBindCounter:[gameDataEntity bind]*3];
                    if ([gameDataEntity bind] > 0) {// 束縛中は攻撃タイミングをランダム時間封印できる
                        enemy.attackCounter += 2 + rand()%(2 + 2*[gameDataEntity bind]);
                    }
                    
                    // ランダム敵に攻撃すると性格が変わる
                    if ([enemy random] > 0) {
                        [enemy setPersonality:rand()%6];
                    }
                    
                    // 毒性
                    if ([enemy poisonCounter] == -2) {// 免疫がある場合
                        if (rand()%100 < (75 - level*10)) {// 発症率 75%, 65%, 55%, 45%
                            [enemy setPoison:[gameDataEntity special]];
                        } 
                    } else {
                        [enemy setPoison:[gameDataEntity special]];
                    }
                    
                    if ([enemy hitPoint] > 0) {            
                        // 敵ダメージサウンド
                        [self playSound:E_SOUND_DAMAGE];
                    } else {
                        // 敵死亡サウンド
                        [self playSound:E_SOUND_ENEMY_EXPLOSION];
                        
                        item[[enemy type]] = YES;// 駒を獲得
                        int dropFuel =  [enemy dropFuel] + ([enemy type]+1)/2;
                        if (stageNumber > 90) {
                            dropFuel--;
                        }
                        
                        [playerKoma setFuel:[playerKoma fuel] + dropFuel];// 燃料の獲得
                        if ([playerKoma fuel] > 240) {
                            [playerKoma setFuel:240];
                        }
                    }
                }

            }
            
        }

    } 
    // 敵の攻撃
    else {
        
        for (int area=0; area<8; area++) {
            CGRect gunRect = [koma getGunRectAtIndex:area];
            
            // 当該エリアに攻撃爆発が無いときは処理しない
            if (gunRect.size.width + gunRect.size.height == 0) {
                continue;
            }
            
            float gx = gunRect.origin.x;
            float gy = gunRect.origin.y;
            float gw = gunRect.size.width;
            float gh = gunRect.size.height;
            
            /*
             攻撃が小さすぎて当たりにくすぎるのを修正
             ver1.0.0: smaller = 9.0f
             ver1.0.1: smaller = 7.0f
             */
            float smaller = 7.0f;
            if ([koma gunType] == E_KOMA_TYPE_KAKU) {
                smaller = 12.0f;
            }

            CGPoint point1 = CGPointMake(gx + smaller, gy + smaller);
            CGPoint point2 = CGPointMake(gx + gw - smaller, gy + smaller);
            CGPoint point3 = CGPointMake(gx + smaller, gy + gh - smaller);
            CGPoint point4 = CGPointMake(gx + gw - smaller, gy + gh - smaller);
            
            // ダメージを受けているときは処理をとばす（点滅中）
            if ([playerKoma damagingCounter] > 0) {
                continue;
            }
            
            // プレイヤーの当たり判定
            CGRect playerRect = CGRectMake([playerKoma pos].x+2, [playerKoma pos].y+2, 40, 40);
            
            BOOL isDamage = NO;
            if (CGRectContainsPoint(playerRect, point1) ||
                CGRectContainsPoint(playerRect, point2) ||
                CGRectContainsPoint(playerRect, point3) ||
                CGRectContainsPoint(playerRect, point4)) {
                isDamage = YES;
            }
            if (isDamage) {
                [playerKoma hitWithValue:1];// プレイヤーがダメージを受ける
                
                if ([playerKoma hitPoint] > 0) {            
                    // プレイヤーダメージサウンド
                    [self playSound:E_SOUND_DAMAGE];
                } else {
                    // プレイヤー死亡サウンド
                    [self playSound:E_SOUND_PLAYER_EXPLOSION];
                }
                [self damageAnimation];

            }
            
        }
    }    
}

/************************************************
 壁攻撃判定
 ************************************************/
- (void)wallAttackCheckWithKoma:(Koma *)koma {
    
    // 通常弾か進行弾かを判定する
    int gunType = [koma gunType];
    BOOL isBlueGun = NO;
    if (gunType == E_KOMA_TYPE_KYO ||
        gunType == E_KOMA_TYPE_KAKU ||
        gunType == E_KOMA_TYPE_HI) {
        isBlueGun = YES;
    }
    
    for (int area=0; area<8; area++) {
        CGRect gunRect = [koma getGunRectAtIndex:area];
        
        // 当該エリアに攻撃爆発が無いときは処理しない
        if (gunRect.size.width + gunRect.size.height == 0) {
            continue;
        }
        
        // 壁を破壊する力が無い時は処理しない
        if ([koma getWallAttackPowerWithArea:area] == 0) {
            continue;
        }
        
        float gx = gunRect.origin.x;
        float gy = gunRect.origin.y;
        float gw = gunRect.size.width;
        float gh = gunRect.size.height;
        float smaller = 8.0f;
        CGPoint point1 = CGPointMake(gx + smaller, gy + smaller);
        CGPoint point2 = CGPointMake(gx + gw - smaller, gy + smaller);
        CGPoint point3 = CGPointMake(gx + smaller, gy + gh - smaller);
        CGPoint point4 = CGPointMake(gx + gw - smaller, gy + gh - smaller);
        
        
        for (int y=0; y<9; y++) {
            for (int x=0; x<9; x++) {
                int mapObject = map[x][y];
                if (mapObject != E_BLOCK_NONE) {
                
                    CGRect blockRect = CGRectMake(11.0f+60.0f*x, 11.0f+60.0f*y, 58.0f, 58.0f);
                    
                    // ハードブロック
                    if (mapObject == E_BLOCK_HARD) {
                        
                        if (isBlueGun) {
                            if (CGRectContainsPoint(blockRect, point1) ||
                                CGRectContainsPoint(blockRect, point2) ||
                                CGRectContainsPoint(blockRect, point3) ||
                                CGRectContainsPoint(blockRect, point4)) {
                                
                                // 当該エリアの攻撃を終了する
                                [koma decreaseWallAttackPowerWithArea:area];
                            }
                        }
                        
                    } 
                    // ソフトブロック
                    else {
                        
                        if (CGRectContainsPoint(blockRect, point1) ||
                            CGRectContainsPoint(blockRect, point2) ||
                            CGRectContainsPoint(blockRect, point3) ||
                            CGRectContainsPoint(blockRect, point4)) {
                            
                            // 進行弾
                            if (isBlueGun) {
                                // 当該エリアの攻撃を終了する
                                [koma decreaseWallAttackPowerWithArea:area];
                                
                            } 
                            // 通常弾
                            else {
                                // 爆発が出たばかりでは壁破壊しない（壁に埋まっている敵が壁を壊さないように）
                                if ([koma gunCounter] > 6) {
                                    continue;
                                }
                            }
                            
                            
                            
                            if ([koma getWallDamagingCounterWithX:x y:y] == 0) {
                                [koma setWallDamagingCounterWithX:x y:y];
                                
                                if (mapObject == E_BLOCK_SOFT1) {
                                    [self playSound:E_SOUND_BLOCK];
                                    map[x][y] = E_BLOCK_NONE;
                                } else {
                                    [self playSound:E_SOUND_BLOCK2];
                                    map[x][y]--;
                                }
                            }
                            
                        } 
                        
                    }
                }
            }
        }

    }
}

/************************************************
 向いている方向から角度を返す
 ************************************************/
- (float)getAngleWithDirection:(int)direction {
    
    if (direction == E_DIRECTION_UP) {
        return 0.0f;
    } else if (direction == E_DIRECTION_LEFT) {
        return 90.0f;
    } else if (direction == E_DIRECTION_DOWN) {
        return 180.0f;
    } else if (direction == E_DIRECTION_RIGHT) {
        return 270.0f;
    }
    
    return 0.0f;
}

/************************************************
 左ボタン押下
 ************************************************/
- (void)leftButtonPushed {
    
    /*
     歩しか無い場合はDISABLEを再生する
     */
    int komaCount = 0;
    for (int i=0; i<8; i++) {
        komaCount += item[i];
    }
    
    // まだゲームが始まっていないとき
    if (komaCount == 0) {
        [self playSound:E_SOUND_DISABLE];
        return;
    } 
    // 歩しか持っていないとき
    else if (komaCount == 1) {
        [self playSound:E_SOUND_DISABLE];
        return;
    } 
    // 駒が２つ以上ある時
    else {
        [self playSound:E_SOUND_SELECT];
        
        int playerType = [playerKoma type];
        
        playerType--;
        // 左にずらした結果が歩を超えていれば王にセットする
        if (playerType < E_KOMA_TYPE_FU) {
            playerType = E_KOMA_TYPE_OU;
        }
        // 所有している駒になるまで左にずらす
        while (!item[playerType]) {
            playerType--;
        }
        [playerKoma setType:playerType];
       
    }
}

/************************************************
 右ボタン押下
 ************************************************/
- (void)rightButtonPushed {
    /*
     歩しか無い場合はDISABLEを再生する
     */
    int komaCount = 0;
    for (int i=0; i<8; i++) {
        komaCount += item[i];
    }
    
    // まだゲームが始まっていないとき
    if (komaCount == 0) {
        [self playSound:E_SOUND_DISABLE];
        return;
    }
    // 歩しか持っていないとき
    else if (komaCount == 1) {
        [self playSound:E_SOUND_DISABLE];
        return;
    } 
    // 駒が２つ以上ある時
    else {
        [self playSound:E_SOUND_SELECT];
        
        int playerType = [playerKoma type];
        // 王より手前ならば右へ進める
        if (playerType < E_KOMA_TYPE_OU) {
            playerType++;
            // 該当する駒を持っていない場合は次を調べる
            while (!item[playerType]) {
                playerType++;
                // 王を超えた場合は歩に戻る
                if (playerType > E_KOMA_TYPE_OU) {
                    playerType = E_KOMA_TYPE_FU;
                }
            }
            [playerKoma setType:playerType];
        } 
        // 王ならば歩に設定する
        else {
            [playerKoma setType:E_KOMA_TYPE_FU];
        }
    }
}

/************************************************
 サウンド再生
 ************************************************/
- (void)playSound:(int)sound {
    if (canPlaySound[sound]) {
        canPlaySound[sound] = NO;
        [soundManager play:sound];
    }
}

/************************************************
 駒所有を判定し、文字色を設定する
 ************************************************/
- (void)setColorWithKomaType:(int)type {
    if (item[type]) {   
        [g setColor:rgb(0, 160, 255)];
    } else {
        [g setColor:rgb(0, 0, 0)];
    }
}

/************************************************
 デジタル数字
 ************************************************/
- (void)drawDigitalNumber:(int)hp x:(float)x y:(float)y; {
    
    int s = 5;// size いっぺんの長さ
    int s2 = 10;// ２辺の長さ
    
    if (hp == 0) {
        [g drawLine_x0:x   y0:y    x1:x+s y1:y];
        [g drawLine_x0:x+s y0:y    x1:x+s y1:y+s];
        [g drawLine_x0:x   y0:y    x1:x y1:y+s];
       // [g drawLine_x0:x   y0:y+s  x1:x+s y1:y+s];
        [g drawLine_x0:x+s y0:y+s  x1:x+s   y1:y+s2];
        [g drawLine_x0:x   y0:y+s2 x1:x+s y1:y+s2];
        [g drawLine_x0:x   y0:y+s  x1:x   y1:y+s2];

    } else if (hp == 1) {
        [g drawLine_x0:x+s y0:y x1:x+s y1:y+s2];
        
    } else if (hp == 2) {
        [g drawLine_x0:x   y0:y    x1:x+s y1:y];
        [g drawLine_x0:x+s y0:y    x1:x+s y1:y+s];
        [g drawLine_x0:x   y0:y+s  x1:x+s y1:y+s];
        [g drawLine_x0:x   y0:y+s  x1:x   y1:y+s2];
        [g drawLine_x0:x   y0:y+s2 x1:x+s y1:y+s2];
        
    } else if (hp == 3) {
        [g drawLine_x0:x   y0:y    x1:x+s y1:y];
        [g drawLine_x0:x+s y0:y    x1:x+s y1:y+s];
        [g drawLine_x0:x   y0:y+s  x1:x+s y1:y+s];
        [g drawLine_x0:x+s y0:y+s  x1:x+s y1:y+s2];
        [g drawLine_x0:x   y0:y+s2 x1:x+s y1:y+s2];
        
    } else if (hp == 4) {
        [g drawLine_x0:x   y0:y    x1:x   y1:y+s];
        [g drawLine_x0:x+s y0:y    x1:x+s y1:y+s];
        [g drawLine_x0:x   y0:y+s  x1:x+s y1:y+s];
        [g drawLine_x0:x+s y0:y+s  x1:x+s y1:y+s2];
        
    } else if (hp == 5) {
        [g drawLine_x0:x   y0:y    x1:x+s y1:y];
        [g drawLine_x0:x   y0:y    x1:x y1:y+s];
        [g drawLine_x0:x   y0:y+s  x1:x+s y1:y+s];
        [g drawLine_x0:x+s y0:y+s  x1:x+s   y1:y+s2];
        [g drawLine_x0:x   y0:y+s2 x1:x+s y1:y+s2];
 
    } else if (hp == 6) {
        [g drawLine_x0:x   y0:y    x1:x+s y1:y];
        [g drawLine_x0:x   y0:y    x1:x y1:y+s];
        [g drawLine_x0:x   y0:y+s  x1:x+s y1:y+s];
        [g drawLine_x0:x+s y0:y+s  x1:x+s   y1:y+s2];
        [g drawLine_x0:x   y0:y+s2 x1:x+s y1:y+s2];
        [g drawLine_x0:x   y0:y+s  x1:x   y1:y+s2];
        
    } else if (hp == 7) {
        [g drawLine_x0:x   y0:y    x1:x+s y1:y];
        [g drawLine_x0:x+s y0:y    x1:x+s y1:y+s];
        [g drawLine_x0:x   y0:y    x1:x y1:y+s];
      //  [g drawLine_x0:x   y0:y+s  x1:x+s y1:y+s];
        [g drawLine_x0:x+s y0:y+s  x1:x+s   y1:y+s2];
     //   [g drawLine_x0:x   y0:y+s2 x1:x+s y1:y+s2];
   //     [g drawLine_x0:x   y0:y+s  x1:x   y1:y+s2];
        
    } else if (hp == 8) {
        [g drawLine_x0:x   y0:y    x1:x+s y1:y];
        [g drawLine_x0:x+s y0:y    x1:x+s y1:y+s];
        [g drawLine_x0:x   y0:y    x1:x y1:y+s];
        [g drawLine_x0:x   y0:y+s  x1:x+s y1:y+s];
        [g drawLine_x0:x+s y0:y+s  x1:x+s   y1:y+s2];
        [g drawLine_x0:x   y0:y+s2 x1:x+s y1:y+s2];
        [g drawLine_x0:x   y0:y+s  x1:x   y1:y+s2];
        
    } else if (hp == 9) {
        [g drawLine_x0:x   y0:y    x1:x+s y1:y];
        [g drawLine_x0:x+s y0:y    x1:x+s y1:y+s];
        [g drawLine_x0:x   y0:y    x1:x y1:y+s];
        [g drawLine_x0:x   y0:y+s  x1:x+s y1:y+s];
        [g drawLine_x0:x+s y0:y+s  x1:x+s   y1:y+s2];
        [g drawLine_x0:x   y0:y+s2 x1:x+s y1:y+s2];
        
    }
}


/************************************************
 敵HPを表示
 ************************************************/
- (void)drawHP:(int)hp x:(float)x y:(float)y; {
    
    
    int s = 11;
    
    int number = 0;
    int hitPoint = hp;
    
    if (hitPoint <= 0) {
        return;
    }
    
    if (hitPoint >= 10000) {
        number = hitPoint/10000;
        hitPoint -= number*10000;
        [self drawDigitalNumber:number x:x+s y:y];
    }
    if (number>0 && hitPoint/1000==0) {
        [self drawDigitalNumber:0 x:x+s*2 y:y];
    }
    
    if (hitPoint >= 1000) {
        number = hitPoint/1000;
        hitPoint -= number*1000;
        [self drawDigitalNumber:number x:x+s*2 y:y];
    }
    if (number>0 && hitPoint/100==0) {
        [self drawDigitalNumber:0 x:x+s*3 y:y];
    }
  
    if (hitPoint >= 100) {
        number = hitPoint/100;
        hitPoint -= number*100;
        [self drawDigitalNumber:number x:x+s*3 y:y];
    }
    if (number>0 && hitPoint/10==0) {
        [self drawDigitalNumber:0 x:x+s*4 y:y];
    }

  
    if (hitPoint >= 10) {
        number = hitPoint/10;
        hitPoint -= number*10;
        [self drawDigitalNumber:number x:x+s*4 y:y];
    }
    
    number = hitPoint;
    [self drawDigitalNumber:number x:x+s*5 y:y];

}

/************************************************
 スペシャルボタン０１
 ************************************************/
- (void)special01ButtonPushed {
    starOption.type = rand()%kStarTypeNumber;
    
    // 全駒獲得するとアニメーション裏技が使える
    BOOL isAnimationOmake = YES;
    for (int i=0; i<8; i++) {
        if (!item[i]) {
            isAnimationOmake = NO;
        }
    }
    
    if (isAnimationOmake) {
        UIViewAnimationOptions options = (UIViewAnimationOptions)(UIViewAnimationOptionRepeat
                                                                  | UIViewAnimationOptionAllowUserInteraction
                  
                                                                  | UIViewAnimationOptionAutoreverse);
        float angle = M_PI*((rand()%11)/10.0f);
        if (rand()%100 < 60) {
            angle = 0;
        } else if (rand()%100 < 50) {
            angle = -angle;
        }
        [AnimationManager basicAnimationWithView:self
                                        duration:0.3f + (rand()%16)/10.0f // 0.3 - 1.8
                                           delay:0.0f
                                         options:options
                                     fromToAlpha:CGPointMake(1.0f, 1.0f)
                                    fromToRotate:CGPointMake(0.0f, angle)
                                      beginScale:CGPointMake(1.0f, 1.0f)
                                     finishScale:CGPointMake(0.2f + (rand()%17)/10.0f, 0.2f + (rand()%17)/10.0f)// 0.2 - 1.8
                                  beginTranslate:CGPointZero
                                 finishTranslate:CGPointMake(20 - rand()%41, 20 - rand()%41)]; 
        
    }
}
/************************************************
 スペシャルボタン０２
 ************************************************/
- (void)special02ButtonPushed {
    starOption.r = rand()%256;
    starOption.g = rand()%256;
    starOption.b = rand()%256;    
}
/************************************************
 スペシャルボタン０３
 ************************************************/
- (void)special03ButtonPushed {
    boardColor.r = rand()%256;
    boardColor.g = rand()%256;
    boardColor.b = rand()%256;   
    
#if DEBUG_MODE
    gameState = E_GAME_STATE_STAGE_CLEAR;
#endif
}

/************************************************
 ダメージアニメーション
 ************************************************/
- (void)damageAnimation {
    
    int animDirection = -2*rand()%2 + 1;// -2*0+1=1, -2*1+1=-1
    
    [self setTransform:CGAffineTransformMakeTranslation(0.0f, 0.0f)];
    [UIView animateWithDuration:0.06f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self setTransform:CGAffineTransformMakeTranslation(animDirection*6.0f, 0.0f)];
                     }completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:0.06f
                                               delay:0.0f
                                             options:UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              [self setTransform:CGAffineTransformMakeTranslation(-animDirection*6.0f, 0.0f)];
                                          }completion:^(BOOL finished) {
                                              
                                              [self setTransform:CGAffineTransformMakeTranslation(0.0f, 0.0f)];
                                              
                                          }
                          ];
                         
                     }
     ];
    

}

@end
