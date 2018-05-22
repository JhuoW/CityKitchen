//
//  HeaderView.m
//  城市厨房
//
//  Created by 臧昊 on 15/1/30.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "HeaderView.h"
#import "UIImage+ZH.h"
#import "AccountTool.h"
#import "CouponsController.h"
#import "MainController.h"


@interface HeaderView()
{
    UIButton *_balanceBtn;
    UIButton *_discountBtn;
    
}

@end

@implementation HeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"my_litchen_top.png"]];
        _balanceBtn = [self addBottomBtn:@"余额" index:0];
        _discountBtn = [self addBottomBtn:@"优惠券" index:1];
        [_discountBtn addTarget:self action:@selector(showCouponsDetail) forControlEvents:UIControlEventTouchUpInside];
        [self addCenterButtonAndLabel];
        
        // 判断是显示登录按钮还是显示账户名
        if ([AccountTool sharedAccountTool].account) {
            [_registerButton removeFromSuperview];
            [_loginButton removeFromSuperview];
//            _discountLabel.text = @"0";
//            _balanceLabel.text = @"0";
        }else{
            [_userNameLabel removeFromSuperview];
            [_evalLabel removeFromSuperview];
        }
    }
    return self;
}

- (void)showCouponsDetail
{
    if ([AccountTool sharedAccountTool].account) {
        CouponsController *couponsController = [[CouponsController alloc]initWithStyle:UITableViewStyleGrouped];
        //    NSLog(@"%@", [_listArray[indexPath.row] detailCode]);
        MainController *main = (MainController *) self.window.rootViewController;
        UINavigationController *navi = (UINavigationController *) main.selectedController;
        [navi pushViewController:couponsController animated:YES];
    }
}

#pragma mark - 添加按钮方法
#pragma mark 添加中间按钮和标签
- (void)addCenterButtonAndLabel
{
    // 注册按钮
    CGFloat width = self.frame.size.width;
    _registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [_registerButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_registerButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1]] forState:UIControlStateNormal];
    _registerButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _registerButton.bounds = CGRectMake(0, 0, width / 4, 25);
    _registerButton.center = CGPointMake(width * 0.25, 40);
    
    [self addSubview:_registerButton];
    
    // 登录按钮
    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_loginButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1]] forState:UIControlStateNormal];
    _loginButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _loginButton.bounds = _registerButton.bounds;
    _loginButton.center = CGPointMake(width * 0.75, 40);
    [self addSubview:_loginButton];
    
    // 账号标签
    _userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width - 20, 30)];
    _userNameLabel.center = CGPointMake(width * 0.5, 35);
    _userNameLabel.font = [UIFont systemFontOfSize:25];
    _userNameLabel.textColor = [UIColor whiteColor];
    //    _userNameLabel.backgroundColor = [UIColor redColor];
    if ([AccountTool sharedAccountTool].account) {
        _userNameLabel.text = [AccountTool sharedAccountTool].account.userName;
    }
    [self addSubview:_userNameLabel];
    
    // 会员等级标签
    _evalLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width - 20, 20)];
    _evalLabel.center = CGPointMake(width * 0.5, 65);
    _evalLabel.font = [UIFont systemFontOfSize:18];
    _evalLabel.textColor = [UIColor whiteColor];
    _evalLabel.text = @"普通会员";
    [self addSubview:_evalLabel];
}
//添加底部按钮
- (UIButton *)addBottomBtn:(NSString *)optionName index:(int) i
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    // 设置图片
    //    [btn setImage:[UIImage imageNamed:@"menubg_unselect.png"]forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:RGBA(0, 0, 0, 0.5)]forState:UIControlStateNormal];
    
    // 调节图片与文字之间的间距
    //    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    //    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    // 设置每个按钮的frame
    CGFloat btnWidth = [UIScreen mainScreen].bounds.size.width / 2;
    CGFloat btnHeight = 40;
    CGFloat btnX = btnWidth * i + i * 2;
    CGFloat btnY = self.frame.size.height - btnHeight;
    btn.frame = CGRectMake(btnX, btnY, btnWidth, btnHeight);
    [self addSubview:btn];
    // 设置按钮的title
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, btnWidth, btnHeight )];
    [btn addSubview:titleLabel];
    // 调节字体大小
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = optionName;
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, btnHeight * 0.5, btnWidth, btnHeight * 0.5)];
    [btn addSubview:numLabel];
    numLabel.font = [UIFont systemFontOfSize:14];
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.textColor = [UIColor whiteColor];
    if (i == 0) {
        _balanceLabel = numLabel;
    }else{
        _discountLabel = numLabel;
    }
    return btn;
}



@end