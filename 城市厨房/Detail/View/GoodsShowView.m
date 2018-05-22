//
//  GoodsShowView.m
//  城市厨房
//
//  Created by 臧昊 on 15/2/14.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "GoodsShowView.h"
#import "UIImageView+WebCache.h"

@interface GoodsShowView()<UIScrollViewDelegate>
{
    // 图片展示
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    CGFloat _width;
    CGFloat _height;
    
    // 商品名称
    UILabel *_goodsName;
    UILabel *_goodsPrice;
}
@end

@implementation GoodsShowView

- (instancetype)initWithFrame:(CGRect)frame andDetailGoods:(DetailGoods *)detailGoods
{
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化scrollView
        _scrollView = [[UIScrollView alloc]init];
        // 设置scrollView的大小
        _scrollView.bounds = CGRectMake(0, 0, 220, 175);
        _scrollView.center = CGPointMake(self.frame.size.width * 0.5, 175 * 0.5);
        _width = _scrollView.frame.size.width;
        _height = _scrollView.frame.size.height;
        // 隐藏水平、垂直滚动条
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        // 设置代理
        _scrollView.delegate = self;
        // 设置scrollView的contentSize
        _scrollView.contentSize = CGSizeMake(detailGoods.pics.count * _scrollView.frame.size.width, _scrollView.frame.size.height);
        // 设置分页
        [_scrollView setPagingEnabled:YES];
        [self addSubview:_scrollView];
        
        // 添加scrollImage
        for (NSInteger i = 0; i < detailGoods.pics.count; i++) {
            // 初始化iamgeView
            UIImageView *imageView = [[UIImageView alloc]init];
            // 图片路径
            if ([detailGoods.pics[i] rangeOfString:@"http"].length) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:detailGoods.pics[i]] placeholderImage:[UIImage imageNamed:@"defualt_iv_400.png"]];
            }else{
                NSString *imageUrl = [kImageURL stringByAppendingString:detailGoods.pics[i]];
                [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"defualt_iv_400.png"]];
            }
            imageView.frame = CGRectMake(i * _width, 0, _width, _height);
            [_scrollView addSubview:imageView];
        }
        // 初始化pageControl
        _pageControl = [[UIPageControl alloc] init];
        // 设置pageControl位置和大小
        _pageControl.center = CGPointMake(self.frame.size.width *0.5, _height * 0.9);
        _pageControl.bounds = CGRectMake(0, 0, 150, 0);
        // 设置pageControl属性
        _pageControl.numberOfPages = detailGoods.pics.count ;
        // 设置pageControl图片
        UIImage *currentImage = [UIImage imageNamed:@"new_feature_pagecontrol_checked_point.png"];
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:currentImage];
        UIImage *noCurrentImage = [UIImage imageNamed:@"new_feature_pagecontrol_point.png"];
        _pageControl.pageIndicatorTintColor = [UIColor colorWithPatternImage:noCurrentImage];
        [self addSubview:_pageControl];
        
        _goodsName = [[UILabel alloc]initWithFrame:CGRectMake(10, _scrollView.frame.size.height + 15, self.frame.size.width - 20, 15)];
        _goodsName.textColor = [UIColor blackColor];
        _goodsName.font = [UIFont systemFontOfSize:12];
//        _goodsName.backgroundColor = [UIColor redColor];
        _goodsName.text = detailGoods.name;
        [self addSubview:_goodsName];
        
        if (detailGoods.prices.count) {
            _goodsPrice = [[UILabel alloc]initWithFrame:CGRectMake(10, _scrollView.frame.size.height + 15 + _goodsName.frame.size.height + 10, self.frame.size.width - 20, 20)];
            _goodsPrice.textColor = kBackgroundGeenColor;
            NSString *price = detailGoods.prices[0][@"price"];
            NSString *unit = detailGoods.prices[0][@"spec"];
            if (price) {
                _goodsPrice.text = [NSString stringWithFormat:@"￥%@/%@",price, unit];
            }
        }
        [self addSubview:_goodsPrice];
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _pageControl.currentPage = scrollView.contentOffset.x  / scrollView.frame.size.width ;
}

@end
