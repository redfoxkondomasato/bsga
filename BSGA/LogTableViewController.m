//
//  LogTableViewController.m
//  BSGA
//
//  Created by 近藤 雅人 on 12/06/17.
//  Copyright (c) 2012年 レッドフォックス株式会社. All rights reserved.
//

#import "LogTableViewController.h"

@implementation LogTableViewController



- (void)viewDidLoad
{
    [super viewDidLoad];

    cellDataArray = nil;
    data = nil;

    
    [mTableView setDelegate:self];
    [mTableView setDataSource:self];
    
    [backButton addTarget:self action:@selector(backButtonPushed) forControlEvents:UIControlEventTouchUpInside];
    
    [self performSelectorInBackground:@selector(getData) withObject:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if ([cellDataArray count] > 0) {
//        PrintLog(@"return %d", [cellDataArray count]);
        return [cellDataArray count];
    } else {     
//        PrintLog(@"return 0");
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 //   PrintLog();

    static NSString *CellIdentifier = @"Cell";
    
    LogTableViewCell *cell = (LogTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        UIViewController *vc = [[UIViewController alloc] initWithNibName:@"LogTableViewCell" bundle:nil];
        cell = (LogTableViewCell *)vc.view;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell.numberLabel setText:[NSString stringWithFormat:@"No.%@",[Misc intToString:indexPath.row+1]]];
    
    NSArray *array = [NSArray arrayWithArray:[cellDataArray objectAtIndex:indexPath.row]];
    
    NSString *scoreString = [array objectAtIndex:14];
    
    if ([scoreString intValue] == 0) {
        [cell.contentView setBackgroundColor:[UIColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1.0f]];
    } else if ([scoreString intValue] < 1000) {
        [cell.contentView setBackgroundColor:[UIColor colorWithRed:0.7f green:0.7f blue:0.7f alpha:1.0f]];
    } else if ([scoreString intValue] < 5000) {
        [cell.contentView setBackgroundColor:[UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:1.0f]];
    } else if ([scoreString intValue] < 10000) {
        [cell.contentView setBackgroundColor:[UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f]];
    }
    
    NSString *payPointString = [array objectAtIndex:11];
    if ([payPointString intValue] == 0) {
        [cell.payPointLabel setTextColor:[UIColor blackColor]];
    }
    
    NSString *payGachaString = [array objectAtIndex:12];
    if ([payGachaString intValue] == 0) {
        [cell.payGachaLabel setTextColor:[UIColor blackColor]];
    }
    
    [cell.dateLabel setText:[array objectAtIndex:0]];
    [cell.launchCountLabel setText:[array objectAtIndex:1]];
    [cell.countryLabel setText:[array objectAtIndex:2]];
    [cell.deviceLabel setText:[array objectAtIndex:3]];
    
    [cell.shokyuLabel setText:[array objectAtIndex:4]];
    [cell.chukyuLabel setText:[array objectAtIndex:5]];
    [cell.jokyuLabel setText:[array objectAtIndex:6]];
    [cell.chokyuLabel setText:[array objectAtIndex:7]];
    
    [cell.gacha01Label setText:[array objectAtIndex:8]];
    [cell.gacha02Label setText:[array objectAtIndex:9]];
    [cell.gacha03Label setText:[array objectAtIndex:10]];
    
    [cell.payPointLabel setText:payPointString];
    [cell.payGachaLabel setText:payGachaString];
    
    [cell.deviceNameLabel setText:[array objectAtIndex:13]];

    [cell.scoreLabel setText:scoreString];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (void)backButtonPushed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getData {
//    PrintLog();

    data = [[NSMutableData alloc] init];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLRequest *request;
    NSURL *url = [NSURL URLWithString:@"http://ocogamas.sitemix.jp/bsga/log.log"];
    request = [NSURLRequest requestWithURL:url];
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    [data appendData:[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error]];
    
    if ([response statusCode] == 200) {
//        PrintLog(@"通信成功");

        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        // 改行で分割
        NSMutableArray *rowArray = [[NSMutableArray alloc] initWithArray:[string componentsSeparatedByString:@"\n"]];
        
        cellDataArray = [[NSMutableArray alloc] init];
        
        for (int i=[rowArray count]-1; i>=0; i--) {
            NSString *row = [rowArray objectAtIndex:i];
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[row componentsSeparatedByString:@","]];
            if ([array count] == 15) {
                [cellDataArray addObject:array];
            }
        }
        [self performSelectorOnMainThread:@selector(reloadTable) withObject:nil waitUntilDone:NO];
    }
    
}

- (void)reloadTable {
    PrintLog();
    [mTableView reloadData];
}

@end
