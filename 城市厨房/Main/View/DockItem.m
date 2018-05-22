//
//  DockItem.m
//  fuckthings
//
//  Created by 臧昊 on 15/1/13.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "DockItem.h"


@implementation DockItem
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置title
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        // 设置图片
        self.imageView.contentMode = UIViewContentModeCenter;
        // 设置选中背景
        [self setBackgroundImage:[UIImage imageNamed:@"menubg_select.png"] forState:UIControlStateSelected];
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat height =contentRect.size.height ;
    CGFloat width = contentRect.size.width ;
    return CGRectMake(0, 0, width, height );
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat height =contentRect.size.height;
    CGFloat width = contentRect.size.width;
    return CGRectMake(0, height * kDockItemImageHeightProportion, width, height * (1 - kDockItemImageHeightProportion - 0.1));
}
@end
