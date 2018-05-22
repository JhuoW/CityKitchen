
//
//  UIBarButtonItem+ZH.m
//  sina
//
//  Created by mac on 14-11-12.
//  Copyright (c) 2014年 ZH. All rights reserved.
//

#import "UIBarButtonItem+ZH.h"

@implementation UIBarButtonItem (ZH)

// 构建一个UIBarbutton
+ (id)initWithIcon:(NSString *)icon highlightedIcon:(NSString *)highlightedIcon target:(id)target action:(SEL)action
{
    // 2.左边的item
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:icon];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highlightedIcon] forState:UIControlStateHighlighted];
    
    // 设置尺寸
    button.bounds = (CGRect){CGPointZero, image.size};
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[self alloc]initWithCustomView:button];
    
    
    
}

- (void) setDefaultStyle
{
//    [[UINavigationBar appearance] setBackgroundImage:[DataUtil imageWithColor:RGB(0, 127, 211)]  forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                          [UIColor whiteColor],
//                                                          UITextAttributeTextColor,
//                                                          [UIColor clearColor],
//                                                          UITextAttributeTextShadowColor,
//                                                          [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
//                                                          UITextAttributeTextShadowOffset,
//                                                          [UIFont boldSystemFontOfSize:17.0],
//                                                          UITextAttributeFont,nil]];
}

@end
