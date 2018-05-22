//
//  HomeGoodsShow.h
//  城市厨房
//
//  Created by 臧昊 on 15/2/11.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeGoodsShow : NSObject<NSCoding>
@property (nonatomic, strong) NSArray *goodsListArray;
@property (nonatomic, strong) NSArray *goodsDetailArray;
@property (nonatomic, copy) NSString *title;

- (void)initWithDict:(NSDictionary *)dict;
@end
