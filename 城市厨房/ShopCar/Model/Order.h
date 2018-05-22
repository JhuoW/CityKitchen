//
//  order.h
//  城市厨房
//
//  Created by 臧昊 on 15/3/4.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject
@property (nonatomic, assign)double account;
@property (nonatomic, copy)NSString *address;
@property (nonatomic, copy)NSString *createTime;
@property (nonatomic, copy)NSString *orderCode;
@property (nonatomic, copy)NSString *payType;
@property (nonatomic, strong)NSMutableArray *productsArray;
@property (nonatomic, strong)NSString *status;
- (id)initWithDict:(NSDictionary *)dict;
@end
