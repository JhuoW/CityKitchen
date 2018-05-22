//
//  OrderController.m
//  城市厨房
//
//  Created by 臧昊 on 15/3/4.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "OrderController.h"
#import "UIImage+ZH.h"
#import "DetailOrderController.h"
#import "MainController.h"
#import "ModelManager.h"
#import "ModelRequestResult.h"
#import "AccountTool.h"

// 支付宝
#import "PayTool.h"

@interface OrderController()
{
    UILabel *_orderCodeLabel;
    UILabel *_accessTimeLabel;
    UILabel *_postPriceLabel;
    UILabel *_goodsPriceLabel;
}

@end

@implementation OrderController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"订单提交成功";
    self.view.backgroundColor = BackgroundColor;
    
    [self addSuccessLabel];
    [self addOrderTable];
    [self addPayAndLookBtn];
}

- (void)addSuccessLabel
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 20)];
    label.text = @"恭喜，您的订单已提交成功！";
    label.textColor = kBackgroundGeenColor;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 40, self.view.frame.size.width - 40, 80)];
    contentLabel.text = @"请您尽快完成支付，超时未支付的订单将被自动取消。";
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = [UIColor grayColor];
    [self.view addSubview:contentLabel];
}

- (void)addOrderTable
{
    UIImageView *img_1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 120, self.view.frame.size.width - 40, 1)];
    img_1.backgroundColor = RGB(176, 176, 176);
    [self.view addSubview:img_1];
    UIImageView *img_2 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 150, self.view.frame.size.width - 40, 1)];
    img_2.backgroundColor = RGB(176, 176, 176);
    [self.view addSubview:img_2];
    UIImageView *img_3 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 180, self.view.frame.size.width - 40, 1)];
    img_3.backgroundColor = RGB(176, 176, 176);
    [self.view addSubview:img_3];
    UIImageView *img_4 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 210, self.view.frame.size.width - 40, 1)];
    img_4.backgroundColor = RGB(176, 176, 176);
    [self.view addSubview:img_4];
    UIImageView *img_5 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 120, 1, 120)];
    img_5.backgroundColor = RGB(176, 176, 176);
    [self.view addSubview:img_5];
    UIImageView *img_6 = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.5, 120, 1, 120)];
    img_6.backgroundColor = RGB(176, 176, 176);
    [self.view addSubview:img_6];
    UIImageView *img_7 = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 20, 120, 1, 120)];
    img_7.backgroundColor = RGB(176, 176, 176);
    [self.view addSubview:img_7];
    UIImageView *img_8 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 240, self.view.frame.size.width - 40, 1)];
    img_8.backgroundColor = RGB(176, 176, 176);
    [self.view addSubview:img_8];
    
    UILabel *label_1 = [[UILabel alloc]initWithFrame:CGRectMake(30, 121, 120, 29)];
    label_1.font = [UIFont systemFontOfSize:14];
    label_1.text = @"订单编号";
    [self.view addSubview:label_1];
    
    UILabel *label_2 = [[UILabel alloc]initWithFrame:CGRectMake(30, 151, 120, 29)];
    label_2.font = [UIFont systemFontOfSize:14];
    label_2.text = @"预订送达时间";
    [self.view addSubview:label_2];
    
    UILabel *label_3 = [[UILabel alloc]initWithFrame:CGRectMake(30, 181, 120, 29)];
    label_3.font = [UIFont systemFontOfSize:14];
    label_3.text = @"邮费";
    [self.view addSubview:label_3];
    
    UILabel *label_4 = [[UILabel alloc]initWithFrame:CGRectMake(30, 211, 120, 29)];
    label_4.font = [UIFont systemFontOfSize:14];
    label_4.text = @"商品总价";
    [self.view addSubview:label_4];
    _orderCodeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.5 + 1, 121, (self.view.frame.size.width - 40) * 0.5 - 1, 29)];
    _orderCodeLabel.backgroundColor = [UIColor whiteColor];
    _orderCodeLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_orderCodeLabel];
    _orderCodeLabel.text = [NSString stringWithFormat:@"  %@", _orderCode];
    
    NSArray *array = [_deliveryType componentsSeparatedByString:@" "];
    _accessTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.5 + 1, 151, (self.view.frame.size.width - 40) * 0.5 - 1, 29)];
    _accessTimeLabel.backgroundColor = [UIColor whiteColor];
    _accessTimeLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_accessTimeLabel];
    if(array.count > 1){
        _accessTimeLabel.text = [NSString stringWithFormat:@"  %@", array[1]];
    }
    _postPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.5 + 1, 181, (self.view.frame.size.width - 40) * 0.5 - 1, 29)];
    _postPriceLabel.backgroundColor = [UIColor whiteColor];
    _postPriceLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_postPriceLabel];
    if(array.count){
        _postPriceLabel.text = [NSString stringWithFormat:@"  %@", array[0]];
    }
    
    _goodsPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.5 + 1, 211, (self.view.frame.size.width - 40) * 0.5 - 1, 29)];
    _goodsPriceLabel.backgroundColor = [UIColor whiteColor];
    _goodsPriceLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_goodsPriceLabel];
    _goodsPriceLabel.text = [NSString stringWithFormat:@"  %0.1f元", _goodsPrice];
}
- (void)addPayAndLookBtn
{
    // 支付按钮
    UIButton *payBtn = [[UIButton alloc]init];
    [payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    payBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [payBtn setBackgroundImage:[UIImage resizedImage:@"common_button_big_red.png"] forState:UIControlStateNormal];
    payBtn.frame = CGRectMake(30, 280, self.view.frame.size.width - 60, 40);
    [payBtn addTarget:self action:@selector(clickPayBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payBtn];
    // 查看按钮
    UIButton *lookBtn = [[UIButton alloc]init];
    [lookBtn setTitle:@"查看订单" forState:UIControlStateNormal];
    [lookBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    lookBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [lookBtn setBackgroundImage:[UIImage resizedImage:@"button.png"] forState:UIControlStateNormal];
    lookBtn.frame = CGRectMake(30, 350, self.view.frame.size.width - 60, 40);
    [lookBtn addTarget:self action:@selector(clickLookBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lookBtn];
}
- (void)clickPayBtn
{
    [[PayTool sharedPayTool] payWithOrderNo:_orderCode ProductName:@"城市厨房产品" ProductDescription:_deliveryType Amount:0.01];
}
- (void)clickLookBtn
{
//    [self.navigationController pushViewController:[[DetailOrderController alloc]init] animated:YES];
    // 弹出订单详情
    MainController *main = (MainController *) self.view.window.rootViewController;
    UINavigationController *navi = (UINavigationController *) main.selectedController;
    DetailOrderController *detailOrderController = [[DetailOrderController alloc] initWithStyle:UITableViewStyleGrouped];
    detailOrderController.orderCode = _orderCode;
//    detailOrderController.orde
    [navi pushViewController:detailOrderController animated:YES];
    [self refreshShopCar];
}
// 刷新购物车
- (void)refreshShopCar
{
    // 刷新购物车
    [[ModelManager sharedManager] httpRequestGetUserShopCarGoodsWithUserCode:[AccountTool sharedAccountTool].account.userCode];
    // 关闭此控制器
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}

@end
