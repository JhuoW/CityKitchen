//
//  UIImage+ZH.m
//  城市厨房
//
//  Created by 臧昊 on 15/1/28.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "UIImage+ZH.h"

@implementation UIImage (ZH)

// 将RGB转换成颜色
+(UIImage*) imageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
// 控制图片大小
-(UIImage*)resize:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    [self drawInRect:rect];
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}
// 拉伸图片（不失真）
+ (UIImage *)resizedImage:(NSString *)imageName
{
    
    UIImage *image = [UIImage imageNamed:imageName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

@end
