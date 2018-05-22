//
//  ListGoods.m
//  城市厨房
//
//  Created by 臧昊 on 15/2/15.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "ListGoods.h"

@implementation ListGoods

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.detailCode = dict[@"code"];
        self.name = dict[@"name"];
        self.pic = dict[@"pic"];
        self.price = dict[@"price"];
        self.score = [dict[@"score"] intValue];
        self.soldNum = [dict[@"soldNum"] intValue];
        self.unit = dict[@"unit"];
    }
    return self;
}

@end
