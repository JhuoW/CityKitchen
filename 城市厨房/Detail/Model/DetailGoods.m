//
//  DetailGoods.m
//  城市厨房
//
//  Created by 臧昊 on 15/2/14.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "DetailGoods.h"

@implementation DetailGoods

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.companyCode = dict[@"companyCode"];
        self.companyName = dict[@"companyName"];
        self.evalNum = [dict[@"evalNum"] intValue];
        self.name = dict[@"name"];
        self.pics = dict[@"pics"];
        self.prices = dict[@"prices"];
        self.relateProducts = dict[@"relateProducts"];
        self.score = [dict[@"score"] intValue];
    }
    return self;
}

@end
