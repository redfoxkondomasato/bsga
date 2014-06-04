//
//  MemoBackView.m
//  BSGA
//
//  Created by 近藤 雅人 on 12/06/18.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import "MemoBackView.h"

@implementation MemoBackView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/***************************************************************
 * 描画
 ***************************************************************/
- (void)drawRect:(CGRect)rect {
    // グラフィックコンテキスト取得
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGGradientRef glossGradient;
    CGColorSpaceRef rgbColorSpace;
    CGFloat locations[2] = {0.0f, 0.45f};
    CGFloat components[8];
        components[0] = 0.59;
        components[1] = 1.00f;
        components[2] = 0.69f;
        components[3] = 1.0f;
    
        components[4] = 0.0f;
        components[5] = 0.0f;
        components[6] = 0.0f;
        components[7] = 1.0f;        
    
    rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    glossGradient = CGGradientCreateWithColorComponents(rgbColorSpace, components, locations, 2);

    CGPoint topCenter = CGPointMake(CGRectGetMidX(self.bounds), 0.0f);
    CGPoint maxCenter = CGPointMake(CGRectGetMidX(self.bounds)+7.0f, CGRectGetMaxY(self.bounds));
    CGContextDrawLinearGradient(context, glossGradient, topCenter, maxCenter, 0);
    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorSpace);
}



@end
