//
//  GameDataEntity.m
//  BSGA
//
//  Created by 近藤 雅人 on 12/05/26.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import "GameDataEntity.h"

@implementation GameDataEntity

@synthesize launchCount;
@synthesize score;

@synthesize points;
@synthesize hp;
@synthesize special;
@synthesize reload;
@synthesize fuel;
@synthesize attack;
@synthesize bind;
@synthesize speed;

@synthesize customizeControllerMode;
@synthesize customizeBackgroundColorRandom;
@synthesize customizeButtonSound;
@synthesize customizeBlock;
@synthesize gachaPoints;
@synthesize payCountPoint;
@synthesize payCountGacha;
/************************************************
 破棄
 ************************************************/
/************************************************
 初期化（デコード）
 ************************************************/
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        
        launchCount = [aDecoder decodeIntegerForKey:@"launchCount"];
        score = [aDecoder decodeIntegerForKey:@"score"];
        
        points = [aDecoder decodeIntegerForKey:@"points"];
        hp = [aDecoder decodeIntegerForKey:@"hp"];
        special = [aDecoder decodeIntegerForKey:@"special"];
        reload = [aDecoder decodeIntegerForKey:@"reload"];
        fuel = [aDecoder decodeIntegerForKey:@"fuel"];
        attack = [aDecoder decodeIntegerForKey:@"attack"];
        bind = [aDecoder decodeIntegerForKey:@"bind"];
        speed = [aDecoder decodeIntegerForKey:@"speed"];
        
        customizeControllerMode = [aDecoder decodeIntegerForKey:@"customizeControllerMode"];
        customizeBackgroundColorRandom = [aDecoder decodeIntegerForKey:@"customizeBackgroundColorRandom"];
        customizeButtonSound = [aDecoder decodeIntegerForKey:@"customizeButtonSound"];
        customizeBlock = [aDecoder decodeIntegerForKey:@"customizeBlock"];
        
        gachaPoints = [aDecoder decodeIntegerForKey:@"gachaPoints"];
        
        payCountPoint = [aDecoder decodeIntegerForKey:@"payCountPoint"];
        payCountGacha = [aDecoder decodeIntegerForKey:@"payCountGacha"];
    
        for (int i=0; i<4; i++) {
            for (int j=0; j<180; j++) {
                stageClearStatus[i][j] = [aDecoder decodeIntegerForKey:[NSString stringWithFormat:@"scs%d-%d", i, j]];
            }
        }
        
        for (int i=0; i<20; i++) {
            gacha01Normal[i] = [aDecoder decodeIntegerForKey:[NSString stringWithFormat:@"gacha01Normal-%d", i]];
        }
        for (int i=0; i<6; i++) {
            gacha01Rare[i] = [aDecoder decodeIntegerForKey:[NSString stringWithFormat:@"gacha01Rare-%d", i]];
        }
        for (int i=0; i<2; i++) {
            gacha01SuperRare[i] = [aDecoder decodeIntegerForKey:[NSString stringWithFormat:@"gacha01SuperRare-%d", i]];
        }
        
        for (int i=0; i<30; i++) {
            gacha02Normal[i] = [aDecoder decodeIntegerForKey:[NSString stringWithFormat:@"gacha02Normal-%d", i]];
        }
        for (int i=0; i<20; i++) {
            gacha02Rare[i] = [aDecoder decodeIntegerForKey:[NSString stringWithFormat:@"gacha02Rare-%d", i]];
        }
        for (int i=0; i<10; i++) {
            gacha02SuperRare[i] = [aDecoder decodeIntegerForKey:[NSString stringWithFormat:@"gacha02SuperRare-%d", i]];
        }

        for (int i=0; i<12; i++) {
            gacha03Normal[i] = [aDecoder decodeIntegerForKey:[NSString stringWithFormat:@"gacha03Normal-%d", i]];
        }
        for (int i=0; i<10; i++) {
            gacha03Rare[i] = [aDecoder decodeIntegerForKey:[NSString stringWithFormat:@"gacha03Rare-%d", i]];
        }
        for (int i=0; i<14; i++) {
            gacha03SuperRare[i] = [aDecoder decodeIntegerForKey:[NSString stringWithFormat:@"gacha03SuperRare-%d", i]];
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
    }
    return self;
}
/************************************************
 エンコード
 ************************************************/
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeInteger:launchCount forKey:@"launchCount"];
    [aCoder encodeInteger:score forKey:@"score"];
    
    [aCoder encodeInteger:points forKey:@"points"];
    
    [aCoder encodeInteger:hp forKey:@"hp"];
    [aCoder encodeInteger:special forKey:@"special"];
    [aCoder encodeInteger:reload forKey:@"reload"];
    [aCoder encodeInteger:fuel forKey:@"fuel"];
    [aCoder encodeInteger:attack forKey:@"attack"];
    [aCoder encodeInteger:bind forKey:@"bind"];
    [aCoder encodeInteger:speed forKey:@"speed"];
    
    [aCoder encodeInteger:customizeControllerMode forKey:@"customizeControllerMode"];
    [aCoder encodeInteger:customizeBackgroundColorRandom forKey:@"customizeBackgroundColorRandom"];
    [aCoder encodeInteger:customizeButtonSound forKey:@"customizeButtonSound"];
    [aCoder encodeInteger:customizeBlock forKey:@"customizeBlock"];
    
    [aCoder encodeInteger:gachaPoints forKey:@"gachaPoints"];
    
    [aCoder encodeInteger:payCountPoint forKey:@"payCountPoint"];
    [aCoder encodeInteger:payCountGacha forKey:@"payCountGacha"];
    
    for (int i=0; i<4; i++) {
        for (int j=0; j<180; j++) {
            [aCoder encodeInteger:stageClearStatus[i][j] forKey:[NSString stringWithFormat:@"scs%d-%d", i, j]];
        }
    }
    
    
    
    for (int i=0; i<20; i++) {
        [aCoder encodeInteger:gacha01Normal[i] forKey:[NSString stringWithFormat:@"gacha01Normal-%d", i]];
    }
    for (int i=0; i<6; i++) {
        [aCoder encodeInteger:gacha01Rare[i] forKey:[NSString stringWithFormat:@"gacha01Rare-%d", i]];
    }
    for (int i=0; i<2; i++) {
        [aCoder encodeInteger:gacha01SuperRare[i] forKey:[NSString stringWithFormat:@"gacha01SuperRare-%d", i]];
    }
    
    for (int i=0; i<30; i++) {
        [aCoder encodeInteger:gacha02Normal[i] forKey:[NSString stringWithFormat:@"gacha02Normal-%d", i]];
    }
    for (int i=0; i<20; i++) {
        [aCoder encodeInteger:gacha02Rare[i] forKey:[NSString stringWithFormat:@"gacha02Rare-%d", i]];
    }
    for (int i=0; i<10; i++) {
        [aCoder encodeInteger:gacha02SuperRare[i] forKey:[NSString stringWithFormat:@"gacha02SuperRare-%d", i]];
    }
    
    for (int i=0; i<12; i++) {
        [aCoder encodeInteger:gacha03Normal[i] forKey:[NSString stringWithFormat:@"gacha03Normal-%d", i]];
    }
    for (int i=0; i<10; i++) {
        [aCoder encodeInteger:gacha03Rare[i] forKey:[NSString stringWithFormat:@"gacha03Rare-%d", i]];
    }
    for (int i=0; i<14; i++) {
        [aCoder encodeInteger:gacha03SuperRare[i] forKey:[NSString stringWithFormat:@"gacha03SuperRare-%d", i]];
    }
    
    
    
}

/************************************************
 ステージクリアステータスをセット
 ************************************************/
- (void)setStageClearStatusWithLevel:(int)level stage:(int)stage value:(int)value {
    stageClearStatus[level][stage] = value;
}

/************************************************
 ステージクリアステータスを取得
 ************************************************/
- (int)getStageClearStatusWithLevel:(int)level stage:(int)stage {
//    PrintLog(@"%d %d %d", level, stage, stageClearStatus[level][stage]);
    return stageClearStatus[level][stage];
}




/************************************************
 ガチャ０１ノーマルをセット
 ************************************************/
- (void)setGacha01Normal:(int)index value:(int)value {
    gacha01Normal[index] = value;
}

/************************************************
 ガチャ０１ノーマルを取得
 ************************************************/
- (int)getGacha01Normal:(int)index {
    return gacha01Normal[index];
}

/************************************************
 ガチャ０１レアをセット
 ************************************************/
- (void)setGacha01Rare:(int)index value:(int)value {
    gacha01Rare[index] = value;
}

/************************************************
 ガチャ０１レアを取得
 ************************************************/
- (int)getGacha01Rare:(int)index {
    return gacha01Rare[index];
}
/************************************************
 ガチャ０１Sレアをセット
 ************************************************/
- (void)setGacha01SuperRare:(int)index value:(int)value {
    gacha01SuperRare[index] = value;
}

/************************************************
 ガチャ０１Sレアを取得
 ************************************************/
- (int)getGacha01SuperRare:(int)index {
    return gacha01SuperRare[index];
}






/************************************************
 ガチャ０２ノーマルをセット
 ************************************************/
- (void)setGacha02Normal:(int)index value:(int)value {
    gacha02Normal[index] = value;
}

/************************************************
 ガチャ０２ノーマルを取得
 ************************************************/
- (int)getGacha02Normal:(int)index {
    return gacha02Normal[index];
}

/************************************************
 ガチャ０２レアをセット
 ************************************************/
- (void)setGacha02Rare:(int)index value:(int)value {
    gacha02Rare[index] = value;
}

/************************************************
 ガチャ０２レアを取得
 ************************************************/
- (int)getGacha02Rare:(int)index {
    return gacha02Rare[index];
}
/************************************************
 ガチャ０２Sレアをセット
 ************************************************/
- (void)setGacha02SuperRare:(int)index value:(int)value {
    gacha02SuperRare[index] = value;
}

/************************************************
 ガチャ０２Sレアを取得
 ************************************************/
- (int)getGacha02SuperRare:(int)index {
    return gacha02SuperRare[index];
}






/************************************************
 ガチャ０３ノーマルをセット
 ************************************************/
- (void)setGacha03Normal:(int)index value:(int)value {
    gacha03Normal[index] = value;
}

/************************************************
 ガチャ０３ノーマルを取得
 ************************************************/
- (int)getGacha03Normal:(int)index {
    return gacha03Normal[index];
}

/************************************************
 ガチャ０３レアをセット
 ************************************************/
- (void)setGacha03Rare:(int)index value:(int)value {
    gacha03Rare[index] = value;
}

/************************************************
 ガチャ０３レアを取得
 ************************************************/
- (int)getGacha03Rare:(int)index {
    return gacha03Rare[index];
}
/************************************************
 ガチャ０３Sレアをセット
 ************************************************/
- (void)setGacha03SuperRare:(int)index value:(int)value {
    gacha03SuperRare[index] = value;
}

/************************************************
 ガチャ０３Sレアを取得
 ************************************************/
- (int)getGacha03SuperRare:(int)index {
    return gacha03SuperRare[index];
}




@end
