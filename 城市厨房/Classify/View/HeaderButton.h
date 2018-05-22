//
//  HeaderButton.h
//  城市厨房
//
//  Created by 臧昊 on 15/2/2.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryTop.h"

@interface HeaderButton : UIButton
@property (nonatomic,assign) BOOL isOpen;
@property (nonatomic, strong) NSArray *classes;

@property (nonatomic, strong) UILabel *subTitle;

@property (nonatomic, strong) CategoryTop *categoryTop;

//@property (nonatomic, strong) NSString *accessory;
@end
