//
//  MemoViewController.m
//  BSGA
//
//  Created by 近藤 雅人 on 12/05/18.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import "MemoViewController.h"

@implementation MemoViewController

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
    
    [backButton addTarget:self
                   action:@selector(backButtonPushed)
         forControlEvents:UIControlEventTouchUpInside];
    
    [mTableView setDelegate:self];
    [mTableView setDataSource:self];
    [mTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [mTableView setShowsVerticalScrollIndicator:NO];
    [mTableView setHidden:YES];
    
    [textField setFont:[UIFont systemFontOfSize:24]];
    [textField setDelegate:self];
    [textField setReturnKeyType:UIReturnKeyDone];

    [self performSelectorInBackground:@selector(getData) withObject:nil];
}

/************************************************
 ビュー表示前
 ************************************************/
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CATransform3D transformFromFlip = CATransform3DMakeRotation(M_PI-0.05f, -1.0f, 0.0f, 1.0f);
    transformFromFlip = CATransform3DScale(transformFromFlip, kFlipAnimationScale, kFlipAnimationScale, 1.0f);
    
    CATransform3D transformToFlip = CATransform3DMakeRotation(0.0f, 0.0f, 0.0f, 0.0f);
    transformToFlip.m34 = kM34;
    
    CALayer *layer = self.view.layer;
    
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
 戻るボタン
 ************************************************/
- (void)backButtonPushed {
    
    CALayer *layer = self.view.layer;
    
    CATransform3D transformFlip = CATransform3DMakeRotation(M_PI, 1.0f, 0.0f, 1.0f);
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
// TextViewDelegate
//
//-----------------------------------------------
/***************************************************************
 * テキストフィールド Return押下
 ***************************************************************/
- (BOOL)textFieldShouldReturn:(UITextField *)textField_
{
    [textField endEditing:YES];
    return YES;
}

/***************************************************************
 * テキストフィールド編集完了前
 ***************************************************************/
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField_
{
    return YES;
}

/***************************************************************
 * テキストフィールド編集完了
 ***************************************************************/
- (void)textFieldDidEndEditing:(UITextField *)textField_
{
    NSUInteger textLength = [[textField_ text] length];

    BOOL bool01 = (textLength > 0 && textLength < 3) || textLength > 60;
    BOOL bool02 = NO;
    NSString *text = [textField_ text];
    if ([text length] >= 3)
    {
        NSString *text01 = [text substringWithRange:NSMakeRange(0, 1)];
        NSString *text02 = [text substringWithRange:NSMakeRange(1, 1)];
        NSString *text03 = [text substringWithRange:NSMakeRange(2, 1)];        
        bool02 = ([text01 isEqualToString:text02] && [text02 isEqualToString:text03]);
    }
    
    if (bool02)
    {
        [[[CustomAlertView alloc] initWithTitle:@"あああとかはダメ"
                                   message:text 
                                  delegate:nil
                         cancelButtonTitle:@"ごめん"
                           otherButtonTitles:nil] show];
    }
    
    if (bool01 || bool02)
    {
        animationCount = 0;
        [UIView animateWithDuration:0.15f
                         animations:^{
                             [textField setTransform:CGAffineTransformMakeTranslation(8.0f, 0.0f)];
                         }
                         completion:^(BOOL finished) {
                             [self textFieldAnimationToLeft];
                         }
         ];
    }
    else if (textLength > 0)
    {
        // 日時
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
        NSString *dateString = [dateFormatter stringFromDate:date];
        
        // 言語（国）
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        
        // デバイス名
        NSString *device = [[UIDevice currentDevice] model];
        NSString *deviceName = [[UIDevice currentDevice] name];
        
        // コメント
        NSMutableString *comment
        = [[NSMutableString alloc] initWithString:[[textField_ text] 
                                                   stringByReplacingOccurrencesOfString:@","
                                                   withString:@" "]];
        
        GameDataEntity *gameDataEntity = [GameDataManager getGameDataEntity];
        int shokyu = 0;
        int chukyu = 0;
        int jokyu = 0;
        int chokyu = 0;
        for (int i=0; i<180; i++) {
            if ([gameDataEntity getStageClearStatusWithLevel:0 stage:i] > -2) {
                shokyu = i+1;
            }
            if ([gameDataEntity getStageClearStatusWithLevel:1 stage:i] > -2) {
                chukyu = i+1;
            }
            if ([gameDataEntity getStageClearStatusWithLevel:2 stage:i] > -2) {
                jokyu = i+1;
            }
            if (i<10) {
                if ([gameDataEntity getStageClearStatusWithLevel:3 stage:i] > -2) {
                    chokyu = i+1;
                }
            }
        }
        
        int gacha01rate = 0;
        int gacha02rate = 0;
        int gacha03rate = 0;
        for (int i=0; i<20; i++) {
            gacha01rate += [gameDataEntity getGacha01Normal:i];
        }
        for (int i=0; i<6; i++) {
            gacha01rate += [gameDataEntity getGacha01Rare:i];
        }
        for (int i=0; i<2; i++) {
            gacha01rate += [gameDataEntity getGacha01SuperRare:i];
        }
        for (int i=0; i<30; i++) {
            gacha02rate += [gameDataEntity getGacha02Normal:i];
        }
        for (int i=0; i<20; i++) {
            gacha02rate += [gameDataEntity getGacha02Rare:i];
        }
        for (int i=0; i<10; i++) {
            gacha02rate += [gameDataEntity getGacha02SuperRare:i];
        }
        for (int i=0; i<12; i++) {
            gacha03rate += [gameDataEntity getGacha03Normal:i];
        }
        for (int i=0; i<10; i++) {
            gacha03rate += [gameDataEntity getGacha03Rare:i];
        }
        for (int i=0; i<14; i++) {
            gacha03rate += [gameDataEntity getGacha03SuperRare:i];
        }
        
        gacha01rate *= 100;
        gacha02rate *= 100;
        gacha03rate *= 100;
        gacha01rate /= 28;
        gacha02rate /= 60;
        gacha03rate /= 36;

        
        NSString *requestText 
        = [NSString stringWithFormat:@"%@,%d,%@,%@,%3d,%3d,%3d,%2d,%3d,%3d,%3d,%5d,%@,%@,%d,%d",
           dateString,
           [gameDataEntity launchCount], 
           language,
           device,
           shokyu, chukyu, jokyu, chokyu,
           gacha01rate, gacha02rate, gacha03rate,
           [gameDataEntity score],
           deviceName,
           comment,
           [gameDataEntity payCountPoint],
           [gameDataEntity payCountGacha]
           ];
        
        NSURL *url = [NSURL URLWithString:@"http://ocogamas.sitemix.jp/bsga/memo/memo.php"];
        NSData *requestData = [requestText dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
        [request setHTTPBody:requestData];
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        [NSURLConnection sendSynchronousRequest:request
                              returningResponse:&response error:&error];
        
        if ([response statusCode] == 200) {
            [textField_ setText:@""];
            [self performSelectorInBackground:@selector(getData) withObject:nil];
        } else {
            [[[CustomAlertView alloc] initWithTitle:@"network error"
                                       message:nil
                                      delegate:nil
                             cancelButtonTitle:@"ahh..."
                               otherButtonTitles:nil] show];
        }
    }
}

/***************************************************************
 * テキストフィールドアニメーション右
 ***************************************************************/
- (void)textFieldAnimationToRight {
    [UIView animateWithDuration:0.15f
                     animations:^{
                         [textField setTransform:CGAffineTransformMakeTranslation(8.0f, 0.0f)];
                     } completion:^(BOOL finished) {
                         [self textFieldAnimationToLeft];
                         animationCount++;
                     }
     ];
}

/***************************************************************
 * テキストフィールドアニメーション左
 ***************************************************************/
- (void)textFieldAnimationToLeft {
    [UIView animateWithDuration:0.15f
                     animations:^{
                         [textField setTransform:CGAffineTransformMakeTranslation(-8.0f, 0.0f)];
                     } completion:^(BOOL finished) {
                         if (animationCount < 1) {
                             [self textFieldAnimationToRight];
                         } else {
                             [UIView animateWithDuration:0.15f
                                              animations:^{
                                                  [textField setTransform:CGAffineTransformMakeTranslation(0.0f, 0.0f)];
                                                  
                                              }
                              ];
                         }
                     }
     ];
}


//-----------------------------------------------
//
// Table
//
//-----------------------------------------------

/************************************************
 セクション数
 ************************************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

/************************************************
 行数
 ************************************************/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [cellDataArray count];
}

/************************************************
 セルの処理
 ************************************************/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PrintLog();
    
    static NSString *CellIdentifier = @"Cell";
    
    MemoCell *cell = (MemoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        UIViewController *vc = [[UIViewController alloc] initWithNibName:@"MemoCell" bundle:nil];
        cell = (MemoCell *)vc.view;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    NSArray *array = [NSArray arrayWithArray:[cellDataArray objectAtIndex:indexPath.row]];

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

#pragma mark - Table view delegate
/************************************************
 セルタップ
 ************************************************/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


/************************************************
 データを取得
 ・通信してデータを取得
 ・表示
 ************************************************/
- (void)getData {
//    PrintLog();
    
    mutableData = [[NSMutableData alloc] init];
    
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
        
        cellDataArray = [[NSMutableArray alloc] init];
        
        for (int i=[rowArray count]-1; i>=0; i--) {
            NSString *row = [rowArray objectAtIndex:i];
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[row componentsSeparatedByString:@","]];
            if ([array count] == 16) {
                [cellDataArray addObject:array];
            }
        }
        
        [self performSelectorOnMainThread:@selector(reloadTable) withObject:nil waitUntilDone:NO];
    }
    
}

/************************************************
 メインスレッドで再描画
 ************************************************/
- (void)reloadTable
{
    PrintLog();
    [mTableView setHidden:NO];
    [mTableView reloadData];
}

/************************************************
 セルの高さ
 ************************************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66.0f;
}



@end
