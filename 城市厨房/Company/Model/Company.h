//
//  Company.h
//  城市厨房
//
//  Created by 臧昊 on 15/3/1.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Company : NSObject
@property (nonatomic, copy)NSString *address;
@property (nonatomic, copy)NSString *companyCode;
@property (nonatomic, copy)NSString *logo;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *tel;
@property (nonatomic, assign)int score;
@property (nonatomic, assign)int viewNum;
- (id)initWithDict:(NSDictionary *)dict;
@end
