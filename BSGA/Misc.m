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

+ (NSString *)getClassWithScore:(int)score {
    NSString *aClass = @"";
    
    if (score < 1000) {
        aClass = @"0. 迷子";
    } else if (score < 2000) {
        aClass = @"1. 初心者";
    } else if (score < 3000) {
        aClass = @"2. はなくそ";
    } else if (score < 4000) {
        aClass = @"3. はなたれ";
    } else if (score < 5000) {
        aClass = @"4. へたくそ";
    } else if (score < 6000) {
        aClass = @"5. ひよっこ";
    } else if (score < 7000) {
        aClass = @"6. 見習い";
    } else if (score < 8000) {
        aClass = @"7. 囲い知ってる";
    } else if (score < 9000) {
        aClass = @"8. 熱心な棋士";
    } else if (score < 10000) {
        aClass = @"9. 特攻隊";
    } else if (score < 11000) {
        aClass = @"10. ガキ大将";
    } else if (score < 12000) {
        aClass = @"11. 隊長";
    } else if (score < 13000) {
        aClass = @"12. 有段者";
    } else if (score < 14000) {
        aClass = @"13. 高段者";
    } else if (score < 15000) {
        aClass = @"14. 餃子の王将";
    } else if (score < 16000) {
        aClass = @"15. (^o^)";
    } else if (score < 17000) {
        aClass = @"16. 武士";
    } else if (score < 18000) {
        aClass = @"17. 大名";
    } else if (score < 19000) {
        aClass = @"18. 成金";
    } else if (score < 20000) {
        aClass = @"19. 銀将";
    } else if (score < 21000) {
        aClass = @"20. 金将";
    } else if (score < 22000) {
        aClass = @"21. 角行";
    } else if (score < 23000) {
        aClass = @"22. 飛車";
    } else if (score < 26000) {
        aClass = @"23. 将軍";
    } else if (score < 30000) {
        aClass = @"24. 達人";
    } else if (score < 34000) {
        aClass = @"25. 師範";
    } else if (score < 37000) {
        aClass = @"26. 名人";
    } else if (score < 43000) {
        aClass = @"27. 魔人";
    } else if (score < 50000) {
        aClass = @"28. 覇王";
    } else if (score < 54000) {
        aClass = @"29. 竜王";
    } else {
        aClass = @"30. ばくはつ王";
    }
    return aClass;
}


@end
