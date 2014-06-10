//
//  CustomWebViewController.h
//  SuperExcitingConfrontationFree
//
//  Created by 近藤 雅人 on 12/07/22.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CustomWebViewController : UIViewController<UIWebViewDelegate>
{
    IBOutlet UIWebView *mWebView;
    IBOutlet UIBarButtonItem *closeBarButtonItem;
    IBOutlet UIBarButtonItem *prevBarButtonItem;
    IBOutlet UIBarButtonItem *nextBarButtonItem;
    
    IBOutlet UIToolbar *toolbar;
    
    NSString *urlString;
    
}
- (void)setupWebViewWithUrl:(NSString *)urlString;
@end
