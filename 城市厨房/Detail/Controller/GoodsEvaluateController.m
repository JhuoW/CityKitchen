//
//  GoodsEvaluateController.m
//  城市厨房
//
//  Created by 臧昊 on 15/3/19.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "GoodsEvaluateController.h"

@interface GoodsEvaluateController ()
{
    UILabel *_nilLabel;
}

@end

@implementation GoodsEvaluateController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    self.title = @"商品评价";
    _nilLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    _nilLabel.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.5);
    _nilLabel.textAlignment = NSTextAlignmentCenter;
    _nilLabel.textColor = [UIColor grayColor];
    _nilLabel.text = @"暂无评价~";
    [self.view addSubview:_nilLabel];
}
@end
