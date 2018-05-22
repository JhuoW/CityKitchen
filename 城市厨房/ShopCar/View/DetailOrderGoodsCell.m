//
//  DetailOrderGoodsCell.m
//  城市厨房
//
//  Created by 臧昊 on 15/3/5.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "DetailOrderGoodsCell.h"
#import "UIImageView+WebCache.h"
#import "DetailController.h"
#import "MainController.h"

@interface DetailOrderGoodsCell()
{
    UIImageView *_imgView;
    UILabel *_titleLabel;
    UILabel *_priceLabel;
    UILabel *_numLabel;
}

@end

@implementation DetailOrderGoodsCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addImgViewAndLabel];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDetail)]];
    }
    return self;
}

- (void)showDetail
{
    DetailController *goodsDetail = [[DetailController alloc]init];
    //    NSLog(@"%@", [_listArray[indexPath.row] detailCode]);
    goodsDetail.detailCode = _productCode;
    MainController *main = (MainController *) self.window.rootViewController;
    UINavigationController *navi = (UINavigationController *) main.selectedController;
    [navi pushViewController:goodsDetail animated:YES];
}

- (void)addImgViewAndLabel
{
    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
    //    _imgView.backgroundColor = [UIColor greenColor];
    [self addSubview:_imgView];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, [UIScreen mainScreen].bounds.size.width - 60 - 100, 40)];
    //    _titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = [UIFont systemFontOfSize:16];
//    _titleLabel.font = [UIFont systemFontOfSize:14];
    //    _titleLabel.backgroundColor = [UIColor redColor];
    [self addSubview:_titleLabel];
    
    _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 110, 10, 70, 20)];
    _priceLabel.textColor = kBackgroundGeenColor;
    _priceLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_priceLabel];
    
    _numLabel = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 110, 30, 70, 20)];
    _numLabel.textAlignment = NSTextAlignmentRight;
    _numLabel.textColor = kBackgroundGeenColor;
    [self addSubview:_numLabel];
    
    self.accessoryView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"common_arrow.png"]];
}

- (void)setOrderGoods:(OrderGoods *)orderGoods
{
    _orderGoods = orderGoods;
    _productCode = _orderGoods.productCode;
    if ([_orderGoods.productPic rangeOfString:@"http"].length) {
        [_imgView sd_setImageWithURL:[NSURL URLWithString:_orderGoods.productPic] placeholderImage:[UIImage imageNamed:@"defualt_iv_400.png"]];
    }else{
        NSString *imageUrl = [kImageURL stringByAppendingString:_orderGoods.productPic];
        [_imgView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"defualt_iv_400.png"]];
    }
    _titleLabel.text = _orderGoods.productName;
    _priceLabel.text = [NSString stringWithFormat:@"￥%0.1f", _orderGoods.productPrice];
    _numLabel.text = [NSString stringWithFormat:@"%d%@", _orderGoods.productCount, _orderGoods.productUnit];
    
}

@end
