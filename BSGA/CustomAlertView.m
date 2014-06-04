//
//  CustomAlertView.m
//  BSGA
//
//  Created by 近藤 雅人 on 12/07/20.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import "CustomAlertView.h"

@implementation CustomAlertView


- (void)show {
    
    [super show];
   
    
    UIView *v = [[self subviews] objectAtIndex:0];
    
    for (UIView *subview in [self subviews]) {
        PrintLog(@"sub = %@", [subview class]);
        
        if ([[subview class] isSubclassOfClass:[UIImageView class]]) {
            v = subview;
            break;
        }
    }
    
    if ([[UIImageView class] isSubclassOfClass:[v class]]) {
        UIImageView *popupView = (UIImageView *) v;
        [popupView setImage:[UIImage imageNamed:@"window_bg3"]];        

    }
    
    PrintLog(@"終わり");     
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        touchBeganPoint = [touch locationInView:[self superview]];
        touchBeganCenterPoint = self.center;
        break;
        
    }
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint point = [touch locationInView:[self superview]];
        [self setCenter:CGPointMake(touchBeganCenterPoint.x + point.x - touchBeganPoint.x,
                                    touchBeganCenterPoint.y + point.y - touchBeganPoint.y)];
        
        break;
    }

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self dismissWithClickedButtonIndex:0 animated:YES];

}

@end
