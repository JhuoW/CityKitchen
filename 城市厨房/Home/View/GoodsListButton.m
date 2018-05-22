//
//  GoodsListButton.m
//  城市厨房
//
//  Created by 臧昊 on 15/2/14.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "GoodsListButton.h"

@implementation GoodsListButton
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        [self setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return self;
}
@end
