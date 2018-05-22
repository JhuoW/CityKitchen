//
//  listCell.h
//  城市厨房
//
//  Created by 臧昊 on 15/2/15.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListGoods.h"

@interface listCell : UITableViewCell
@property (nonatomic, strong)ListGoods *listGoods;
@property (nonatomic, strong)NSString *detailCode;
@end
