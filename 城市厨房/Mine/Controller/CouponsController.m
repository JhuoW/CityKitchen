//
//  CouponsController.m
//  城市厨房
//
//  Created by 臧昊 on 15/3/12.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "CouponsController.h"
#import "ModelManager.h"
#import "ModelRequestResult.h"
#import "AccountTool.h"
#import "MJRefresh.h"

@interface CouponsController()
{
    long _pageNo;
    NSMutableArray *_couponsArray;
    UILabel *_nilCouponsLabel;
}

@end

@implementation CouponsController

- (void)viewDidLoad
{
    self.title = @"优惠券列表";
    self.view.backgroundColor = BackgroundColor;
    _pageNo = 1;
    [[ModelManager sharedManager]httpRequestGetUserCouponsWithUserCode:[AccountTool sharedAccountTool].account.userCode PageNo:1];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userCouponsFinished:) name:kModelRequestGetUserCoupons object:nil];
    
    _couponsArray = [NSMutableArray array];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}

- (void)footerRereshing
{
    if (_couponsArray.count % 12) {
        _pageNo = _couponsArray.count / 12 + 2;
    }else{
        _pageNo = _couponsArray.count / 12 + 1;
    }
    [[ModelManager sharedManager] httpRequestGetUserCouponsWithUserCode:[AccountTool sharedAccountTool].account.userCode PageNo:(int)_pageNo];
}

- (void)userCouponsFinished:(NSNotification *)notification
{
    ModelRequestResult *result = [notification.userInfo objectForKey:DICT_MODEL_REQUEST_RESULT_KEY];
    NSDictionary *dict = result.responseObject;
    if ([dict[@"ret"] isEqualToString:@"success"]) {
        for (NSDictionary *dictionary in dict[@"couponList"]) {
            [_couponsArray addObject:dictionary];
        }
        [self.tableView reloadData];
    }
    [self.tableView footerEndRefreshing];
    if (!_couponsArray.count) {
        _nilCouponsLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        _nilCouponsLabel.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.5);
        _nilCouponsLabel.textAlignment = NSTextAlignmentCenter;
        _nilCouponsLabel.textColor = [UIColor grayColor];
        _nilCouponsLabel.text = @"暂无优惠券~";
        [self.view addSubview:_nilCouponsLabel];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _couponsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

#pragma mark - 创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.bounds = CGRectMake(0, 0, self.view.frame.size.width, 100);
        cell.backgroundColor = RGB(103, 103, 103);
    }
    
    UILabel *label_1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 30)];
    //    label_1.backgroundColor = [UIColor redColor];
    label_1.textAlignment = NSTextAlignmentCenter;
    label_1.font = [UIFont systemFontOfSize:32];
    label_1.textColor = [UIColor whiteColor];
    label_1.text = [NSString stringWithFormat:@"￥%@",_couponsArray[indexPath.section][@"account"]];
    [cell.contentView addSubview:label_1];
    
    
    UILabel *label_2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 75, self.view.frame.size.width, 15)];
    //    label_2.backgroundColor = [UIColor redColor];
    label_2.textAlignment = NSTextAlignmentCenter;
    label_2.font = [UIFont systemFontOfSize:12];
    label_2.textColor = [UIColor whiteColor];
    label_2.text = [NSString stringWithFormat:@"优惠券号:%@", _couponsArray[indexPath.section][@"code"]];
    [cell.contentView addSubview:label_2];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

@end
