//
//  order.m
//  城市厨房
//
//  Created by 臧昊 on 15/3/4.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "Order.h"
#import "OrderGoods.h"
//@property (nonatomic, copy)NSString *account;
//@property (nonatomic, copy)NSString *address;
//@property (nonatomic, copy)NSString *createTime;
//@property (nonatomic, copy)NSString *orderCode;
//@property (nonatomic, copy)NSString *payType;
//@property (nonatomic, strong)NSMutableArray *productsArray;
@implementation Order
- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.account = [dict[@"account"] doubleValue];
        self.address = dict[@"address"];
        self.createTime = dict[@"createTime"];
        self.orderCode = dict[@"orderCode"];
        self.payType = dict[@"payType"];
        self.status = dict[@"status"];
        self.productsArray = [NSMutableArray array];
        for (NSDictionary *dictionary in dict[@"products"]) {
            OrderGoods *orderGoods = [[OrderGoods alloc]initWithDict:dictionary];
            [self.productsArray addObject:orderGoods];
        }
    }
    return self;
}

@end
