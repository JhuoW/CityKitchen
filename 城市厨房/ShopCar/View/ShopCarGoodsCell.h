//
//  ShopCarGoodsCell.h
//  城市厨房
//
//  Created by 臧昊 on 15/2/26.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopCarGoods.h"

@protocol ShopCarGoodsCellDelegate <NSObject>
@optional
//-(void)dock:(Dock *)dock itemSelectedFrom:(NSInteger)from To:(NSInteger)to;
- (void)shopCarGoodsNumChangeFrom: (int)oldNum to:(int)newNum withPrice: (double)price;
- (void)shopCarGoodsCheckThisGoodsPrice:(double)price andNum:(int)num;
- (void)shopCarGoodsUnCheckThisGoodsPrice:(double)price andNum:(int)num;
@end

@interface ShopCarGoodsCell : UITableViewCell
@property (nonatomic, strong)ShopCarGoods *shopCarGoods;
@property (nonatomic, assign)BOOL isSelectedToBuy;
// 代理
@property (nonatomic,weak) id <ShopCarGoodsCellDelegate> delegate;
@end
