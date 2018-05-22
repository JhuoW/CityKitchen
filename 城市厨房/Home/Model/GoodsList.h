//
//  GoodsList.h
//  城市厨房
//
//  Created by 臧昊 on 15/2/11.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsList : NSObject<NSCoding>
@property (nonatomic, copy) NSString *listTitle;
@property (nonatomic, copy) NSString *listCode;
- (void)initWithDict:(NSDictionary *)dict atKey:(NSString *)key;

@end
