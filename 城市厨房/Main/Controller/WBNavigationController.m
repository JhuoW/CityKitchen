//
//  WBNavigationController.m
//  fuckthings
//
//  Created by 臧昊 on 15/1/16.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "WBNavigationController.h"
#import "UIImage+ZH.h"
@implementation WBNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINavigationBar *bar = [UINavigationBar appearance];
//    [bar setFrame: CGRectMake(0, 0, self.view.window.frame.size.width, 24)];
    // 设置bar背景图片
    [bar setBackgroundImage:[UIImage imageWithColor:kBackgroundGeenColor] forBarMetrics:UIBarMetricsDefault];
    // 设置bar相关属性
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSBackgroundColorAttributeName : [UIColor blackColor]}];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
//                                                                      }];
//    [bar setTitleVerticalPositionAdjustment:0 forBarMetrics:UIBarMetricsDefaultPrompt];
//    UIBarMetrics metric = UIBarMetricsDefaultPrompt;
    
    
//    UIBarButtonItem *item = [UIBarButtonItem appearance];
//    //  设置item属性
//    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor]} forState:UIControlStateNormal];
//    // 设置item背景图片
//    [item setBackgroundImage:[UIImage imageNamed:@"navigationbar_button_background.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    [item setBackgroundImage:[UIImage imageNamed:@"navigationbar_button_background_pushed.png"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
}



@end
