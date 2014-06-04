//
//  Koma.m
//  BSGA
//
//  Created by 近藤 雅人 on 12/04/30.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import "Koma.h"

@implementation Koma
@synthesize state;
@synthesize direction;
@synthesize pos;
@synthesize type;
@synthesize speed;
@synthesize hitPoint;
@synthesize damagingCounter;
@synthesize deadExplosionCounter;

@synthesize gunType;
@synthesize gunDirection;
@synthesize gunDefaultPos;
@synthesize gunCounter;

@synthesize isTame;
@synthesize isWeak;
@synthesize tameRange;
/************************************************
 初期化
 ************************************************/
- (id)init {
    self = [super init];
    if (self) {
        state = E_KOMA_STATE_NONE;
        direction = E_DIRECTION_UP;
        for (int i=0; i<8; i++) {
            gunRect[i] = CGRectZero;
        }
    }
    return self;
}

/************************************************
 向きを計算して返却する
 ************************************************/
- (int)calcDirectionWithDirectionX:(int)x directionY:(int)y {
    
    if (y == -1) {
        direction = E_DIRECTION_UP;
    } else if (y == 1) {
        direction = E_DIRECTION_DOWN;
    } else if (y == 0) {
        if (x == -1) {
            direction = E_DIRECTION_LEFT;
        } else if (x == 0) {
            // 停止しているときは以前と同じ方向なので何もしない
        } else if (x == 1) {
            direction = E_DIRECTION_RIGHT;
        }
    }
    return direction;
}

/************************************************
 移動
 ・通れない場合は０、通れる場合は１を返す
 ************************************************/
- (float)moveWithDirectionX:(float)x directionY:(float)y {
    
    pos.x += x;
    pos.y += y;
    
    
    
    return [self checkOnBoard];
}


/************************************************
 盤上チェック
 ・通れない場合は０、通れる場合は１を返す
 ************************************************/
- (float)checkOnBoard {
    
    float returnValue = 1.0f;
    
    if (pos.x < 11.0f) {
        pos.x = 11.0f;
        returnValue = 0;
    }
    if (pos.y < 11.0f) {
        pos.y = 11.0f;
        returnValue = 0;
    }
    
    if (pos.x > 505.0f) {
        pos.x = 505.0f;
        returnValue = 0;
    }
    if (pos.y > 505.0f) {
        pos.y = 505.0f;
        returnValue = 0;
    }
    
    return returnValue;
}

/************************************************
 setPos
 ************************************************/
- (void)setPos:(CGPoint)point {
    pos = point;
}

/************************************************
 ダメージ
 ************************************************/
- (void)hitWithValue:(int)value {
    if (hitPoint > 0) {
        hitPoint -= value;
        damagingCounter = 39;        
    }
}

/************************************************
 攻撃の矩形を返す
 ************************************************/
- (CGRect)getGunRectAtIndex:(int)index {
    return gunRect[index];
}

/************************************************
 攻撃の矩形をセットする
 ************************************************/
- (void)setGunRectAtIndex:(int)index bullet:(int)bullet {
    
    // 既に壁にぶつかった進行弾の場合
    if (wallAttackPower[index] <= 0) {
        return;
    }
    
    int count = 21 - gunCounter; // 0から始まり、19に到達する
    
    if (isTame) {
        count = 2*(21 - gunCounter + tameRange*(21 - gunCounter));
    }
    if (isWeak) {
        count = 0.6f * (21 - gunCounter);
    }
    
    
    // 撃ったときのキャラの左上座標
    float x = gunDefaultPos.x;
    float y = gunDefaultPos.y;
    
    float adjust = 17.0f;// 初期の引き寄せサイズ
    
    // 通常弾
    if (bullet == E_GUN_BULLET_NORMAL) {
        if (index == 0) {
            gunRect[index] = CGRectMake(x-adjust-count*2, y-adjust-count*2, 34, 34);            
        } else if (index == 1) {
            gunRect[index] = CGRectMake(x+5, y-adjust-count*2, 34, 34);
        } else if (index == 2) {
            gunRect[index] = CGRectMake(x+44-adjust+count*2, y-adjust-count*2, 34, 34);                        
        } else if (index == 3) {
            gunRect[index] = CGRectMake(x-adjust-count*2, y+5, 34, 34);                                    
        } else if (index == 4) {
            gunRect[index] = CGRectMake(x+44-adjust+count*2, y+5, 34, 34);                                    
            
        } else if (index == 5) {
            gunRect[index] = CGRectMake(x-adjust-count*2, y-adjust+44+count*2, 34, 34);                                    
            
        } else if (index == 6) {
            gunRect[index] = CGRectMake(x+5, y-adjust+44+count*2, 34, 34);                                    
            
        } else if (index == 7) {
            gunRect[index] = CGRectMake(x+44-adjust+count*2, y-adjust+44+count*2, 34, 34);                                    
            
        } 
    } 
    // 進行弾（飛車・角）
    else if (bullet == E_GUN_BULLET_OGOMA) {
        
        int hishaCount = count*9;
        int kakuCount = count*6;
        
        int hishaAdjust = 18; // 飛車はやや離れた位置から発射する（マスと重なっている敵が壁を破壊しないようにするため）
        int kakuAdjust = 25;// 角はひとマス離れた斜めマスから発射する
        
        if (index == 0) {
            gunRect[index] = CGRectMake(x-adjust-kakuCount-kakuAdjust, y-adjust-kakuCount-kakuAdjust, 34, 34);            
        } else if (index == 1) {
            gunRect[index] = CGRectMake(x+5, y-adjust-hishaCount-hishaAdjust, 34, 34);
        } else if (index == 2) {
            gunRect[index] = CGRectMake(x+44-adjust+kakuCount+kakuAdjust, y-adjust-kakuCount-kakuAdjust, 34, 34);                        
        } else if (index == 3) {
            gunRect[index] = CGRectMake(x-adjust-hishaCount-hishaAdjust, y+5, 34, 34);                                    
        } else if (index == 4) {
            gunRect[index] = CGRectMake(x+44-adjust+hishaCount+hishaAdjust, y+5, 34, 34);                                    
            
        } else if (index == 5) {
            gunRect[index] = CGRectMake(x-adjust-kakuCount-kakuAdjust, y-adjust+44+kakuCount+kakuAdjust, 34, 34);                                    
            
        } else if (index == 6) {
            gunRect[index] = CGRectMake(x+5, y-adjust+44+hishaCount+hishaAdjust, 34, 34);                                    
            
        } else if (index == 7) {
            gunRect[index] = CGRectMake(x+44-adjust+kakuCount+kakuAdjust, y-adjust+44+kakuCount+kakuAdjust, 34, 34);                                    
            
        } 
    } 
    // 香車弾
    else if (bullet == E_GUN_BULLET_KYOSYA) {
        
        int kyosyaCount = count*13;
        int kyosyaAdjust = 18;
        
        if (index == 1) {
            gunRect[index] = CGRectMake(x+5, y-adjust-kyosyaCount-kyosyaAdjust, 34, 34);
            
        } else if (index == 3) {
            gunRect[index] = CGRectMake(x-adjust-kyosyaCount-kyosyaAdjust, y+5, 34, 34);                                    
         
        } else if (index == 4) {
            gunRect[index] = CGRectMake(x+44-adjust+kyosyaCount+kyosyaAdjust, y+5, 34, 34);                                    
            
        } else if (index == 6) {
            gunRect[index] = CGRectMake(x+5, y-adjust+44+kyosyaCount+kyosyaAdjust, 34, 34);                                    
            
        } 
    }
    // 桂馬弾
    else if (bullet == E_GUN_BULLET_KEIMA) {
        
        int keimaValue = 14;
        
        /*
         桂馬の攻撃が狭すぎて回避が難しかったため修正
          ver1.0.0: 19+count
          ver1.0.1: 30+count
         */
        int keimaCount = 30+count;
        
        if (index == 0) {
            gunRect[index] = CGRectMake(x-adjust-keimaCount, y-adjust-keimaCount-44-keimaValue, 34, 34);            
        } else if (index == 1) {
            gunRect[index] = CGRectMake(x+44-adjust+keimaCount, y-adjust-keimaCount-44-keimaValue, 34, 34);            
        } else if (index == 2) {
            gunRect[index] = CGRectMake(x-adjust-keimaCount-44-keimaValue, y-adjust-keimaCount, 34, 34);            
        } else if (index == 3) {
            gunRect[index] = CGRectMake(x-adjust-keimaCount-44-keimaValue, y-adjust+44+keimaCount, 34, 34);            
        } else if (index == 4) {
            gunRect[index] = CGRectMake(x-adjust+keimaCount+88+keimaValue, y-adjust-keimaCount, 34, 34);            
            
        } else if (index == 5) {
            gunRect[index] = CGRectMake(x-adjust+keimaCount+88+keimaValue, y-adjust+44+keimaCount, 34, 34);            
            
        } else if (index == 6) {
            gunRect[index] = CGRectMake(x-adjust-keimaCount, y-adjust+keimaCount+88+keimaValue, 34, 34);            
            
        } else if (index == 7) {
            gunRect[index] = CGRectMake(x+44-adjust+keimaCount, y-adjust+keimaCount+88+keimaValue, 34, 34);            
            
        } 
        if (index == 0) {

        } else if (index == 2) {
            
        } else if (index == 5) {
            
        } else if (index == 7) {
            
        }
    }
}


/************************************************
 攻撃処理
 ************************************************/
- (void)gunWork {
    
    // 最後のフレームでは後始末を行う
    if (gunCounter == 1) {
        for (int i=0; i<8; i++) {
            gunRect[i] = CGRectZero;
        }
        gunCounter--;
        return;
    }

    
    /*
     
      [0][1][2]
      [3][ ][4]
      [5][6][7]
     
     桂馬 
         [0][ ][1]
      [2][ ][ ][ ][4]
      [ ][ ][ ][ ][ ]
      [3][ ][ ][ ][5]
         [6][ ][7]
     
     */
    
    if (gunType == E_KOMA_TYPE_FU) {
        if (gunDirection == E_DIRECTION_UP) {
            [self setGunRectAtIndex:1 bullet:E_GUN_BULLET_NORMAL];            
        } else if (gunDirection == E_DIRECTION_LEFT) {
            [self setGunRectAtIndex:3 bullet:E_GUN_BULLET_NORMAL];    
        } else if (gunDirection == E_DIRECTION_RIGHT) {
            [self setGunRectAtIndex:4 bullet:E_GUN_BULLET_NORMAL];    
        } else if (gunDirection == E_DIRECTION_DOWN) {
            [self setGunRectAtIndex:6 bullet:E_GUN_BULLET_NORMAL];    
        }
        
    } else if (gunType == E_KOMA_TYPE_KYO) {
        if (gunDirection == E_DIRECTION_UP) {
            [self setGunRectAtIndex:1 bullet:E_GUN_BULLET_KYOSYA];            
        } else if (gunDirection == E_DIRECTION_LEFT) {
            [self setGunRectAtIndex:3 bullet:E_GUN_BULLET_KYOSYA];    
        } else if (gunDirection == E_DIRECTION_RIGHT) {
            [self setGunRectAtIndex:4 bullet:E_GUN_BULLET_KYOSYA];    
        } else if (gunDirection == E_DIRECTION_DOWN) {
            [self setGunRectAtIndex:6 bullet:E_GUN_BULLET_KYOSYA];    
        }
        
    } else if (gunType == E_KOMA_TYPE_KEI) {
        if (gunDirection == E_DIRECTION_UP) {
            [self setGunRectAtIndex:0 bullet:E_GUN_BULLET_KEIMA];            
            [self setGunRectAtIndex:1 bullet:E_GUN_BULLET_KEIMA];    
            

            // test 
            /*
            {
                [self setGunRectAtIndex:2 bullet:E_GUN_BULLET_KEIMA];            
                [self setGunRectAtIndex:3 bullet:E_GUN_BULLET_KEIMA];            
                [self setGunRectAtIndex:4 bullet:E_GUN_BULLET_KEIMA];            
                [self setGunRectAtIndex:5 bullet:E_GUN_BULLET_KEIMA];            
                [self setGunRectAtIndex:6 bullet:E_GUN_BULLET_KEIMA];            
                [self setGunRectAtIndex:7 bullet:E_GUN_BULLET_KEIMA];            
            }    
             */
            
        } else if (gunDirection == E_DIRECTION_LEFT) {
            [self setGunRectAtIndex:2 bullet:E_GUN_BULLET_KEIMA];            
            [self setGunRectAtIndex:3 bullet:E_GUN_BULLET_KEIMA];            
        } else if (gunDirection == E_DIRECTION_RIGHT) {
            [self setGunRectAtIndex:4 bullet:E_GUN_BULLET_KEIMA];            
            [self setGunRectAtIndex:5 bullet:E_GUN_BULLET_KEIMA];            
        } else if (gunDirection == E_DIRECTION_DOWN) {
            [self setGunRectAtIndex:6 bullet:E_GUN_BULLET_KEIMA];            
            [self setGunRectAtIndex:7 bullet:E_GUN_BULLET_KEIMA];            
        }

    } else if (gunType == E_KOMA_TYPE_GIN) {
        if (gunDirection == E_DIRECTION_UP) {
            [self setGunRectAtIndex:0 bullet:E_GUN_BULLET_NORMAL];
            [self setGunRectAtIndex:1 bullet:E_GUN_BULLET_NORMAL];
            [self setGunRectAtIndex:2 bullet:E_GUN_BULLET_NORMAL];
            [self setGunRectAtIndex:5 bullet:E_GUN_BULLET_NORMAL];
            [self setGunRectAtIndex:7 bullet:E_GUN_BULLET_NORMAL];
        } else if (gunDirection == E_DIRECTION_LEFT) {
            [self setGunRectAtIndex:0 bullet:E_GUN_BULLET_NORMAL];
            [self setGunRectAtIndex:3 bullet:E_GUN_BULLET_NORMAL];
            [self setGunRectAtIndex:5 bullet:E_GUN_BULLET_NORMAL];
            [self setGunRectAtIndex:2 bullet:E_GUN_BULLET_NORMAL];
            [self setGunRectAtIndex:7 bullet:E_GUN_BULLET_NORMAL];
        } else if (gunDirection == E_DIRECTION_RIGHT) {
            [self setGunRectAtIndex:2 bullet:E_GUN_BULLET_NORMAL];
            [self setGunRectAtIndex:4 bullet:E_GUN_BULLET_NORMAL];
            [self setGunRectAtIndex:7 bullet:E_GUN_BULLET_NORMAL];
            [self setGunRectAtIndex:0 bullet:E_GUN_BULLET_NORMAL];
            [self setGunRectAtIndex:5 bullet:E_GUN_BULLET_NORMAL];
        } else if (gunDirection == E_DIRECTION_DOWN) {
            [self setGunRectAtIndex:0 bullet:E_GUN_BULLET_NORMAL];
            [self setGunRectAtIndex:2 bullet:E_GUN_BULLET_NORMAL];
            [self setGunRectAtIndex:5 bullet:E_GUN_BULLET_NORMAL];
            [self setGunRectAtIndex:6 bullet:E_GUN_BULLET_NORMAL];
            [self setGunRectAtIndex:7 bullet:E_GUN_BULLET_NORMAL];
        }

    } else if (gunType == E_KOMA_TYPE_KIN) {
        if (gunDirection == E_DIRECTION_UP) {
            [self setGunRectAtIndex:0 bullet:E_GUN_BULLET_NORMAL];
            [self setGunRectAtIndex:1 bullet:E_GUN_BULLET_NORMAL];
            [self setGunRectAtIndex:2 bullet:E_GUN_BULLET_NORMAL];
            [self setGunRectAtIndex:3 bullet:E_GUN_BULLET_NORMAL];
            [self setGunRectAtIndex:4 bullet:E_GUN_BULLET_NORMAL];
            [self setGunRectAtIndex:6 bullet:E_GUN_BULLET_NORMAL];
        } else if (gunDirection == E_DIRECTION_LEFT) {
            [self setGunRectAtIndex:0 bullet:E_GUN_BULLET_NORMAL];
            [self setGunRectAtIndex:3 bullet:E_GUN_BULLET_NORMAL];
            [self setGunRectAtIndex:5 bullet:E_GUN_BULLET_NORMAL];
            [self setGunRectAtIndex:1 bullet:E_GUN_BULLET_NORMAL];
            [self setGunRectAtIndex:6 bullet:E_GUN_BULLET_NORMAL];
            [self setGunRectAtIndex:4 bullet:E_GUN_BULLET_NORMAL];
        } else if (gunDirection == E_DIRECTION_RIGHT) {
            [self setGunRectAtIndex:2 bullet:E_GUN_BULLET_NORMAL];
            [self setGunRectAtIndex:4 bullet:E_GUN_BULLET_NORMAL];
            [self setGunRectAtIndex:7 bullet:E_GUN_BULLET_NORMAL];
            [self setGunRectAtIndex:1 bullet:E_GUN_BULLET_NORMAL];
            [self setGunRectAtIndex:6 bullet:E_GUN_BULLET_NORMAL];
            [self setGunRectAtIndex:3 bullet:E_GUN_BULLET_NORMAL];
        } else if (gunDirection == E_DIRECTION_DOWN) {
            [self setGunRectAtIndex:1 bullet:E_GUN_BULLET_NORMAL];
            [self setGunRectAtIndex:3 bullet:E_GUN_BULLET_NORMAL];
            [self setGunRectAtIndex:4 bullet:E_GUN_BULLET_NORMAL];
            [self setGunRectAtIndex:5 bullet:E_GUN_BULLET_NORMAL];
            [self setGunRectAtIndex:6 bullet:E_GUN_BULLET_NORMAL];
            [self setGunRectAtIndex:7 bullet:E_GUN_BULLET_NORMAL];
        }
        
    } else if (gunType == E_KOMA_TYPE_KAKU) {
        [self setGunRectAtIndex:0 bullet:E_GUN_BULLET_OGOMA];
        [self setGunRectAtIndex:2 bullet:E_GUN_BULLET_OGOMA];
        [self setGunRectAtIndex:5 bullet:E_GUN_BULLET_OGOMA];
        [self setGunRectAtIndex:7 bullet:E_GUN_BULLET_OGOMA];
        
    } else if (gunType == E_KOMA_TYPE_HI) {
        [self setGunRectAtIndex:1 bullet:E_GUN_BULLET_OGOMA];
        [self setGunRectAtIndex:3 bullet:E_GUN_BULLET_OGOMA];
        [self setGunRectAtIndex:4 bullet:E_GUN_BULLET_OGOMA];
        [self setGunRectAtIndex:6 bullet:E_GUN_BULLET_OGOMA];
        
    } else if (gunType == E_KOMA_TYPE_OU) {
        [self setGunRectAtIndex:0 bullet:E_GUN_BULLET_NORMAL];
        [self setGunRectAtIndex:1 bullet:E_GUN_BULLET_NORMAL];
        [self setGunRectAtIndex:2 bullet:E_GUN_BULLET_NORMAL];
        [self setGunRectAtIndex:3 bullet:E_GUN_BULLET_NORMAL];
        [self setGunRectAtIndex:4 bullet:E_GUN_BULLET_NORMAL];
        [self setGunRectAtIndex:5 bullet:E_GUN_BULLET_NORMAL];
        [self setGunRectAtIndex:6 bullet:E_GUN_BULLET_NORMAL];
        [self setGunRectAtIndex:7 bullet:E_GUN_BULLET_NORMAL];
        
    }
    gunCounter--;
}

/************************************************
 壁に対するダメージカウンタを返す
 ************************************************/
- (int)getWallDamagingCounterWithX:(int)x y:(int)y {
    return wallDamagingCounter[x][y];
}

/************************************************
 壁に対するダメージカウンタを与える
 ・該当壁に攻撃が当たったタイミングで呼ぶ
 ************************************************/
- (void)setWallDamagingCounterWithX:(int)x y:(int)y {
    wallDamagingCounter[x][y] = 22;
}

/************************************************
 壁に対するダメージカウンタを減らす
 ************************************************/
- (void)decreaseWallDamagingCounterWithX:(int)x y:(int)y {
    wallDamagingCounter[x][y]--;
}

/************************************************
 攻撃エリアに対する壁攻撃有効値を返す
 ************************************************/
- (int)getWallAttackPowerWithArea:(int)area {
    return wallAttackPower[area];
}

/************************************************
 攻撃エリアに対する壁攻撃有効値を減らす
 ************************************************/
- (void)decreaseWallAttackPowerWithArea:(int)area {
    wallAttackPower[area]--;
}

/************************************************
 壁攻撃有効値をリセットする
 ・攻撃開始のタイミングで呼ぶ
 ************************************************/
- (void)resetWallAttackPower {
    for (int i=0; i<8; i++) {
        wallAttackPower[i] = 1;
    }
}

@end
