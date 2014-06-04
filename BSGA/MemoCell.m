//
//  MemoCell.m
//  BSGA
//
//  Created by 近藤 雅人 on 12/06/18.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import "MemoCell.h"

@implementation MemoCell
@synthesize numberLabel, launchCountLabel, dateLabel;
@synthesize countryLabel, deviceLabel, deviceNameLabel;
@synthesize shokyuLabel, chukyuLabel, jokyuLabel, chokyuLabel;
@synthesize gacha01Label, gacha02Label, gacha03Label;
@synthesize commentLabel;
@synthesize scoreLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
