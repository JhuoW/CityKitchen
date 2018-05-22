//
//  OrderGoods.h
//  城市厨房
//
//  Created by 臧昊 on 15/3/4.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderGoods : NSObject
@property (nonatomic, copy)NSString *productCode;
@property (nonatomic, assign)int productCount;
@property (nonatomic, copy)NSString *productName;
@property (nonatomic, copy)NSString *productPic;
@property (nonatomic, assign)double productPrice;
@property (nonatomic, copy)NSString *productSpec;
@property (nonatomic, copy)NSString *productUnit;
- (id)initWithDict:(NSDictionary *)dict;
@end
