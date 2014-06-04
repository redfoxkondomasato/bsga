//
//  LogTableViewController.h
//  BSGA
//
//  Created by 近藤 雅人 on 12/06/17.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogTableViewCell.h"
#import "Misc.h"
@interface LogTableViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    
    IBOutlet UIButton *backButton;
    IBOutlet UITableView *mTableView;
    
    NSMutableData *data;
    NSMutableArray *cellDataArray;
}

@end
