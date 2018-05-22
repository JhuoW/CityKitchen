//
//  MyBrowseCell.m
//  城市厨房
//
//  Created by 臧昊 on 15/3/11.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "MyBrowseCell.h"
#import "UIImageView+WebCache.h"
#import "DetailController.h"
#import "MainController.h"





@interface MyBrowseCell()
{
    NSString *_productCode;
    UIImageView *_productPicView;
    UILabel *_productNameLabel;
    UILabel *_productPriceLabel;
}

@end

@implementation MyBrowseCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"common_arrow.png"]];
        [self addImageAndLabel];
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

- (void)addImageAndLabel
{
    // 图片
    _productPicView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 80)];
    [self addSubview:_productPicView];
    
    // 商品名称
    _productNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, [UIScreen mainScreen].bounds.size.width - 110, 40)];
    [self addSubview:_productNameLabel];
    
    // 商品价格
    _productPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 70, [UIScreen mainScreen].bounds.size.width - 110, 20)];
    _productPriceLabel.textColor = kBackgroundGeenColor;
    [self addSubview:_productPriceLabel];
}

- (void)setMyBrowse:(MyBrowse *)myBrowse
{
    // 图片路径
    if ([myBrowse.pic rangeOfString:@"http"].length) {
        [_productPicView sd_setImageWithURL:[NSURL URLWithString:myBrowse.pic] placeholderImage:[UIImage imageNamed:@"defualt_iv_400.png"]];
    }else{
        NSString *imageUrl = [kImageURL stringByAppendingString:myBrowse.pic];
        [_productPicView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"defualt_iv_400.png"]];
    }
    if (myBrowse.productName) {
        _productNameLabel.text = myBrowse.productName;
    }
//    if (![myBrowse.price isEqualToString:@""]) {
        _productPriceLabel.text = [NSString stringWithFormat:@"￥%@", myBrowse.price];
//    }
    _productCode = myBrowse.productCode;
}

@end
