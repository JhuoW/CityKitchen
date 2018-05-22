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
#import "ModelManager.h"
#import "ModelRequestResult.h"
#import "ListGoods.h"
#import "listCell.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"

@interface GoodsListController () <UITableViewDataSource,UITableViewDelegate, GoodsListDockDelegate>
{
//    UITableViewController *_goodsListTableviewController;
    UITableView *_goodsListTableview;
//    ListGoods *_listGoods;
    NSMutableArray *_listArray;
    GoodsListDock *_listDock;
    long _pageNo;
    MBProgressHUD *_hud;
    NSString *_field;
    NSString *_sort;
}
@end

@implementation GoodsListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    self.title = @"商品列表";
    _listArray = [NSMutableArray array];
    _listDock = [[GoodsListDock alloc]init];
    _listDock.delegate = self;
    
    //设置默认排序字段
    _field = @"sale";
    _sort = @"desc";
    _pageNo = 1;
    [self.view addSubview:_listDock];
    [self addGoodsListTableView];
     [_goodsListTableview addFooterWithTarget:self action:@selector(footerRereshing)];
    if (kCheckNetStatus) {
        
        if (_listCode) {    // 显示二级分类商品
            [[ModelManager sharedManager] httpRequestGetGoodsListInformationWithCode:_listCode PageNo:(int)_pageNo Field:_field Sort:_sort];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listInformationFinished:) name:kModelRequestGetGoodsListInformation object:nil];
        }else{              // 显示商家商品
            [[ModelManager sharedManager] httpRequestGetCompanyGoodsWithCompanyCode:_companyCode PageNo:(int)_pageNo Field:_field Sort:_sort];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(companyGoodsFinished:) name:kModelRequestGetCompanyAllGoods object:nil];
        }
        _hud = [MBProgressHUD showHUDAddedTo:_goodsListTableview animated:YES];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查网络设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil ];
        [alertView show];
    }
}

- (void)footerRereshing
{
//    [_goodsListTableview footerBeginRefreshing];
    if (_listArray.count % 12) {
        _pageNo = _listArray.count / 12 + 2;
    }else{
        _pageNo = _listArray.count / 12 + 1;
    }
    if (_listCode) {
        [[ModelManager sharedManager] httpRequestGetGoodsListInformationWithCode:_listCode PageNo:(int)_pageNo Field:_field  Sort:_sort];
    }else{
        [[ModelManager sharedManager] httpRequestGetCompanyGoodsWithCompanyCode:_companyCode PageNo:(int)_pageNo Field:_field Sort:_sort];
    }
    
}

- (void)listInformationFinished: (NSNotification *)notification
{
    
    ModelRequestResult *result = [notification.userInfo objectForKey:DICT_MODEL_REQUEST_RESULT_KEY];
    
    if (result.succ) {
        if ((int)_pageNo == 1) {
            [_listArray removeAllObjects];
            _goodsListTableview.contentOffset = CGPointMake(0, 0);
        }
        NSDictionary *dict = result.responseObject;
        if ([dict[@"ret"] isEqualToString:@"success"]) {
            NSArray *array = [result.responseObject objectForKey:@"productList"];
            for (NSDictionary *goods in array) {
                ListGoods *listGoods = [[ListGoods alloc]initWithDict:goods];
                [_listArray addObject: listGoods];
            }
            
            if (!_listArray.count) {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
                label.center = _goodsListTableview.center;
                label.textAlignment = NSTextAlignmentCenter;
                label.text = @"商品尚未更新~";
                label.textColor = [UIColor grayColor];
                [self.view addSubview:label];
            }
            [_goodsListTableview reloadData];
        }
        
    }
    [_hud hide:YES];
    [_goodsListTableview footerEndRefreshing];
}

- (void)companyGoodsFinished:(NSNotification *)notification
{
    ModelRequestResult *result = [notification.userInfo objectForKey:DICT_MODEL_REQUEST_RESULT_KEY];
    if (result.succ) {
        if ((int)_pageNo == 1) {
            [_listArray removeAllObjects];
            [_goodsListTableview setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        NSDictionary *dict = result.responseObject;
        if ([dict[@"ret"] isEqualToString:@"success"]) {
            NSArray *array = [result.responseObject objectForKey:@"productList"];
            for (NSDictionary *goods in array) {
                ListGoods *listGoods = [[ListGoods alloc]initWithDict:goods];
                [_listArray addObject: listGoods];
            }
            // 当没有商品时
            if (!_listArray.count) {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
                label.center = self.view.center;
                label.textAlignment = NSTextAlignmentCenter;
                label.text = @"商品尚未更新~";
                label.textColor = [UIColor grayColor];
                [self.view addSubview:label];
            }
            [_goodsListTableview reloadData];
        }
    }
    [_hud hide:YES];
    [_goodsListTableview footerEndRefreshing];
}

- (void)addGoodsListTableView
{
    _goodsListTableview = [[UITableView alloc] init];
    _goodsListTableview.backgroundColor = BackgroundColor;
    _goodsListTableview.delegate = self;
    _goodsListTableview.dataSource = self;
    _goodsListTableview.separatorStyle = UITableViewCellSelectionStyleNone;
    _goodsListTableview.frame = CGRectMake(0, kDockHeight, self.view.frame.size.width, self.view.frame.size.height - kDockHeight * 2 - 20);
    [self.view addSubview:_goodsListTableview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}


#pragma mark - 创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    listCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[listCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
//    cell.bounds = CGRectMake(0, 0, self.view.frame.size.width, 120);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.listGoods = _listArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中状态
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailController *goodsDetail = [[DetailController alloc]init];
    NSLog(@"%@", [_listArray[indexPath.row] detailCode]);
    goodsDetail.detailCode = [_listArray[indexPath.row] detailCode];
    [self.navigationController pushViewController:goodsDetail animated:YES];
}

#pragma mark - GoodsListDock代理
- (void)goodsListDockField:(NSString *)field SortedBy:(NSString *)sort
{
    _field = field;
    _sort = sort;
    _pageNo = 1;
    if (_listCode) {
        [[ModelManager sharedManager] httpRequestGetGoodsListInformationWithCode:_listCode PageNo:(int)_pageNo Field:_field  Sort:_sort];
    }else{
        [[ModelManager sharedManager] httpRequestGetCompanyGoodsWithCompanyCode:_companyCode PageNo:(int)_pageNo Field:_field Sort:_sort];
    }
    _hud = [MBProgressHUD showHUDAddedTo:_goodsListTableview animated:YES];
}

@end
