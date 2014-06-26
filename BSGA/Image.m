//
//  Image.m
//  BSGA
//
//  Created by 近藤 雅人 on 12/05/04.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import "Image.h"

//Imageの実装
@implementation Image

//シンセサイズ
@synthesize data  =_data;
@synthesize name  =_name;
@synthesize width =_width;
@synthesize height=_height;

//====================
//初期化
//====================
//初期化
- (id)init {
    if ((self=[super init])) {
        _data  =NULL;
        _name  =0;
        _width =0;
        _height=0;
    }
    return self;
}

//メモリ解放
- (void)dealloc {
    PrintLog();
    
    GLuint num=self.name;
    if (num!=0) glDeleteTextures(1,&num);
    if (_data!=NULL) free(_data);    
    
     
}

//====================
//イメージの生成
//====================
//テクスチャの生成
+ (BOOL)makeTeture:(UIImage*)image toOutput:(unsigned char**)textureData 
      andImageSize:(int*)pImageSize 
     andImageWidth:(int*)pImageWidth andImageHeight:(int*)pImageHeight {
    CGImageRef       imageRef;
    NSUInteger       i;
    int              textureSize = 0;
    int              imageWidth;
    int              imageHeight;
    NSUInteger       maxImageSize;
    CGContextRef     context;
    CGColorSpaceRef  colorSpace;
    BOOL             hasAlpha;
    size_t           bitsPerComponent;
    CGImageAlphaInfo info;
    if (!image) return NO;
    
    //イメージ情報の取得
    imageRef=[image CGImage];   
    imageWidth=CGImageGetWidth(imageRef);
    imageHeight=CGImageGetHeight(imageRef);
    if (imageWidth>imageHeight) {
        maxImageSize=imageWidth;
    } else {
        maxImageSize=imageHeight;
    }
    for (i=2;i<=1024;i*=2) {
        if (i>=maxImageSize) {
            textureSize=i;
            break;
        }
    }
    if (textureSize>512) return NO;
    *pImageSize  =textureSize;
    *pImageWidth =imageWidth;
    *pImageHeight=imageHeight;
    info=CGImageGetAlphaInfo(imageRef);
    
    //アルファ成分チェック
    hasAlpha=((info==kCGImageAlphaPremultipliedLast) || 
              (info==kCGImageAlphaPremultipliedFirst) || 
              (info==kCGImageAlphaLast) || 
              (info==kCGImageAlphaFirst)?YES:NO);
    colorSpace=CGColorSpaceCreateDeviceRGB();
    *textureData=(unsigned char*)malloc(textureSize*textureSize*4);
    if (!*textureData) {
		CGColorSpaceRelease(colorSpace);
		return NO;
    }
	if (hasAlpha) {
        bitsPerComponent=kCGImageAlphaPremultipliedLast;
    } else {
        bitsPerComponent=kCGImageAlphaNoneSkipLast;
    }
    context=CGBitmapContextCreate(*textureData,textureSize,textureSize, 
                                  8,4*textureSize,colorSpace,bitsPerComponent|kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    //画像ファイルの画像サイズ!=テクスチャのサイズの時
    if ((textureSize!=imageWidth) || (textureSize!=imageHeight)) {
        CGContextScaleCTM(context,
                          (CGFloat)textureSize/imageWidth,
                          (CGFloat)textureSize/imageHeight);
    }
    CGRect rect=CGRectMake(0,0,CGImageGetWidth(imageRef),
                           CGImageGetHeight(imageRef));
    
    CGContextClearRect(context,rect);
    CGContextDrawImage(context,rect,imageRef);
    CGContextRelease(context);
    return YES;
}

//イメージの生成
+ (Image*)makeImage:(UIImage*)image {
    unsigned char* textureData;
    GLuint         textureName;
    GLsizei        textureSize;
    GLsizei        textureWidth;
    GLsizei        textureHeight;
    
    //テクスチャの生成
    if ([Image makeTeture:image toOutput:(unsigned char**)&textureData 
             andImageSize:&textureSize 
            andImageWidth:&textureWidth andImageHeight:&textureHeight]) {
        //テクスチャの設定
        glGenTextures(1,&textureName);
        glBindTexture(GL_TEXTURE_2D,textureName);
        glTexImage2D(GL_TEXTURE_2D,0,GL_RGBA,textureSize,textureSize,
                     0,GL_RGBA,GL_UNSIGNED_BYTE,textureData);
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR); 
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR); 
        
        //テクスチャオブジェクトの生成
        Image* texture=[[Image alloc] init];
        texture.data=textureData;
        texture.name=textureName;
        texture.width=textureWidth;
        texture.height=textureHeight;
        return texture;
    } else {
        return nil;
    }
}

//テキストUIイメージの生成
+ (UIImage*)makeTextUIImage:(NSString*)text font:(UIFont*)font 
                      color:(UIColor*)color bgcolor:(UIColor*)bgcolor
{
    //ラベルの生成
    UILabel* label=[[UILabel alloc] init];
    NSDictionary *attributes = @{ NSForegroundColorAttributeName : color,
								  NSFontAttributeName : font,
                                  NSBackgroundColorAttributeName : bgcolor};

    // iOS7のみ。
	CGRect rect = [text boundingRectWithSize:CGSizeMake(512.0f, 512.0f)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];

    
    

    [text sizeWithFont:font constrainedToSize:CGSizeMake(512,512)
         lineBreakMode:NSLineBreakByWordWrapping];
    
    int width  = (int)(rect.size.width);
    int height = (int)(rect.size.height);
    [label setFrame:CGRectMake(0, 0, width, height)];
    [label setText:text];
    [label setFont:font];
    [label setTextColor:color];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setBackgroundColor:bgcolor];
    [label setNumberOfLines:0];
    
    //コンテキストの生成
    if (width<32)  { width=32; }
    if (height<32) { height=32; }
    unsigned char *bmpData;
    CGContextRef context;	
    CGColorSpaceRef colorSpace;
    
	bmpData = malloc(width * height * sizeof(unsigned char)*4);
    
    if (!bmpData)
    {
        PrintLog(@"bmpData is nil ... width=%d, height=%d", width, height);
    }
    
	colorSpace=CGColorSpaceCreateDeviceRGB();
    context = CGBitmapContextCreate(bmpData,
                                  width,height,8,width*4,
                                  colorSpace,
                                  kCGImageAlphaPremultipliedFirst);
    
    if (!context)
    {
        PrintLog(@"bmpData = %s", bmpData);
        PrintLog(@"context is nil. width=%d, height=%d", width, height);
    }

    
    CGContextSetShouldAntialias(context,0);
    CGContextClearRect(context,CGRectMake(0, 0, width, height));
    
    //コンテキストの設定
    UIGraphicsPushContext(context);
    CGContextTranslateCTM(context,0, height);
    CGContextScaleCTM(context,1,-1);    
    
    //ラベルの描画
    [label.layer renderInContext:context];
    
    
    CGImageRef imageRef = CGBitmapContextCreateImage(context);

    if (!imageRef)
    {
        PrintLog(@"imageRef is nil...");
    }

    
    UIImage* image=[[UIImage alloc] initWithCGImage:imageRef];

    if (image == nil)
    {
        PrintLog(@"image is nil...");
    }
    
    //コンテキストの設定解放
    UIGraphicsPopContext();
    
    //コンテキストの解放
	CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CGImageRelease(imageRef);
    free(bmpData);
    return image;
}

//テキストテクスチャの生成
+ (Image*)makeTextImage:(NSString*)text font:(UIFont*)font color:(UIColor*)color {
    UIImage* image = [Image makeTextUIImage:text
                                       font:font color:color bgcolor:[UIColor clearColor]];
    
    if (image == nil)
    {
        PrintLog(@"ERROR image is nil.");
    }
    Image *resultImage = [Image makeImage:image];
    if (resultImage == nil)
    {
        PrintLog(@"ERROR nil Result Image");
    }
    return resultImage;
}
@end