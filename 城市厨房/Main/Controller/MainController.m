//
//  MainController.m
//  fuckthings
//
//  Created by 臧昊 on 15/1/10.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "MainController.h"
#import "Dock.h"
#import "HomeController.h"
#import "ClassifyController.h"
#import "ShopCarController.h"
#import "MineController.h"
#import "MoreController.h"
#import "WBNavigationController.h"
#import "UIBarButtonItem+ZH.h"

#define MENU_POPOVER_FRAME  CGRectMake(100, 0, 140, 88)

@interface MainController () <UINavigationControllerDelegate>
@end
@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
    [self addChildViewControllers];
    [self addDockItem];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}

- (void)addDockItem
{
    
    [_dock addDockItemWithIcon:@"menu_home_unselected.png" andSelectedImage:@"menu_home_unselected.png" title:@"首页"];
    [_dock addDockItemWithIcon:@"menu_unselected_search.png" andSelectedImage:@"menu_unselected_search.png" title:@"分类"];
    [_dock addDockItemWithIcon:@"menu_shopcar_unselected.png" andSelectedImage:@"menu_shopcar_unselected.png" title:@"购物车"];
    [_dock addDockItemWithIcon:@"menu_personal_unselected.png" andSelectedImage:@"menu_personal_unselected.png" title:@"我的"];
    [_dock addDockItemWithIcon:@"menu_more_unselected.png" andSelectedImage:@"menu_more_unselected.png" title:@"更多"];
    
}

- (void)addChildViewControllers
{
    HomeController *home = [[HomeController alloc]initWithStyle:UITableViewStyleGrouped];
    WBNavigationController *nav1 = [[WBNavigationController alloc]initWithRootViewController:home];
    nav1.delegate = self;
    [self addChildViewController:nav1];
    
    ClassifyController *classify = [[ClassifyController alloc]initWithStyle:UITableViewStyleGrouped];
    WBNavigationController *nav2 = [[WBNavigationController alloc]initWithRootViewController:classify];
    nav2.delegate = self;
    [self addChildViewController:nav2];
    
    ShopCarController *shopping = [[ShopCarController alloc]init];
    WBNavigationController *nav3 = [[WBNavigationController alloc]initWithRootViewController:shopping];
    [self addChildViewController:nav3];
    
    MineController *mine = [[MineController alloc]initWithStyle:UITableViewStyleGrouped];
    WBNavigationController *nav4 = [[WBNavigationController alloc]initWithRootViewController:mine];
    nav4.delegate = self;
    [self addChildViewController:nav4];
    
    MoreController *more = [[MoreController alloc]initWithStyle:UITableViewStyleGrouped];
    WBNavigationController *nav5 = [[WBNavigationController alloc]initWithRootViewController:more];
    nav5.delegate = self;
    [self addChildViewController:nav5];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - navigationcontroller代理方法    *实现弹出视图细节*
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 1.获取当前导航栏控制器的根控制器
    UIViewController *rootViewController = navigationController.viewControllers[0];
    if (viewController != rootViewController)   // 要展示的控制器不是根控制器（下移Dock）
    {
        [UIView animateWithDuration:0.2f animations:^{
            
            // 2.dock下移
            CGRect newDockFrame = _dock.frame;
            newDockFrame.origin.y += 1 * kDockHeight;
            _dock.frame = newDockFrame;
            
            // 3.拉长导航控制器view
            CGRect navigationFrame = navigationController.view.frame;
            navigationFrame.size.height = [UIScreen mainScreen].bounds.size.height;
            navigationController.view.frame = navigationFrame;
        }];
        // 4.添加左上角返回按钮
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem initWithIcon:@"left_image.png" highlightedIcon:@"left_image.png" target:self action:@selector(back)];
    }else{                                      // 当前控制器是根控制器 （上移Dock）
        [UIView animateWithDuration:0.2f animations:^{
            // 上移Dock
            CGRect newDockFrame = _dock.frame;
            newDockFrame.origin.y = self.view.frame.size.height - kDockHeight;
            _dock.frame = newDockFrame;
            // 缩短导航控制器view
            CGRect navigationFrame = navigationController.view.frame;
            navigationFrame.size.height = [UIScreen mainScreen].bounds.size.height - kDockHeight;
            navigationController.view.frame = navigationFrame;
        }];
        
    }
}
- (void)back
{
    [self.childViewControllers[_dock.selectedIndex] popViewControllerAnimated:YES];
}



@end
