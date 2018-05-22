//
//  CategoryChild.h
//  城市厨房
//
//  Created by 臧昊 on 15/2/13.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryChild : NSObject<NSCoding>
@property (nonatomic, copy)NSString *categoryName;
@property (nonatomic, copy)NSString *listCode;

- (void)initWithDict:(NSDictionary *)dict;
@end
