//
//  GoodsList.m
//  城市厨房
//
//  Created by 臧昊 on 15/2/11.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "GoodsList.h"
@interface GoodsList ()

@end

@implementation GoodsList

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.listTitle forKey:@"listTitle"];
    [aCoder encodeObject:self.listCode forKey:@"listCode"];

}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.listTitle = [aDecoder decodeObjectForKey:@"listTitle"];
        self.listCode = [aDecoder decodeObjectForKey:@"listCode"];

    }
    return self;
}

- (void)initWithDict:(NSDictionary *)dict atKey:(NSString *)key
{
        self.listTitle = key;
        self.listCode = dict[key];
}

@end
