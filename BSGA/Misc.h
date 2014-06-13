//
//  Misc.h
//  BSGA
//
//  Created by 近藤 雅人 on 12/04/30.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StageManager.h"



@interface Misc : NSObject {
    
}

+ (NSString *)intToString:(int)number;
+ (NSString *)getLevelString:(int)level;

+ (NSString *)getRankWithStage:(int)stage value:(int)value;


@end

@protocol PaymentDoneDelegate

- (void)paymentDone;

@end
