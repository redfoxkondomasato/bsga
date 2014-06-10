//
//  TipsViewController.m
//  BSGA
//
//  Created by 近藤 雅人 on 12/05/18.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import "TipsViewController.h"

@interface TipsViewController ()

@end

@implementation TipsViewController
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
        
    }
    return self;
}
/************************************************
 ビュー読み込み後
 ************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setGameDataEntity:[GameDataManager getGameDataEntity]];
    
    [pointsLabel setText:[NSString stringWithFormat:@"%d", [gameDataEntity gachaPoints]]];
    
    srand(time(NULL));
    [titleLabel setText:@""];
    [messageLabel setText:@""];

    messageGachaArray = [NSArray arrayWithObjects:
                          @"日下部\nひかべ、くさかべ", 
                          @"田原\nたはら、たばる",
                          @"今日\nきょう、こんにち",
                          @"左腕\nさわん、ひだりうで",
                          @"白兎\nはくと、しろうさぎ",
                          @"山形\nさんけい、やまがた",
                          @"右腕\nみぎうで、うわん", 
                          @"一物\nいちもつ、いちぶつ",
                          @"最中\nさいちゅう、もなか",
                          @"最上\nさいじょう、もがみ",
                          @"水面\nすいめん、みなも",
                          @"小人\nこびと、しょうにん",
                          @"丹生\nにわ、にゅう、たんせい",
                          @"人気\nひとけ、にんき",
                          @"大人気\nだいにんき、おとなげ",
                          @"栗林\nくりばやし、りつりん",
                          @"関西\nかんさい、かんせい",
                          @"大分\nおおいた、だいぶ",
                          @"犬猫\nいぬねこ、けんびょう",
                          @"生物\nせいぶつ、なまもの",
                        nil];

    messageGachaRareArray = [NSArray arrayWithObjects:
                              @"風水\nふうすい、かざみ",
                              @"戯言\nざれごと、たわごと",
                              @"御手洗\nみたらい、おてあらい",
                              @"永久\nえいきゅう、とわ、とこしえ",
                              @"風車\nふうしゃ、かざぐるま",
                              @"足跡\nあしあと、そくせき",
                              nil];
    messageGachaSuperRareArray = [NSArray arrayWithObjects:
                                   @"螺旋\nらせん、ねじ",
                                   @"銀杏\nぎんなん、いちょう",
                                   nil];
    
    // 中級が出現している
    if ( [gameDataEntity getStageClearStatusWithLevel:E_STAGE_LEVEL_CHUKYU stage:0] > -2 ) {
        [message2GachaButton setHidden:NO];
        [message2GachaCollectionButton setHidden:NO];
        
        message2GachaArray = [NSArray arrayWithObjects:
                               @"紅葉\nもみじ、こうよう",
                               @"十分\nじゅうぶん、１０ぷん",
                               @"音色\nねいろ、おんしょく",
                               @"鍛冶\nかじ、だすじ",
                               @"悪戯\nあくぎ、いたずら",
                               @"見物\nけんぶつ、みもの",
                               @"下手\nへた、したて、しもて",
                               @"上手\nじょうず、うわて、かみて",
                               @"蟷螂\nかまきり、とうろう",
                               @"性質\nせいしつ、たち",
                               @"工場\nこうじょう、こうば",
                               @"罪人\nざいにん、つみびと",
                               @"森林\nしんりん、もりばやし",
                               @"一寸\nいっすん、ちょっと",
                               @"眼鏡\nめがね、がんきょう",
                               @"手前\nてまえ、てめえ",
                               @"何故\nなぜ、なにゆえ",
                               @"歩兵\nほへい、ふひょう",
                               @"梅雨\nつゆ、ばいう",
                               @"女子\nじょし、おなご",
                               @"パン作ってる会社にクレームをだした事がある\n店に置いてるパンにマヨネーズ入りが多すぎると",
                               @"いくら探してもまともなものが見つからなかったので\n諦めてレディースの眼鏡を購入した",
                               @"大量の排便が原因で絶命する事を\n専門用語で穴開き死ショックというらしい",
                               @"海水全体には約５０億トンの金が含まれているらしい",
                               @"難しいゲームが減っているので、私が作った",
                               @"米は呼吸をするため、常温保存だと劣化する\n冷蔵庫に保存するのが良いと言われる",
                               @"キシリトールはバナナなど天然の食材に含まれる",
                               @"Japanとは、日本（じっぽん）と中国で読まれていた由縁という",
                               @"初級、中級の敵は、攻撃をする前に少し停止してくれる",
                               @"能力配分と敵を倒す順序が重要",
                               nil];
        message2GachaRareArray = [NSArray arrayWithObjects:
                                   @"肉汁\nにくじる、にくじゅう",
                                   @"分別\nふんべつ、ぶんべつ",
                                   @"何時\nいつ、なんじ、なんどき",
                                   @"何処\nどこ、いずこ、いづこ",
                                   @"経緯\nけいい、いきさつ",
                                   @"色紙\nしきし、いろがみ",
                                   @"雲雀\nひばり、うんじゃく",
                                   @"左右\nさゆう、とかく",
                                   @"千尋\nちひろ、ちなみ",
                                   @"重複\nじゅうふく、ちょうふく",
                                   @"乙女\nおとめ、おつ",
                                   @"一途\nいちず、いっと",
                                   @"画像が荒い理由？\nガラケー時代に作ったアプリの移植だからさ",
                                   @"駒の画像はペイントで描いた",
                                   @"ブロックの画像は鉄板や木材の写真を使っている",
                                   @"スーパーレアでは裏技も公開しているらしい",
                                   @"画像も音も一人で作っている\n音の作成には２万円ほど掛かっている",
                                   @"初級をクリアすると溜め打ちが使えるようになるらしい",
                                   @"ゲームの開発には４ヶ月要した\niPhoneへの移植はその半分程度",
                                   @"駒が成れれば良いのに\nさらっと言うけど企画と実装が大変だ",                                   
                                   nil];
        message2GachaSuperRareArray = [NSArray arrayWithObjects:
                                        @"スーパーレアだからといって必ずしも価値のある情報が得られるわけではない",
                                        @"小学生低学年までは床に落ちていた髪の毛を拾って食べていた",
                                        @"ゲームを進めるとわけのわからない敵が現れるのは、ネタ切れ防止策だ",
                                        @"なるべくポイントを購入せずクリアしてほしいというのは開発者の本意\n売上が欲しいのももちろん本意",
                                        @"「難関」は私の単なる感想なので、びびる必要はない",
                                        @"初級、中級、上級と用意することで、どこかで詰まっても逃げ道をユーザに与える\nゲームバランスを意識する手間を省いたのだ",
                                        @"ヴィトンの何がいいの？\n高く売れるところ？",
                                        @"ケンタッキーが一日に殺す鶏の数をフェルミ推定してみよう",
                                        @"俺が癌で死ぬわけない\n多くの人はそう思っているはず",
                                        @"ゲーム画面のある場所をタップすると、盤の色、星の色、星のパターンを変えられる\nえ、知ってた？",
                                        nil];
        
        [message2GachaButton addTarget:self
                                action:@selector(message2GachaButtonPushed)
                      forControlEvents:UIControlEventTouchUpInside];
        [message2GachaCollectionButton addTarget:self
                                          action:@selector(message2GachaCollectionButtonPushed)
                                forControlEvents:UIControlEventTouchUpInside];
    }
    // 上級が出現している
    if ( [gameDataEntity getStageClearStatusWithLevel:E_STAGE_LEVEL_JOKYU stage:0] > -2 ) {
        [message3GachaButton setHidden:NO];
        [message3GachaCollectionButton setHidden:NO];
        
        message3GachaArray = [NSArray arrayWithObjects:
                               @"ビールの味？\n父親のゲップの味がするね",
                               @"授業料を授業のコマ数で割ると...\n大学の講義は1コマ90分当たり1500円くらいだった",
                               @"勤労感謝の日に感謝しません\nただ与えられた休日を満喫するのみ",
                               @"鶏卵は神の食材",
                               @"歩の裏の「と」は金の字が崩れ字\n成り香、成り桂、成り銀も同じ",
                               @"もばぐりのガチャで一枚絵のカードもらって何がいいのかわからない\n世の中価値あるべきは情報だろうが\n画像も情報の一つだけどさ",
                               @"タイトル画像はマジックで殴り書きしたものをデジカメで撮影したもの",
                               @"燃料が80以上の時は「特殊」が「威力」に加算されるらしいと噂されている",
                               @"行き詰まったら能力配分を大幅に見直すと進めたりします",
                               @"牛肉は高いけど鶏や豚のほうが好き",
                               @"タバコの火は約400度で吸うと約倍\nマッチの発火直後は約2500度で、\n太陽表面は6000度、中心は数千万度",
                               @"ハズレ",
                               nil];
        message3GachaRareArray = [NSArray arrayWithObjects:
                                   @"ウサギの目の色が赤いのは、\n眼球の裏の血管が赤いため",
                                   @"最初は将棋をモチーフにしたシューティングゲームを作る予定だった",
                                   @"unkoが臭いのではない\n臭いのがunkoなのだ",
                                   @"1000円札は野口から夏目に戻すべき\nなんだねあの髪型は",
                                   @"将棋の駒は高い\n100円均一ので満足できるわ",
                                   @"年間360回ラーメン屋に行ったが、１キロも太らなかった\n寧ろ痩せた",
                                   @"林檎やメロンはエチレンガスを発生し、付近の食材に影響を与える",
                                   @"（制作秘話）\n開発に着手したのは2012年のゴールデンウィーク始めだ",
                                   @"（制作秘話）\n本業を終えてから自宅で数時間の作業をほぼ毎日繰り返した\n休日はそれほど作業をしていない",
                                   @"（制作秘話）\n本業でも同時期にiPhoneアプリを開発していた",
                                   nil];
        message3GachaSuperRareArray = [NSArray arrayWithObjects:
                                        @"タバコの煙には４千もの化学物質が含まれている\n79％が一酸化炭素で、次いで7.5%がニコチンだ",
                                        @"おでんの王様であるちくわぶは、\nなんと関東にしかないらしい",
                                        @"飛車よりも香車の方が射程が長い",
                                        @"怒りは無謀をもって始まり、公開をもって終わる\nピタゴラスの名言",
                                        @"味は食べ物の成分が唾液に溶けて味蕾の溝に液体が流れる事で感じるため、唾液が乾いていると味がわからなくなる",
                                        @"駄目の語源は囲碁",
                                        @"アリジゴクの成体であるウスバカゲロウは口が未発達で物を食べられず、一日で死ぬ\nアリジゴクは生涯一度しかうんこをしない",
                                        @"宇宙とビッグバンのWikipedia面白いよ",
                                        @"特殊の効果１\n一定確率で毒を与える。毒は自然治癒する",
                                        @"特殊の効果２\n敵が攻撃をするタイミングを表示させる",
                                        @"特殊の効果３\n敵の攻撃を萎縮させる",
                                        @"特殊の効果４\n溜め打ちの飛距離を上げる",
                                        @"特殊の効果５\n特殊の値を威力にある倍率を掛けて加算する",
                                        @"たまに出る変なブロックの出現確率は0.5%",
                                        nil];

        
        [message3GachaButton addTarget:self
                                action:@selector(message3GachaButtonPushed)
                      forControlEvents:UIControlEventTouchUpInside];
        [message3GachaCollectionButton addTarget:self
                                          action:@selector(message3GachaCollectionButtonPushed)
                                forControlEvents:UIControlEventTouchUpInside];

    
    }
     
    
    
    [backButton addTarget:self
                   action:@selector(backButtonPushed)
         forControlEvents:UIControlEventTouchUpInside];
    
    
    [messageGachaButton addTarget:self
                           action:@selector(messageGachaButtonPushed) 
                 forControlEvents:UIControlEventTouchUpInside];
    
    [messageGachaCollectionButton addTarget:self
                                     action:@selector(messageGachaCollectionButtonPushed)
                           forControlEvents:UIControlEventTouchUpInside];
    
    [buyButton addTarget:self action:@selector(buyButtonPushed)
        forControlEvents:UIControlEventTouchUpInside];

}

/************************************************
 ビュー表示前
 ************************************************/
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CATransform3D transformFromFlip = CATransform3DMakeRotation(M_PI-0.05f, 0.0f, 1.0f, 1.0f);
    transformFromFlip = CATransform3DScale(transformFromFlip, kFlipAnimationScale, kFlipAnimationScale, 1.0f);
    
    CATransform3D transformToFlip = CATransform3DMakeRotation(0.0f, 0.0f, 0.0f, 0.0f);
    transformToFlip.m34 = kM34;
    
    CALayer *layer = self.view.layer;
    
    CABasicAnimation* animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    [animation setDelegate:self];
    [animation setDuration:kLong2AnimationDuration];
    [animation setRepeatCount:0];
    [animation setRemovedOnCompletion:NO];
    [animation setFromValue:[NSValue valueWithCATransform3D:transformFromFlip]];
    [animation setToValue:[NSValue valueWithCATransform3D:transformToFlip]];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];    
    [layer addAnimation:animation forKey:@"transformAnimationAppear"];
}

/************************************************
 戻るボタン
 ************************************************/
- (void)backButtonPushed {
    [GameDataManager saveGameDataEntity:gameDataEntity];
    
    CALayer *layer = self.view.layer;
    
    CATransform3D transformFlip = CATransform3DMakeRotation(M_PI, 0.0f, -1.0f, 1.0f);
    transformFlip = CATransform3DScale(transformFlip, kFlipAnimationScale, kFlipAnimationScale, 1.0f);
    
    // アニメーション後の形をセット
    layer.transform = transformFlip;
    
    CATransform3D transform;
    transform = CATransform3DIdentity;
    transform.m34 = kM34;// 奥行き
    
    CABasicAnimation* animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    [animation setDelegate:self];
    [animation setDuration:kLong2AnimationDuration];
    [animation setRepeatCount:0];
    [animation setRemovedOnCompletion:NO];
    [animation setFromValue:[NSValue valueWithCATransform3D:transform]];
    [animation setToValue:[NSValue valueWithCATransform3D:transformFlip]];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];    
    [layer addAnimation:animation forKey:@"transformAnimationBack"];
}

/************************************************
 メッセージガチャ
 ************************************************/
- (void)messageGachaButtonPushed {
    if ([gameDataEntity gachaPoints] <= 0) {
        return;
    }
    [gameDataEntity setGachaPoints:[gameDataEntity gachaPoints]-1];
    [pointsLabel setText:[Misc intToString:[gameDataEntity gachaPoints]]];
    
    [AnimationManager popAnimationWithView:pointsLabel duration:1.1f delay:0.0f alpha:0.5f];
            
    int random = rand()%100;
    NSString *title = @"";
    NSString *message = @"";
    if (random < 95) {// 95% ノーマル
        random = rand()%[messageGachaArray count];
        title = [NSString stringWithFormat:@"ノーマル %d/%d", random+1, [messageGachaArray count]];
        message = [messageGachaArray objectAtIndex:random];
        
        if ([gameDataEntity getGacha01Normal:random] == 0) {
            BSGAAppDelegate *appDelegate = (BSGAAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate.soundManager play:E_SOUND_LASER2];
        }
        
        [gameDataEntity setGacha01Normal:random value:1];
    } else if (random < 99) {// 4% レア
        random = rand()%[messageGachaRareArray count];
        title = [NSString stringWithFormat:@"レア %d/%d", random+1, [messageGachaRareArray count]];
        message = [messageGachaRareArray objectAtIndex:random];
  
        if ([gameDataEntity getGacha01Rare:random] == 0) {
            BSGAAppDelegate *appDelegate = (BSGAAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate.soundManager play:E_SOUND_ENEMY_EXPLOSION];
        }

        [gameDataEntity setGacha01Rare:random value:1];
        

        
    } else {// 1% スーパーレア
        random = rand()%[messageGachaSuperRareArray count];
        title = [NSString stringWithFormat:@"スーパーレア %d/%d", random+1, [messageGachaSuperRareArray count]];
        message = [messageGachaSuperRareArray objectAtIndex:random];
        
        if ([gameDataEntity getGacha01SuperRare:random] == 0) {
            BSGAAppDelegate *appDelegate = (BSGAAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate.soundManager play:E_SOUND_PLAYER_EXPLOSION];
        }

        
        [gameDataEntity setGacha01SuperRare:random value:1];

    }
    [GameDataManager saveGameDataEntity:gameDataEntity];    

    [titleLabel setText:title];
    [messageLabel setText:message];
    
    [AnimationManager popAnimationWithView:titleLabel
                                  duration:0.8f
                                     delay:0.0f
                                     alpha:0.6f];
    [AnimationManager popAnimationWithView:messageLabel
                                  duration:0.5f
                                     delay:0.0f
                                     alpha:0.6f];
}

/************************************************
 メッセージガチャコレクション
 ************************************************/
- (void)messageGachaCollectionButtonPushed {
    NSMutableString *string = [[NSMutableString alloc] init];
    [string setString:@""];
    int i=0;
    for (NSString *message in messageGachaArray) {
        if ([gameDataEntity getGacha01Normal:i] == 0) {
            [string appendFormat:@"☆Normal [%02d]\n？？？？？\n\n", i+1];
        } else {
            [string appendFormat:@"★Normal [%02d]\n%@\n\n", i+1, message];
        }
        i++;
    }
    i=0;
    for (NSString *message in messageGachaRareArray) {
        if ([gameDataEntity getGacha01Rare:i] == 0) {
            [string appendFormat:@"☆Rare [%02d]\n？？？？？\n\n", i+1];
        } else {
            [string appendFormat:@"★Rare [%02d]\n%@\n\n", i+1, message];
        }
        i++;
    }
    i=0;
    for (NSString *message in messageGachaSuperRareArray) {
        if ([gameDataEntity getGacha01SuperRare:i] == 0) {
            [string appendFormat:@"☆SuperRare [%02d]\n？？？？？\n\n", i+1];
        } else {
            [string appendFormat:@"★SuperRare [%02d]\n%@\n\n", i+1, message];
        }
        i++;
    }
    
    
    
    
    
    [[[UIAlertView alloc] initWithTitle:nil
                                message:string
                               delegate:nil
                      cancelButtonTitle:@"(^o^)"
                      otherButtonTitles:nil] show];
}


/************************************************
 メッセージ２ガチャ
 ************************************************/
- (void)message2GachaButtonPushed {
    if ([gameDataEntity gachaPoints] <= 0) {
        return;
    }
    [gameDataEntity setGachaPoints:[gameDataEntity gachaPoints]-1];
    [pointsLabel setText:[Misc intToString:[gameDataEntity gachaPoints]]];
    
    [AnimationManager popAnimationWithView:pointsLabel duration:1.1f delay:0.0f alpha:0.5f];
    
    
    
    int random = rand()%100;
    NSString *title = @"";
    NSString *message = @"";
    if (random < 85) {// 85% ノーマル
        random = rand()%[message2GachaArray count];
        title = [NSString stringWithFormat:@"ノーマル %d/%d", random+1, [message2GachaArray count]];
        message = [message2GachaArray objectAtIndex:random];
        
        if ([gameDataEntity getGacha02Normal:random] == 0) {
            BSGAAppDelegate *appDelegate = (BSGAAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate.soundManager play:E_SOUND_LASER2];
        }
        
        
        [gameDataEntity setGacha02Normal:random value:1];
    } else if (random < 97) {// 12% レア
        random = rand()%[message2GachaRareArray count];
        title = [NSString stringWithFormat:@"レア %d/%d", random+1, [message2GachaRareArray count]];
        message = [message2GachaRareArray objectAtIndex:random];
        
        if ([gameDataEntity getGacha02Rare:random] == 0) {
            BSGAAppDelegate *appDelegate = (BSGAAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate.soundManager play:E_SOUND_ENEMY_EXPLOSION];
        }
        
        [gameDataEntity setGacha02Rare:random value:1];
        
    } else {// 3% スーパーレア
        random = rand()%[message2GachaSuperRareArray count];
        title = [NSString stringWithFormat:@"スーパーレア %d/%d", random+1, [message2GachaSuperRareArray count]];
        message = [message2GachaSuperRareArray objectAtIndex:random];
        
        if ([gameDataEntity getGacha02SuperRare:random] == 0) {
            BSGAAppDelegate *appDelegate = (BSGAAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate.soundManager play:E_SOUND_PLAYER_EXPLOSION];
        }
        
        [gameDataEntity setGacha02SuperRare:random value:1];
        
    }
    
    [GameDataManager saveGameDataEntity:gameDataEntity];
    
    
    [titleLabel setText:title];
    [messageLabel setText:message];
    
    [AnimationManager popAnimationWithView:titleLabel
                                  duration:0.8f
                                     delay:0.0f
                                     alpha:0.6f];
    [AnimationManager popAnimationWithView:messageLabel
                                  duration:0.5f
                                     delay:0.0f
                                     alpha:0.6f];
}

/************************************************
 メッセージ２ガチャコレクション
 ************************************************/
- (void)message2GachaCollectionButtonPushed {
    NSMutableString *string = [[NSMutableString alloc] init];
    [string setString:@""];
    int i=0;
    for (NSString *message in message2GachaArray) {
        if ([gameDataEntity getGacha02Normal:i] == 0) {
            [string appendFormat:@"☆Normal [%02d]\n？？？？？\n\n", i+1];
        } else {
            [string appendFormat:@"★Normal [%02d]\n%@\n\n", i+1, message];
        }
        i++;
    }
    i=0;
    for (NSString *message in message2GachaRareArray) {
        if ([gameDataEntity getGacha02Rare:i] == 0) {
            [string appendFormat:@"☆Rare [%02d]\n？？？？？\n\n", i+1];
        } else {
            [string appendFormat:@"★Rare [%02d]\n%@\n\n", i+1, message];
        }
        i++;
    }
    i=0;
    for (NSString *message in message2GachaSuperRareArray) {
        if ([gameDataEntity getGacha02SuperRare:i] == 0) {
            [string appendFormat:@"☆SuperRare [%02d]\n？？？？？\n\n", i+1];
        } else {
            [string appendFormat:@"★SuperRare [%02d]\n%@\n\n", i+1, message];
        }
        i++;
    }
    
    [[[UIAlertView alloc] initWithTitle:nil
                                message:string
                               delegate:nil
                      cancelButtonTitle:@"(^o^)"
                      otherButtonTitles:nil] show];
}


/************************************************
 メッセージ３ガチャ
 ************************************************/
- (void)message3GachaButtonPushed {
    if ([gameDataEntity gachaPoints] <= 0) {
        return;
    }
    [gameDataEntity setGachaPoints:[gameDataEntity gachaPoints]-1];
    [pointsLabel setText:[Misc intToString:[gameDataEntity gachaPoints]]];
    
    [AnimationManager popAnimationWithView:pointsLabel duration:1.1f delay:0.0f alpha:0.5f];
    
    
    
    int random = rand()%100;
    NSString *title = @"";
    NSString *message = @"";
    if (random < 75) {// 75% ノーマル
        random = rand()%[message3GachaArray count];
        title = [NSString stringWithFormat:@"ノーマル %d/%d", random+1, [message3GachaArray count]];
        message = [message3GachaArray objectAtIndex:random];
        
        if ([gameDataEntity getGacha03Normal:random] == 0) {
            BSGAAppDelegate *appDelegate = (BSGAAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate.soundManager play:E_SOUND_LASER2];
        }
        
        
        [gameDataEntity setGacha03Normal:random value:1];
    } else if (random < 97) {// 22% レア
        random = rand()%[message3GachaRareArray count];
        title = [NSString stringWithFormat:@"レア %d/%d", random+1, [message3GachaRareArray count]];
        message = [message3GachaRareArray objectAtIndex:random];
        
        if ([gameDataEntity getGacha03Rare:random] == 0) {
            BSGAAppDelegate *appDelegate = (BSGAAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate.soundManager play:E_SOUND_ENEMY_EXPLOSION];
        }
        
        [gameDataEntity setGacha03Rare:random value:1];
        
    } else {// 3% スーパーレア
        random = rand()%[message3GachaSuperRareArray count];
        title = [NSString stringWithFormat:@"スーパーレア %d/%d", random+1, [message3GachaSuperRareArray count]];
        message = [message3GachaSuperRareArray objectAtIndex:random];
        
        if ([gameDataEntity getGacha03SuperRare:random] == 0) {
            BSGAAppDelegate *appDelegate = (BSGAAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate.soundManager play:E_SOUND_PLAYER_EXPLOSION];
        }
        
        
        [gameDataEntity setGacha03SuperRare:random value:1];
        
    }
    [GameDataManager saveGameDataEntity:gameDataEntity];
    
    [titleLabel setText:title];
    [messageLabel setText:message];
    
    [AnimationManager popAnimationWithView:titleLabel
                                  duration:0.8f
                                     delay:0.0f
                                     alpha:0.6f];
    [AnimationManager popAnimationWithView:messageLabel
                                  duration:0.5f
                                     delay:0.0f
                                     alpha:0.6f];
}

/************************************************
 メッセージ３ガチャコレクション
 ************************************************/
- (void)message3GachaCollectionButtonPushed {
    NSMutableString *string = [[NSMutableString alloc] init];
    [string setString:@""];
    int i=0;
    for (NSString *message in message3GachaArray) {
        if ([gameDataEntity getGacha03Normal:i] == 0) {
            [string appendFormat:@"☆Normal [%02d]\n？？？？？\n\n", i+1];
        } else {
            [string appendFormat:@"★Normal [%02d]\n%@\n\n", i+1, message];
        }
        i++;
    }
    i=0;
    for (NSString *message in message3GachaRareArray) {
        if ([gameDataEntity getGacha03Rare:i] == 0) {
            [string appendFormat:@"☆Rare [%02d]\n？？？？？\n\n", i+1];
        } else {
            [string appendFormat:@"★Rare [%02d]\n%@\n\n", i+1, message];
        }
        i++;
    }
    i=0;
    for (NSString *message in message3GachaSuperRareArray) {
        if ([gameDataEntity getGacha03SuperRare:i] == 0) {
            [string appendFormat:@"☆SuperRare [%02d]\n？？？？？\n\n", i+1];
        } else {
            [string appendFormat:@"★SuperRare [%02d]\n%@\n\n", i+1, message];
        }
        i++;
    }
    
    [[[UIAlertView alloc] initWithTitle:nil
                                message:string
                               delegate:nil
                      cancelButtonTitle:@"(^o^)"
                      otherButtonTitles:nil] show];
}






/************************************************
 購入ボタン押下
 ************************************************/
- (void)buyButtonPushed {
    BSGAAppDelegate *appDelegate = (BSGAAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate setDelegate:self];
    [appDelegate payGachaPoints];
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
    }
}


//-----------------------------------------------
//
// PaymentDoneDelegate
//
//-----------------------------------------------
/************************************************
 購入処理完了
 ************************************************/
- (void)paymentDone {
    [gameDataEntity setGachaPoints:[gameDataEntity gachaPoints]+300];
    [gameDataEntity setPayCountGacha:[gameDataEntity payCountGacha]+1];
    [pointsLabel setText:[Misc intToString:[gameDataEntity gachaPoints]]];
    
    [AnimationManager popAnimationWithView:pointsLabel duration:1.0f delay:0.0f alpha:0.5f];
    
    [AnimationManager popAnimationWithView:self.view
                                  duration:0.5f
                                     delay:0.0f
                                     alpha:1.0f];
    
    [GameDataManager saveGameDataEntity:gameDataEntity];
}

@end
