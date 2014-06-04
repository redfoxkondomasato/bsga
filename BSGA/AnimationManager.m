//
//  AnimationManager.m
//  BSGA
//
//  Created by 近藤 雅人 on 12/05/25.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import "AnimationManager.h"

@implementation AnimationManager

+ (void)popAnimationWithView:(UIView *)view
                    duration:(float)duration 
                       delay:(float)delay 
                       alpha:(float)alpha{
    
    [view setAlpha:alpha];
    [view setTransform:CGAffineTransformMakeScale(0.5f, 0.5f)];
    
    [UIView animateWithDuration:duration/2.0f
                          delay:delay
                        options:(UIViewAnimationCurveEaseIn|UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         
                         [view setAlpha:1.0f];
                         [view setTransform:CGAffineTransformMakeScale(1.15f, 1.15f)];
                         
                     }completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:duration/4.0f
                                          animations:^{
                                              
                                              [view setTransform:CGAffineTransformMakeScale(0.85f, 0.85f)];
                                              
                                          }completion:^(BOOL finished) {
                                              
                                              [UIView animateWithDuration:duration/4.0f
                                                               animations:^{
                                                                   
                                                                   [view setTransform:CGAffineTransformMakeScale(1.0f, 1.0f)];
                                                               }
                                               ];
                                              
                                          }
                          ];
                     }
     ];
    
}

+ (void)basicAnimationWithView:(UIView *)view 
                      duration:(float)duration 
                         delay:(float)delay
                       options:(UIViewAnimationOptions)options
                   fromToAlpha:(CGPoint)alpha
                  fromToRotate:(CGPoint)angle
                    beginScale:(CGPoint)beginScale
                   finishScale:(CGPoint)finishScale
                beginTranslate:(CGPoint)beginTranslate
               finishTranslate:(CGPoint)finishTranslate {
    
    [view setAlpha:alpha.x];
    
    CGAffineTransform beginTransform = CGAffineTransformMakeRotation(angle.x);
    beginTransform = CGAffineTransformScale(beginTransform, beginScale.x, beginScale.y);
    beginTransform = CGAffineTransformTranslate(beginTransform, beginTranslate.x, beginTranslate.y);
    [view setTransform:beginTransform];
    
    CGAffineTransform finishTransform = CGAffineTransformMakeRotation(angle.y);
    finishTransform = CGAffineTransformScale(finishTransform, finishScale.x, finishScale.y);
    finishTransform = CGAffineTransformTranslate(finishTransform, finishTranslate.x, finishTranslate.y);
    
    
    [UIView animateWithDuration:duration
                          delay:delay
                        options:options
                     animations:^{
                         [view setAlpha:alpha.y];
                         [view setTransform:finishTransform];
                         
                     }completion:^(BOOL finished) {
                         
                     }
     ];
    
}

@end
