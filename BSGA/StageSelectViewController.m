//
//  StageSelectViewController.m
//  BSGA
//
//  Created by 近藤 雅人 on 12/05/21.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import "StageSelectViewController.h"


@implementation StageSelectViewController
@synthesize gameDataEntity;
/************************************************
 破棄
 ************************************************/

/************************************************
 初期化
 ************************************************/
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        selectedLevel = -1;
        selectedStage = -1;
    }
    return self;
}

/************************************************
 ビュー読み込み後
 ************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    
  //  PrintLog(@"level:%d stage:%d", selectedLevel, selectedStage);
    [displayLevelLabel setText:@""];
    [displayRankLabel setText:@""];
    [displayMessageLabel setText:@""];
    
    BSGAAppDelegate *appDelegate = (BSGAAppDelegate *)[[UIApplication sharedApplication] delegate];
    soundManager = appDelegate.soundManager;

    [scrollView setContentSize:CGSizeMake(contentView.frame.size.width, contentView.frame.size.height)];
    
    [backButton addTarget:self
                   action:@selector(backButtonPushed)
         forControlEvents:UIControlEventTouchUpInside];
    
    
    [self setGameDataEntity:[GameDataManager getGameDataEntity]];
    [self performSelector:@selector(setup) withObject:nil afterDelay:0.2f];
    
    int rankS = 0;
    int rankA = 0;
    int rankB = 0;
    int rankC = 0;
    int rankD = 0;
    int rankE = 0;
    int rankF = 0;
    int rankG = 0;
    for (int level = 0; level < 4; level++) {
        for (int stage = 0; stage<180; stage++) {
            int clearStatus = [gameDataEntity getStageClearStatusWithLevel:level stage:stage];
            NSString *rank = [Misc getRankWithStage:stage value:clearStatus];
            if ([rank isEqualToString:@"S"]) {
                rankS++;
            } else if ([rank isEqualToString:@"A"]) {
                rankA++;
            } else if ([rank isEqualToString:@"B"]) {
                rankB++;
            } else if ([rank isEqualToString:@"C"]) {
                rankC++;
            } else if ([rank isEqualToString:@"D"]) {
                rankD++;
            } else if ([rank isEqualToString:@"E"]) {
                rankE++;
            } else if ([rank isEqualToString:@"F"]) {
                rankF++;
            } else if ([rank isEqualToString:@"G"]) {
                rankG++;
            }
        }
    }
    
    [rankSLabel setText:[NSString stringWithFormat:@"S  %3d", rankS]];
    [rankALabel setText:[NSString stringWithFormat:@"A  %3d", rankA]];
    [rankBLabel setText:[NSString stringWithFormat:@"B  %3d", rankB]];
    [rankCLabel setText:[NSString stringWithFormat:@"C  %3d", rankC]];
    [rankDLabel setText:[NSString stringWithFormat:@"D  %3d", rankD]];
    [rankELabel setText:[NSString stringWithFormat:@"E  %3d", rankE]];
    [rankFLabel setText:[NSString stringWithFormat:@"F  %3d", rankF]];
    [rankGLabel setText:[NSString stringWithFormat:@"G  %3d", rankG]];
    
    [gameDataEntity setScore:100*rankS + 81*rankA + 64*rankB + 49*rankC + 36*rankD + 25*rankE + 16*rankF + 9*rankG];
    [GameDataManager saveGameDataEntity:gameDataEntity];
    
    [scrollLeftButton addTarget:self action:@selector(scrollLeftButtonPushed) forControlEvents:UIControlEventTouchUpInside];
    [scrollRightButton addTarget:self action:@selector(scrollRightButtonPushed) forControlEvents:UIControlEventTouchUpInside];
    

}
/************************************************
 ビュー表示後
 ************************************************/
- (void)viewDidAppear:(BOOL)animated {
}

/************************************************
 ビュー表示前
 ************************************************/
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CATransform3D transformFromFlip = CATransform3DMakeRotation(M_PI/2.0f, -1.0f, 1.0f, 0.0f);
    transformFromFlip = CATransform3DScale(transformFromFlip, kFlipAnimationScale, kFlipAnimationScale, 1.0f);
    
    CATransform3D transformToFlip = CATransform3DMakeRotation(0.0f, 0.0f, 1.0f, 0.0f);
    transformToFlip.m34 = kM34;
    
    CALayer *layer = self.view.layer;
    
    // アニメーション後の形をセット
    [layer setTransform:transformToFlip];
    
    CABasicAnimation* animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    [animation setDelegate:self];
    [animation setDuration:kLongAnimationDuration];
    [animation setRepeatCount:0];
    [animation setRemovedOnCompletion:NO];
    [animation setFromValue:[NSValue valueWithCATransform3D:transformFromFlip]];
    [animation setToValue:[NSValue valueWithCATransform3D:transformToFlip]];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];    
    [layer addAnimation:animation forKey:@"transformAnimationAppear"];
}

/************************************************
 ボタンのセットアップ
 ************************************************/
- (void)setupButtonWithButton:(UIButton *)button index:(int)i maxStage:(int)maxStage level:(int)level {
    [button setFrame:CGRectMake(36+70*(maxStage - i - 1), 18, 44, 44)];
    [button setBackgroundImage:[UIImage imageNamed:@"round_button"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"round_button_pushed"] forState:UIControlStateHighlighted];
     
    [button setExclusiveTouch:YES];
   
    int rankValue = [gameDataEntity getStageClearStatusWithLevel:level stage:i];
    NSString *rank = [Misc getRankWithStage:i value:rankValue];
    UIColor *titleColor = [UIColor whiteColor];
    if ([rank isEqualToString:@"S"]) {
        titleColor = [rankSLabel textColor];
    } else if ([rank isEqualToString:@"A"]) {
        titleColor = [rankALabel textColor];        
    } else if ([rank isEqualToString:@"B"]) {
        titleColor = [rankBLabel textColor];        
    } else if ([rank isEqualToString:@"C"]) {
        titleColor = [rankCLabel textColor];        
    } else if ([rank isEqualToString:@"D"]) {
        titleColor = [rankDLabel textColor];        
    } else if ([rank isEqualToString:@"E"]) {
        titleColor = [rankELabel textColor];        
    } else if ([rank isEqualToString:@"F"]) {
        titleColor = [rankFLabel textColor];        
    } else if ([rank isEqualToString:@"G"]) {
        titleColor = [rankGLabel textColor];        
    }
    
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setTitle:[NSString stringWithFormat:@"%d", i+1] forState:UIControlStateNormal];        
    [button setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    [[button titleLabel] setShadowOffset:CGSizeMake(0.0f, -1.0f)];
    
//    [button setReversesTitleShadowWhenHighlighted:YES];
    
    [button setTag:i];
    [button setAlpha:0.0f];
}

/************************************************
 ステージインフォ
 ************************************************/
- (void)setupStageInfoWithIndex:(int)i maxStage:(int)maxStage level:(int)level scrollView:(UIScrollView *)aScrollView {
    int stage = i+1;
    UILabel *hardLabel = [[UILabel alloc] init];
    [hardLabel setFrame:CGRectMake(36+70*(maxStage - i - 1), 0, 44, 22)];
    [hardLabel setFont:[UIFont systemFontOfSize:10]];
    [hardLabel setTextColor:[UIColor redColor]];
    [hardLabel setTextAlignment:NSTextAlignmentCenter];
    [hardLabel setBackgroundColor:[UIColor clearColor]];
    [hardLabel setText:@"難関"];
    if (level == E_STAGE_LEVEL_SHOKYU) {
        if (stage == 25 || stage == 26 || stage == 39 || stage == 40 || stage == 48 || stage == 58 || 
            stage == 62 || stage == 91 || stage == 92 || stage == 94 || stage == 96 || stage == 100 ||
            stage == 107 || stage == 128 || stage == 129 || stage == 176) {
            [aScrollView addSubview:hardLabel];
        } 
        
    } else if (level == E_STAGE_LEVEL_CHUKYU) {
        if (stage == 26 || stage == 29 || stage == 35 || stage == 39 || stage == 58 || stage == 62 ||
            stage == 75 || stage == 96 || stage == 102 || stage == 160) {
            [aScrollView addSubview:hardLabel];
        }
    } else if (level == E_STAGE_LEVEL_JOKYU) {
        if (stage == 26 || stage == 29 || stage == 35 || stage == 38 || stage == 39 || stage == 61 ||
            stage == 62 || stage == 129 || stage == 149 || stage == 150 || stage == 157 || stage == 158 ||
            stage == 160 || stage == 163 || stage == 167 || stage == 171) {
            [aScrollView addSubview:hardLabel];
        }
        
    } else if (level == E_STAGE_LEVEL_CHOKYU) {
        if (stage == 7) {
            [aScrollView addSubview:hardLabel];
        }   
    }
    
    
}

/************************************************
 スクロールビューのセットアップ
 ************************************************/
- (void)setupScrollViewWithScrollView:(UIScrollView *)aScrollView maxStage:(int)maxStage {
        
    int i=0;
    
    SEL selector = nil;
    
    int level = [aScrollView tag];
    NSString *levelText = [Misc getLevelString:level];
    if (level == E_STAGE_LEVEL_SHOKYU) {
        selector = @selector(shokyuButtonPushed:);
    } else if (level == E_STAGE_LEVEL_CHUKYU) {
        selector = @selector(chukyuButtonPushed:);
    } else if (level == E_STAGE_LEVEL_JOKYU) {
        selector = @selector(jokyuButtonPushed:);
    } else if (level == E_STAGE_LEVEL_CHOKYU) {
        selector = @selector(chokyuButtonPushed:);
    }
    
    // 難易度の表示
    if (maxStage > 0) {
        UILabel *levelLabel = [[UILabel alloc] init];
        [levelLabel setFrame:CGRectMake(2, 18, 30, 44)];
        [levelLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [levelLabel setTextColor:[UIColor scrollViewTexturedBackgroundColor]];
        [levelLabel setShadowColor:[UIColor blackColor]];
        [levelLabel setShadowOffset:CGSizeMake(0, -1)];
        [levelLabel setBackgroundColor:[UIColor clearColor]];
        [levelLabel setText:levelText];
        [aScrollView addSubview:levelLabel];
    }
    
    for (i=0; i<maxStage; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self setupButtonWithButton:button index:i maxStage:maxStage level:[aScrollView tag]];
        [self setupStageInfoWithIndex:i maxStage:maxStage level:level scrollView:aScrollView];
        
        [button addTarget:self
                   action:selector
         forControlEvents:UIControlEventTouchUpInside];
        [aScrollView addSubview:button];
    }
    [aScrollView setContentSize:CGSizeMake(26+i*70, aScrollView.frame.size.height)];
    
    [UIView animateWithDuration:0.5f
                     animations:^{
                         for (UIView *view in [aScrollView subviews]) {
                             [view setAlpha:1.0f];
                        }
                     }
     ];

}

/************************************************
 ビューのセットアップ
 ************************************************/
- (void)setup {
    PrintLog();
    
    [shokyuScrollView setTag:E_STAGE_LEVEL_SHOKYU];
    [chukyuScrollView setTag:E_STAGE_LEVEL_CHUKYU];
    [jokyuScrollView setTag:E_STAGE_LEVEL_JOKYU];
    [chokyuScrollView setTag:E_STAGE_LEVEL_CHOKYU];
    
    int maxStage[4];
    for (int i=0; i<4; i++) {
        maxStage[i] = 0;
    }
    for (int level=0; level<4; level++) {
        for (int stage=0; stage<180; stage++) {
            int status = [gameDataEntity getStageClearStatusWithLevel:level stage:stage];
            if (status > -2) {// -2:選択不可 -1:未クリア 0...:クリア
                maxStage[level] = stage+1;                
            }
        }
    }
    
    
    [self setupScrollViewWithScrollView:shokyuScrollView maxStage:maxStage[0]];
    [self setupScrollViewWithScrollView:chukyuScrollView maxStage:maxStage[1]];
    [self setupScrollViewWithScrollView:jokyuScrollView maxStage:maxStage[2]];
    [self setupScrollViewWithScrollView:chokyuScrollView maxStage:maxStage[3]];
    
    
    /*
    [self setupScrollViewWithScrollView:shokyuScrollView maxStage:180];//maxStage[0]];
    [self setupScrollViewWithScrollView:chukyuScrollView maxStage:180];//maxStage[1]];
    [self setupScrollViewWithScrollView:jokyuScrollView maxStage:180];//maxStage[2]];
    [self setupScrollViewWithScrollView:chokyuScrollView maxStage:10];//maxStage[3]];
    */
}


/************************************************
 戻るボタン
 ************************************************/
- (void)backButtonPushed {
    
    CALayer *layer = self.view.layer;
    
    CATransform3D transformFlip = CATransform3DMakeRotation(M_PI/2.0f, 1.0f, -1.0f, 0.0f);
    transformFlip = CATransform3DScale(transformFlip, kFlipAnimationScale, kFlipAnimationScale, 1.0f);
    
    // アニメーション後の形をセット
    layer.transform = transformFlip;
    
    CATransform3D transform;
    transform = CATransform3DIdentity;
    transform.m34 = kM34;// 奥行き
    
    CABasicAnimation* animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    [animation setDelegate:self];
    [animation setDuration:kLongAnimationDuration];
    [animation setRepeatCount:0];
    [animation setRemovedOnCompletion:NO];
    [animation setFromValue:[NSValue valueWithCATransform3D:transform]];
    [animation setToValue:[NSValue valueWithCATransform3D:transformFlip]];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];    
    [layer addAnimation:animation forKey:@"transformAnimationBack"];

}

/************************************************
 ゲーム開始
 ************************************************/
- (void)startGame:(NSArray *)array {
    
    int stage = [[array objectAtIndex:0] intValue];
    int level = [[array objectAtIndex:1] intValue];
    
    // 2回目のタップ
    if (stage == selectedStage && level == selectedLevel) {
        
        if (selectedLevel == E_STAGE_LEVEL_CHOKYU) {
            stage += 180;
        }
        
        stageEntity = nil;
        stageEntity = [StageManager getStageEntityAtIndex:stage];
        
        nextPage = [[GameViewController alloc] initWithNibName:@"GameViewController" bundle:nil];
        [(GameViewController *)nextPage setStageEntity:stageEntity];
        [(GameViewController *)nextPage setLevel:level];
        [(GameViewController *)nextPage setStageNumber:stage];
        
        CALayer *layer = self.view.layer;
        
        CATransform3D transformFlip = CATransform3DMakeRotation(M_PI/2.0f, 1.0f, -1.0f, 0.0f);
        transformFlip = CATransform3DScale(transformFlip, kFlipAnimationScale, kFlipAnimationScale, 1.0f);
        
        // アニメーション後の形をセット
        [layer setTransform:transformFlip];
        
        CATransform3D transform;    
        transform = CATransform3DIdentity;
        transform.m34 = kM34;// 奥行き
        
        CABasicAnimation* animation;
        animation = [CABasicAnimation animationWithKeyPath:@"transform"];
        [animation setDelegate:self];
        [animation setDuration:kLongAnimationDuration];
        [animation setRepeatCount:0];
        [animation setRemovedOnCompletion:NO];
        [animation setFromValue:[NSValue valueWithCATransform3D:transform]];
        [animation setToValue:[NSValue valueWithCATransform3D:transformFlip]];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];    
        [layer addAnimation:animation forKey:@"transformAnimationNext"];
    }
    // １回目のタップ
    else {
        selectedLevel = level;
        selectedStage = stage;
        
        // レベルを表示
        NSString *levelText = [Misc getLevelString:level];
        [displayLevelLabel setText:[NSString stringWithFormat:@"%@ %d", levelText, stage+1]];
        [AnimationManager popAnimationWithView:displayLevelLabel
                                      duration:0.4f
                                         delay:0.05f
                                         alpha:0.6f];
        // ランクを表示
        int rankValue = [gameDataEntity getStageClearStatusWithLevel:selectedLevel stage:selectedStage];
        NSString *rank = [Misc getRankWithStage:selectedStage value:rankValue];        
        if ([rank isEqualToString:@"S"]) {
            [displayRankLabel setTextColor:[rankSLabel textColor]];
        } else if ([rank isEqualToString:@"A"]) {
            [displayRankLabel setTextColor:[rankALabel textColor]];
        } else if ([rank isEqualToString:@"B"]) {
            [displayRankLabel setTextColor:[rankBLabel textColor]];
        } else if ([rank isEqualToString:@"C"]) {
            [displayRankLabel setTextColor:[rankCLabel textColor]];
        } else if ([rank isEqualToString:@"D"]) {
            [displayRankLabel setTextColor:[rankDLabel textColor]];
        } else if ([rank isEqualToString:@"E"]) {
            [displayRankLabel setTextColor:[rankELabel textColor]];
        } else if ([rank isEqualToString:@"F"]) {
            [displayRankLabel setTextColor:[rankFLabel textColor]];
        } else if ([rank isEqualToString:@"G"]) {
            [displayRankLabel setTextColor:[rankGLabel textColor]];
        }
        
        if (rankValue >= 0) {
            [displayRankLabel setText:[NSString stringWithFormat:@"%@ (%d)", rank, rankValue]];            
        } else {
            [displayRankLabel setText:@""];            
            
        }
        
        [AnimationManager popAnimationWithView:displayRankLabel
                                      duration:0.6f
                                         delay:0.0f alpha:0.5f];
        
        // メッセージを表示 TODO
        int s = stage+1;
        NSString *mes = @"";
        if (level == E_STAGE_LEVEL_SHOKYU) {
            if (s == 1) { mes = @"ばくはつSGアクションの世界へ\nようこそ！\nさあ、大冒険のはじまりだ";}
            else if (s == 2) { mes = @"ゲージが溜まると攻撃できます\n連打してもダメ！";}
            else if (s == 3) { mes = @"壊せそうなブロックは壊せます\n壊せなさそうなブロックは壊せなさそうです";}
            else if (s == 4) { mes = @"新規ステージクリアでポイントが貰えます\nポイントは「能力」画面で振り分けます";}
            else if (s == 5) { mes = @"赤い敵は好戦的\n緑の敵は逃げ腰";}
            else if (s == 6) { mes = @"駒を奪っても燃料が無いと使えません\n香車は１発打つのに燃料を「４」消費します";}
            else if (s == 7) { mes = @"強い敵を倒すとより多く燃料が貰えます";}
            else if (s == 8) { mes = @"奪った駒は、攻撃ボタンのちょい上をタップすると切り替えられます";}
            else if (s == 9) { mes = @"銀登場！興奮しますね";}
            else if (s == 10) { mes = @"ストーリー紹介\n「敵がいるので倒してください」";}
            else if (s == 11) { mes = @"序盤は攻撃力が大事です\nたまに発想を変える必要もあります";}
            else if (s == 12) { mes = @"敵を毒状態にしても自然治癒します";}
            else if (s == 13) { mes = @"一度毒を受けた敵は免疫がつき、\n毒を受けにくくなります\n中級、上級になるにつれて免疫力が増します";}
            else if (s == 14) { mes = @"硬い銀";}
            else if (s == 15) { mes = @"便利な桂馬";}
            else if (s == 16) { mes = @"ちょっと難しいかもしれません\n敵の多い地帯に注意し、１つずつ掃除します\n銀を先に取るとやりやすいです";}
            else if (s == 17) { mes = @"全員好戦的！";}
            else if (s == 18) { mes = @"大駒";}
            else if (s == 19) { mes = @"攻撃力だけ上げてもダメ";}
            else if (s == 20) { mes = @"香車のみ";}
            else if (s == 21) { mes = @"せまい";}
            else if (s == 22) { mes = @"「特殊」を使うと\n攻略しやすいかも";}
            else if (s == 23) { mes = @"香車には香車を";}
            else if (s == 24) { mes = @"将棋は最高にCOOLだぜ";}
            else if (s == 25) { mes = @"初の難関ステージ！\n腕の見せ所です";}
            else if (s == 26) { mes = @"２連続で難関という鬼畜仕様";}
            else if (s == 27) { mes = @"難関直後の一休み";}
            else if (s == 28) { mes = @"逃げる敵って嫌だね";}
            else if (s == 29) { mes = @"地味に難しいステージ";}
            else if (s == 30) { mes = @"香車が気持ちいいステージ";}
            else if (s == 31) { mes = @"王には香車がいいですね";}
            else if (s == 32) { mes = @"香車のみ２";}
            else if (s == 33) { mes = @"序盤が勝負";}
            else if (s == 34) { mes = @"赤銀が厄介";}
            else if (s == 35) { mes = @"個々が強力。銀さえ取れれば";}
            else if (s == 39) { mes = @"桂馬のみ";}

            
            
            
            
            
            
            
        } else if (level == E_STAGE_LEVEL_CHUKYU) {
            if (s == 1) { mes = @"いよいよ中級！\nポイントも増え、戦略性が一気に増します";}
            else if (s == 2) { mes = @"SとかAとかのランクはただの飾りらしいです";}
            else if (s == 3) { mes = @"しばらくはポイント稼ぎですね";}
            
            
        } else if (level == E_STAGE_LEVEL_JOKYU) {
            if (s == 1) { mes = @"拱く\n篩";}
            else if (s == 2) { mes = @"こまぬく\nふるい";}
            else if (s == 3) { mes = @"右往左往";}
            else if (s == 4) { mes = @"うおうさおう\n大勢の人が右へ行ったり\n左へ行ったりする混乱状態";}
            else if (s == 5) { mes = @"人身御供\n外様"; }
            else if (s == 6) { mes = @"ひとみごくう\nとざま"; }
            else if (s == 7) { mes = @"悲憤慷慨";}
            else if (s == 8) { mes = @"ひふんこうがい\n世の中の不義不正や自分の\n運命を悲しみ憤る";}
            else if (s == 9) { mes = @"注連縄\n聾唖"; }
            else if (s == 10) { mes = @"しめなわ\nろうあ"; }
            else if (s == 11) { mes = @"夜目遠目"; }
            else if (s == 12) { mes = @"女性ははっきりと見えない\nほうが美しく見える"; }
            else if (s == 13) { mes = @"覚束ない\n厨"; }
            else if (s == 14) { mes = @"おぼつかない\nくりや"; }
            else if (s == 15) { mes = @"奇奇怪怪"; }
            else if (s == 16) { mes = @"ききかいかい\n非常に不思議で\n怪しい様子"; }
            else if (s == 17) { mes = @"強請る\n一廉"; }
            else if (s == 18) { mes = @"ゆする\nひとかど"; }
            else if (s == 19) { mes = @"美人薄命"; }
            else if (s == 20) { mes = @"びじんはくめい\n美人はとかく短命だったり\n不幸であったりする"; }
            else if (s == 21) { mes = @"貼付\n添付"; }
            else if (s == 22) { mes = @"貼付けること\n付け加えること"; }
            else if (s == 23) { mes = @"行雲流水"; }
            else if (s == 24) { mes = @"こううんりゅうすい\n物事に執着せず、自由な\n気持ちでいる様子"; }
            else if (s == 25) { mes = @"機械\n器械"; }
            else if (s == 26) { mes = @"動力を持つ\n動力を持たない"; }
            else if (s == 27) { mes = @"拈華微笑"; }
            else if (s == 28) { mes = @"ねんげみしょう\n以心伝心のこと\n無言で伝える"; }
            else if (s == 29) { mes = @"条例\n条令"; }
            else if (s == 30) { mes = @"地方公共団体による\n箇条書きの法令"; }
            else if (s == 31) { mes = @"薄志弱行"; }
            else if (s == 32) { mes = @"はくしじゃっこう\n意志が弱い\n消極的で意気地なし"; }
            else if (s == 33) { mes = @"修練\n習練"; }
            else if (s == 34) { mes = @"鍛えること\n練習すること"; }
            else if (s == 35) { mes = @"一日千秋"; }
            else if (s == 36) { mes = @"いちじつせんしゅう\n一日が千年のように長く\n感じるほど待ち遠しい"; }
            else if (s == 37) { mes = @"意志\n意思"; }
            else if (s == 38) { mes = @"積極的な心ぐみ\nしようとする考え"; }
            else if (s == 39) { mes = @"不言実行"; }
            else if (s == 40) { mes = @"ふげんじっこう\n文句を言わず\n黙って実行する"; }
            else if (s == 41) { mes = @"濁酒\n艾"; }
            else if (s == 42) { mes = @"どぶろく\nもぐさ"; }
            else if (s == 43) { mes = @"雲散霧消"; }
            else if (s == 44) { mes = @"うんさんむしょう\n跡形も無く\n消え失せる事"; }
            else if (s == 45) { mes = @"防人\n石榴"; }
            else if (s == 46) { mes = @"さきもり\nざくろ"; }
            else if (s == 47) { mes = @"閑話休題"; }
            else if (s == 48) { mes = @"かんわきゅうだい\n本題に戻る\n「それはさておき」"; }
            else if (s == 49) { mes = @"傀儡\n入水"; }
            else if (s == 50) { mes = @"かいらい\nじゅすい"; }
            else if (s == 51) { mes = @"盛者必衰"; }
            else if (s == 52) { mes = @"じょうしゃひっすい\n景気のいいやつも\nいずれ必ず衰える"; }
            else if (s == 53) { mes = @"殺陣師\n訥弁"; }
            else if (s == 54) { mes = @"たてし\nとつべん"; }
            else if (s == 55) { mes = @"二束三文"; }
            else if (s == 56) { mes = @"にそくさんもん\n数が多くて\n値段が安い"; }
            else if (s == 57) { mes = @"行火\n砧"; }
            else if (s == 58) { mes = @"あんか\nきぬた"; }
            else if (s == 59) { mes = @"言語道断"; }
            else if (s == 60) { mes = @"ごんごどうだん\n言葉で言い表せないこと\n「もってのほか」"; }
            else if (s == 61) { mes = @"眦、睚、眥\n魁、槐\n隼、英、鶻\n湖"; }
            else if (s == 62) { mes = @"まなじり\nさきがけ\nはやぶさ\nみずうみ"; }
            else if (s == 63) { mes = @"萼、英\n弟\n妹\n雷、霹、霆"; }
            else if (s == 64) { mes = @"はなぶさ\nおとうと\nいもうと\nいかずち"; }
            else if (s == 65) { mes = @"曙、暁、曉\n曙\n盃、杯、觴、盞、觚、巵、卮\n禍、災、厄、妖、殃"; }
            else if (s == 66) { mes = @"あかつき\nあけぼの\nさかずき\nわざわい"; }
            else if (s == 67) { mes = @"轟\n礎\n銀\n姑"; }
            else if (s == 68) { mes = @"とどろき\nいしずえ\nしろがね\nしゅうとめ"; }
            else if (s == 69) { mes = @"俎、爼\n灯、燈、燭\n兵\n猪、豬、猯"; }
            else if (s == 70) { mes = @"まないた\nともしび\nつわもの\nいのしし"; }
            else if (s == 71) { mes = @"狼\n鶯、鴬\n橙\n楠、樟"; }
            else if (s == 72) { mes = @"おおかみ\nうぐいす\nだいだい\nくすのき"; }
            else if (s == 73) { mes = @"鎹\n壽、寿\n屍、尸\n柵"; }
            else if (s == 74) { mes = @"かすがい\nことぶき\nしかばね\nしがらみ"; }
            else if (s == 75) { mes = @"磔\n紅\n幻\n侍、士"; }
            else if (s == 76) { mes = @"はりつけ\nくれない\nまぼろし\nさむらい"; }
            else if (s == 77) { mes = @"徒\n梟\n鴛、鴦\n黛"; }
            else if (s == 78) { mes = @"いたずら\nふくろう\nおしどり\nまゆずみ"; }
            else if (s == 79) { mes = @"邪、咼\n理\n鋸\n某"; }
            else if (s == 80) { mes = @"よこしま\nことわり\nのこぎり\nなにがし"; }
            else if (s == 81) { mes = @"髻\n賂、賄\n褌\n古"; }
            else if (s == 82) { mes = @"もとどり\nまいない\nふんどし\nいにしえ"; }
            else if (s == 83) { mes = @"陵\n諺\n陛、階\n公"; }
            else if (s == 84) { mes = @"みささぎ\nことわざ\nきざはし\nおおやけ"; }
            else if (s == 85) { mes = @"橘\n枳\n冠、冕\n源"; }
            else if (s == 86) { mes = @"たちばな\nからたち\nかんむり\nみなもと"; }
            else if (s == 87) { mes = @"梔\n鰰\n柊\n懐、懷"; }
            else if (s == 88) { mes = @"くちなし\nはたはた\nひいらぎ\nふところ"; }
            else if (s == 89) { mes = @"淪、漣\n筍、笋\n俤\n唇、吻、脣"; }
            else if (s == 90) { mes = @"さざなみ\nたけのこ\nおもかげ\nくちびる"; }
            else if (s == 91) { mes = @"鵯\n蜩\n餞、贐\n掌"; }
            else if (s == 92) { mes = @"ひよどり\nひぐらし\nはなむけ\nてのひら、たなごころ"; }
            else if (s == 93) { mes = @"酣、闌\n鯱\n笄\n凩"; }
            else if (s == 94) { mes = @"たけなわ\nしゃちほこ\nこうがい\nこがらし"; }
            else if (s == 95) { mes = @"凱、閧\n諍\n羹、羮\n塊、團、団"; }
            else if (s == 96) { mes = @"かちどき\nいさかい\nあつもの\nかたまり"; }
            else if (s == 97) { mes = @"魂、魄\n私\n皇\n趣、概"; }
            else if (s == 98) { mes = @"たましい\nわたくし\nすめらぎ\nおもむき"; }
            else if (s == 99) { mes = @"詔、勅、敕\n政\n鏖\n坤"; }
            else if (s == 100) { mes = @"みことのり\nまつりごと\nみなごろし\nひつじさる"; }
            else if (s == 101) { mes = @"縦、恣、縱、擅、肆、亶\n潴、瀦\n穽\n鰾"; }
            else if (s == 102) { mes = @"ほしいまま\nみずたまり\nおとしあな\nうきぶくろ"; }
            else if (s == 103) { mes = @"辱める\n悉く、尽く\n恭しく\n覆す"; }
            else if (s == 104) { mes = @"はずかしめる\nことごとく\nうやうやしく\nくつがえす"; }
            else if (s == 105) { mes = @"陥れる\n夥しい\n志す\n漱ぐ"; }
            else if (s == 106) { mes = @"おとしいれる\nおびただしい\nこころざす\nくちすすぐ"; }
            else if (s == 107) { mes = @"滞る\n快い\n蹲る\n予め"; }
            else if (s == 108) { mes = @"とどこおる\nこころよい\nうずくまる\nあらかじめ"; }
            else if (s == 109) { mes = @"憤る\n蟠り\n弄ぶ、玩ぶ\n潔い"; }
            else if (s == 110) { mes = @"いきどおる\nわだかまり\nもてあそぶ\nいさぎよい"; }
            else if (s == 111) { mes = @"苟も\n慮る\n忝い\n喧しい"; }
            else if (s == 112) { mes = @"いやしくも\nおもんばかる\nかたじけない\nかまびすしい"; }
            else if (s == 113) { mes = @"謙る、遜る\n翻す\n梳る\n唆す"; }
            else if (s == 114) { mes = @"へりくだる\nひるがえす\nくしけずる\nそそのかす"; }
            else if (s == 115) { mes = @"仕る\n奉る\n承る\n著しい"; }
            else if (s == 116) { mes = @"つかまつる\nたてまつる\nうけたまわる\nいちじるしい"; }
            else if (s == 117) { mes = @"跪く\n細雪\n俄雨\n涎"; }
            else if (s == 118) { mes = @"ひざまずく\nささめゆき\nにわかあめ\nよだれ"; }
            else if (s == 119) { mes = @"元肇基初創大磬治一源甫始\n弌壹巴東素魁長本甲先俶才\n哉捷順壱祝宗太春建統新聡\n共通点は？"; }
            else if (s == 120) { mes = @"すべて「はじめ」と読む"; }
            else if (s == 121) { mes = @"衡功整斎和晋鈞齊寿稠準聖\n儔斌平恒央精同倫旬格史一\n如文毎與的中人敏大洵寧釣\n共通点は？"; }
            else if (s == 122) { mes = @"すべて「ひとし」と読む"; }
            else if (s == 123) { mes = @"九庇斉宇寛契長尋大史閑昶\n栄恆暉悠脩諭亀常均廂遠敞\n彌仁壽永亘央匡久延恒尚弥\n共通点は？"; }
            else if (s == 124) { mes = @"すべて「ひさし」と読む"; }
            else if (s == 125) { mes = @"克洸徹洸健勍壮力耐猛捷堅\n勝功錬幹勉大了乾立斎競敢\n精佶兢雄侃洸彊剛強毅勁豪\n共通点は？"; }
            else if (s == 126) { mes = @"すべて「つよし」と読む"; }
            else if (s == 127) { mes = @"力訓努孜勲励強仂勧孟伝精\n孔茂彊勢孜劼工農均学任乾\n勉勤敏事統耕克任勇恪奨労\n共通点は？"; }
            else if (s == 128) { mes = @"すべて「つとむ」と読む"; }
            else if (s == 129) { mes = @"花麻里空大玉子糸無金南石\n李西姫隠蕪牛摩生参白山桜\n共通点は？"; }
            else if (s == 130) { mes = @"人の名前じゃないよっ\nすべて野菜・果物の漢字の一部。\n例：大蒜、山葵、姫林檎、空豆、無花果、隠元豆"; }
            else if (s == 131) { mes = @"厂　厄厚厘原\n勹　勺勾勿匁\n夂　冬\n匚　区匹匝匡匠"; }
            else if (s == 132) { mes = @"がんだれ\nつつみがまえ\nふゆがしら\nはこがまえ"; }
            else if (s == 133) { mes = @"冫　决冱冲冰况\n儿　兄兇光充先\n亠　亡亢亦亥交\n力　加功劣"; }
            else if (s == 134) { mes = @"にすい\nひとあし、にんにょう\nなべぶた\nちから"; }
            else if (s == 135) { mes = @"幺　幻幼幽幾\n彡　形彦彩彫\n戈　戉戊戍戎戌成我\n殳　殴段殷殺殻殼殿毅毆"; }
            else if (s == 136) { mes = @"いとがしら\nさんづくり\nかのほこ、ほこづくり\nるまた、ほこづくり"; }
            else if (s == 137) { mes = @"气　気氛氤氣\n缶　缸缺罅罌\n行　衍衒術街衙衝衛衞衡衢\n風　颪颯颱颶飃飄飆"; }
            else if (s == 138) { mes = @"きがまえ\nほとぎへん\nぎょうがまえ\nかぜ"; }
            else if (s == 139) { mes = @"louse\nmonk⇔nun\nmaster⇔mistress\nmarble→marbles"; }
            else if (s == 140) { mes = @"虱（しらみ）\n僧侶⇔尼僧\n主人⇔主婦\n大理石→おはじき"; }
            else if (s == 141) { mes = @"娶る　めとる\n野点　のだて\n碩学　せきがく\n頗る　すこぶる"; }
            else if (s == 142) { mes = @"妻として迎える\n野外で茶をたてること\n学問の広く深い人\nやや　軽く"; }
            else if (s == 143) { mes = @"誰何　すいか\n瓜実顔　うりざねがお\n帷幄　いあく\n寸毫　すんごう"; }
            else if (s == 144) { mes = @"呼びとがめること\n白く細長い瓜の種の様な顔\n作戦計画を立てる所\n極めて僅かなこと"; }
            else if (s == 145) { mes = @"閲する　けみする\n十姉妹　じゅうしまつ\n辺鄙　へんぴ\n由々しい　ゆゆしい"; }
            else if (s == 146) { mes = @"調べる。あらため見る\n鳥の名前\nかたいなか。不便な土地\n忌まわしい。不吉"; }
            else if (s == 147) { mes = @"優男　やさおとこ\n塹壕　ざんごう\n抗う　あらがう\n寝穢い　いぎたない"; }
            else if (s == 148) { mes = @"風流を解する男\n野戦の防御施設\n相手の言うことを否定する\n中々目を覚まさない。寝坊"; }
            else if (s == 149) { mes = @"阿吽　あうん\n隘路　あいろ\n万年青　おもと\n似非　えせ"; }
            else if (s == 150) { mes = @"最初と最後\n狭い道。障害\n植物の名前\n偽もの。劣っている。悪質"; }
            else if (s == 151) { mes = @"首魁　しゅかい\n蔑ろ　ないがしろ\n別嬪　べっぴん\n惑溺　わくでき"; }
            else if (s == 152) { mes = @"張本人。首謀者\n侮り軽んずる。しどけない\nとりわけ美しい女\n迷って本心を失うこと"; }
            else if (s == 153) { mes = @"絆される　ほだされる\n木賊　とくさ\n拙い　つたない\n虚仮威し　こけおどし"; }
            else if (s == 154) { mes = @"束縛される\n植物の名前\n劣っている。運が悪い\n見え透いたおどし"; }
            else if (s == 155) { mes = @"誤謬　ごびゅう\n下手物　げてもの\n好々爺　こうこうや\n徐に　おもむろに"; }
            else if (s == 156) { mes = @"間違い\n並みの品\n良い感じの老人\n静かに。落ち着いて"; }
            else if (s == 157) { mes = @"欺瞞　ぎまん\n夭折　ようせつ\n四方山　よもやま\n顰蹙　ひんしゅく"; }
            else if (s == 158) { mes = @"人目を欺き騙す事\n若くして死ぬこと\n世間。雑多\n顔をしかめること"; }
            else if (s == 159) { mes = @"頓に　とみに\n僭越　せんえつ\n同胞　はらから　どうほう\n誣告　ぶこく"; }
            else if (s == 160) { mes = @"急に。しきりに\nでしゃばり\n兄弟姉妹のこと。同国民\nわざと嘘を告げる"; }
            else if (s == 161) { mes = @"欣快　きんかい\n忽焉　こつえん\n等閑　なおざり\n掩蔽　えんぺい"; }
            else if (s == 162) { mes = @"喜ばしく気持ちがいい\nたちまち。忽然\nいい加減にする様\n覆い隠すこと"; }
            else if (s == 163) { mes = @"頑是無い　がんぜない\n烏有　うゆう\n恙無い　つつがない\n尨犬　むくいぬ"; }
            else if (s == 164) { mes = @"無邪気である\n何も無いこと\n無事である。異状がない\n毛の多い犬"; }
            else if (s == 165) { mes = @"微醺　びくん\n憤懣　ふんまん\n生業　なりわい\n舌鋒　ぜっぽう"; }
            else if (s == 166) { mes = @"少し酒に酔うこと\n憤り悶えること\n世渡りの仕事\n激しい弁論の調子"; }
            else if (s == 167) { mes = @"折半　せっぱん\n知悉　ちしつ\n頽廃　退廃　たいはい\n擾乱　じょうらん"; }
            else if (s == 168) { mes = @"半分に分けること\n知り尽くすこと\n衰え廃れること\n入り乱れる。乱れ騒ぐ"; }
            else if (s == 169) { mes = @"諭す　さとす\n苦衷　くちゅう\n扼殺　やくさつ\n身罷る　薨　みまかる"; }
            else if (s == 170) { mes = @"言い聞かせて納得させる\n苦しい心の中\n手で首を絞めて殺すこと\n死ぬ"; }
            else if (s == 171) { mes = @"渺茫　びょうぼう\n徒食　としょく\n詳らか　つまびらか\n掣肘　せいちゅう"; }
            else if (s == 172) { mes = @"広々として果てしない\n仕事しないで遊び暮らす\n詳しいさま\n干渉し自由に行動させない"; }
            else if (s == 173) { mes = @"忸怩　じくじ\n浚渫　しゅんせつ\n殊更　ことさら\n矍鑠　かくしゃく"; }
            else if (s == 174) { mes = @"恥じ入る様\n水底の土砂等をさらうこと\nわざわざ。わざと\n老いぼれても丈夫で元気"; }
            else if (s == 175) { mes = @"馘首　かくしゅ\n仄聞　そくぶん\n病臥　びょうが\n吻合　ふんごう"; }
            else if (s == 176) { mes = @"首を切り取る。解雇する\nちょっと聞くこと\n病気で床につく\nぴったりと合うこと"; }
            else if (s == 177) { mes = @"快刀乱麻　かいとうらんま\n頑迷固陋　がんめいころう\n豪放磊落　ごうほうらいらく\n生殺与奪　せいさつよだつ"; }
            else if (s == 178) { mes = @"複雑な物事をてきぱきと処理すること\n頑固で見聞きが狭く、新しい事態に対処できない\n男らしく、小さなことに拘らない\n生かすも殺すも自分の思うがままであること"; }
            else if (s == 179) { mes = @"ネタ切れ（スタミナ切れ）"; }
            else if (s == 180) { mes = @"今までの知識を振り絞りましょう（＾＾）"; }

        } else if (level == E_STAGE_LEVEL_CHOKYU) {
            
        } 
        [displayMessageLabel setText:mes];
        [AnimationManager popAnimationWithView:displayMessageLabel
                                      duration:0.7f
                                         delay:0.0f
                                         alpha:0.3f];
    }
    

}
/************************************************
 ゲーム開始
 ・セレクタを介す事でボタンが凹む描画がされる
 ************************************************/
- (void)startGameWithStage:(int)stage level:(int)level {
        
    [soundManager play:E_SOUND_BUTTON];
    NSArray *sendArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:stage],
                          [NSNumber numberWithInt:level], nil];
    [self performSelector:@selector(startGame:) withObject:sendArray afterDelay:0.0f];
}

/************************************************
 初級ボタン
 ************************************************/
- (void)shokyuButtonPushed:(UIButton *)button {
    [self startGameWithStage:[button tag] level:E_STAGE_LEVEL_SHOKYU];
}
/************************************************
 中級ボタン
 ************************************************/
- (void)chukyuButtonPushed:(UIButton *)button {
    [self startGameWithStage:[button tag] level:E_STAGE_LEVEL_CHUKYU];
}
/************************************************
 上級ボタン
 ************************************************/
- (void)jokyuButtonPushed:(UIButton *)button {
    [self startGameWithStage:[button tag] level:E_STAGE_LEVEL_JOKYU];
}
/************************************************
 超級ボタン
 ************************************************/
- (void)chokyuButtonPushed:(UIButton *)button {
    [self startGameWithStage:[button tag] level:E_STAGE_LEVEL_CHOKYU];
}

/************************************************
 左スクロールボタン
 ************************************************/
- (void)scrollLeftButtonPushed {
#if DEBUG_MODE
    [gameDataEntity setStageClearStatusWithLevel:selectedLevel stage:selectedStage value:1];
    [gameDataEntity setStageClearStatusWithLevel:selectedLevel stage:selectedStage+1 value:-1];
    [GameDataManager saveGameDataEntity:gameDataEntity];
    [self setup];
#endif
    [soundManager play:E_SOUND_LASER2];
    [shokyuScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [chukyuScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [jokyuScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [chokyuScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

/************************************************
 右スクロールボタン
 ************************************************/
- (void)scrollRightButtonPushed {
    [soundManager play:E_SOUND_LASER2];
    [shokyuScrollView setContentOffset:CGPointMake([shokyuScrollView contentSize].width-320, 0) animated:YES];
    [chukyuScrollView setContentOffset:CGPointMake([chukyuScrollView contentSize].width-320, 0) animated:YES];
    [jokyuScrollView setContentOffset:CGPointMake([jokyuScrollView contentSize].width-320, 0) animated:YES];
    [chokyuScrollView setContentOffset:CGPointMake([chokyuScrollView contentSize].width-320, 0) animated:YES];
    
}

//-----------------------------------------------
//
// CAAnimationDelegate
//
//-----------------------------------------------
/************************************************
 CAAnimation停止
 ************************************************/
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    CALayer *layer = self.view.layer;
    
    if (anim == [self.view.layer animationForKey:@"transformAnimationBack"]) {
        [self.navigationController popViewControllerAnimated:NO];        
        [layer removeAnimationForKey:@"transformAnimationBack"];
    } else if (anim == [layer animationForKey:@"transformAnimationAppear"]) {
        [layer removeAnimationForKey:@"transformAnimationAppear"];
    } else if (anim == [layer animationForKey:@"transformAnimationNext"]) {
        if (nextPage) {
            [self.navigationController pushViewController:nextPage animated:NO];
            nextPage = nil;
        }
        [layer removeAnimationForKey:@"transformAnimationNext"];
    }
}



@end
