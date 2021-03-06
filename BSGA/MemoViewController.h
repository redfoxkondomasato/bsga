//
//  MemoViewController.h
//  BSGA
//
//  Created by 近藤 雅人 on 12/05/18.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MemoCell.h"
#import "GameDataManager.h"
#import "GameDataEntity.h"
#import "Misc.h"
#import "AnimationManager.h"

@interface MemoViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    IBOutlet UIButton *backButton;
    
    IBOutlet UITableView *mTableView;
    
    IBOutlet UITextField *textField;
    
    NSMutableArray *cellDataArray;
    
    int animationCount;

}
- (void)textFieldAnimationToLeft;
- (void)textFieldAnimationToRight;


@end
