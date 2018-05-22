//
//  Address.m
//  城市厨房
//
//  Created by 臧昊 on 15/2/22.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "Address.h"
@implementation Address
- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.definiteAddress = [dict[@"address"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.city = [dict[@"city"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.district = [dict[@"district"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.name = [dict[@"name"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.province = [dict[@"province"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.tel = dict[@"tel"];
        self.postCode = dict[@"postCode"];
        self.isDefault = [dict[@"isDefault"] boolValue];
        self.addressId = dict[@"id"];
    }
    return self;
}
@end
