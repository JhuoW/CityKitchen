//
//  SearchViewController.m
//  城市厨房
//
//  Created by 臧昊 on 15/1/27.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "SearchViewController.h"
#import "GoodsListController.h"
#import "ModelManager.h"
#import "ModelRequestResult.h"
#import "WBNavigationController.h"
#import "MainController.h"

@interface SearchViewController ()<UISearchBarDelegate>

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    [self addNavView];
}

- (void) addNavView
{
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
//    [cancelButton setTitle:@"fuck" forState:UIControlStateHighlighted];
    cancelButton.bounds = CGRectMake(0, 0, 50, 15);
    [cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchDown];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cancelButton];
    
    
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    searchBar.delegate = self;
    [searchBar becomeFirstResponder];

    self.navigationItem.titleView = searchBar;
//    NSLog(@"%@",NSStringFromCGRect(self.navigationItem.titleView.frame));
}

- (void)cancelClick
{
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    MainController *main = (MainController *)self.view.window.rootViewController;
    UINavigationController *nav = (UINavigationController *)main.selectedController;
    GoodsListController *list = [[GoodsListController alloc]init];
    list.listCode = @"3917f501-333a-11e4-b6da-00163e024610";
    [nav pushViewController:list animated:YES];
    
    [searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:NO completion:nil];
    
//    WBNavigationController *nav = [[WBNavigationController alloc]initWithRootViewController:list];
    
//    [self presentViewController:nav animated:NO completion:nil];
    
//    [self.navigationController pushViewController:list animated:YES];
    
    
}

@end
