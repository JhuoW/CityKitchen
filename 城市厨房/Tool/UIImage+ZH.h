//
//  UIImage+ZH.h
//  城市厨房
//
//  Created by 臧昊 on 15/1/28.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ZH)
+(UIImage*) imageWithColor:(UIColor*)color;
-(UIImage*)resize:(CGRect)rect;
+ (UIImage *)resizedImage:(NSString *)imageName;
@end
