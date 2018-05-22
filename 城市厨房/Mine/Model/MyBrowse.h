//
//  MyBrowse.h
//  城市厨房
//
//  Created by 臧昊 on 15/3/11.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyBrowse : NSObject<NSCoding>
@property (nonatomic, copy)NSString *productCode;
@property (nonatomic, copy)NSString *productName;
@property (nonatomic, copy)NSString *pic;
@property (nonatomic, copy)NSString *price;

@end
