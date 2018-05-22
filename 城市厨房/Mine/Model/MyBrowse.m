//
//  MyBrowse.m
//  城市厨房
//
//  Created by 臧昊 on 15/3/11.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "MyBrowse.h"

@implementation MyBrowse
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.productCode forKey:@"productCode"];
    [aCoder encodeObject:self.productName forKey:@"productName"];
    [aCoder encodeObject:self.pic forKey:@"pic"];
    [aCoder encodeObject:self.price forKey:@"price"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.productCode = [aDecoder decodeObjectForKey:@"productCode"];
        self.productName = [aDecoder decodeObjectForKey:@"productName"];
        self.pic = [aDecoder decodeObjectForKey:@"pic"];
        self.price = [aDecoder decodeObjectForKey:@"price"];
    }
    return self;
}
@end
