//
//  DetailGoods.h
//  城市厨房
//
//  Created by 臧昊 on 15/2/14.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailGoods : NSObject
// 商铺标识(code)
@property (nonatomic, copy) NSString *companyCode;
// 商铺名称
@property (nonatomic, copy) NSString *companyName;
// 评论数
@property (nonatomic, assign) int evalNum;
// 商品名称
@property (nonatomic, copy) NSString *name;
// 商品图片
@property (nonatomic, copy) NSArray *pics;
// 商品价格
@property (nonatomic, copy) NSArray *prices;
// 猜你喜欢
@property (nonatomic, copy) NSArray *relateProducts;
// 评价（几颗星）
@property (nonatomic, assign) int score;

- (id)initWithDict:(NSDictionary *)dict;
@end
