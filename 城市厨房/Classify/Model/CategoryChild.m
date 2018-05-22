//
//  CategoryChild.m
//  城市厨房
//
//  Created by 臧昊 on 15/2/13.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "CategoryChild.h"

@implementation CategoryChild

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.categoryName forKey:@"categoryName"];
    [aCoder encodeObject:self.listCode forKey:@"listCode"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.categoryName = [aDecoder decodeObjectForKey:@"categoryName"];
        self.listCode = [aDecoder decodeObjectForKey:@"code"];
    }
    return self;
}

- (void)initWithDict:(NSDictionary *)dict
{
    self.categoryName = dict[@"categoryName"];
    self.listCode = dict[@"code"];
}

@end
