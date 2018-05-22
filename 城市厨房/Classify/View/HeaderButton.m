//
//  HeaderButton.m
//  城市厨房
//
//  Created by 臧昊 on 15/2/2.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "HeaderButton.h"
#import "UIImageView+WebCache.h"
@interface HeaderButton()
{
    UIImageView *_iconView;
    UIImageView *_accessoryView;
    NSString *_icon;
    UILabel *_mainTitle;
}
@end

@implementation HeaderButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isOpen = NO;
        self.backgroundColor = [UIColor whiteColor];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        // 添加imageview
        [self addView];
    }
    return self;
}


- (void) addView
{
    // 图标
    _iconView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.height * 0.7, self.frame.size.height * 0.7)];
    _iconView.center = CGPointMake(self.frame.size.height * 0.5 , self.frame.size.height * 0.5);
    [self addSubview:_iconView];
    
    // 主标题
    _mainTitle = [[UILabel alloc]init];
    _mainTitle.frame = CGRectMake(self.frame.size.height * 0.85, self.frame.size.height * 0.2, self.frame.size.width - self.frame.size.height * 0.85, 20);
    _mainTitle.font = [UIFont systemFontOfSize:16];
    _mainTitle.textColor = [UIColor blackColor];
    [self addSubview:_mainTitle];
    
    // 子标题
    _subTitle = [[UILabel alloc]init];
    _subTitle.frame = CGRectMake(self.frame.size.height * 0.85, self.frame.size.height * 0.6, self.frame.size.width - self.frame.size.height * 0.85 - 40, 20);
//    _subTitle.backgroundColor = [UIColor redColor];
    _subTitle.font = [UIFont systemFontOfSize:13];
    _subTitle.textColor = [UIColor grayColor];
    [self addSubview:_subTitle];
    
    // 导航图标
    _accessoryView = [[UIImageView alloc]init];
    UIImage *image = [UIImage imageNamed:@"cat2.png"];
    _accessoryView.bounds = (CGRect){CGPointZero, image.size};
    _accessoryView.center = CGPointMake(self.frame.size.width - 30, self.frame.size.height * 0.5);
    _accessoryView.image = image;
    [self addSubview:_accessoryView];
    
}

// 设置图标
- (void)setIcon:(NSString *)icon
{
    _iconView.image = [UIImage imageNamed:icon];
}

// 设置accessoryView
- (void)setIsOpen:(BOOL)isOpen
{
    _isOpen = isOpen;
    _accessoryView.image = isOpen ? [UIImage imageNamed:@"cat1.png"] : [UIImage imageNamed:@"cat2.png"];
}

// 设置图标、主标题
- (void)setCategoryTop:(CategoryTop *)categoryTop
{
    [_iconView sd_setImageWithURL:[NSURL URLWithString:categoryTop.icon] placeholderImage:[UIImage imageNamed:@"defualt_goods_img.png"]];
    _mainTitle.text = categoryTop.categoryName;
    
//    NSLog(@"≥≥≥≥≥≥≥≥≥≥≥≥%@",categoryTop.icon);
    
}

@end
