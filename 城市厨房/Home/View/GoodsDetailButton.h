//
//  GoodsDetailButton.h
//  城市厨房
//
//  Created by 臧昊 on 15/2/12.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsDetailButton : UIButton

@property (nonatomic, strong)UILabel *goodsDetailTitle;
@property (nonatomic, strong)UILabel *goodsDetailPrice;
@property (nonatomic, strong)UIImageView *goodsImage;
@property (nonatomic, copy)NSString *detailCode;
@end
