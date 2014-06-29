//
//  MemoCell.h
//  BSGA
//
//  Created by 近藤 雅人 on 12/06/18.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemoCell : UITableViewCell {
    
}

@property(nonatomic, strong) IBOutlet UILabel *launchCountLabel;
@property(nonatomic, strong) IBOutlet UILabel *dateLabel;
@property(nonatomic, strong) IBOutlet UILabel *countryLabel;
@property(nonatomic, strong) IBOutlet UILabel *deviceLabel;
@property(nonatomic, strong) IBOutlet UILabel *deviceNameLabel;
@property(nonatomic, strong) IBOutlet UILabel *shokyuLabel;
@property(nonatomic, strong) IBOutlet UILabel *chukyuLabel;
@property(nonatomic, strong) IBOutlet UILabel *jokyuLabel;
@property(nonatomic, strong) IBOutlet UILabel *chokyuLabel;
@property(nonatomic, strong) IBOutlet UILabel *gacha01Label;
@property(nonatomic, strong) IBOutlet UILabel *gacha02Label;
@property(nonatomic, strong) IBOutlet UILabel *gacha03Label;

@property(nonatomic, strong) IBOutlet UILabel *commentLabel;
@property(nonatomic, strong) IBOutlet UILabel *scoreLabel;

@end
