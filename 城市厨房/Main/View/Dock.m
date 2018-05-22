//
//  Dock.m
//  fuckthings
//
//  Created by 臧昊 on 15/1/13.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "Dock.h"
#import "DockItem.h"
#import "MainController.h"
#import "ShopCarController.h"
#import "AccountTool.h"
#import "LoginController.h"
#import "WBNavigationController.h"

@interface Dock ()
{
    DockItem *_SelectedDockItem;
}

@end

@implementation Dock

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"menubg_unselect.png"]]];
    }
    return self;
}

- (void)addDockItemWithIcon:(NSString *)icon andSelectedImage:(NSString *)selectedIcon title:(NSString *)title
{
    DockItem *dockItem = [[DockItem alloc]init];
    [dockItem setTitle:title forState:UIControlStateNormal];
    [dockItem setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [dockItem setImage:[UIImage imageNamed:selectedIcon] forState:UIControlStateSelected];
    [self addSubview:dockItem];
    [dockItem addTarget:self action:@selector(clickDockItem:) forControlEvents:UIControlEventTouchDown];
    
    NSInteger count = self.subviews.count;
    if (count == 1) {
//        dockItem.selected = YES;
//        _SelectedDockItem = dockItem;
        [self clickDockItem:dockItem];
    }
//    [UIView beginAnimations:nil context:nil];
    CGFloat dockItemWidth = self.frame.size.width / count;
    CGFloat dockItemHeight = self.frame.size.height;
    for (int i = 0; i < count; i ++) {
        DockItem *dockItems = self.subviews[i];
        dockItems.tag = i;
        dockItems.frame = CGRectMake(dockItemWidth * i, 0, dockItemWidth, dockItemHeight);
    }
//    [UIView commitAnimations];
}

- (void)clickDockItem:(DockItem *)selectedDockItem
{
    if (selectedDockItem.tag != 2) {    // 如果不是点击购物车
        if ([_delegate respondsToSelector:@selector(dock:itemSelectedFrom:To:)]) {
            [_delegate dock:self itemSelectedFrom:_SelectedDockItem.tag To:selectedDockItem.tag];
        }
        _SelectedDockItem.selected = NO;
        selectedDockItem.selected = YES;
        _SelectedDockItem = selectedDockItem;
        _selectedIndex = _SelectedDockItem.tag;
    }else {     // 点击购物车
        // 压入购物车视图
        if ([AccountTool sharedAccountTool].account) {
            ShopCarController *shopCar = [[ShopCarController alloc]init];
            MainController *main = (MainController *) self.window.rootViewController;
            UINavigationController *navi = (UINavigationController *) main.selectedController;
            [navi pushViewController:shopCar animated:YES];
        }else{
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未登录账号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alertView show];
            LoginController *loginController = [[LoginController alloc]initWithStyle:UITableViewStyleGrouped];
            WBNavigationController *nvc = [[WBNavigationController alloc]initWithRootViewController:loginController];
            // 弹出登录界面
            [self.window.rootViewController presentViewController:nvc animated:YES completion:nil];
        }
        
    }
}

@end
