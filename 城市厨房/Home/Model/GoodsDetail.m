//
//  GoodsDetail.m
//  城市厨房
//
//  Created by 臧昊 on 15/2/11.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "GoodsDetail.h"

@implementation GoodsDetail

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.detailCode forKey:@"detailCode"];
    [aCoder encodeObject:self.goodsImageUrl forKey:@"goodsImageUrl"];
    [aCoder encodeObject:@(self.goodsPrice) forKey:@"goodsPrice"];
    [aCoder encodeObject:self.goodsTitle forKey:@"goodsTitle"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.detailCode = [aDecoder decodeObjectForKey:@"detailCode"];
        self.goodsImageUrl = [aDecoder decodeObjectForKey:@"goodsImageUrl"];
        self.goodsPrice = [[aDecoder decodeObjectForKey:@"goodsPrice"] floatValue];
        self.goodsTitle = [aDecoder decodeObjectForKey:@"goodsTitle"];
    }
    return self;
}

- (void)initWithDict:(NSDictionary *)dict
{
        self.detailCode = dict[@"code"];
        self.goodsImageUrl = dict[@"pic"];
        self.goodsPrice = [dict[@"price"] floatValue];
        self.goodsTitle = dict[@"title"];
}

@end
