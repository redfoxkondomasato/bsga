//
//  BSGAAppDelegate.m
//  BSGA
//
//  Created by 近藤 雅人 on 12/04/21.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import "BSGAAppDelegate.h"


@implementation BSGAAppDelegate

@synthesize soundManager;
@synthesize window = _window;
@synthesize delegate;
/************************************************
 破棄
 ************************************************/

/************************************************
 アプリケーション開始
 ************************************************/
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    soundManager = [[SoundManager alloc] init];
    
    TopViewController *topViewController
    = [[TopViewController alloc] initWithNibName:@"TopViewController" bundle:nil];
 
    UINavigationController *navigationController
    = [[UINavigationController alloc] initWithRootViewController:topViewController];
    [navigationController setNavigationBarHidden:YES];
    
    
    // window背景
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"window_bg"]];
    [imageView setFrame:CGRectMake(0, 0, 320, 480)];
    [self.window addSubview:imageView];

    
    [self.window setRootViewController:navigationController];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)payEasyMode {
    if (![SKPaymentQueue canMakePayments]) {
        [[[CustomAlertView alloc] initWithTitle:@"アプリ内購入制限"
                                   message:@"設定で機能制限されています"
                                  delegate:nil
                         cancelButtonTitle:@"その通りです"
                           otherButtonTitles:nil] show];
        return;
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    NSSet *set = [NSSet setWithObjects:kInAppPurchaseEasyMode, nil];
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    [productsRequest setDelegate:self];
    [productsRequest start];
    
}

- (void)payGachaPoints {
    if (![SKPaymentQueue canMakePayments]) {
        [[[CustomAlertView alloc] initWithTitle:@"アプリ内購入制限"
                                     message:@"設定で機能制限されています"
                                    delegate:nil
                           cancelButtonTitle:@"その通りです"
                           otherButtonTitles:nil] show];
        return;
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    NSSet *set = [NSSet setWithObjects:kInAppPurchaseGachaPoints, nil];
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    [productsRequest setDelegate:self];
    [productsRequest start];
    
}


- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    if (response == nil) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        return;
    }
    
    for (NSString *identifier in response.invalidProductIdentifiers) {
        PrintLog(@"invalid = %@", identifier);
    }
         
    for (SKProduct *product in response.products) {
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
//    PrintLog(@"購入処理中");
    for (SKPaymentTransaction *transaction in transactions) {
        if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
//            PrintLog(@"購入成功 %@", transaction.payment.productIdentifier);
            
            
            [delegate paymentDone];
            
            [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

            
        } else if (transaction.transactionState == SKPaymentTransactionStateRestored) {
            [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        } else if (transaction.transactionState == SKPaymentTransactionStateFailed) {
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
    }
    
}

@end
