//
//  BSGAAppDelegate.h
//  BSGA
//
//  Created by 近藤 雅人 on 12/04/21.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "TopViewController.h"
#import "SoundManager.h"

@interface BSGAAppDelegate : UIResponder <UIApplicationDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver> {
    
}
@property (nonatomic, strong) SoundManager *soundManager;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, weak) id delegate;

- (void)payEasyMode;
- (void)payGachaPoints;

@end
