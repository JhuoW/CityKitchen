//
//  Account.h
//  城市厨房
//
//  Created by 臧昊 on 15/2/19.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject<NSCoding>
// code值
@property (nonatomic, copy) NSString *userCode;
// 用户名
@property (nonatomic, copy) NSString *userName;
// 用户密码
@property (nonatomic, copy) NSString *userPwd;
// 购物车
@property (nonatomic, assign) int cartNum;
// 订单数
@property (nonatomic, assign) int orderNum;
// 等级
@property (nonatomic, assign) int evalNum;
@end
