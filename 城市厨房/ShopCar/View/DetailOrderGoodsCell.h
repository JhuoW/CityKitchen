//
//  DetailOrderGoodsCell.h
//  城市厨房
//
//  Created by 臧昊 on 15/3/5.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderGoods.h"
@interface DetailOrderGoodsCell : UITableViewCell
@property (nonatomic, strong)OrderGoods *orderGoods;
@property (nonatomic, copy)NSString *productCode;
@end
