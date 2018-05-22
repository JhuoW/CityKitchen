//
//  categoryTop.h
//  城市厨房
//
//  Created by 臧昊 on 15/2/13.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryTop : NSObject<NSCoding>
@property (nonatomic, copy)NSString *categoryName;
@property (nonatomic, copy)NSString *code;
@property (nonatomic, copy)NSString *icon;

- (void)initWithDict:(NSDictionary *)dict;
@end
