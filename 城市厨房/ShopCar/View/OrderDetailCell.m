//
//  OrderDetailCell.m
//  城市厨房
//
//  Created by 臧昊 on 15/3/4.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "OrderDetailCell.h"
#import "UIImageView+WebCache.h"

@interface OrderDetailCell()
{
    UIImageView *_imgView;
    UILabel *_titleLabel;
    UILabel *_priceLabel;
    UILabel *_numLabel;
}

@end

@implementation OrderDetailCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addImgViewAndLabel];
    }
    return self;
}
- (void)addImgViewAndLabel
{
    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 45, 45)];
//    _imgView.backgroundColor = [UIColor greenColor];
    [self addSubview:_imgView];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 10, [UIScreen mainScreen].bounds.size.width - 65 - 80, 30)];
//    _titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = [UIFont systemFontOfSize:14];
//    _titleLabel.backgroundColor = [UIColor redColor];
    [self addSubview:_titleLabel];
    
    _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 40, 100, 20)];
    _priceLabel.textColor = kBackgroundGeenColor;
    [self addSubview:_priceLabel];
    
    _numLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    _numLabel.textAlignment = NSTextAlignmentCenter;
    _numLabel.textColor = kBackgroundGeenColor;
//    _numLabel.backgroundColor = [UIColor redColor];
    self.accessoryView = _numLabel;
}

- (void)setShopCarGoods:(ShopCarGoods *)shopCarGoods
{
    _shopCarGoods = shopCarGoods;
    if ([shopCarGoods.pic rangeOfString:@"http"].length) {
        [_imgView sd_setImageWithURL:[NSURL URLWithString:shopCarGoods.pic] placeholderImage:[UIImage imageNamed:@"defualt_iv_400.png"]];
    }else{
        NSString *imageUrl = [kImageURL stringByAppendingString:shopCarGoods.pic];
        [_imgView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"defualt_iv_400.png"]];
    }
    _titleLabel.text = shopCarGoods.name;
    _priceLabel.text = [NSString stringWithFormat:@"￥%0.1f", shopCarGoods.price];
    _numLabel.text = [NSString stringWithFormat:@"%d%@", shopCarGoods.num, shopCarGoods.unit];
}

@end
