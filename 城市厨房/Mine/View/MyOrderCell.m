//
//  MyOrderCell.m
//  城市厨房
//
//  Created by 臧昊 on 15/3/5.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "MyOrderCell.h"
#import "UIImageView+WebCache.h"
#import "OrderGoods.h"
#import "DetailOrderController.h"
#import "MainController.h"
#import "NSMutableAttributedString+ZH.h"

@interface MyOrderCell()
{
    UILabel *_orderCodeLabel;
    UILabel *_createTimeLabel;
    UILabel *_accountLabel;
    UILabel *_statusLabel;
    UIScrollView *_goodsScrollView;
}

@end

@implementation MyOrderCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"common_arrow.png"]];
        [self addImageAndLabel];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrderDetail)]];
    }
    return self;
}

- (void)showOrderDetail
{
    DetailOrderController *detailOrderController = [[DetailOrderController alloc]initWithStyle:UITableViewStyleGrouped];
    //    NSLog(@"%@", [_listArray[indexPath.row] detailCode]);
    detailOrderController.orderCode = _order.orderCode;
    MainController *main = (MainController *) self.window.rootViewController;
    UINavigationController *navi = (UINavigationController *) main.selectedController;
    [navi pushViewController:detailOrderController animated:YES];
}

- (void)addImageAndLabel
{
    _orderCodeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width - 40, 25)];
    [self addSubview:_orderCodeLabel];
    
    _createTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, [UIScreen mainScreen].bounds.size.width - 40, 25)];
    [self addSubview:_createTimeLabel];
    
    _accountLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, [UIScreen mainScreen].bounds.size.width - 40, 25)];
    [self addSubview:_accountLabel];
    
    _statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 75, [UIScreen mainScreen].bounds.size.width - 40, 25)];
    [self addSubview:_statusLabel];
    
    // 初始化scrollView
    _goodsScrollView = [[UIScrollView alloc]init];
    // 设置scrollView的大小
    _goodsScrollView.frame = CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 60);
    [self addSubview:_goodsScrollView];

//
    
}

//@property (nonatomic, assign)double account;
//@property (nonatomic, copy)NSString *address;
//@property (nonatomic, copy)NSString *createTime;
//@property (nonatomic, copy)NSString *orderCode;
//@property (nonatomic, copy)NSString *payType;
//@property (nonatomic, strong)NSMutableArray *productsArray;
//@property (nonatomic, strong)NSString *status;

- (void)setOrder:(Order *)order
{
    _order = order;
    _orderCodeLabel.text = [NSString stringWithFormat:@"订单号:   %@", order.orderCode];
    _createTimeLabel.text = [NSString stringWithFormat:@"下单时间:   %@", order.createTime];
    _accountLabel.text = [NSString stringWithFormat:@"订单时间:   %0.1f", order.account];
     NSMutableAttributedString *AttributedStr = [NSMutableAttributedString mutableAttributedStringCreatedWithString:[NSString stringWithFormat:@"订单状态:   %@", order.status] rangeFrom:8 length:order.status.length];
    _statusLabel.attributedText = AttributedStr;
    
    // 设置scrollView的contentSize
    _goodsScrollView.contentSize = CGSizeMake(order.productsArray.count * _goodsScrollView.frame.size.height, _goodsScrollView.frame.size.height);
    
    
    // 添加scrollImage
    CGFloat imageViewWidth = 50;
    CGFloat imageViewHeight = 50;
    for (NSInteger i = 0; i < order.productsArray.count; i++) {
        // 初始化iamgeView
        UIImageView *imageView = [[UIImageView alloc]init];
        // 图片路径
        OrderGoods *orderGoods = order.productsArray[i];
        if ([orderGoods.productPic rangeOfString:@"http"].length) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:orderGoods.productPic] placeholderImage:[UIImage imageNamed:@"defualt_iv_400.png"]];
        }else{
            NSString *imageUrl = [kImageURL stringByAppendingString:orderGoods.productPic];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"defualt_iv_400.png"]];
        }
        imageView.frame = CGRectMake(5 + i * (imageViewWidth + 5), 0, imageViewWidth, imageViewHeight);
        [_goodsScrollView addSubview:imageView];
    }
}

@end
