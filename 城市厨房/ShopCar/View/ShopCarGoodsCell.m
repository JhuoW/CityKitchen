//
//  ShopCarGoodsCell.m
//  城市厨房
//
//  Created by 臧昊 on 15/2/26.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "ShopCarGoodsCell.h"
#import "UIImageView+WebCache.h"
#import "MainController.h"
#import "DetailController.h"
#import "ChangeNumView.h"
#import "FVCustomAlertView.h"
#import "UIImage+ZH.h"
#import "ModelManager.h"
#import "ModelRequestResult.h"
#import "AccountTool.h"
#import "CheckButton.h"

@interface ShopCarGoodsCell()
{
    CheckButton *_checkboxBtn;
    UIImageView *_imgView;
    UILabel *_title;
    UILabel *_priceLabel;
    UIButton *_changeNumBtn;
    UILabel *_numLabel;
    NSString *_productCode;
    int _goodsNum;
//    ChangeNumView *_changeNumView;
    NSString *_cartItemId;
    UINavigationController *_navi;
    int _tempNum;
}
@property (nonatomic, strong)ChangeNumView *changeNumView;
@end

@implementation ShopCarGoodsCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 添加checkBox
        [self addCheckboxBtn];
        // 添加Img和Label
        [self addImageAndLabels];
        // 添加changeNumBtn
        [self addChangeNumBtn];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDetail)]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetShopCarGoodsNumFinished:) name:kModelRequestResetShopCarGoodsNum object:nil];
    }
    return self;
}

- (void)resetShopCarGoodsNumFinished:(NSNotification *)notification
{
    ModelRequestResult *result = [notification.userInfo objectForKey:DICT_MODEL_REQUEST_RESULT_KEY];
    NSDictionary *dict = result.responseObject;
    NSLog(@"%@", dict);
    if([dict[@"ret"] isEqualToString:@"success"])
    {
        
        // 旧商品数目
        _tempNum = [_numLabel.text intValue];
        // 新商品数目
        _goodsNum = [_changeNumView.numLabel.text intValue];
        _numLabel.text = [NSString stringWithFormat:@"%d", _goodsNum];
        // 减去原来的加上新的
        if ([_delegate respondsToSelector:@selector(shopCarGoodsNumChangeFrom:to:withPrice:)]) {
            [_delegate shopCarGoodsNumChangeFrom:_tempNum to:_goodsNum withPrice:_shopCarGoods.price];
        }
    }
//    MainController *main = (MainController *) self.window.rootViewController;
//    UINavigationController *navi = (UINavigationController *) main.selectedController;
//    [FVCustomAlertView showDefaultDoneAlertOnView:navi.view withTitle:@"Done"];
//    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(dismissAlertView) userInfo:nil repeats:NO];
}
- (void)dismissAlertView:(UIAlertView *)alertView
{
//    MainController *main = (MainController *) self.window.rootViewController;
//    UINavigationController *navi = (UINavigationController *) main.selectedController;
//    [FVCustomAlertView hideAlertFromView:navi.view fading:YES];
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

- (void)addCheckboxBtn
{
    _isSelectedToBuy = 1;
    
    _checkboxBtn = [[CheckButton alloc]initWithFrame:CGRectMake(0, 0, 50, 90)];
//    _checkboxBtn.center = CGPointMake(25, 45);
    _checkboxBtn.selected = YES;
    
    [_checkboxBtn addTarget:self action:@selector(clickCheckboxBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_checkboxBtn];
}

- (void)clickCheckboxBtn
{
    _checkboxBtn.selected = !_checkboxBtn.selected;
    _isSelectedToBuy= !_isSelectedToBuy;
    if(_isSelectedToBuy){
        if ([_delegate respondsToSelector:@selector(shopCarGoodsCheckThisGoodsPrice:andNum:)]) {
            [_delegate shopCarGoodsCheckThisGoodsPrice:_shopCarGoods.price andNum:_goodsNum];
        }
    }else{
        if ([_delegate respondsToSelector:@selector(shopCarGoodsUnCheckThisGoodsPrice:andNum:)]) {
            [_delegate shopCarGoodsUnCheckThisGoodsPrice:_shopCarGoods.price andNum:_goodsNum];
        }
    }
}

- (void)addImageAndLabels
{
    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 10, 70, 70)];
    [self addSubview:_imgView];
    
    _title = [[UILabel alloc]initWithFrame:CGRectMake(130, 10, [UIScreen mainScreen].bounds.size.width - 140, 20)];
    [self addSubview:_title];
    
    _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(135, 60, 100, 20)];
    _priceLabel.textColor = kBackgroundGeenColor;
    [self addSubview:_priceLabel];
}

- (void)addChangeNumBtn
{
    _goodsNum = 1;
    _changeNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *numImg = [UIImage imageNamed:@"numberbutton.png"];
    [_changeNumBtn setImage:numImg forState:UIControlStateNormal];
    _changeNumBtn.frame = (CGRect){CGPointMake([UIScreen mainScreen].bounds.size.width - 40 - numImg.size.width, 50), numImg.size};
    [_changeNumBtn addTarget:self action:@selector(clickChangeNumBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_changeNumBtn];
    _numLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
    _numLabel.center = CGPointMake(20, _changeNumBtn.frame.size.height * 0.5);
    _numLabel.textAlignment = NSTextAlignmentCenter;
    [_changeNumBtn addSubview:_numLabel];
}

#pragma mark 点击更换商品数目
- (void)clickChangeNumBtn
{
//    UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:@[@"Default", @"Custom"]];
//    [control setSelectedSegmentIndex:0];
//    [control setTintColor:[UIColor whiteColor]];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [sureButton setTintColor:kBackgroundGeenColor];
    [sureButton setTitle:@"确认" forState:UIControlStateNormal];
    [sureButton setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
//    [closeButton sizeToFit];
    [sureButton addTarget:self action:@selector(clickSureBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _changeNumView = [[ChangeNumView alloc] initWithFrame:CGRectMake(0, 5, 100, 100)];
    _changeNumView.numLabel.text = [NSString stringWithFormat:@"%d", _goodsNum];
    [_changeNumView addSubview:sureButton];
   
    sureButton.frame = CGRectMake(0, 0, 50, 30);
    sureButton.center = CGPointMake(_changeNumView.frame.size.width * 0.5, 75);
    
    MainController *main = (MainController *) self.window.rootViewController;
    UINavigationController *navi = (UINavigationController *) main.selectedController;
    [FVCustomAlertView showAlertOnView:navi.view withTitle:nil titleColor:[UIColor blackColor] width:150 height:110 backgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] backgroundColor:nil cornerRadius:5.0 shadowAlpha:0.4 alpha:0.9 contentView:_changeNumView type:FVAlertTypeCustom];
    
}

// 点击AlertView确定按钮
- (void)clickSureBtn:(id)sender {
    MainController *main = (MainController *) self.window.rootViewController;
    UINavigationController *navi = (UINavigationController *) main.selectedController;
    [FVCustomAlertView hideAlertFromView:navi.view fading:YES];
    [[ModelManager sharedManager]httpRequestResetCartItemId:_shopCarGoods.cartItemId number:_goodsNum WithUserCode:[AccountTool sharedAccountTool].account.userCode];
}

- (void)setShopCarGoods:(ShopCarGoods *)shopCarGoods
{
    _shopCarGoods = shopCarGoods;
    _productCode = shopCarGoods.productCode;
//    _cartItemId = shopCarGoods.cartItemId;
    if ([shopCarGoods.pic rangeOfString:@"http"].length) {
        [_imgView sd_setImageWithURL:[NSURL URLWithString:shopCarGoods.pic] placeholderImage:[UIImage imageNamed:@"defualt_iv_400.png"]];
    }else{
        NSString *imageUrl = [kImageURL stringByAppendingString:shopCarGoods.pic];
        [_imgView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"defualt_iv_400.png"]];
    }
    _title.text = shopCarGoods.name;
//    NSLog(@"11111111jjjj%@", shopCarGoods.cartItemId);
    _priceLabel.text = [NSString stringWithFormat:@"￥%0.1f", shopCarGoods.price];
//    _cartItemId = [[NSString alloc]init];
    
    _goodsNum = shopCarGoods.num;
    _numLabel.text = [NSString stringWithFormat:@"%d", _goodsNum];
    
    
}



@end
