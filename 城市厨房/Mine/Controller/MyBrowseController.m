//
//  MyBrowseController.m
//  城市厨房
//
//  Created by 臧昊 on 15/3/11.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "MyBrowseController.h"
#import "MyBrowse.h"
#import "MyBrowseCell.h"

@interface MyBrowseController()<UIAlertViewDelegate>
{
    NSMutableArray *_browseArray;
    UILabel *_nilLabel;
}

@end

@implementation MyBrowseController
- (void)viewDidLoad
{
    self.title = @"浏览记录";
    _browseArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"browseProductCode"]];
    
    _nilLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    _nilLabel.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.5);
    _nilLabel.textAlignment = NSTextAlignmentCenter;
    _nilLabel.textColor = [UIColor grayColor];
    _nilLabel.text = @"暂无浏览记录~";
    [self addNav];
    if (!_browseArray.count) {
        [self.view addSubview:_nilLabel];
    }
}

- (void)addNav
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"清空" forState:UIControlStateNormal];
    //    btn.backgroundColor = [UIColor redColor];
    //    button1.enabled = NO;
    btn.bounds = CGRectMake(0, 0, 30, 15);
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [btn addTarget:self action:@selector(clickClearBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickClearBtn
{
    if (_browseArray.count) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定清空？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 1;
        [alertView show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1 && buttonIndex == 1) {
        // 删除沙盒中的浏览对象
        NSMutableArray *array = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"browseProductCode"]];
        [array removeAllObjects];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"browseProductCode"];
        // 快速执行上一句话
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // 通过获取的索引值删除数组中的值
        [_browseArray removeAllObjects];
        [self.tableView reloadData];
        [self.view addSubview:_nilLabel];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _browseArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark - 创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MyBrowseCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MyBrowseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.myBrowse = [NSKeyedUnarchiver unarchiveObjectWithData:_browseArray[indexPath.row]];
    return cell;
}

#pragma mark 删除cell代理
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        // 获取选中删除行索引值
        NSInteger row = [indexPath row];
        
        // 删除沙盒中的浏览对象
        NSMutableArray *array = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"browseProductCode"]];
        [array removeObjectAtIndex:row];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"browseProductCode"];
        // 快速执行上一句话
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // 通过获取的索引值删除数组中的值
        [_browseArray removeObjectAtIndex:row];
        // 删除单元格的某一行时，在用动画效果实现删除过程
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        if(_browseArray.count == 0){
            [self.view addSubview:_nilLabel];
        }
    }
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

@end
