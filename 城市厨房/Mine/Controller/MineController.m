//
//  MineController.m
//  城市厨房
//
//  Created by 臧昊 on 15/1/20.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "MineController.h"
#import "HeaderView.h"
#import "UIImage+ZH.h"
#import "LoginController.h"
#import "WBNavigationController.h"
#import "AccountTool.h"
#import "MyAccountController.h"
#import "MyOrderController.h"
#import "RegisterController.h"
#import "MyCollectController.h"
#import "MyBrowseController.h"
#import "EvaluateController.h"

#pragma mark - 底部退出按钮
@interface logoutButton : UIButton
@end

@implementation logoutButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat x = 10;
    CGFloat y = 0;
    CGFloat width = contentRect.size.width - 2 * x;
    CGFloat height = contentRect.size.height;
    return CGRectMake(x, y, width, height);
}
@end

@interface MineController ()<UIAlertViewDelegate>
{
    HeaderView * _headerView;
    NSArray *_data;
    UIButton *_button1;
    UIButton *_button2;
    UIButton *_button3;
    UIButton *_logout;
}
@end

@implementation MineController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"我的厨房";
    [ self.tableView setSeparatorInset : UIEdgeInsetsMake(0, 0, 0, 0) ];
    [self loadPlist];
    if ([AccountTool sharedAccountTool].account) {
        [self addLogoutBtn];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:@"loginSuccess" object:nil];
}

- (void)loginSuccess:(NSNotification *)notification
{
    // 添加登出按钮
    [self addLogoutBtn];
    [self.tableView reloadData];
}

- (void)addLogoutBtn
{
    logoutButton *logout = [logoutButton buttonWithType:UIButtonTypeCustom];
    
    [logout setImage:[UIImage resizedImage:@"common_button_big_red.png"] forState:UIControlStateNormal];
    [logout setImage:[UIImage resizedImage:@"common_button_big_red_highlighted.png"] forState:UIControlStateHighlighted];
    
    // tableFooterView的宽度不需要设置。默认就是整个tableView的宽度。
    logout.bounds = CGRectMake(0, 0, 0, 44);
    
    // 设置按钮文字
    [logout setTitle:@"退出登录" forState:UIControlStateNormal];
    // logout.contentEdgeInsets = UIEdgeInsetsMake(0, 100, 0, 100);
    
    // 设置tableView整体的边界
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    //    UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
    
    self.tableView.tableFooterView = logout;
    [logout addTarget:self action:@selector(showAlertView) forControlEvents:UIControlEventTouchUpInside];
    _logout = logout;
}

- (void)showAlertView
{
    if ([AccountTool sharedAccountTool].account) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定要登出吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

#pragma mark AlertView代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[AccountTool sharedAccountTool] removeAccount];
        [_logout removeFromSuperview];
    }
    [self.tableView reloadData];
}

// 加载plist文件
- (void)loadPlist
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Mine" withExtension:@"plist"];
    
    _data = [NSArray arrayWithContentsOfURL:url];
//    NSLog(@"%@",_data);
}

// 返回组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _data.count;
}

// 返回每组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return [_data[section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        _headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 140)];
        [_headerView.registerButton addTarget:self action:@selector(registerButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
        // 判断是否登录账号！！！！
        if ([AccountTool sharedAccountTool].account) {
            cell.accessoryView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"common_arrow.png"]];
        }else{
            cell.accessoryView = nil;
        }
        [cell.contentView addSubview:_headerView];
    }else {
        NSDictionary *dict = _data[indexPath.section][indexPath.row];
        cell.textLabel.text = dict[@"name"];
        UIImage *icon = [UIImage imageNamed:dict[@"icon"]];
        cell.imageView.image = icon;
        
        cell.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        //设置acceseoryView
        cell.accessoryView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"common_arrow.png"]];
        
    }
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return _headerView.frame.size.height;
    }
    else{
        return 44;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }else{
        return 1;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        return 40;
    }
    return 15;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if ([AccountTool sharedAccountTool].account) {
            [self.navigationController pushViewController:[[MyAccountController alloc]initWithStyle:UITableViewStyleGrouped] animated:YES];
            return;
        }
    }
    if ([AccountTool sharedAccountTool].account) {
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                [self.navigationController pushViewController:[[MyOrderController alloc]initWithStyle:UITableViewStyleGrouped] animated:YES];
            }else{
                [self.navigationController pushViewController:[[EvaluateController alloc]initWithStyle:UITableViewStyleGrouped] animated:YES];
            }
        }else if (indexPath.section == 2){
            if (indexPath.row == 0) {
                [self.navigationController pushViewController:[[MyCollectController alloc]initWithStyle:UITableViewStyleGrouped] animated:YES];
            }else{
                [self.navigationController pushViewController:[[MyBrowseController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
            }
        }
    }else{
        [self loginButtonClick];
    }
}

// 登录按钮触发
- (void)loginButtonClick
{
    LoginController *loginController = [[LoginController alloc]initWithStyle:UITableViewStyleGrouped];
    WBNavigationController *nvc = [[WBNavigationController alloc]initWithRootViewController:loginController];
    // 弹出登录界面
    [self presentViewController:nvc animated:YES completion:nil];
}

// 登录按钮触发
- (void)registerButtonClick
{
    RegisterController *registerController = [[RegisterController alloc]initWithStyle:UITableViewStyleGrouped];
    WBNavigationController *nvc = [[WBNavigationController alloc]initWithRootViewController:registerController];
    // 弹出登录界面
    [self presentViewController:nvc animated:YES completion:nil];
}



@end
