//
//  GoodsDetailButton.m
//  城市厨房
//
//  Created by 臧昊 on 15/2/12.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "GoodsDetailButton.h"

@implementation GoodsDetailButton
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor redColor];
        // 添加imageview
        
        _goodsImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width * 0.35, self.frame.size.height * 0.3, self.frame.size.width * 0.6, self.frame.size.height * 0.6)];
        _goodsImage.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_goodsImage];
        [self addGoodsDetailLabel];
    }
    return self;
}

- (void)addGoodsDetailLabel
{
    _goodsDetailTitle = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, self.frame.size.width * 0.8, 50)];
    _goodsDetailTitle.numberOfLines = 0;
    _goodsDetailTitle.font = [UIFont systemFontOfSize:12];
//    _goodsDetailTitle.backgroundColor = [UIColor grayColor];
    _goodsDetailTitle.textColor = [UIColor blackColor];
    [self addSubview:_goodsDetailTitle];
    
    _goodsDetailPrice = [[UILabel alloc]initWithFrame:CGRectMake(5, self.frame.size.height - 55, 60, 50)];
    _goodsDetailPrice.numberOfLines = 0;
    _goodsDetailPrice.textColor = kBackgroundGeenColor;
    [self addSubview:_goodsDetailPrice];

}

@end
