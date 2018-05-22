//
//  MyOrderController.m
//  城市厨房
//
//  Created by 臧昊 on 15/2/21.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "MyOrderController.h"
#import "MyOrderCell.h"
#import "ModelManager.h"
#import "ModelRequestResult.h"
#import "AccountTool.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"

@interface MyOrderController()
{
    UILabel *_nilLabel;
    NSMutableArray *_myOrderArray;
    
    long _pageNo;
    MBProgressHUD *_hud;
}

@end

@implementation MyOrderController
- (void)viewDidLoad
{
    self.title = @"我的订单";
    _pageNo = 1;
    [[ModelManager sharedManager]httpRequestGetUserOrderWithUserCode:[AccountTool sharedAccountTool].account.userCode PageNo:(int)_pageNo];
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userOrderFinished:) name:kModelRequestGetUserOrder object:nil];
    _myOrderArray = [NSMutableArray array];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}

- (void)footerRereshing
{
    //    [_goodsListTableview footerBeginRefreshing];
    if (_myOrderArray.count % 12) {
        _pageNo = _myOrderArray.count / 12 + 2;
    }else{
        _pageNo = _myOrderArray.count / 12 + 1;
    }
    [[ModelManager sharedManager]httpRequestGetUserOrderWithUserCode:[AccountTool sharedAccountTool].account.userCode PageNo:(int)_pageNo];
    
}

- (void)userOrderFinished:(NSNotification *)notification
{
    ModelRequestResult *result = [notification.userInfo objectForKey:DICT_MODEL_REQUEST_RESULT_KEY];
    NSDictionary *dict = result.responseObject;
    if ([dict[@"ret"] isEqualToString:@"success"]) {
        
        for (NSDictionary *dictionary in dict[@"orderList"]) {
            Order *order = [[Order alloc]initWithDict:dictionary];
            [_myOrderArray addObject:order];
        }
        [self.tableView reloadData];
    }
    if (_myOrderArray.count == 0) {
        [self addNilLabel];
    }
    [_hud hide:YES];
    [self.tableView footerEndRefreshing];
}

// 订单为空时
- (void)addNilLabel
{
    _nilLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
    _nilLabel.center = CGPointMake(self.view.frame.size.width * 0.5, (self.view.frame.size.height - 64) * 0.5);
    _nilLabel.textAlignment = NSTextAlignmentCenter;
    _nilLabel.textColor = [UIColor grayColor];
    _nilLabel.text = @"暂无订单~";
    [self.view addSubview:_nilLabel];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _myOrderArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

#pragma mark - 创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld", (long)indexPath.section];
    MyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MyOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.order = _myOrderArray[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

@end
