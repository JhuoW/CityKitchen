//
//  DetailOrderController.m
//  城市厨房
//
//  Created by 臧昊 on 15/3/4.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "DetailOrderController.h"
#import "ModelManager.h"
#import "ModelRequestResult.h"
#import "Order.h"
#import "DetailOrderGoodsCell.h"
#import "UIImage+ZH.h"
#import "PayTool.h"

@interface DetailOrderController()
{
//    NSMutableArray *_orderGoodsArray;
    Order *_order;
}

@end

@implementation DetailOrderController
- (void)viewDidLoad
{
//    self.view.backgroundColor =
    self.title = @"订单详情";
    [[ModelManager sharedManager]httpRequestQueryOrderWithOrderCode:_orderCode];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryOrderFinished:) name:kModelRequestQueryOrder object:nil];
}
- (void)queryOrderFinished:(NSNotification *)notification
{
    ModelRequestResult *result = [notification.userInfo objectForKey:DICT_MODEL_REQUEST_RESULT_KEY];
    NSDictionary *dict = result.responseObject;
    
    if (dict[@"ret"]) {
        _order = [[Order alloc]initWithDict:dict[@"order"]];
        [self.tableView reloadData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return _order.productsArray.count;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section) {
        return 60;
    }else{
        return 70;
    }
}

#pragma mark - 创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld", (long)indexPath.section, (long)indexPath.row];
        DetailOrderGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[DetailOrderGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
//        NSLog(@"%@",[orderGoods.productsArray[indexPath.row] productCode]);
        cell.orderGoods = _order.productsArray[indexPath.row];
//        cell.productCode = [_orderGoodsArray[indexPath.row] productCode];
        return cell;
    }else{
        NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld", (long)indexPath.section, (long)indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.section == 0) {
            if (_order) {
                cell.imageView.image = [UIImage imageNamed:@"orderDetail_order.png"];
                UILabel *statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, 150, 20)];
                statusLabel.textColor = kBackgroundGeenColor;
                statusLabel.text = _order.status;
                [cell addSubview:statusLabel];
                
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 40, 80, 20)];
                label.font = [UIFont systemFontOfSize:16];
                label.text = @"订单金额:";
                [cell addSubview:label];
                
                UILabel * accountLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 40, 60, 20)];
                accountLabel.text = [NSString stringWithFormat:@"￥%0.1f", _order.account];
                accountLabel.textColor = kBackgroundGeenColor;
                [cell addSubview:accountLabel];
                
                if ([_order.status isEqualToString:@"未付款"]) {
                    UIButton *payBtn = [[UIButton alloc]init];
                    [payBtn setTitle:@"付款" forState:UIControlStateNormal];
                    payBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                    [payBtn setBackgroundImage:[UIImage resizedImage:@"common_button_big_red.png"] forState:UIControlStateNormal];
                    payBtn.frame = CGRectMake(self.view.frame.size.width - 100, 20, 60, 30);
                    [payBtn addTarget:self action:@selector(clickpayBtn) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:payBtn];
                }
            }
//        }else if (indexPath.section == 1){
//            cell.imageView.image = [UIImage imageNamed:@"orderDetail_user.png"];
//            UILabel *nameAndTelLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, self.view.frame.size.width - 80, 20)];
//            nameAndTelLabel.backgroundColor = [UIColor redColor];
//            //        nameAndTelLabel.text = [NSString stringWithFormat:@"%@  %@", _order.]
//            [cell addSubview:nameAndTelLabel];
//            
//            UILabel *addrLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 35, self.view.frame.size.width - 80, 20)];
//            addrLabel.backgroundColor = [UIColor redColor];
//            [cell addSubview:addrLabel];
        }else{
            if (_order) {
                UILabel *orderCodeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 8, self.view.frame.size.width - 20, 20)];
                //            nameAndTelLabel.backgroundColor = [UIColor redColor];
                orderCodeLabel.font = [UIFont systemFontOfSize:16];
                orderCodeLabel.text = [NSString stringWithFormat:@"订单编号: %@", _order.orderCode];
                [cell addSubview:orderCodeLabel];
                
                UILabel *orderTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 32, self.view.frame.size.width - 20, 20)];
                //            addrLabel.backgroundColor = [UIColor redColor];
                orderTimeLabel.font = [UIFont systemFontOfSize:16];
                orderTimeLabel.text = [NSString stringWithFormat:@"下单时间: %@", _order.createTime];
                [cell addSubview:orderTimeLabel];
            }
        }
        return cell;
    }
        
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section) {
        return 10;
    }else{
        return 0.001;
    }
}

- (void)clickpayBtn
{
    [[PayTool sharedPayTool] payWithOrderNo:_orderCode ProductName:@"城市厨房产品" ProductDescription:_order.createTime Amount:_order.account];
}

@end
