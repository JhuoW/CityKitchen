//
//  GoodsListController.m
//  城市厨房
//
//  Created by 臧昊 on 15/2/9.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "GoodsListController.h"
#import "GoodsListDock.h"
#import "UIImage+ZH.h"
#import "DetailController.h"
//#import "GoodsDetailController.h"

@interface GoodsListController () <UITableViewDataSource,UITableViewDelegate>
{
    UITableViewController *_goodsListTableviewController;
}
@end

@implementation GoodsListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    GoodsListDock *listDock = [[GoodsListDock alloc]init];
    [self.view addSubview:listDock];
    
    
    _goodsListTableviewController = [[UITableViewController alloc] init];
    _goodsListTableviewController.tableView.backgroundColor = BackgroundColor;
    _goodsListTableviewController.tableView.delegate = self;
    _goodsListTableviewController.tableView.dataSource = self;
    _goodsListTableviewController.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _goodsListTableviewController.view.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44);
    [self.view addSubview:_goodsListTableviewController.tableView];
//    NSLog(@"%f", self.view.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

#pragma mark - 创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    cell.bounds = CGRectMake(0, 0, self.view.frame.size.width, 120);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height - 1, self.view.frame.size.width, 1)];
    
    lineImageView.image = [UIImage imageWithColor:RGB(208, 207, 211)];
    [cell.contentView addSubview:lineImageView];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中状态
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailController *goodsDetail = [[DetailController alloc]init];
    [self.navigationController pushViewController:goodsDetail animated:YES];
}

@end
