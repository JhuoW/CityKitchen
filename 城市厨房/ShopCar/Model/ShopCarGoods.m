//
//  ShopCarGoods.m
//  城市厨房
//
//  Created by 臧昊 on 15/2/26.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "ShopCarGoods.h"


@implementation ShopCarGoods
- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.cartItemId = dict[@"id"];
        self.name = dict[@"name"];
        self.num = [dict[@"num"] intValue];
        self.pic = dict[@"pic"];
        self.price = [dict[@"price"] doubleValue];
        self.productCode = dict[@"productCode"];
        self.spec = dict[@"spec"];
        self.unit = dict[@"unit"];
    }
    return self;
}
@end
