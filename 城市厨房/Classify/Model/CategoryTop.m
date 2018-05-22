//
//  categoryTop.m
//  城市厨房
//
//  Created by 臧昊 on 15/2/13.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "categoryTop.h"
#import "ModelManager.h"
@implementation CategoryTop

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.categoryName forKey:@"categoryName"];
    [aCoder encodeObject:self.code forKey:@"code"];
    [aCoder encodeObject:self.icon forKey:@"icon"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.categoryName = [aDecoder decodeObjectForKey:@"categoryName"];
        self.code = [aDecoder decodeObjectForKey:@"code"];
        self.icon = [aDecoder decodeObjectForKey:@"icon"];
        
    }
    return self;
}

- (void)initWithDict:(NSDictionary *)dict
{
    self.categoryName = dict[@"categoryName"];
    self.code = dict[@"code"];
    self.icon = dict[@"ico"];
//        [[ModelManager sharedManager] httpRequestGetCategoryChildWithCode:self.code];

}

@end
