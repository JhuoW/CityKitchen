//
//  Account.m
//  城市厨房
//
//  Created by 臧昊 on 15/2/19.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "Account.h"

@implementation Account

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_userCode forKey:@"userCode"];
    [aCoder encodeObject:_userName forKey:@"userName"];
    [aCoder encodeObject:_userPwd forKey:@"userPwd"];
    [aCoder encodeObject:@(_cartNum) forKey:@"cartNum"];
    [aCoder encodeObject:@(_orderNum) forKey:@"orderNum"];
    [aCoder encodeObject:@(_evalNum) forKey:@"evalNum"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [self init]) {
        self.userCode = [aDecoder decodeObjectForKey:@"userCode"];
        self.userName = [aDecoder decodeObjectForKey:@"userName"];
        self.userPwd = [aDecoder decodeObjectForKey:@"userPwd"];
        self.cartNum = [[aDecoder decodeObjectForKey:@"cartNum"] intValue];
        self.orderNum = [[aDecoder decodeObjectForKey:@"orderNum"] intValue];
        self.evalNum = [[aDecoder decodeObjectForKey:@"evalNum"] intValue];
    }
    return self;
}

@end
