//
//  OrderController.h
//  城市厨房
//
//  Created by 臧昊 on 15/3/4.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderController : UIViewController

@property (nonatomic, copy)NSString *deliveryType;
@property (nonatomic, copy)NSString *orderCode;
@property (nonatomic, assign)double goodsPrice;

@end
