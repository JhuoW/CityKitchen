//
//  CheckButton.m
//  城市厨房
//
//  Created by 臧昊 on 15/3/3.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "CheckButton.h"
#import "UIImage+ZH.h"

@implementation CheckButton
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置图片
        self.imageView.contentMode = UIViewContentModeCenter;
        UIImage *checkedImg = [UIImage imageNamed:@"checkbox_checked.png"];
        UIImage *uncheckedImg = [UIImage imageNamed:@"checkbox_unchecked.png"];
        [self setImage:[checkedImg resize:CGRectMake(0, 0, 22, 22)] forState:UIControlStateSelected];
        [self setImage:[uncheckedImg resize:CGRectMake(0, 0, 22, 22)] forState:UIControlStateNormal];
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
//    return CGRectMake(0, 0, 22, 22 );
    CGFloat height =contentRect.size.height ;
    CGFloat width = contentRect.size.width ;
    return CGRectMake(0, 0, width, height );
}
@end
