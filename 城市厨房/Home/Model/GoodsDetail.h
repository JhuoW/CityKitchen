//
//  GoodsDetail.h
//  城市厨房
//
//  Created by 臧昊 on 15/2/11.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsDetail : NSObject<NSCoding>
@property (nonatomic , copy) NSString *detailCode;
@property (nonatomic, copy) NSString *goodsImageUrl;
@property (nonatomic, assign) double goodsPrice;
@property (nonatomic, copy) NSString *goodsTitle;

- (void)initWithDict:(NSDictionary *)dict;

@end
