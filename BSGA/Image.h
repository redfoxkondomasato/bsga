//
//  Image.h
//  BSGA
//
//  Created by 近藤 雅人 on 12/05/04.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <QuartzCore/QuartzCore.h>

//Imageの宣言
@interface Image : NSObject {
    unsigned char* _data;  //データ
    GLuint         _name;  //名前
    int            _width; //幅
    int            _height;//高さ
}

//プロパティ
@property unsigned char* data;
@property GLuint         name;
@property int            width;
@property int            height;

//イメージの生成
+ (Image*)makeImage:(UIImage*)image;
+ (Image*)makeTextImage:(NSString*)text 
                   font:(UIFont*)font color:(UIColor*)color;
@end
