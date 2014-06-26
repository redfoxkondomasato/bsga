//
//  Graphics.m
//  BSGA
//
//  Created by 近藤 雅人 on 12/05/04.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import "Graphics.h"

//テクスチャ頂点情報
GLfloat panelVertices[]={
    0,  0, //左上
    0, -1, //左下
    1,  0, //右上
    1, -1, //右下
};

//テクスチャUV情報
const GLfloat panelUVs[]={
    0.0f, 0.0f, //左上
    0.0f, 1.0f, //左下
    1.0f, 0.0f, //右上
    1.0f, 1.0f, //右下
};

//Graphicsの実装
@implementation Graphics

//====================
//初期化
//====================
//初期化
- (id)init {
    if (self=[super init]) {
        //背景サイズ
        _bgSize=CGSizeMake(320,460);
        
        //色
        _color=GRAPHICS_BLACK;
        
        //グラフィックス設定
        _flipMode=GRAPHICS_FLIP_NONE;
        _originX =0;
        _originY =0;
        
        //文字列設定
        _fontSize=12;
        _textList=[[NSMutableArray alloc] init];
        _textMap =[[NSMutableDictionary alloc] init];
    }
    return self;
}

//メモリ解放
- (void)dealloc {
    PrintLog();
}

//初期化
- (void)initSize:(CGSize)size {    
    _bgSize=size;
    
    //ビューポート変換
    glViewport(0,0,_bgSize.width,_bgSize.height);
    
    //投影変換
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrthof(-_bgSize.width/2,_bgSize.width/2,
             -_bgSize.height/2,_bgSize.height/2,-100,100);    
    glTranslatef(-_bgSize.width/2,_bgSize.height/2,0);
    
    //モデリング変換    
    glMatrixMode(GL_MODELVIEW);
    
    //クリア色の設定
    glClearColor(1,1,1,1);
    
    //頂点配列の設定
    glVertexPointer(2,GL_FLOAT,0,panelVertices);
    glEnableClientState(GL_VERTEX_ARRAY);
    
    //UVの設定
    glTexCoordPointer(2,GL_FLOAT,0,panelUVs);
    
    //テクスチャの設定
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glEnable(GL_TEXTURE_2D);
    
    //ブレンドの設定
    glEnable(GL_BLEND);
    glBlendEquationOES(GL_FUNC_ADD_OES);
    glBlendFunc(GL_ONE,GL_ONE_MINUS_SRC_ALPHA);
    
    //ポイントの設定
    glEnable(GL_POINT_SMOOTH);
}

//クリア
- (void)clear {
    glClear(GL_COLOR_BUFFER_BIT); 
}


//====================
//クリッピング
//====================
//クリッピングの指定
- (void)clipRect_x:(GLfloat)x y:(GLfloat)y w:(GLfloat)w h:(GLfloat)h {
    GLfloat area0[4]={ 0,-1, 0,-y  };
    GLfloat area1[4]={ 0, 1, 0, y+h};
    GLfloat area2[4]={ 1, 0, 0,-x  };
    GLfloat area3[4]={-1, 0, 0, x+w};
    glClipPlanef(GL_CLIP_PLANE0,area0);
    glClipPlanef(GL_CLIP_PLANE1,area1);
    glClipPlanef(GL_CLIP_PLANE2,area2);
    glClipPlanef(GL_CLIP_PLANE3,area3);
    glEnable(GL_CLIP_PLANE0);
    glEnable(GL_CLIP_PLANE1);
    glEnable(GL_CLIP_PLANE2);
    glEnable(GL_CLIP_PLANE3);
}

//クリッピングのクリア
- (void)clearClip {
    glDisable(GL_CLIP_PLANE0);
    glDisable(GL_CLIP_PLANE1);
    glDisable(GL_CLIP_PLANE2);
    glDisable(GL_CLIP_PLANE3);
}


//====================
//色
//====================
//色の指定
- (void)setColor:(Color)color {
    _color=color;
}

//色の生成
+ (Color)makeColor_r:(int)r g:(int)g b:(int)b a:(int)a {
    Color color;
    color.r=r;
    color.g=g;
    color.b=b;
    color.a=a;
    return color;
}


//====================
//グラフィックス設定
//====================
//ライン幅の指定
- (void)setLineWidth:(float)lineWidth {
    glLineWidth(lineWidth);
    glPointSize(lineWidth);
}

//フリップモードの指定
- (void)setFlipMode:(int)flipMode {
    _flipMode=flipMode;
}


//減点の指定
- (void)setOrigin_x:(int)x y:(int)y {
    _originX=x;
    _originY=y;
}


//====================
//文字列設定
//====================
//フォントサイズの指定
- (void)setFontSize:(int)fontSize {
    _fontSize=fontSize;			
}

//フォントサイズの取得
- (int)getFontSize {
    return _fontSize;
}

//文字列幅の取得
- (int)stringWidth:(NSString*)text {
    return [text sizeWithFont:[UIFont systemFontOfSize:_fontSize]].width;  
}

//文字列高さの取得
- (int)stringHeight:(NSString*)text {
    return [text sizeWithFont:[UIFont systemFontOfSize:_fontSize]].height;  
}


//====================
//描画
//====================
//ラインの描画
- (void)drawLine_x0:(int)x0 y0:(int)y0 x1:(int)x1 y1:(int)y1 {
    GLfloat _vertexs[256*3];
    GLbyte  _colors[256*4];
    
    //頂点配列情報
    _vertexs[0]= x0;_vertexs[1]=-y0;_vertexs[2]=0;
    _vertexs[3]= x1;_vertexs[4]=-y1;_vertexs[5]=0;     
    
    //カラー配列情報
    for (int i=0;i<2;i++) {
        _colors[i*4  ]=_color.r;
        _colors[i*4+1]=_color.g;
        _colors[i*4+2]=_color.b;
        _colors[i*4+3]=_color.a;
    }
    
    //ラインの描画
    glBindTexture(GL_TEXTURE_2D,0);
    glEnableClientState(GL_COLOR_ARRAY);
    glVertexPointer(3,GL_FLOAT,0,_vertexs);
    glColorPointer(4,GL_UNSIGNED_BYTE,0,_colors);
//    glPushMatrix();
    glTranslatef(_originX,-_originY,0);
    glDrawArrays(GL_LINE_STRIP,0,2);
//    glPopMatrix();
}

//ポイントの描画
- (void)drawPoint_x:(int)x y:(int)y {
    GLfloat _vertexs[3];
    GLbyte  _colors[4];
    
    //頂点配列情報
    _vertexs[0]= x;_vertexs[1]=-y;_vertexs[2]=0;
//    _vertexs[3]= x+5;_vertexs[4]=-y+5;_vertexs[5]=0;     
    
    //カラー配列情報
//    for (int i=0;i<1;i++) {
        _colors[ 0 ]=_color.r;
        _colors[ 1]=_color.g;
        _colors[ 2]=_color.b;
        _colors[ 3]=_color.a;
//    }
    
    // ポイントの描画
    glBindTexture(GL_TEXTURE_2D,0);
    glEnableClientState(GL_COLOR_ARRAY);
    glVertexPointer(3,GL_FLOAT,0,_vertexs);
    glColorPointer(4,GL_UNSIGNED_BYTE,0,_colors);
//    glPushMatrix();
//    glTranslatef(_originX,-_originY,0);
//    glDrawArrays(GL_LINE_STRIP,0,2);
    glDrawArrays(GL_POINTS,0,1);
//    glPopMatrix();
}


//矩形の描画
- (void)drawRect_x:(int)x y:(int)y w:(int)w h:(int)h {
    GLfloat _vertexs[256*3];
    GLbyte  _colors[256*4];
    
    //頂点配列情報
    _vertexs[0]= x;  _vertexs[1] =-y;  _vertexs[2] =0;
    _vertexs[3]= x;  _vertexs[4] =-y-h;_vertexs[5] =0;  
    _vertexs[6]= x+w;_vertexs[7] =-y-h;_vertexs[8] =0;
    _vertexs[9]= x+w;_vertexs[10]=-y;  _vertexs[11]=0;  
    
    //カラー配列情報
    for (int i=0;i<4;i++) {
        _colors[i*4  ]=_color.r;
        _colors[i*4+1]=_color.g;
        _colors[i*4+2]=_color.b;
        _colors[i*4+3]=_color.a;
    }
    
    //ラインの描画
    glBindTexture(GL_TEXTURE_2D,0);
    glEnableClientState(GL_COLOR_ARRAY);
    glVertexPointer(3,GL_FLOAT,0,_vertexs);
    glColorPointer(4,GL_UNSIGNED_BYTE,0,_colors);
    glPushMatrix();
    glTranslatef(_originX,-_originY,0);
    glDrawArrays(GL_LINE_LOOP,0,4);
    glPopMatrix();
}

//矩形の塗り潰し
- (void)fillRect_x:(float)x y:(float)y w:(float)w h:(float)h {
    GLfloat _vertexs[256*3];
    GLbyte  _colors[256*4];
    
    //頂点配列情報
    _vertexs[0]= x;  _vertexs[1] =-y;  _vertexs[2] =0;
    _vertexs[3]= x;  _vertexs[4] =-y-h;_vertexs[5] =0;  
    _vertexs[6]= x+w;_vertexs[7] =-y;  _vertexs[8] =0;
    _vertexs[9]= x+w;_vertexs[10]=-y-h;_vertexs[11]=0;  
    
    //カラー配列情報
    for (int i=0;i<4;i++) {
        _colors[i*4  ]=_color.r;
        _colors[i*4+1]=_color.g;
        _colors[i*4+2]=_color.b;
        _colors[i*4+3]=_color.a;
    }
    
    //三角形の描画
    glBindTexture(GL_TEXTURE_2D,0);
    glEnableClientState(GL_COLOR_ARRAY);
    glVertexPointer(3,GL_FLOAT,0,_vertexs);
    glColorPointer(4,GL_UNSIGNED_BYTE,0,_colors);
    glPushMatrix();
    glTranslatef(_originX,-_originY,0);
    glDrawArrays(GL_TRIANGLE_STRIP,0,4);
    glPopMatrix();
}

//円の描画
- (void)drawCircle_x:(int)x y:(int)y r:(int)r {
    GLfloat _vertexs[256*3];
    GLbyte  _colors[256*4];
    int length=100;
    
    //頂点配列情報
    for (int i=0;i<length;i++) {
        float angle=2*M_PI*i/length;
        _vertexs[i*3+0]= x+cos(angle)*r;
        _vertexs[i*3+1]=-y+sin(angle)*r;
        _vertexs[i*3+2]=0;
    }
    
    //カラー配列情報
    for (int i=0;i<length;i++) {
        _colors[i*4  ]=_color.r;
        _colors[i*4+1]=_color.g;
        _colors[i*4+2]=_color.b;
        _colors[i*4+3]=_color.a;
    }
    
    //ラインの描画
    glBindTexture(GL_TEXTURE_2D,0);
    glEnableClientState(GL_COLOR_ARRAY);
    glVertexPointer(3,GL_FLOAT,0,_vertexs);
    glColorPointer(4,GL_UNSIGNED_BYTE,0,_colors);
    glPushMatrix();
    glTranslatef(_originX,-_originY,0);
    glDrawArrays(GL_LINE_LOOP,0,length);
//    glDrawArrays(GL_LINES, 0, length);
    
//    glDrawArrays(GL_POINTS,0,length);
    glPopMatrix();
}

//円の塗り潰し
- (void)fillCircle_x:(float)x y:(float)y r:(float)r {
    GLfloat _vertexs[256*3];
    GLbyte  _colors[256*4];
    int length=30+2;
    
    //頂点配列情報
    _vertexs[0]= x;
    _vertexs[1]=-y;
    _vertexs[2]=0;
    for (int i=1;i<length;i++) {
        float angle=2*M_PI*i/(length-2);
        _vertexs[i*3+0]= x+cos(angle)*r;
        _vertexs[i*3+1]=-y+sin(angle)*r;
        _vertexs[i*3+2]=0;
    }
    
    //カラー配列情報
    for (int i=0;i<length;i++) {
        _colors[i*4  ]=_color.r;
        _colors[i*4+1]=_color.g;
        _colors[i*4+2]=_color.b;
        _colors[i*4+3]=_color.a;
    }
    
    //ラインの描画
    glBindTexture(GL_TEXTURE_2D,0);
    glEnableClientState(GL_COLOR_ARRAY);
    glVertexPointer(3,GL_FLOAT,0,_vertexs);
    glColorPointer(4,GL_UNSIGNED_BYTE,0,_colors);
    glPushMatrix();
    glTranslatef(_originX,-_originY,0);
    glDrawArrays(GL_TRIANGLE_FAN,0,length);
    glPopMatrix();
}

//イメージの描画
- (void)drawImage:(Image*)image x:(int)x y:(int)y {
    if (image==nil) return;
    int dx=_originX+x;
    int dy=_originY+y;
    int dw=image.width;
    int dh=image.height;
    if (_flipMode==GRAPHICS_FLIP_HORIZONTAL) {
        dx+=image.width;
        dw=-image.width;
    } else if (_flipMode==GRAPHICS_FLIP_VERTICAL) {
        dy+=image.height;
        dh=-image.height;
    }
    glBindTexture(GL_TEXTURE_2D,image.name);
    glVertexPointer(2,GL_FLOAT,0,panelVertices);
    glDisableClientState(GL_COLOR_ARRAY);
    glPushMatrix();
    glTranslatef(dx,-dy,0);
    glScalef(dw,dh,1);
    glDrawArrays(GL_TRIANGLE_STRIP,0,4);
    glPopMatrix();
}

//イメージの描画
- (void)drawScaledImage:(Image*)image
                      x:(float)x y:(float)y w:(float)w h:(float)h
                     sx:(float)sx sy:(float)sy sw:(float)sw sh:(float)sh 
angle:(float)angle {    
 
    /*
    if (_flipMode==GRAPHICS_FLIP_HORIZONTAL) {
        sx=image.width-sw-sx;
    } else if (_flipMode==GRAPHICS_FLIP_VERTICAL) {
        sy=image.height-sh-sy;
    }
     */
    
    float dw=image.width*w/sw;
    float dh=image.height*h/sh;
    float dx=_originX+x-sx*w/sw;
    float dy=_originY+y-sy*h/sh;
    /*
    if (_flipMode==GRAPHICS_FLIP_HORIZONTAL) {
        dx+=dw;// x軸移動
        dw=-dw;// 幅（拡大縮小）
    } else if (_flipMode==GRAPHICS_FLIP_VERTICAL) {
        dy+=dh;// y軸移動
        dh=-dh;// 高さ（拡大縮小）
    }
    */
    [self clipRect_x:_originX+x y:_originY+y w:w h:h];
    glBindTexture(GL_TEXTURE_2D,image.name);
    glVertexPointer(2,GL_FLOAT,0,panelVertices);
    glDisableClientState(GL_COLOR_ARRAY);
    glPushMatrix();
    glRotatef(angle, 0.0f, 0.0f, 1.0f);

    if (angle == 0.0f) {
        glTranslatef(dx, -dy, 0.0f);        
    } else if (angle == 90.0f) {
        
        float tmp1 = h/sh;
        float tmp2 = sx*w/sw;
        
        float ay = (sy + sh)*tmp1 + tmp2;
        float ax = sy*tmp1 - tmp2;
        glTranslatef(-dy-ay, -dx+ax, 0.0f);
        
    } else if (angle == 180.0f) {
        
        
        float tmp1 = h/sh;
        float tmp2 = sx*w/sw;
        
        float ax = w + 2*tmp2;
        float ay = sy*2*tmp1 + h;
        
        glTranslatef(-dx-ax, dy+ay, 0.0f);
        
    } else if (angle == 270.0f) {
        
        float tmp1 = h/sh;
        float tmp2 = sx*w/sw;
        
        float ax = (sy + sh)*tmp1 + tmp2;
        float ay = sy*tmp1 - tmp2;
        glTranslatef(dy+ay, dx+ax, 0.0f);        
    }
  
    glScalef(dw, dh, 1.0f);
    glDrawArrays(GL_TRIANGLE_STRIP,0,4);
    glPopMatrix();
    
    [self clearClip];
}

//テキストイメージの生成
- (Image*)makeTextImage:(NSString*)text {
    NSString* key=[NSString stringWithFormat:@"%d,%d,%d,%d,%d,%@",
                   _fontSize,_color.r,_color.g,_color.b,_color.a,text];
    
    //イメージの取得
    Image* image=[_textMap objectForKey:key];
    if (image!=nil) {
        [_textList removeObject:image];
        [_textList insertObject:image atIndex:0];
        return image;
    }
    
    //イメージの生成
    image = [Image makeTextImage:text
                            font:[UIFont systemFontOfSize:_fontSize*2]
                           color:[UIColor colorWithRed:_color.r/255.0f green:_color.g/255.0f
                                                  blue:_color.b/255.0f alpha:_color.a/255.0f]];
    
    if (image == nil)
    {
        PrintLog(@"ERROR ==========... image == nil");
    }
    else
    {
        // 問題ないイメージ
    }
    
    image.width =image.width/2;
    image.height=image.height/2;
    [_textMap setObject:image forKey:key];
    [_textList insertObject:key atIndex:0];
    
    //イメージの削除
    if (_textList.count>TEXT_BUFF) {
        key=[_textList objectAtIndex:_textList.count-1];
        [_textMap removeObjectForKey:key];
        [_textList removeObjectAtIndex:_textList.count-1];
    }
    return image;
}

//文字列の描画
- (void)drawString:(NSString*)text x:(float)x y:(float)y {
    [self drawImage:[self makeTextImage:text] x:x y:y];
}
@end