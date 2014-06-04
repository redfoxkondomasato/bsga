//
//  AnimationManager.h
//  BSGA
//
//  Created by 近藤 雅人 on 12/05/25.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnimationManager : NSObject {
    
}
+ (void)popAnimationWithView:(UIView *)view
                    duration:(float)duration 
                       delay:(float)delay
                       alpha:(float)alpha;

+ (void)basicAnimationWithView:(UIView *)view 
                      duration:(float)duration 
                         delay:(float)delay
                       options:(UIViewAnimationOptions)options
                   fromToAlpha:(CGPoint)alpha
                  fromToRotate:(CGPoint)angle
                    beginScale:(CGPoint)beginScale
                   finishScale:(CGPoint)finishScale
                beginTranslate:(CGPoint)beginTranslate
               finishTranslate:(CGPoint)finishTranslate;
@end
