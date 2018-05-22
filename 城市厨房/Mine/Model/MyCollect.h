//
//  MyCollect.h
//  城市厨房
//
//  Created by 臧昊 on 15/2/26.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCollect : NSObject

@property (nonatomic, copy)NSString *productCode;
@property (nonatomic, copy)NSString *productName;
@property (nonatomic, copy)NSString *pic;
@property (nonatomic, copy)NSString *price;
@property (nonatomic, assign)int score;
@property (nonatomic, assign)int soldNum;
@property (nonatomic, copy)NSString *unit;
- (id)initWithDict:(NSDictionary *)dict;
@end
