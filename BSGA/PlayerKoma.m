//
//  PlayerKoma.m
//  BSGA
//
//  Created by 近藤 雅人 on 12/05/06.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import "PlayerKoma.h"

@implementation PlayerKoma
@synthesize maxHP;
@synthesize fuel;
@synthesize gunGaugeMax;
@synthesize gunGauge;
@synthesize superGunGauge;
@synthesize attackPower;
@synthesize fever;
/************************************************
 初期化
 ************************************************/
- (id)init {
    self = [super init];
    if (self) {
      
    }
    return self;
}
@end
