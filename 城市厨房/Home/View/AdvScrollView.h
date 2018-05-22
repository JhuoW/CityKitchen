//
//  AdvScrollView.h
//  城市厨房
//
//  Created by 臧昊 on 15/1/31.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvScrollView : UIView 

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *scrollView;
- (instancetype)initWithFrame:(CGRect)frame addScrollViewWithImages:(NSArray *)images;

@end
