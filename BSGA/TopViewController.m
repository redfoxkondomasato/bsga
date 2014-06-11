//
//  TopViewController.m
//  BSGA
//
//  Created by 近藤 雅人 on 12/04/21.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import "TopViewController.h"

static int kGetMemoDataCountDown = 10;

@interface TopViewController()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *_memoDataArray;
    NSTimer *_timer;
    int _getMemoDataCountDown;

}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation TopViewController


/************************************************
 初期化
 ************************************************/
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _memoDataArray = [[NSMutableArray alloc] init];
        _getMemoDataCountDown = 0;
    }
    return self;
}

/************************************************
 ビュー読み込み後
 ************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    GameDataEntity *gameDataEntity = [GameDataManager getGameDataEntity];
    
    [gameDataEntity setLaunchCount:[gameDataEntity launchCount]+1];// 起動回数カウントアップ
    [GameDataManager saveGameDataEntity:gameDataEntity];
    
    [self performSelectorInBackground:@selector(sendData) withObject:nil];
    
    [launchCountLabel setText:[NSString stringWithFormat:@"起動回数　%d", [gameDataEntity launchCount]]];
    
    srand(time(NULL));
    
    BSGAAppDelegate *appDelegate = (BSGAAppDelegate *)[[UIApplication sharedApplication] delegate];
    soundManager = appDelegate.soundManager;

    [startButton     setExclusiveTouch:YES];
    [abilityButton   setExclusiveTouch:YES];
    [customizeButton setExclusiveTouch:YES];
    [tipsButton      setExclusiveTouch:YES];
    
    
    int launchCount = [gameDataEntity launchCount];
    
    // 起動回数が10の倍数のとき
    if (launchCount % 10 == 0 && launchCount > 0) {
        
        // 0.0f - 3.0f
        float scale = (rand()%31)/10.0f;
        [AnimationManager basicAnimationWithView:titleImageView
                                        duration:1.0f
                                           delay:0.2f
                                         options:UIViewAnimationOptionCurveEaseIn
                                     fromToAlpha:CGPointMake(0.6f, 1.0f)
                                    fromToRotate:CGPointZero
                                      beginScale:CGPointMake(scale, scale)
                                     finishScale:CGPointMake(1.0f, 1.0f)
                                  beginTranslate:CGPointZero
                                 finishTranslate:CGPointZero];
    }
    
    _timer = nil;
}

/************************************************
 ビュー非表示前
 ************************************************/
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([_timer isValid])
    {
        [_timer invalidate];
        _timer = nil;
    }
}

/************************************************
 ビュー表示前
 ************************************************/
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([_timer isValid] == NO)
    {
        _timer = [NSTimer timerWithTimeInterval:1.0f
                                         target:self
                                       selector:@selector(getMemoDataTick)
                                       userInfo:nil
                                        repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    
    GameDataEntity *gameDataEntity = [GameDataManager getGameDataEntity];
    // TODO -2ってなんだよw
    if ([gameDataEntity getStageClearStatusWithLevel:E_STAGE_LEVEL_SHOKYU stage:3] == -2)
    {
        [customizeButton setHidden:YES];
    } else
    {
        [customizeButton setHidden:NO];
    }
    
    if (transitionType == E_TRANSITION_TYPE_FLIP) {
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
    } else if (transitionType == E_TRANSITION_TYPE_FLIP_X) {
        CATransform3D transformFromFlip = CATransform3DMakeRotation(M_PI/2.0f, -1.0f, 0.0f, 0.0f);
        transformFromFlip = CATransform3DScale(transformFromFlip, kFlipXAnimationScale, kFlipXAnimationScale, 1.0f);
        
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
 
    } else if (transitionType == E_TRANSITION_TYPE_FLIP_YZ) {
        CATransform3D transformFromFlip = CATransform3DMakeRotation(M_PI-0.05f, 0.0f, 1.0f, 1.0f);
        transformFromFlip = CATransform3DScale(transformFromFlip, kFlipAnimationScale, kFlipAnimationScale, 1.0f);
        
        CATransform3D transformToFlip = CATransform3DMakeRotation(0.0f, 0.0f, 0.0f, 0.0f);
        transformToFlip.m34 = kM34;
        
        CALayer *layer = self.view.layer;
        
        // アニメーション後の形をセット
        [layer setTransform:transformToFlip];
        
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
        
    } else if (transitionType == E_TRANSITION_TYPE_FLIP_XZ) {
        CATransform3D transformFromFlip = CATransform3DMakeRotation(M_PI-0.05f, -1.0f, 0.0f, 1.0f);
        transformFromFlip = CATransform3DScale(transformFromFlip, kFlipAnimationScale, kFlipAnimationScale, 1.0f);
        
        CATransform3D transformToFlip = CATransform3DMakeRotation(0.0f, 0.0f, 0.0f, 0.0f);
        transformToFlip.m34 = kM34;
        
        CALayer *layer = self.view.layer;
        
        // アニメーション後の形をセット
        [layer setTransform:transformToFlip];
        
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
    
}

/************************************************
 開始ボタン
 ************************************************/
- (IBAction)startButtonTouchDown:(id)sender
{
    transitionType = E_TRANSITION_TYPE_ALPHA;
    [soundManager play:E_SOUND_SELECT];
        
    transitionType = E_TRANSITION_TYPE_FLIP;
    nextPage = nil;    
    
    nextPage = [[StageSelectViewController alloc] initWithNibName:@"StageSelectViewController" bundle:nil];
    
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

/************************************************
 能力ボタン
 ************************************************/
- (IBAction)abilityButtonTouchDown:(id)sender
{
    [soundManager play:E_SOUND_SELECT];
    transitionType = E_TRANSITION_TYPE_FLIP;
    nextPage = nil;
    nextPage = [[AbilityViewController alloc] initWithNibName:@"AbilityViewController" bundle:nil];
    
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

/************************************************
 設定ボタン
 ************************************************/
- (IBAction)customizeButtonTouchDown:(id)sender
{
    [soundManager play:E_SOUND_SELECT];
    
    nextPage = nil;
    nextPage = [[CustomizeViewController alloc] initWithNibName:@"CustomizeViewController" bundle:nil];

    transitionType = E_TRANSITION_TYPE_FLIP_X;
    
    CALayer *layer = self.view.layer;
    
    CATransform3D transformFlip = CATransform3DMakeRotation(M_PI/2.0f, 1.0f, 0.0f, 0.0f);
    transformFlip = CATransform3DScale(transformFlip, kFlipXAnimationScale, kFlipXAnimationScale, 1.0f);
    
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

/************************************************
 TIPSボタン
 ************************************************/
- (IBAction)tipsButtonTouchDown:(id)sender
{
    [soundManager play:E_SOUND_SELECT];
    
    nextPage = nil;
    nextPage = [[TipsViewController alloc] initWithNibName:@"TipsViewController" bundle:nil];

    transitionType = E_TRANSITION_TYPE_FLIP_YZ;
    
    CALayer *layer = self.view.layer;
    
    CATransform3D transformFlip = CATransform3DMakeRotation(M_PI, 0.0f, -1.0f, 1.0f);
    transformFlip = CATransform3DScale(transformFlip, kFlipAnimationScale, kFlipAnimationScale, 1.0f);
    
    // アニメーション後の形をセット
    [layer setTransform:transformFlip];
    
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
    [layer addAnimation:animation forKey:@"transformAnimationNext"];
}

#pragma mark - CAAnimationDelegate

/************************************************
 CAAnimation停止
 ************************************************/
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    CALayer *layer = self.view.layer;
    
    if (anim == [layer animationForKey:@"transformAnimationNext"]) {
        if (nextPage) {
            [self.navigationController pushViewController:nextPage animated:NO];
            nextPage = nil;
        }
        [layer removeAnimationForKey:@"transformAnimationNext"];
    } else if (anim == [layer animationForKey:@"transformAnimationAppear"]) {
        [layer removeAnimationForKey:@"transformAnimationAppear"];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_memoDataArray count];
}

- (void)reloadTable
{
    [_tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PrintLog();
    
    static NSString *CellIdentifier = @"MemoCell";
    
    MemoCell *cell = (MemoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        UIViewController *vc = [[UIViewController alloc] initWithNibName:@"MemoCell" bundle:nil];
        cell = (MemoCell *)vc.view;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    NSArray *array = [NSArray arrayWithArray:[_memoDataArray objectAtIndex:indexPath.row]];
    
    [cell.numberLabel setText:[Misc getClassWithScore:[[array objectAtIndex:11] intValue]]];
    
    [cell.dateLabel setText:[array objectAtIndex:0]];
    [cell.launchCountLabel setText:[array objectAtIndex:1]];
    [cell.countryLabel setText:[array objectAtIndex:2]];
    [cell.deviceLabel setText:[array objectAtIndex:3]];
    
    [cell.shokyuLabel setText:[array objectAtIndex:4]];
    [cell.chukyuLabel setText:[array objectAtIndex:5]];
    [cell.jokyuLabel setText:[array objectAtIndex:6]];
    [cell.chokyuLabel setText:[array objectAtIndex:7]];
    
    [cell.gacha01Label setText:[array objectAtIndex:8]];
    [cell.gacha02Label setText:[array objectAtIndex:9]];
    [cell.gacha03Label setText:[array objectAtIndex:10]];
    
    [cell.scoreLabel setText:[array objectAtIndex:11]];
    
    [cell.deviceNameLabel setText:[array objectAtIndex:12]];
    [cell.commentLabel setText:[array objectAtIndex:13]];
    
    if ([[array objectAtIndex:14] intValue] > 0) {
        [cell.commentLabel setTextColor:[UIColor redColor]];
    }
    
    [AnimationManager popAnimationWithView:cell.shokyuLabel
                                  duration:0.3f
                                     delay:0.3f
                                     alpha:0.0f];
    [AnimationManager popAnimationWithView:cell.chukyuLabel
                                  duration:0.3f
                                     delay:0.5f
                                     alpha:0.0f];
    [AnimationManager popAnimationWithView:cell.jokyuLabel
                                  duration:0.3f
                                     delay:0.7f
                                     alpha:0.0f];
    [AnimationManager popAnimationWithView:cell.chokyuLabel
                                  duration:0.3f
                                     delay:0.9f
                                     alpha:0.0f];
    
    
    [AnimationManager popAnimationWithView:cell.commentLabel
                                  duration:0.5f
                                     delay:0.2f
                                     alpha:0.7f];
    
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66.0f;
}

#pragma mark - Timer

/************************************************
 データ取得準備
 ************************************************/
- (void)getMemoDataTick
{
    PrintLog(@"count down = %d", _getMemoDataCountDown);
    if (_getMemoDataCountDown > 0)
    {
        _getMemoDataCountDown--;
    }
    
    if (_getMemoDataCountDown <= 0)
    {
        _getMemoDataCountDown = kGetMemoDataCountDown;
        
        [self performSelectorInBackground:@selector(getMemoData) withObject:nil];
    }
    
}

#pragma mark - thread

/************************************************
 MEMOデータ取得
 ************************************************/
- (void)getMemoData
{
    PrintLog(@"MEMOデータ取得開始");
    
    NSMutableData *mutableData = [[NSMutableData alloc] init];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLRequest *request;
    NSURL *url = [NSURL URLWithString:@"http://ocogamas.sitemix.jp/bsga/memo/memo.log"];
    request = [NSURLRequest requestWithURL:url];
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    [mutableData appendData:[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error]];
    
    if ([response statusCode] == 200) {
        //      PrintLog(@"通信成功");
        
        NSString *string = [[NSString alloc] initWithData:mutableData encoding:NSUTF8StringEncoding];
        // 改行で分割
        NSMutableArray *rowArray = [[NSMutableArray alloc] initWithArray:[string componentsSeparatedByString:@"\n"]];
        
        [_memoDataArray removeAllObjects];
        _memoDataArray = [[NSMutableArray alloc] init];
        
        for (int i=[rowArray count]-1; i>=0; i--) {
            NSString *row = [rowArray objectAtIndex:i];
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[row componentsSeparatedByString:@","]];
            if ([array count] == 16) {
                [_memoDataArray addObject:array];
            }
        }
        
        [self performSelectorOnMainThread:@selector(reloadTable) withObject:nil waitUntilDone:NO];
    }
    
}

/************************************************
 データ送信
 ************************************************/
- (void)sendData
{
    [SendDataManager sendData];
}
@end
