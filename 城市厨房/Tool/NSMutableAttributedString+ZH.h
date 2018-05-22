//
//  NSMutableAttributedString+ZH.h
//  城市厨房
//
//  Created by 臧昊 on 15/3/2.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSMutableAttributedString (ZH)
+(NSMutableAttributedString *)mutableAttributedStringCreatedWithString:(NSString *)string rangeFrom:(NSInteger)location length:(NSInteger)length;
@end
