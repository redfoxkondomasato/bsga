//
//  CustomWebViewController.m
//  SuperExcitingConfrontationFree
//
//  Created by 近藤 雅人 on 12/07/22.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import "CustomWebViewController.h"

@implementation CustomWebViewController

/***************************************************************
 * 破棄
 ***************************************************************/
- (void)dealloc {
    [mWebView setDelegate:nil];
}

/***************************************************************
 * 初期化
 ***************************************************************/
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

/***************************************************************
 * ビュー読み込み後
 ***************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    [toolbar setAlpha:0.85f];
    [mWebView setDelegate:self];
    
    [closeBarButtonItem setTarget:self];
    [closeBarButtonItem setAction:@selector(closeBarButtonItemPushed)];
    
    [prevBarButtonItem setTarget:self];
    [prevBarButtonItem setAction:@selector(prevBarButtonItemPushed)];
    
    [nextBarButtonItem setTarget:self];
    [nextBarButtonItem setAction:@selector(nextBarButtonItemPushed)];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [mWebView loadRequest:urlRequest];
    
}

/***************************************************************
 * メモリ警告後
 ***************************************************************/
- (void)viewDidUnload
{
    [super viewDidUnload];
}

/***************************************************************
 * セットアップ
 ***************************************************************/
- (void)setupWebViewWithUrl:(NSString *)string {
    urlString = string;
}

/***************************************************************
 * 閉じるボタン
 ***************************************************************/
- (void)closeBarButtonItemPushed {
    [self dismissModalViewControllerAnimated:YES];
}

/***************************************************************
 * 戻るボタン
 ***************************************************************/
- (void)prevBarButtonItemPushed {
    [mWebView goBack];
}
/***************************************************************
 * 進むボタン
 ***************************************************************/
- (void)nextBarButtonItemPushed {
    [mWebView goForward];
}

/***************************************************************
 * 
 * UIWebViewDelegate
 *
 ***************************************************************/
/***************************************************************
 * 読み込み開始
 ***************************************************************/
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}
/***************************************************************
 * 読み込み完了
 ***************************************************************/
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];    
}

/***************************************************************
 * 読み込み前
 ***************************************************************/
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked || navigationType == UIWebViewNavigationTypeOther) {
        if ([request.URL.host isEqualToString:@"itunes.apple.com"]) {
            [[UIApplication sharedApplication] openURL:request.URL];
            return NO;
        }
    }
    
    return YES;
}

/***************************************************************
 * エラー
 ***************************************************************/
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    if (error.code == -999) {
        return;
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [[[UIAlertView alloc] initWithTitle:@"error"
                                 message:nil
                                delegate:nil
                       cancelButtonTitle:@"x"
                       otherButtonTitles:nil, nil] show];
}



@end
