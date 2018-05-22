//
//  ShopCarController.m
//  城市厨房
//
//  Created by 臧昊 on 15/1/20.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "ShopCarController.h"
#import "UIImage+ZH.h"
#import "ShopCarGoods.h"
#import "ShopCarGoodsCell.h"
#import "ModelManager.h"
#import "ModelRequestResult.h"
#import "AccountTool.h"
#import "NSMutableAttributedString+ZH.h"
#import "DetailController.h"
#import "EditOrderController.h"

#import "MBProgressHUD.h"

@interface ShopCarController ()<UITableViewDataSource, UITableViewDelegate, ShopCarGoodsCellDelegate>
{
//    int _GoodsNum;
    CGFloat _allPrice;
    UIButton *_boughtBtn;
    NSMutableArray *_shopCarArray;
    UITableView *_shopCarTableView;
    // 被选中欲生成订单的
    NSMutableArray *_selectedGoodsArray;
    UIView *_nilView;
 
    MBProgressHUD *_hud;
}
@end

@implementation ShopCarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购物车";
    self.view.backgroundColor = BackgroundColor;
    [self insertView];
    [self addShopCarTableView];
    [self addBoughtView];
#warning 当未登录时弹出登录界面
    if ([AccountTool sharedAccountTool].account) {
        [[ModelManager sharedManager] httpRequestGetUserShopCarGoodsWithUserCode:[AccountTool sharedAccountTool].account.userCode];
        _hud = [MBProgressHUD showHUDAddedTo:_shopCarTableView animated:YES];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopCarGoodsFinished:) name:kModelRequestGetUserShopCar object:nil];
    }
    
}

- (void)shopCarGoodsFinished: (NSNotification *)notification
{
    ModelRequestResult *result = [notification.userInfo objectForKey:DICT_MODEL_REQUEST_RESULT_KEY];
    NSDictionary *dict = result.responseObject;
//    NSLog(@"%@", dict);
    _shopCarArray = [NSMutableArray array];
    _goodsSum = 0;
    _goodsSumPrice = 0;
    for (NSDictionary *dictionary in dict[@"cartItemList"]) {
        ShopCarGoods *_shopCarGoods = [[ShopCarGoods alloc]initWithDict:dictionary];
        [_shopCarArray addObject:_shopCarGoods];
        _goodsSum += _shopCarGoods.num;
        _goodsSumPrice += _shopCarGoods.num * _shopCarGoods.price;
        NSLog(@"%d---%f", _goodsSum, _goodsSumPrice);
        NSLog(@"%@", _shopCarGoods.cartItemId);
//        _goodsSumPrice = 0;
//        NSLog(@"%ld", _shopCarArray.count);
    }
    [_hud hide:YES];
    if (!_shopCarArray.count) {
        // 当购物车为空时显示的界面
        [self.view insertSubview: _nilView atIndex:self.view.subviews.count];
    }else{
        _boughtBtn.enabled = YES;
        [_nilView removeFromSuperview];
    }
    NSString *numString = [NSString stringWithFormat:@"%d", _goodsSum];
    _numLabel.attributedText = [NSMutableAttributedString mutableAttributedStringCreatedWithString:[NSString stringWithFormat:@"总数\n%d件", _goodsSum] rangeFrom:3 length:numString.length];
    NSString *priceString = [NSString stringWithFormat:@"￥%.1f", _goodsSumPrice];
    _priceLabel.attributedText = [NSMutableAttributedString mutableAttributedStringCreatedWithString:[NSString stringWithFormat:@"预计价格\n￥%.1f", _goodsSumPrice] rangeFrom:5 length:priceString.length];
    [_shopCarTableView reloadData];
}

- (void)addShopCarTableView
{
    _shopCarTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kDockHeight - 20) style:UITableViewStyleGrouped];
    _shopCarTableView.delegate = self;
    _shopCarTableView.dataSource = self;
    [self.view addSubview:_shopCarTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _shopCarArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark - 创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"Cell";
//    ShopCarGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[ShopCarGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell.shopCarGoods = _shopCarArray[indexPath.row];
//        cell.delegate= self;
//    }
    
    ShopCarGoodsCell *cell = [[ShopCarGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil ];
    cell.shopCarGoods = _shopCarArray[indexPath.row];
    cell.delegate= self;
    return cell;
}


#pragma mark 删除cell代理
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        // 获取选中删除行索引值
        NSInteger row = [indexPath row];
        [[ModelManager sharedManager]httpRequestRemoveCartItemId:[_shopCarArray[row] cartItemId] WithUserCode:[AccountTool sharedAccountTool].account.userCode];
        // 更新Dock中的label
        _goodsSum -= [_shopCarArray[row] num];
        _goodsSumPrice -= [_shopCarArray[row] num] * [_shopCarArray[row] price];
        NSString *numString = [NSString stringWithFormat:@"%d", _goodsSum];
        _numLabel.attributedText = [NSMutableAttributedString mutableAttributedStringCreatedWithString:[NSString stringWithFormat:@"总数\n%d件", _goodsSum] rangeFrom:3 length:numString.length];
        NSString *priceString = [NSString stringWithFormat:@"￥%.1f", _goodsSumPrice];
        _priceLabel.attributedText = [NSMutableAttributedString mutableAttributedStringCreatedWithString:[NSString stringWithFormat:@"预计价格\n￥%.1f", _goodsSumPrice] rangeFrom:5 length:priceString.length];
        // 通过获取的索引值删除数组中的值
        [_shopCarArray removeObjectAtIndex:row];
        // 删除单元格的某一行时，在用动画效果实现删除过程
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }  
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark shopCarCell的代理方法
- (void)shopCarGoodsNumChangeFrom:(int)oldNum to:(int)newNum withPrice:(double)price
{
    _goodsSum -= oldNum;
    _goodsSum += newNum;
    _goodsSumPrice -= oldNum * price;
    _goodsSumPrice += newNum * price;
    NSString *numString = [NSString stringWithFormat:@"%d", _goodsSum];
    _numLabel.attributedText = [NSMutableAttributedString mutableAttributedStringCreatedWithString:[NSString stringWithFormat:@"总数\n%d件", _goodsSum] rangeFrom:3 length:numString.length];
    NSString *priceString = [NSString stringWithFormat:@"￥%.1f", _goodsSumPrice];
    _priceLabel.attributedText = [NSMutableAttributedString mutableAttributedStringCreatedWithString:[NSString stringWithFormat:@"预计价格\n￥%.1f", _goodsSumPrice] rangeFrom:5 length:priceString.length];
//    _numLabel.text = [NSString stringWithFormat:@"总数\n%d件", _goodsSum];
//    _priceLabel.text = [NSString stringWithFormat:@"预计价格\n￥%.1f", _goodsSumPrice];
}

- (void)shopCarGoodsCheckThisGoodsPrice:(double)price andNum:(int)num
{
    _goodsSum += num;;
    _goodsSumPrice += num * price;
    NSString *numString = [NSString stringWithFormat:@"%d", _goodsSum];
    _numLabel.attributedText = [NSMutableAttributedString mutableAttributedStringCreatedWithString:[NSString stringWithFormat:@"总数\n%d件", _goodsSum] rangeFrom:3 length:numString.length];
    NSString *priceString = [NSString stringWithFormat:@"￥%.1f", _goodsSumPrice];
    _priceLabel.attributedText = [NSMutableAttributedString mutableAttributedStringCreatedWithString:[NSString stringWithFormat:@"预计价格\n￥%.1f", _goodsSumPrice] rangeFrom:5 length:priceString.length];
}

- (void)shopCarGoodsUnCheckThisGoodsPrice:(double)price andNum:(int)num
{
    _goodsSum -= num;;
    _goodsSumPrice -= num * price;
    NSString *numString = [NSString stringWithFormat:@"%d", _goodsSum];
    _numLabel.attributedText = [NSMutableAttributedString mutableAttributedStringCreatedWithString:[NSString stringWithFormat:@"总数\n%d件", _goodsSum] rangeFrom:3 length:numString.length];
    NSString *priceString = [NSString stringWithFormat:@"￥%.1f", _goodsSumPrice];
    _priceLabel.attributedText = [NSMutableAttributedString mutableAttributedStringCreatedWithString:[NSString stringWithFormat:@"预计价格\n￥%.1f", _goodsSumPrice] rangeFrom:5 length:priceString.length];
}

- (void)addBoughtView
{
    UIView *boughtView = [[UIView alloc]init];
    boughtView.backgroundColor = [UIColor whiteColor];
    boughtView.frame = CGRectMake(0, self.view.frame.size.height - 2 * kDockHeight - 20, self.view.frame.size.width, kDockHeight);
    UIImageView *line1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    line1.backgroundColor = kLineColor;
    [boughtView addSubview:line1];
    UIImageView *line2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1, kDockHeight - 10)];
    line2.center = CGPointMake(self.view.frame.size.width / 3, kDockHeight / 2);
    line2.backgroundColor = kLineColor;
    [boughtView addSubview:line2];
    UIImageView *line3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1, kDockHeight - 10)];
    line3.center = CGPointMake(self.view.frame.size.width / 3 * 2, kDockHeight / 2);
    line3.backgroundColor = kLineColor;
    [boughtView addSubview:line3];
    [self.view addSubview:boughtView];
    
    _numLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width / 3, kDockHeight)];
    _numLabel.textColor = [UIColor grayColor];
    _numLabel.numberOfLines = 0;
    _numLabel.textAlignment = NSTextAlignmentCenter;
    _numLabel.text = [NSString stringWithFormat:@"总数\n0件"];
    [boughtView addSubview:_numLabel];
    
    _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 3, 0, self.view.frame.size.width / 3, kDockHeight)];
    _priceLabel.textColor = [UIColor grayColor];
    _priceLabel.numberOfLines = 0;
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    _priceLabel.text = [NSString stringWithFormat:@"预计价格\n￥0"];
    [boughtView addSubview:_priceLabel];
    
    _boughtBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width / 3 - 6, kDockHeight - 4)];
    _boughtBtn.center = CGPointMake(self.view.frame.size.width * 5 / 6, kDockHeight * 0.5);
    [_boughtBtn setBackgroundImage:[UIImage imageWithColor:kBackgroundGeenColor] forState:UIControlStateNormal];
    [_boughtBtn setTitle:@"结 算" forState:UIControlStateNormal];
    [_boughtBtn addTarget:self action:@selector(clickBoughtBtn) forControlEvents:UIControlEventTouchUpInside];
    _boughtBtn.enabled = NO;
    [boughtView addSubview:_boughtBtn];
}

- (void)clickBoughtBtn
{
    _selectedGoodsArray = [NSMutableArray array];
    // 遍历每个cell，确认该cell用户是否购买
    for (int i = 0; i < _shopCarArray.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        ShopCarGoodsCell *cell = (ShopCarGoodsCell *)[_shopCarTableView cellForRowAtIndexPath:indexPath];
        if (cell.isSelectedToBuy) {
            [_selectedGoodsArray addObject:cell.shopCarGoods];
        }
    }
    // 判断是否选中商品
    if(_selectedGoodsArray.count){
        EditOrderController *editOrderController = [[EditOrderController alloc]init];
        editOrderController.selectedGoodsArray = _selectedGoodsArray;
        editOrderController.allGoodsPrice = _goodsSumPrice;
        [self.navigationController pushViewController:editOrderController animated:YES];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择至少一件商品" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
    
}

#pragma mark - 购物车为空显示
- (void)insertView
{
    _nilView = [[UIView alloc]initWithFrame:self.view.frame];
    _nilView.backgroundColor = BackgroundColor;
    UIButton *shopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shopBtn.bounds = CGRectMake(0, 0, self.view.frame.size.width * 0.8, 40 );
    shopBtn.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.5);
    [shopBtn setBackgroundImage:[UIImage resizedImage:@"common_button_big_red.png"] forState:UIControlStateNormal];
    [shopBtn setTitle:@"逛一逛" forState:UIControlStateNormal];
    [shopBtn addTarget:self action:@selector(clickShopBtn) forControlEvents:UIControlEventTouchDown];
    [_nilView addSubview:shopBtn];
    
    UIImage *image = [UIImage imageNamed:@"shopCar.png"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, image.size.width * 0.6, image.size.height * 0.6)];
    imageView.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.3);
    imageView.image = image;
    [_nilView addSubview:imageView];
    
    UILabel *messageLabel = [[UILabel alloc]init];
    messageLabel.bounds = CGRectMake(0, 0, self.view.frame.size.width * 0.8, 20);
    messageLabel.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.41);
    messageLabel.text = @"购物车是空的，快去选购心爱的商品吧!";
    messageLabel.textColor = [UIColor grayColor];
    messageLabel.font = [UIFont systemFontOfSize:14];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    [_nilView addSubview:messageLabel];
    
}

- (void)clickShopBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
