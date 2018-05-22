//
//  ClassifyController.m
//  城市厨房
//
//  Created by 臧昊 on 15/1/20.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "ClassifyController.h"
#import "HeaderButton.h"
#import "SubClassifyController.h"
#import "GoodsListController.h"
#import "ModelManager.h"
#import "ModelRequestResult.h"
#import "CategoryTop.h"
#import "CategoryChild.h"
#import "HttpTool.h"
#import "MBProgressHUD.h"

@interface ClassifyController ()
{
    NSMutableArray *_headers;
    NSMutableArray *_categoryTopArray;
    NSMutableArray *_categoryChildArray;
    MBProgressHUD *_hud;
    NSMutableArray *_childNameArray;
    // 判断是否删除子类数组；
    BOOL isClearSubClassify;
}
@end

@implementation ClassifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分类";
    self.view.backgroundColor = BackgroundColor;
    self.tableView.rowHeight = (self.view.frame.size.height - 88) * 0.2;
    isClearSubClassify = 1;
    //    [ self.tableView setSeparatorInset : UIEdgeInsetsMake(0, 0, 0, 0) ];
    _headers = [NSMutableArray array];
    _categoryTopArray = [NSMutableArray array];
    _categoryChildArray = [NSMutableArray array];
    // 用于装载子标题
    _childNameArray = [NSMutableArray array];
    
    // 获取沙盒内商品分类并赋值到_categoryTopArray数组
    NSMutableArray *array_categoryTop = [[[NSUserDefaults standardUserDefaults] objectForKey:@"categoryTop"] mutableCopy];
    // 判断是否沙盒内有数据,如果没有初始化一个数组
    if (array_categoryTop.count == 0) {
        array_categoryTop = [NSMutableArray array];
    }
    
    if(array_categoryTop.count){
        for (NSData *data in array_categoryTop) {
            // 解档
            CategoryTop *categoryTop = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [_categoryTopArray addObject:categoryTop];
            HeaderButton *btn = [[HeaderButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width * 11 / 40)];
            // 设置图标、主标题
            btn.categoryTop = categoryTop;
            
            [btn addTarget:self action:@selector(clickHeaderButton:) forControlEvents:UIControlEventTouchUpInside];
            [_headers addObject:btn];
        }
    }
    
    // 获取沙盒内商品分类并赋值到_categoryChildArray数组
    NSMutableArray *array_categoryChild = [[[NSUserDefaults standardUserDefaults] objectForKey:@"categoryChild"] mutableCopy];
    if (array_categoryChild.count == 0) {
        array_categoryChild = [NSMutableArray array];
    }
    if(array_categoryChild.count){
        for (NSArray *array in array_categoryChild) {
            NSMutableArray *array_categoryChild_2 = [NSMutableArray array];
            for (NSData *data in array) {
                CategoryChild *categoryChild = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                [array_categoryChild_2 addObject:categoryChild];
            }
            [_categoryChildArray addObject:array_categoryChild_2];
            
        }
        // 显示在一级分类上的二级分类
        for (int i = 0; i < _categoryChildArray.count; i ++) {
            if (_childNameArray.count) {
                [_childNameArray removeAllObjects];
            }
            for (CategoryChild *categoryChild in _categoryChildArray[i]) {
                [_childNameArray addObject:categoryChild.categoryName];
            }
            [_headers[i] subTitle].text = [_childNameArray componentsJoinedByString:@"/"];
            //            _childNameArray addObject:_categoryChildArray[i][]
        }
    }
    
    if (kCheckNetStatus)
    {
        [[ModelManager sharedManager] httpRequestGetCategoryTop];
        _hud = [MBProgressHUD showHUDAddedTo: [[UIApplication sharedApplication] keyWindow] animated:YES];
//        _hud.dimBackground = YES;
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络好像出错了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryChildFinished:) name:kModelRequestGetCategoryChild object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryTopFinished:) name:kModelRequestGetCategoryTop object:nil];
}

- (void)categoryTopFinished:(NSNotification *)notification
{
    ModelRequestResult *result = [notification.userInfo objectForKey:DICT_MODEL_REQUEST_RESULT_KEY];
    [_hud hide:YES];
    if (result.succ) {
        NSArray *topDataArray = [result.responseObject objectForKey:@"data"];
        
        [_categoryTopArray removeAllObjects];
        [_headers removeAllObjects];
        NSMutableArray *array = [[[NSUserDefaults standardUserDefaults] objectForKey:@"categoryTop"] mutableCopy];
        if (array.count) {
            [array removeAllObjects];
        }else{
            array = [NSMutableArray array];
        }
        
        for (NSDictionary *dict in topDataArray) {
            CategoryTop *categoryTop = [[CategoryTop alloc]init];
            [categoryTop initWithDict:dict];
            [_categoryTopArray addObject:categoryTop];
            
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:categoryTop];
            [array addObject:data];
            
            HeaderButton *btn = [[HeaderButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width * 11 / 40)];
            // 设置图标、主标题
            btn.categoryTop = categoryTop;
            
            [btn addTarget:self action:@selector(clickHeaderButton:) forControlEvents:UIControlEventTouchUpInside];
            [_headers addObject:btn];
            
            // 获取子类
            [[ModelManager sharedManager] httpRequestGetCategoryChildWithCode:categoryTop.code];
            
        }
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"categoryTop"];
        // 快速执行上一句话
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.tableView reloadData];
    }
    
}

- (void)categoryChildFinished:(NSNotification *)notification
{
    ModelRequestResult *result = [notification.userInfo objectForKey:DICT_MODEL_REQUEST_RESULT_KEY];
    if (result.succ) {
        NSArray *dataArray = [result.responseObject objectForKey:@"data"];
        
        NSMutableArray *array = [[[NSUserDefaults standardUserDefaults] objectForKey:@"categoryChild"] mutableCopy];
        
        if (isClearSubClassify) {
            [_categoryChildArray removeAllObjects];
            
            if (array.count) {
                [array removeAllObjects];
            }else{
                array = [NSMutableArray array];
            }
            isClearSubClassify = 0;
            
        }
        
        // 存放归档并放入沙盒的数据
        NSMutableArray *childArray_2 = [NSMutableArray array];
        // 存放未经过归档的数据
        NSMutableArray *childArray = [NSMutableArray array];
        for (NSDictionary *dict in dataArray) {
            CategoryChild *categoryChild = [[CategoryChild alloc]init];
            [categoryChild initWithDict:dict];
            [childArray addObject:categoryChild];
            
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:categoryChild];
            [childArray_2 addObject:data];
        }
        // 用于显示
        [_categoryChildArray addObject:childArray];
        
        // 用于存储于沙盒
        [array addObject:childArray_2];
        
        for (int i = 0; i < _categoryChildArray.count; i ++) {
            if (_childNameArray.count) {
                [_childNameArray removeAllObjects];
            }
            for (CategoryChild *categoryChild in _categoryChildArray[i]) {
                [_childNameArray addObject:categoryChild.categoryName];
            }
//            NSLog(@"%@",_headers);
            [_headers[i] subTitle].text = [_childNameArray componentsJoinedByString:@"/"];
            //            _childNameArray addObject:_categoryChildArray[i][]
        }
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"categoryChild"];
        // 快速执行上一句话
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.tableView reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HeaderButton *btn = _headers[section];
    NSInteger count = btn.isOpen ? [_categoryChildArray[section] count] :0;
    //
    return count;
    //    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return _categoryTopArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"99999999999999999%@",_categoryChildArray);
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)indexPath.section, (long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    CategoryChild *categoryChild = _categoryChildArray[indexPath.section][indexPath.row];
    //    NSLog(@"%@", categoryChild.categoryName);
    cell.textLabel.text = [NSString stringWithFormat:@"               %@",categoryChild.categoryName];
    //    cell.textLabel.textColor = [UIColor grayColor];
    //    cell.textLabel.text = [_headers[indexPath.section] classes][indexPath.row];
    cell.backgroundColor = BackgroundColor;
    cell.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"common_arrow.png"]];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _headers[section];
}

// 基类按钮点击事件
- (void)clickHeaderButton:(HeaderButton *)header
{
    // 保证子类都加载完毕
    if (_categoryChildArray.count == _categoryTopArray.count) {
        for (HeaderButton *btn in _headers) {
            if (btn != header) {
                btn.isOpen = NO;
            }
        }
        header.isOpen = !header.isOpen;
        [self.tableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_categoryChildArray.count) {
        GoodsListController *list = [[GoodsListController alloc]init];
        CategoryChild *categoryChild = _categoryChildArray[indexPath.section][indexPath.row];
        list.listCode =  categoryChild.listCode;
        [self.navigationController pushViewController:list animated:YES];
    }
    
    //    list.title = _array[indexPath.section][indexPath.row];
    
    
    //    _subClassifyController = [[SubClassifyController alloc]init];
    //    _subClassifyController.view.frame = CGRectMake(self.view.frame.size.width, 0 + self.tableView.contentOffset.y, self.view.frame.size.width * 0.5, self.view.frame.size.height );
    //    // 1.底层tableview停止滚动
    //    self.tableView.scrollEnabled = NO;
    //
    //    // 2.赋值数据数组，刷新subTableview
    //
    //    // 3.动画弹出subTableView
    //    [UIView animateWithDuration:0.3f animations:^{
    //
    //        [self.tableView addSubview:_subClassifyController.view];
    //        CGRect newFrame = _subClassifyController.view.frame;
    //        newFrame.origin.x -= self.view.frame.size.width * 0.5;
    //        _subClassifyController.view.frame = newFrame;
    //    }];
    //    // 4.表面覆盖半透明button
    //    _shadowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [_shadowButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
    //    _shadowButton.frame = CGRectMake(0, 0 + self.tableView.contentOffset.y,self.view.frame.size.width, self.view.frame.size.height);
    //    [_shadowButton addTarget:self action:@selector(clickShadowButton) forControlEvents:UIControlEventTouchDown];
    //    [self.view insertSubview:_shadowButton belowSubview:_subClassifyController.view];
}



- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.view.frame.size.width * 11 / 40;
    
}


@end
