//
//  MyCollectController.m
//  城市厨房
//
//  Created by 臧昊 on 15/2/26.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "MyCollectController.h"
#import "AccountTool.h"
#import "ModelRequestResult.h"
#import "ModelManager.h"
#import "MyCollect.h"
#import "MyCollectCell.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"

@interface MyCollectController()
{
    NSMutableArray *_myCollectArray;
    UILabel *_nilCollectLabel;
    
    long _pageNo;
    MBProgressHUD *_hud;
    NSString *_field;
    NSString *_sort;
}

@end

@implementation MyCollectController
- (void)viewDidLoad
{
    self.title = @"我的收藏";
    _pageNo = 1;
    [[ModelManager sharedManager] httpRequestGetUserCollectWithUserCode:[AccountTool sharedAccountTool].account.userCode PageNo:(int)_pageNo];
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userCollectFinished:) name:kModelRequestGetUserCollect object:nil];
    _myCollectArray = [NSMutableArray array];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
}

- (void)footerRereshing
{
    //    [_goodsListTableview footerBeginRefreshing];
    if (_myCollectArray.count % 12) {
        _pageNo = _myCollectArray.count / 12 + 2;
    }else{
        _pageNo = _myCollectArray.count / 12 + 1;
    }
    [[ModelManager sharedManager] httpRequestGetUserCollectWithUserCode:[AccountTool sharedAccountTool].account.userCode PageNo:(int)_pageNo];
    
}

- (void)userCollectFinished: (NSNotification *)notification
{
    ModelRequestResult *result = [notification.userInfo objectForKey:DICT_MODEL_REQUEST_RESULT_KEY];
    NSDictionary *dict = result.responseObject;
    if ([dict[@"ret"] isEqualToString:@"success"]) {
        for (NSDictionary *dictionary in dict[@"productList"]) {
            MyCollect *myCollect = [[MyCollect alloc]initWithDict:dictionary];
            [_myCollectArray addObject:myCollect];
        }
        if (_myCollectArray.count == 0) {
            _nilCollectLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
            _nilCollectLabel.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.5);
            _nilCollectLabel.textAlignment = NSTextAlignmentCenter;
            _nilCollectLabel.textColor = [UIColor grayColor];
            _nilCollectLabel.text = @"暂无收藏~";
            [self.view addSubview:_nilCollectLabel];
        }else if (_myCollectArray.count){
            [_nilCollectLabel removeFromSuperview];
        }
        [self.tableView reloadData];
        
        
    }
    [_hud hide:YES];
    [self.tableView footerEndRefreshing];
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _myCollectArray.count;
}

#pragma mark - 创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MyCollectCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MyCollectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.myCollect = _myCollectArray[indexPath.row];
    return cell;
}

#pragma mark 删除cell代理
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        // 获取选中删除行索引值
        NSInteger row = [indexPath row];
        [[ModelManager sharedManager]httpRequestRemoveCollectedProduct:[_myCollectArray[row] productCode] WithUserCode:[AccountTool sharedAccountTool].account.userCode];
        // 通过获取的索引值删除数组中的值
        [_myCollectArray removeObjectAtIndex:row];
        // 删除单元格的某一行时，在用动画效果实现删除过程
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

@end
