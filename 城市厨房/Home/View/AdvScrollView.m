//
//  AdvScrollView.m
//  城市厨房
//
//  Created by 臧昊 on 15/1/31.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "AdvScrollView.h"
#import "UIImageView+WebCache.h"
#import "DetailController.h"
#import "MainController.h"
@interface AdvScrollView() <UIScrollViewDelegate>
{
    CGFloat _width;
    CGFloat _height;
}

@end

@implementation AdvScrollView

- (instancetype)initWithFrame:(CGRect)frame addScrollViewWithImages:(NSArray *)images
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        
        // 初始化scrollView
        _scrollView = [[UIScrollView alloc]init];
        // 设置scrollView的大小
        _scrollView.frame = frame;
        // 隐藏水平滚动条
        _scrollView.showsHorizontalScrollIndicator = NO;
        // 设置代理
        _scrollView.delegate = self;
        // 设置scrollView的contentSize
        _scrollView.contentSize = CGSizeMake((images.count + 2) * frame.size.width, frame.size.height);
        // 设置分页
        [_scrollView setPagingEnabled:YES];
        
        [self addSubview:_scrollView];
        
        _width = frame.size.width;
        _height = frame.size.height;
        
        // 添加scrollImage
        UIImageView *imageView = [[UIImageView alloc]init];
        if (images.count != 0) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:images[images.count - 1]] placeholderImage:[UIImage imageNamed:@"defualt_iv_400.png"]];
//            NSLog(@"%@",images[0]);
//            NSLog(@"%@",images[images.count - 1]);
        }
        
        
        imageView.frame = CGRectMake(0, 0, _width, _height);
        [_scrollView addSubview:imageView];
        
        for (NSInteger i = 0; i < images.count; i++) {
            // 初始化iamgeView
            UIImageView *imageView = [[UIImageView alloc]init];
            // 图片路径
            // NSString *imageName = images[i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:images[i]] placeholderImage:[UIImage imageNamed:@"defualt_iv_400.png"]];
            imageView.frame = CGRectMake((i + 1) * _width, 0, _width, _height);
            [_scrollView addSubview:imageView];            
        }
        if (images.count != 0) {
// 1.最右侧添加再添加第一张图片
            UIImageView *imageView2 = [[UIImageView alloc]init];
            [imageView2 sd_setImageWithURL:[NSURL URLWithString:images[0]] placeholderImage:[UIImage imageNamed:@"defualt_iv_400.png"]];
            imageView2.frame = CGRectMake((images.count + 1) * _width, 0, _width, _height);
            [_scrollView addSubview:imageView2];
        }
        [_scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
        
//        NSLog(@"%f", _scrollView.contentSize.width);
        // 初始化pageControl
        _pageControl = [[UIPageControl alloc] init];
        // 设置pageControl位置和大小
        _pageControl.center = CGPointMake(_width *0.5, _height * 0.85);
        _pageControl.bounds = CGRectMake(0, 0, 150, 0);
        // 设置pageControl属性
        _pageControl.numberOfPages = images.count ;
        
        // 设置pageControl图片
        UIImage *currentImage = [UIImage imageNamed:@"new_feature_pagecontrol_checked_point.png"];
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:currentImage];
        
        UIImage *noCurrentImage = [UIImage imageNamed:@"new_feature_pagecontrol_point.png"];
        _pageControl.pageIndicatorTintColor = [UIColor colorWithPatternImage:noCurrentImage];
        
        [self addSubview:_pageControl];
        
        [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(getResults) userInfo:nil repeats:YES];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        [self addGestureRecognizer:tapGestureRecognizer ];
    }
    return self;
}

- (void)getResults
{
    CGPoint point = _scrollView.contentOffset;
    point.x += self.frame.size.width;
    [_scrollView setContentOffset:point animated:YES];
}

#pragma mark - ScrollView滚动视图代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_scrollView.contentSize.width == _scrollView.contentOffset.x + self.frame.size.width)
    {
        CGPoint point = _scrollView.contentOffset;
        point.x = self.frame.size.width;
        [_scrollView setContentOffset:point animated:NO];
    }else if (_scrollView.contentOffset.x == 0)
    {
        CGPoint point = _scrollView.contentOffset;
        point.x = _scrollView.contentSize.width - 2 * self.frame.size.width;
        [_scrollView setContentOffset:point animated:NO];
    }
    _pageControl.currentPage = scrollView.contentOffset.x  / scrollView.frame.size.width - 1;
    
}
- (void)tapGestureAction:(UITapGestureRecognizer *)gesture
{
//    DetailController *detail = [[DetailController alloc] init];
//    NSLog(@"123334");
//    detail.detailCode = detailBtn.detailCode;
//    MainController *main = (MainController *)self.window.rootViewController;
//    NSLog(@"%@", main);
//    UINavigationController *nav = (UINavigationController *)main.selectedController;
//    NSLog(@"%@", nav);
//    [nav pushViewController:detail animated:YES];
}

@end
