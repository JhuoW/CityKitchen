//
//  Company.m
//  城市厨房
//
//  Created by 臧昊 on 15/3/1.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "Company.h"
//@property (nonatomic, copy)NSString *address;
//@property (nonatomic, copy)NSString *companyCode;
//@property (nonatomic, copy)NSString *name;
//@property (nonatomic, copy)NSString *tel;
//@property (nonatomic, assign)int score;
//@property (nonatomic, assign)int viewNum;
@implementation Company
- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.address = dict[@"address"];
        self.companyCode = dict[@"code"];
        self.logo = dict[@"logo"];
        self.name = dict[@"name"];
        self.tel = dict[@"telephone"];
        self.score = [dict[@"score"] intValue];
        self.viewNum = [dict[@"viewNum"] intValue];
    }
    return self;
}
@end
