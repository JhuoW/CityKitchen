//
//  ListGoods.h
//  城市厨房
//
//  Created by 臧昊 on 15/2/15.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListGoods : NSObject
// 商品详细列表
@property (nonatomic, copy) NSString *detailCode;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, assign) int score;
@property (nonatomic, assign) int soldNum;
@property (nonatomic, copy) NSString *unit;

- (id)initWithDict:(NSDictionary *)dict;
@end
