//
//  PayTool.h
//  城市厨房
//
//  Created by 臧昊 on 15/3/12.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderPay.h"
#import "Singleton.h"

@interface PayTool : NSObject

single_interface(PayTool);

- (void)payWithOrderNo:(NSString *)orderCode ProductName:(NSString *)productName ProductDescription:(NSString *)productDescription Amount:(double)amount;
@end
