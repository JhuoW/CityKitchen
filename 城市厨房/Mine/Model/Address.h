//
//  Address.h
//  城市厨房
//
//  Created by 臧昊 on 15/2/22.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Address : NSObject
@property (nonatomic, copy)NSString *definiteAddress;
@property (nonatomic, copy)NSString *city;
@property (nonatomic, copy)NSString *district;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *province;
@property (nonatomic, copy)NSString *tel;
@property (nonatomic, copy)NSString *postCode;
@property (nonatomic, assign)BOOL isDefault;
@property (nonatomic, copy) NSString *addressId;
- (id)initWithDict:(NSDictionary *)dict;
@end
