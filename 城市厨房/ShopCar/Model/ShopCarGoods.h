//
//  ShopCarGoods.h
//  城市厨房
//
//  Created by 臧昊 on 15/2/26.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopCarGoods : NSObject

@property (nonatomic, copy) NSString *cartItemId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int num;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, assign) double price;
@property (nonatomic, copy) NSString *productCode;
@property (nonatomic, copy) NSString *spec;
@property (nonatomic, copy) NSString *unit;
- (id)initWithDict:(NSDictionary *)dict;
@end
