//
//  HomeGoodsShow.m
//  城市厨房
//
//  Created by 臧昊 on 15/2/11.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "HomeGoodsShow.h"
#import "GoodsDetail.h"
#import "GoodsList.h"

@implementation HomeGoodsShow

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.goodsListArray forKey:@"goodsListArray"];
    [aCoder encodeObject:self.goodsDetailArray forKey:@"goodsDetailArray"];
    [aCoder encodeObject:self.title forKey:@"title"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.goodsListArray = [aDecoder decodeObjectForKey:@"goodsListArray"];
        self.goodsDetailArray = [aDecoder decodeObjectForKey:@"goodsDetailArray"];
        self.title = [aDecoder decodeObjectForKey:@"title"];

    }
    return self;
}

- (void)initWithDict:(NSDictionary *)dict
{

        // cell标题
        self.title = dict[@"categoryName"];
        
        // cell图片商品
        NSMutableArray *detailArray = [NSMutableArray array];
        for (NSDictionary *detailDict in dict[@"productList"])
        {
            GoodsDetail *goodsDetail = [[GoodsDetail alloc]init];
            [goodsDetail initWithDict:detailDict];
            [detailArray addObject:goodsDetail];
        }
        self.goodsDetailArray = [NSArray arrayWithArray:detailArray];
//        [self.goodsDetailArray arrayByAddingObjectsFromArray:];
//        NSLog(@"wwwwww%@", self.goodsDetailArray);
        // cell商品分类
        NSMutableArray *listArray = [NSMutableArray array];
        NSArray *keys = [dict[@"categoryChild"] allKeys];
        for (NSString *key in keys)
        {
            GoodsList *goodsList = [[GoodsList alloc]init];
            [goodsList initWithDict:dict[@"categoryChild"] atKey:key];
            [listArray addObject:goodsList];
        }
//        NSLog(@"%@", listArray);
        self.goodsListArray = [NSArray arrayWithArray:listArray];

}




@end
