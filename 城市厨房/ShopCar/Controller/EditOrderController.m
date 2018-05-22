//
//  EditOrderController.m
//  城市厨房
//
//  Created by 臧昊 on 15/3/3.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "EditOrderController.h"
#import "AddressCell.h"
#import "ModelManager.h"
#import "ModelRequestResult.h"
#import "AccountTool.h"
#import "ShopCarGoods.h"
#import "OrderDetailCell.h"
#import "HttpTool.h"
#import "OrderController.h"
#import "WBNavigationController.h"
#import "MyAddressController.h"
#import "AddAddressController.h"

@interface EditOrderController()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_orderTableView;
    UIView *_orderDock;
    Address *_defaultAddress;
    UILabel *_nilAddressLabel;
    UILabel *_priceLabel;
}

@end

@implementation EditOrderController
- (void)viewDidLoad
{
    self.title = @"填写订单";
    self.view.backgroundColor = BackgroundColor;
    [self addTableViewAndDock];
    if (kCheckNetStatus) {
        [[ModelManager sharedManager]httpRequestGetUserAddressWithUserCode:[AccountTool sharedAccountTool].account.userCode];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAddressFinished:) name:kModelRequestGetUserAddress object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createOrderFinished:) name:kModelRequestCreateOrder object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNewAddress:) name:@"checkThisAddress" object:nil];
}

- (void)checkNewAddress:(NSNotification *)notification
{
    NSLog(@"dddddd");
    
    _defaultAddress = [notification.userInfo objectForKey:@"address"];
    [_orderTableView reloadData];
}

- (void)userAddressFinished: (NSNotification *)notification
{
    ModelRequestResult *result = [notification.userInfo objectForKey:DICT_MODEL_REQUEST_RESULT_KEY];
    NSDictionary *dict = result.responseObject;
    //    NSLog(@"%@",dict);
    if ([dict[@"ret"] isEqualToString:@"success"]) {
        NSArray *array = dict[@"deliveryAddress"];
        if (array.count) {
            for (NSDictionary *dictionary in array) {
                Address *address = [[Address alloc]initWithDict:dictionary];
                if (address.isDefault) {
                    _defaultAddress = address;
                    [_orderTableView reloadData];
                    return;
                }
            }
        }
    }
}

- (void)createOrderFinished: (NSNotification *)notification
{
    ModelRequestResult *result = [notification.userInfo objectForKey:DICT_MODEL_REQUEST_RESULT_KEY];
    NSDictionary *dict = result.responseObject;
    NSLog(@"%@", dict);
    if ([dict[@"ret"] isEqualToString:@"success"]) {
        OrderController *orderController = [[OrderController alloc]init];
        orderController.deliveryType = dict[@"deliveryType"];
        orderController.orderCode = dict[@"orderCode"];
        orderController.goodsPrice = _allGoodsPrice;
        WBNavigationController *nav = [[WBNavigationController alloc]initWithRootViewController:orderController];
        [self presentViewController:nav animated:NO completion:nil];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)addTableViewAndDock
{
    _orderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44 - 64) style:UITableViewStyleGrouped];
    _orderTableView.delegate = self;
    _orderTableView.dataSource = self;
    [self.view addSubview:_orderTableView];
    
    _orderDock = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 44 - 64, self.view.frame.size.width, 44)];
    _orderDock.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_orderDock];
    
    UIImageView *line1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    line1.backgroundColor = kLineColor;
    [_orderDock addSubview:line1];
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5)];
    imgView.backgroundColor = BackgroundColor;
    [_orderDock addSubview:imgView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 88, 44)];
    label.text = @"商品总价:";
//    label.backgroundColor  = [UIColor redColor];
    [_orderDock addSubview:label];
    
    _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 0, self.view.frame.size.width - 100 - 140, 44)];
    _priceLabel.textColor = kBackgroundGeenColor;
    _priceLabel.text = [NSString stringWithFormat:@"￥%0.1f",_allGoodsPrice];
    [_orderDock addSubview:_priceLabel];
    
    UIButton *submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 130, 7, 120, 30)];
    submitBtn.backgroundColor = kBackgroundGeenColor;
    [submitBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(clickSumbitOrder) forControlEvents:UIControlEventTouchUpInside];
    [_orderDock addSubview:submitBtn];
}

- (void)clickSumbitOrder
{
    NSMutableArray *selectedGoodsIdArray = [NSMutableArray array];
    for (ShopCarGoods *shopCarGoods in _selectedGoodsArray) {
        [selectedGoodsIdArray addObject:shopCarGoods.cartItemId];
        NSLog(@"%@", shopCarGoods.cartItemId);
    }
//#warning 出问题的参数
    NSString *cartIdArrayString = [selectedGoodsIdArray componentsJoinedByString:@","];// 出问题的参数
    NSLog(@"|||||%@", cartIdArrayString);
    if (_defaultAddress) {
        [[ModelManager sharedManager]httpRequestCreateOrder:cartIdArrayString WithUserCode:[AccountTool sharedAccountTool].account.userCode AndCustAddrId:_defaultAddress.addressId];
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择地址" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section) {
        return _selectedGoodsArray.count;
    }else{
        return 1;
    }
}

#pragma mark - 创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld", (long)indexPath.section, (long)indexPath.row];
        AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[AddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if(_defaultAddress){
            cell.address = _defaultAddress;
            [_nilAddressLabel removeFromSuperview];
        }else{
            _nilAddressLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
            _nilAddressLabel.center = CGPointMake(self.view.frame.size.width * 0.5, 55);
            _nilAddressLabel.textAlignment = NSTextAlignmentCenter;
            _nilAddressLabel.text = @"添加地址";
            _nilAddressLabel.textColor = kBackgroundGeenColor;
            [cell addSubview:_nilAddressLabel];
        }
        return cell;
    }else{
        NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld", (long)indexPath.section, (long)indexPath.row];
        OrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (cell == nil) {
            cell = [[OrderDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.shopCarGoods = (ShopCarGoods *) _selectedGoodsArray[indexPath.row];
//        cell.textLabel.text = [shopCarGoods name];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (_defaultAddress) {
            [self.navigationController pushViewController:[[MyAddressController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
        }else{
            [self.navigationController pushViewController:[[AddAddressController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
//    titleLabel.backgroundColor = BackgroundColor;
    titleLabel.textColor = [UIColor grayColor];
    if (section) {
        titleLabel.text = @"  商品清单";
    }else{
        titleLabel.text = @"  收货地址";
    }
    return titleLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 110;
    }else{
        return 65;
    }
}

- (void)setSelectedGoodsArray:(NSMutableArray *)selectedGoodsArray
{
    _selectedGoodsArray = selectedGoodsArray;
    [_orderTableView reloadData];
}


@end
