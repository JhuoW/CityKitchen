//
//  GoodsListDock.m
//  城市厨房
//
//  Created by 臧昊 on 15/2/9.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "GoodsListDock.h"
#import "UIImage+ZH.h"
@interface GoodsListDock ()
{
    UIButton *_selectedBtn;
    UIView *_selectedView;
}
@end

@implementation GoodsListDock

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1)];
        lineImageView.image = [UIImage imageWithColor:RGB(218, 218, 218)];
        [self addSubview:lineImageView];
        [self addBtn:@"价格" index:0];
        [self addBtn:@"销量" index:1];
        [self addBtn:@"人气" index:2];
        self.userInteractionEnabled = YES;
        
        
        _selectedView = [[UIView alloc]init];
        _selectedView.backgroundColor = [UIColor clearColor];
        _selectedView.frame = CGRectMake(-(self.frame.size.width / 3), self.frame.size.height - 2, self.frame.size.width / 3, 3);
        [self addSubview:_selectedView];
    }
    return self;
}

// 设置位置
- (void)setFrame:(CGRect)frame
{
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    frame.size.height = 44;
    [super setFrame:frame];
}

#pragma mark 添加按钮方法
- (UIButton *)addBtn:(NSString *)optionName index:(int) i
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = i;
    // 设置按钮的title
    [btn setTitle:optionName forState:UIControlStateNormal];
    // 设置按钮title的颜色
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    // 调节字体大小
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    // 取消highlight状态
    [btn setAdjustsImageWhenHighlighted:NO];
    // 设置图片
    if (i == 0) {
        [btn setImage:[UIImage imageNamed:@"cat2.png"]forState:UIControlStateNormal];
//        if (_isPrice) {
//            [btn setImage:[UIImage imageNamed:@"cat1.png"] forState:UIControlStateSelected];
//        }else{
//            [btn setImage:[UIImage imageNamed:@"common_arrow.png"] forState:UIControlStateSelected];
//        }
//        
    }else{
        [btn setImage:[UIImage imageNamed:@"cat2.png"]forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"cat1.png"] forState:UIControlStateSelected];
    }
    
    // 设置dockItem的点击监听事件
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    // 调节图片与文字之间的间距
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    // 设置每个按钮的frame
    CGFloat btnWidth = [UIScreen mainScreen].bounds.size.width / 3;
    CGFloat btnHeight = 44;
    CGFloat btnX = btnWidth * i;
    CGFloat btnY = 0;
    btn.frame = CGRectMake(btnX, btnY, btnWidth, btnHeight);
    [self addSubview:btn];
    
    // 添加按钮中间的竖条
    if (i != 0) { // 如果index不等于0， 添加分割线
        UIImageView *divider = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_card_bottom_line.png"]];
        
        // 分割线的大小不要设置因为使用的是initwithImage这个方法，默认显示图片原始尺寸
        // 设置位置
        divider.center = CGPointMake(btn.frame.origin.x, 44 / 2);
        [self addSubview:divider];
    }
    return btn;
}

- (void)btnClick:(UIButton *)btn
{
    if (_selectedBtn && btn.tag != _selectedBtn.tag) { // 当点击的不是同一个button
        _selectedBtn.selected = NO;
    }
    if (btn.tag == 0) {
        _isPrice = !_isPrice;
        if (_isPrice) {
            [btn setImage:[UIImage imageNamed:@"cat1.png"] forState:UIControlStateSelected];
        }else{
            [btn setImage:[UIImage imageNamed:@"common_arrow.png"] forState:UIControlStateSelected];
        }
    }
    btn.selected = YES;
    _selectedView.backgroundColor = RGB(114, 165, 35);
    [UIView animateWithDuration:0.3 animations:^{
        CGPoint p = btn.center;
        p.y = self.frame.size.height - 2;
        _selectedView.center = p;
    }];
    _selectedBtn = btn;

}

@end
