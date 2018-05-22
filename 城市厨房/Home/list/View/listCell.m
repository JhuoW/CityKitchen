//
//  listCell.m
//  城市厨房
//
//  Created by 臧昊 on 15/2/15.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "listCell.h"
#import "UIImageView+WebCache.h"

@interface listCell()
{
    UIImageView * _imageView;
    UILabel *_nameLabel;
    UILabel *_priceLabel;
    UILabel *_unitLabel;
    UILabel *_scoreLabel;
}

@end

@implementation listCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addImageView];
        [self addLabels];
//        [self addShopCarBtn];
    }
    return self;
}

- (void)addImageView
{
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 100, 100)];
    [self addSubview:_imageView];
}

- (void)addLabels
{
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 119, [UIScreen mainScreen].bounds.size.width, 1)];
    lineImageView.backgroundColor = RGB(207, 207, 207);
    [self addSubview:lineImageView];
    
    // 商品名称
    _nameLabel = [[UILabel alloc]initWithFrame: CGRectMake(120, 10, [UIScreen mainScreen].bounds.size.width - 120, 20)];
    _nameLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:_nameLabel];
    
    // 商品价格
    _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.frame.origin.x, 35, _nameLabel.frame.size.width, _nameLabel.frame.size.height)];
    _priceLabel.textColor = kBackgroundGeenColor;
    [self addSubview:_priceLabel];
    
    // 商品评价
    _scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.frame.origin.x, 60, 85, 15)];
//    _scoreLabel.backgroundColor = [UIColor grayColor];
    _scoreLabel.textAlignment = NSTextAlignmentRight;
    _scoreLabel.textColor = [UIColor grayColor];
    _scoreLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_scoreLabel];
}

- (void)addShopCarBtn
{
    UIButton *shopCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *shopCarImg = [UIImage imageNamed:@"addShopCar.png"];
    [shopCarBtn setImage:shopCarImg forState:UIControlStateNormal];
    shopCarBtn.bounds = CGRectMake(0, 0, shopCarImg.size.width * 0.7, shopCarImg.size.height * 0.7);
    shopCarBtn.center = CGPointMake([UIScreen mainScreen].bounds.size.width - shopCarImg.size.width * 0.5, 120 - shopCarImg.size.height * 0.5);
    [self addSubview:shopCarBtn];
}

- (void)setListGoods:(ListGoods *)listGoods
{
    _detailCode = listGoods.detailCode;
    if ([listGoods.pic rangeOfString:@"http"].length) {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:listGoods.pic] placeholderImage:[UIImage imageNamed:@"defualt_iv_400.png"]];
    }else{
        NSString *imageUrl = [kImageURL stringByAppendingString:listGoods.pic];
        [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"defualt_iv_400.png"]];
    }
    _nameLabel.text = listGoods.name;
    if (listGoods.name.length) {
        _priceLabel.text = [NSString stringWithFormat:@"￥%@", listGoods.price];
    }
    for (int i = 0; i < listGoods.score; i ++) {
        UIImageView *starView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"starlight.png"]];
        starView.bounds = CGRectMake(0, 0, 10, 10);
        starView.center = CGPointMake(5 + 12 * i, _scoreLabel.frame.size.height * 0.5);
        [_scoreLabel addSubview:starView];
    }
    for (int i = 0; i < 5 - listGoods.score; i ++) {
        UIImageView *starView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"starlight.png"]];
        starView.bounds = CGRectMake(0, 0, 10, 10);
        starView.center = CGPointMake(5 + 12 *( i + listGoods.score ), _scoreLabel.frame.size.height * 0.5);
        [_scoreLabel addSubview:starView];
    }
    _scoreLabel.text = [NSString stringWithFormat:@"(%d)", listGoods.soldNum];
}

@end
