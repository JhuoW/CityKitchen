//
//  OrderGoods.m
//  城市厨房
//
//  Created by 臧昊 on 15/3/4.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "OrderGoods.h"


@implementation OrderGoods
- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.productCode = dict[@"productCode"];
        self.productCount = [dict[@"productCount"] intValue];
        self.productName = dict[@"productName"];
        self.productPic = dict[@"productPic"];
        self.productPrice = [dict[@"productPrice"] doubleValue];
        self.productSpec = dict[@"productSpec"];
        self.productUnit = dict[@"productUnit"];
    }
    return self;
}
@end
