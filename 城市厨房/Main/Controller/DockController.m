//
//  DockController.m
//  fuckthings
//
//  Created by 臧昊 on 15/1/13.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "DockController.h"
#import "ShopCarController.h"
@interface DockController () <DockDelegate>


@end

@implementation DockController 

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    [self addDock];
    
}


- (void)addDock
{
    Dock *dock = [[Dock alloc] init];
    dock.frame = CGRectMake(0, self.view.frame.size.height - kDockHeight, self.view.frame.size.width, kDockHeight);
    [self.view addSubview:dock];
    _dock = dock;
    _dock.delegate = self;
}

- (void)dock:(Dock *)dock itemSelectedFrom:(NSInteger)from To:(NSInteger)to
{
    if (to < 0 || to >= self.childViewControllers.count) return;
    
    _selectedController = self.childViewControllers[to];
    // 上一个视图从父视图中删除
    UIViewController *oldViewController = self.childViewControllers[from];
    [oldViewController.view removeFromSuperview];
    // 添加选中视图
    UIViewController *newView = self.childViewControllers [to];
    [self.view addSubview:newView.view];
    // 设置新视图frame
    CGFloat height = self.view.frame.size.height - kDockHeight;
    CGFloat width = self.view.frame.size.width;
    newView.view.frame = CGRectMake(0, 0, width, height);
}

@end
