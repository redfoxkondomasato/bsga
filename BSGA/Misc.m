//
//  Misc.m
//  BSGA
//
//  Created by 近藤 雅人 on 12/04/30.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import "Misc.h"

@implementation Misc

+ (NSString *)intToString:(int)number {
    return [NSString stringWithFormat:@"%d", number];
}

+ (NSString *)getLevelString:(int)level {
    NSString *levelText = nil;
    if (level == E_STAGE_LEVEL_SHOKYU) {
        levelText = @"初級";
    } else if (level == E_STAGE_LEVEL_CHUKYU) {
        levelText = @"中級";
    } else if (level == E_STAGE_LEVEL_JOKYU) {
        levelText = @"上級";
    } else if (level == E_STAGE_LEVEL_CHOKYU) {
        levelText = @"超級";            
    }
    return levelText;
}

+ (NSString *)getRankWithStage:(int)stage value:(int)value {
    NSString *rank = @"";
    
    if (value < 0) {
        return rank;
    }
    
    if (stage < 30) {
        if (value == 0) {
            rank = @"S";            
        } else if (value == 1) {
            rank = @"A";
        } else if (value == 2) {
            rank = @"B";
        } else if (value == 3) {
            rank = @"C";
        } else if (value == 4) {
            rank = @"D";
        } else if (value == 5) {
            rank = @"E";
        } else if (value == 6) {
            rank = @"F";
        } else if (value >= 7) {
            rank = @"G";
        } 
    } else if (stage < 60) {
        if (value <= 1) {
            rank = @"S";            
        } else if (value <= 2) {
            rank = @"A";
        } else if (value <= 3) {
            rank = @"B";
        } else if (value <= 4) {
            rank = @"C";
        } else if (value <= 6) {
            rank = @"D";
        } else if (value <= 8) {
            rank = @"E";
        } else if (value <= 10) {
            rank = @"F";
        } else if (value >= 12) {
            rank = @"G";
        } 
    } else if (stage < 90) {
        if (value <= 2) {
            rank = @"S";            
        } else if (value <= 3) {
            rank = @"A";
        } else if (value <= 4) {
            rank = @"B";
        } else if (value <= 5) {
            rank = @"C";
        } else if (value <= 7) {
            rank = @"D";
        } else if (value <= 10) {
            rank = @"E";
        } else if (value <= 12) {
            rank = @"F";
        } else if (value >= 14) {
            rank = @"G";
        }
    } else if (stage < 120) {
        if (value <= 3) {
            rank = @"S";            
        } else if (value <= 4) {
            rank = @"A";
        } else if (value <= 5) {
            rank = @"B";
        } else if (value <= 6) {
            rank = @"C";
        } else if (value <= 8) {
            rank = @"D";
        } else if (value <= 11) {
            rank = @"E";
        } else if (value <= 13) {
            rank = @"F";
        } else if (value >= 15) {
            rank = @"G";
        } 
    } else {
        if (value <= 4) {
            rank = @"S";            
        } else if (value <= 5) {
            rank = @"A";
        } else if (value <= 6) {
            rank = @"B";
        } else if (value <= 7) {
            rank = @"C";
        } else if (value <= 9) {
            rank = @"D";
        } else if (value <= 12) {
            rank = @"E";
        } else if (value <= 14) {
            rank = @"F";
        } else if (value >= 16) {
            rank = @"G";
        }
    }
    

    return rank;
    

}


@end
