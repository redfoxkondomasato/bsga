//
//  PlayerKoma.h
//  BSGA
//
//  Created by 近藤 雅人 on 12/05/06.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Koma.h"
@interface PlayerKoma : Koma {
}
@property (nonatomic) int maxHP;
@property (nonatomic) int fuel;
@property (nonatomic) float gunGaugeMax;
@property (nonatomic) float gunGauge;
@property (nonatomic) float superGunGauge;// 溜め打ちゲージ
@property (nonatomic) int fever;// フィーバー（溜め打ち状態）
@property (nonatomic) int attackPower;

@end
