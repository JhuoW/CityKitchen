//
//  NSMutableAttributedString+ZH.m
//  城市厨房
//
//  Created by 臧昊 on 15/3/2.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "NSMutableAttributedString+ZH.h"

@implementation NSMutableAttributedString (ZH)
+(NSMutableAttributedString *)mutableAttributedStringCreatedWithString:(NSString *)string rangeFrom:(NSInteger)location length:(NSInteger)length
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:string];
    
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:kBackgroundGeenColor
                          range:NSMakeRange(location, length)];
    return attributedStr;
}
@end
