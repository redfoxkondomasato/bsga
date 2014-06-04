//
//  Canvas.h
//  BSGA
//
//  Created by 近藤 雅人 on 12/05/04.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

//Canvasの実装
@interface Canvas : UIView {    
@private
    //描画
    EAGLContext* _context;        //コンテキスト
    GLint        _bgWidth;        //背景幅
    GLint        _bgHeight;       //背景高さ
    GLuint       _viewRenderBuff; //レンダーバッファ
    GLuint       _viewFrameBuff;  //フレームバッファ
    GLuint       _depthRenderBuff;//デプスレンダーバッファ
    BOOL         _initFlag;       //初期化フラグ
    
    //アニメ
    NSTimer* __weak _animeTimer;//アニメタイマー
}

//描画
@property(readonly) GLint bgWidth;
@property(readonly) GLint bgHeight;

//描画
- (void)setup;
- (void)onTick;
- (void)calcGame;

//アニメ
- (void)startAnime:(int)interval;
- (void)stopAnime;
@end