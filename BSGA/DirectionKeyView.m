//
//  DirectionKeyView.m
//  BSGA
//
//  Created by 近藤 雅人 on 12/04/22.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import "DirectionKeyView.h"

@implementation DirectionKeyView
@synthesize soundManager;
@synthesize isPushed;
//@synthesize keyAlpha;
@synthesize x, y;
@synthesize baseX, baseY;//, baseAlpha;
@synthesize posX, posY;
@synthesize isMute;
@synthesize directionX, directionY;
/************************************************
 破棄
 ************************************************/
- (void)dealloc {
    PrintLog();
}

/************************************************
 view生成時
 ************************************************/
- (void)awakeFromNib {
    // 位置固定
    if (kControllerStyle == 0) {
        baseX = 70;
        baseY = 390;
        x = 70;
        y = 390;
   //     baseAlpha = 1.0f;
        
    } else {
   //     baseAlpha = 0.0f;
    }
}


/************************************************
 描画
 ************************************************/
/*
- (void)drawRect:(CGRect)rect
{
 
    // Drawing code
    CGContextRef cgContext = UIGraphicsGetCurrentContext();
    
    float baseSizeX = 70.0f;
    float baseSizeY = 70.0f;
    float distanceX = fabs(baseX-x);
    float distanceY = fabs(baseY-y);
    float distance = sqrt(distanceX*distanceX + distanceY*distanceY);
   
    float distanceLimit = 80;
    if (distance > distanceLimit) {
        baseSizeX -= (distance - distanceLimit);
        baseSizeY -= (distance - distanceLimit);
        if (baseSizeX < 0) {
            baseSizeX = 0;
        }
        if (baseSizeY < 0) {
            baseSizeY = 0;
        }
    } else {
    }
    posX = x - baseSizeX/2.0f;
    posY = y - baseSizeY/2.0f;        
    
    // ベース
//    CGContextSetRGBFillColor(cgContext, 0.6, 0.7, 0.7, baseAlpha/6.0f);
//    CGContextFillEllipseInRect(cgContext, CGRectMake(baseX-60, baseY-60, 120.0, 120.0)); 
    
    // ベースライン
    CGContextSetLineWidth(cgContext, 1.0f);
    CGContextSetRGBStrokeColor(cgContext, 0.5, 0.7, 0.7, baseAlpha/4.0f);
    
    // ベースリング
//    CGContextSetRGBStrokeColor(cgContext, 0.6, 0.7, 0.7, baseAlpha/2.0f);
//    CGContextStrokeEllipseInRect(cgContext, CGRectMake(baseX-60, baseY-60, 120.0, 120.0));
    
    float small;
    float large;
    // 斜め範囲30度モード
    if (kControllerMode == 0) {
        small = 30;
        large = 52;
    }      
    // 斜め範囲45度モード
    else if (kControllerMode == 1) {
        small = 23;
        large = 55;
    }
    CGContextMoveToPoint(cgContext, baseX-small, baseY-large);
    CGContextAddLineToPoint(cgContext, baseX+small, baseY+large);
    
    CGContextMoveToPoint(cgContext, baseX-large, baseY-small);
    CGContextAddLineToPoint(cgContext, baseX+large, baseY+small);
    
    CGContextMoveToPoint(cgContext, baseX+large, baseY-small);
    CGContextAddLineToPoint(cgContext, baseX-large, baseY+small);
    
    CGContextMoveToPoint(cgContext, baseX+small, baseY-large);
    CGContextAddLineToPoint(cgContext, baseX-small, baseY+large);        
    
    
    CGContextStrokePath(cgContext); 
    

    

    // コントロールキー
    CGContextSetLineWidth(cgContext, 3.0f);

    CGContextSetRGBStrokeColor(cgContext, 0.1, 0.5+distance/120, 0.7, keyAlpha);
    CGContextStrokeEllipseInRect(cgContext, CGRectMake(posX, posY, baseSizeX, baseSizeY));

    CGContextSetRGBStrokeColor(cgContext, 0.1, 0.7, 0.5+distance/120, keyAlpha);
    CGContextStrokeEllipseInRect(cgContext, CGRectMake(posX+10, posY+10, baseSizeX-20, baseSizeY-20));
  

    float relativeX = x-baseX;
    float relativeY = y-baseY;
    
    float inclination = relativeY/relativeX;
//    NSString *direction = @"停止";
    
    float beforeDirectionX = directionX;
    float beforeDirectionY = directionY;
    
    directionX = 0;
    directionY = 0;
    
    if (distance < kControllerStopDistance) {
        // 幅が小さいときは動かない
    } else {
        
        if (relativeX==0 && relativeY==0) {
            //        direction = @"停止";
        } else if (relativeX==0 && relativeY<0) {
            //        direction = @"真上";
            directionY = kDirectionUp;
        } else if (relativeX==0 && relativeY>0) {
            //        direction = @"真下";
            directionY = kDirectionDown;
        } else if (relativeY==0 && relativeX<0) {
            //        direction = @"真左";
            directionX = -1;
        } else if (relativeY==0 && relativeX>0) {
            //        direction = @"真右";
            directionX = 1;
        } else {
            float large;
            float small; 
            
            // 斜め範囲small度モード
            if (kControllerMode == 0) {
                large = 1.7320508; // 60度　（2.41421356 67.5度）
                small = 0.57735027;// 30度　（0.41423562 22.5度）
            }
            // 斜め範囲45度モード
            else if (kControllerMode == 1) {
                large = 2.41421356;
                small = 0.41423562;
            }
            if (relativeX>0) { 
                if (inclination <= -large) {
                    //                direction = @"上";
                    directionY = kDirectionUp;
                } else if (inclination < -small && inclination > -large) {
                    //                direction = @"右上";
                    directionX = 1;
                    directionY = kDirectionUp;
                } else if (inclination >= -large && inclination <= small) {
                    //                direction = @"右";
                    directionX = 1;
                } else if (inclination > small && inclination < large) {
                    //                direction = @"右下";
                    directionX = 1;
                    directionY = kDirectionDown;
                } else if (inclination >= large) {
                    //                direction = @"下";
                    directionY = kDirectionDown;
                }
            } else {
                if (inclination <= -large) {
                    //                direction = @"下";
                    directionY = kDirectionDown;
                } else if (inclination < -small && inclination > -large) {
                    //                direction = @"左下";
                    directionX = -1;
                    directionY = kDirectionDown;
                } else if (inclination >= -large && inclination <= small) {
                    //                direction = @"左";
                    directionX = -1;
                } else if (inclination > small && inclination < large) {
                    //                direction = @"左上";
                    directionX = -1;
                    directionY = kDirectionUp;
                } else if (inclination >= large) {
                    //                direction = @"上";
                    directionY = kDirectionUp;
                }
            }
        }
        
    }
   
    if ((beforeDirectionX*10 + beforeDirectionY != directionX*10 + directionY)
        && !(directionX==0 && directionY==0)) {
        [soundManager play:E_SOUND_SOUND00];
    }
    
    //ここまで引いた線を画面に描く
    CGContextStrokePath(cgContext); 
    
//    [delegate sendDirectionKeyWithX:directionX y:directionY];

}
*/

/************************************************
 タッチ位置をコントローラの中心にリセットする（停止状態にする）
 ************************************************/
- (void)resetTouch {
    x = baseX;
    y = baseY;
}

//-----------------------------------------------
//
// タッチ
//
//-----------------------------------------------

/************************************************
 タッチ開始
 ************************************************/
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    keyAlpha = 1.0;
//    baseAlpha = 1.0;
    if (!isMute) {
        [soundManager play:E_SOUND_BUTTON];
    }
    isPushed = YES;
    
    for (UITouch *touch in touches) {
        CGPoint point = [touch locationInView:self];
        x = point.x;
        y = point.y;
        
        // 位置固定
        if (kControllerStyle == 0) {
        } else {
            baseX = x;
            baseY = y;
//            baseAlpha = 1.0f;
        }
//        [self setNeedsDisplay];
        break;
    }
}

/************************************************
 タッチ移動
 ************************************************/
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint point = [touch locationInView:self];
        x = point.x;
        y = point.y;
//        [self setNeedsDisplay];
        break;
    }
}

/************************************************
 タッチ終了
 ************************************************/
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    isPushed = NO;
//    keyAlpha = 0.0;
    // 位置固定
    /*
    if (kControllerStyle == 0) {
    } else {
        baseAlpha = 0.0f;
    }
     */

    x = baseX;
    y = baseY;
//    [self setNeedsDisplay];
    
}

/************************************************
 タッチキャンセル
 ************************************************/
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesCancelled");
//    [self setNeedsDisplay];

    isPushed = NO;
}


@end
