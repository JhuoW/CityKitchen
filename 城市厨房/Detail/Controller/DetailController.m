//
//  DetailController.m
//  城市厨房
//
//  Created by 臧昊 on 15/2/14.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "DetailController.h"
#import "ModelManager.h"
#import "ModelRequestResult.h"
#import "DetailGoods.h"
#import "GoodsShowView.h"
#import "AccountTool.h"
#import "CompanyController.h"
#import "NSMutableAttributedString+ZH.h"
#import "GoodsInformationController.h"
#import "MBProgressHUD.h"
#import "MyBrowse.h"
#import "ShopCarController.h"
#import "LoginController.h"
#import "WBNavigationController.h"
#import "GoodsEvaluateController.h"
#define kShopDock 50
#define kDetailGoodsCellHeight 250

@interface DetailController() <UITableViewDelegate, UITableViewDataSource>
{
    DetailGoods *_detailGoods;
    NSString *_detailIntroduction;
    UITableView *_goodsTableView;
    int _goodsNum;
    UILabel *_numLabel;
    UIButton *_subBtn;
    UIButton *_addBtn;
    UIButton *_boughtBtn;
    UIView *_shopDock;
    
    MBProgressHUD *_hud;
}
@end
@implementation DetailController 

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"商品详情";
    self.view.backgroundColor = BackgroundColor;
    // 添加收藏按钮
    [self addNav];
    // 添加底部操作条
    [self addShopDock];
    _shopDock.userInteractionEnabled = NO;
    // 添加tableView
    [self addGoodsTableView];
    if (kCheckNetStatus) {
        [[ModelManager sharedManager] httpRequestGetGoodsSimpleInformationWithCode:_detailCode];
        _hud = [MBProgressHUD showHUDAddedTo:_goodsTableView animated:YES];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goodsSimpleInformationFinished:) name:kModelRequestGetGoodsSimpleInformation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addToShopCarFinished:) name:kModelRequestAdd2ShopCar object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCollectedProductFinished:) name:kModelRequestAddCollectedProduct object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeCollectedProductFinished:) name:kModelRequestRemoveCollectedProduct object:nil];
    
    
}

//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kModelRequestGetGoodsSimpleInformation object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kModelRequestGetGoodsDetailInformation object:nil];
//}


- (void)goodsSimpleInformationFinished: (NSNotification *)notification
{
    ModelRequestResult *result = [notification.userInfo objectForKey:DICT_MODEL_REQUEST_RESULT_KEY];
    NSLog(@"%@",result.responseString);
    if (result.succ) {
        NSDictionary *dict = [result.responseObject objectForKey:@"productObj"];
        _detailGoods = [[DetailGoods alloc]initWithDict:dict];
    }
    _shopDock.userInteractionEnabled = YES;
    [_goodsTableView reloadData];
    [_hud hide:YES];
    
    // 加入浏览记录
    NSMutableArray *browseProductArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"browseProductCode"] mutableCopy];
//    NSLog(@"%@", browseProductArray);
    if(browseProductArray.count == 0){
        browseProductArray = [NSMutableArray array];
    }
    if (browseProductArray.count >= 20) {
        [browseProductArray removeLastObject];
    }
    BOOL i = 1;
    for (NSData *data in browseProductArray) {
        MyBrowse *myBrowse = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([myBrowse.productCode isEqualToString:_detailCode]) {
            i = 0;
            NSLog(@"%d",i);
            break;
        }
    }
    if (i) {
        MyBrowse *myBrowse = [[MyBrowse alloc]init];
        myBrowse.productCode = _detailCode;
        myBrowse.productName = _detailGoods.name;
        if (_detailGoods.pics.count) {
            myBrowse.pic = _detailGoods.pics[0];
        }
        if (_detailGoods.prices.count) {
            myBrowse.price = _detailGoods.prices[0][@"price"];
//            NSLog(@"896546435134  %@", myBrowse.price);
        }
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:myBrowse];
        [browseProductArray insertObject:data atIndex:0];
        
        [[NSUserDefaults standardUserDefaults] setObject:browseProductArray forKey:@"browseProductCode"];
        // 快速执行上一句话
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

- (void)addToShopCarFinished:(NSNotification *)notification
{
    ModelRequestResult *result = [notification.userInfo objectForKey:DICT_MODEL_REQUEST_RESULT_KEY];
    NSDictionary *dict = result.responseObject;
    if ([dict[@"ret"] isEqualToString:@"success"]) {
        [self showAlert:@"加入购物车成功"];
        [[ModelManager sharedManager] httpRequestGetUserShopCarGoodsWithUserCode:[AccountTool sharedAccountTool].account.userCode];
    }
}

- (void)addCollectedProductFinished:(NSNotification *)notification
{
    ModelRequestResult *result = [notification.userInfo objectForKey:DICT_MODEL_REQUEST_RESULT_KEY];
    NSDictionary *dict = result.responseObject;
    if ([dict[@"ret"] isEqualToString:@"success"]) {
        [self showAlert:@"收藏成功"];
    }
}

- (void)removeCollectedProductFinished:(NSNotification *)notification
{
    ModelRequestResult *result = [notification.userInfo objectForKey:DICT_MODEL_REQUEST_RESULT_KEY];
    NSDictionary *dict = result.responseObject;
    if ([dict[@"ret"] isEqualToString:@"success"]) {
        [self showAlert:@"删除收藏成功"];
    }
}

- (void)addNav
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn setTitle:@"添加" forState:UIControlStateNormal];
    //    btn.backgroundColor = [UIColor redColor];
    //    button1.enabled = NO;
//    btn.bounds = CGRectMake(0, 0, 30, 15);
//    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    UIImage *imgSelected = [UIImage imageNamed:@"detail_favorite.png"];
    UIImage *img = [UIImage imageNamed:@"detail_favorite_pressed.png"];
    btn.bounds = CGRectMake(0, 0, img.size.width, img.size.height * 0.85) ;
    btn.selected = NO;
    [btn setImage:imgSelected forState:UIControlStateSelected];
    [btn setImage:img forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickCollectBtn:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)clickCollectBtn:(UIButton *)btn
{
    if ([AccountTool sharedAccountTool].account) {
        btn.selected = !btn.selected;
        if (btn.selected) {
            [[ModelManager sharedManager]httpRequestAddCollectedProduct:_detailCode WithUserCode:[AccountTool sharedAccountTool].account.userCode];
        }else{
            [[ModelManager sharedManager]httpRequestRemoveCollectedProduct:_detailCode WithUserCode:[AccountTool sharedAccountTool].account.userCode];
        }
    }else{
        [self showLoginController];
    }
}

- (void)addShopDock
{
    _shopDock = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - kDockHeight - 20 - kShopDock, self.view.frame.size.width, 50)];
    _shopDock.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_shopDock];
    // 分割线
    UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    lineView.backgroundColor = kLineColor;
    [_shopDock addSubview:lineView];
    // 减少按钮
    _subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _subBtn.bounds = CGRectMake(0, 0, 30, 30);
    _subBtn.center = CGPointMake(30, _shopDock.frame.size.height * 0.5);
    [_subBtn setBackgroundImage:[UIImage imageNamed:@"numberSub.png"] forState:UIControlStateNormal];
    [_subBtn addTarget:self action:@selector(subNum) forControlEvents:UIControlEventTouchUpInside];
    _subBtn.enabled = NO;
    [_shopDock addSubview:_subBtn];
    // 添加按钮
    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addBtn.bounds = CGRectMake(0, 0, 30, 30);
    _addBtn.center = CGPointMake(90, _shopDock.frame.size.height * 0.5);
    [_addBtn setBackgroundImage:[UIImage imageNamed:@"numberAdd.png"] forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(addNum) forControlEvents:UIControlEventTouchUpInside];
    [_shopDock addSubview:_addBtn];
    
    // 数量label
    _goodsNum = 1;
    _numLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    _numLabel.center = CGPointMake(_subBtn.center.x + 30, _shopDock.frame.size.height * 0.5);
    _numLabel.text = [NSString stringWithFormat:@"%d", _goodsNum];
    _numLabel.textAlignment = NSTextAlignmentCenter;
    [_shopDock addSubview:_numLabel];
    
    UIImageView *lineView1 = [[UIImageView alloc]initWithFrame:CGRectMake(45, 10, 30, 1)];
    lineView1.backgroundColor = RGB(234, 234, 234);
    [_shopDock addSubview:lineView1];
    UIImageView *lineView2 = [[UIImageView alloc]initWithFrame:CGRectMake(45, 39, 30, 1)];
    lineView2.backgroundColor = RGB(234, 234, 234);
    [_shopDock addSubview:lineView2];
    
    // 购买按钮
    _boughtBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _boughtBtn.frame = CGRectMake(120, 10, self.view.frame.size.width - 120 - 60, 30);
    [_boughtBtn setBackgroundColor:kBackgroundGeenColor];
    [_boughtBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    _boughtBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_boughtBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_boughtBtn addTarget:self action:@selector(addToShopCar) forControlEvents:UIControlEventTouchUpInside];
    [_shopDock addSubview:_boughtBtn];
    
    // 购物车按钮
    UIButton * shopCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shopCarBtn.frame = CGRectMake(self.view.frame.size.width - 45, 10, 30, 30);
    [shopCarBtn setBackgroundImage:[UIImage imageNamed:@"shopcar_float.png"] forState:UIControlStateNormal];
//    [shopCarBtn setTitle:@"1" forState:UIControlStateNormal];
    [_shopDock addSubview:shopCarBtn];
    [shopCarBtn addTarget:self action:@selector(showShopCar) forControlEvents:UIControlEventTouchUpInside];
    
//    UILabel *shopNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, 14, 14)];
//    shopNumLabel.textColor = kBackgroundGeenColor;
//    shopNumLabel.font = [UIFont systemFontOfSize:10];
//    shopNumLabel.textAlignment = NSTextAlignmentCenter;
//    shopNumLabel.text = @"99";
//    [shopCarBtn addSubview:shopNumLabel];
    
}

- (void)showShopCar
{
    if ([AccountTool sharedAccountTool].account) {
        [self.navigationController pushViewController:[[ShopCarController alloc] init] animated:YES];
    }else{
        [self showLoginController];
    }
}

- (void)addToShopCar
{
    if ([AccountTool sharedAccountTool].account) {
        [[ModelManager sharedManager]httpRequestAddGoods:_detailCode inNum:_goodsNum WithProductPriceId:_detailGoods.prices[0][@"productPriceId"] UserCode:[AccountTool sharedAccountTool].account.userCode];
    }else{
        [self showLoginController];
    }
}

- (void)showLoginController
{
    LoginController *loginController = [[LoginController alloc]initWithStyle:UITableViewStyleGrouped];
    WBNavigationController *nvc = [[WBNavigationController alloc]initWithRootViewController:loginController];
    // 弹出登录界面
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)addGoodsTableView
{
    _goodsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kDockHeight - 20 - kShopDock) style:UITableViewStyleGrouped];
//    _goodsTableView.backgroundColor = [UIColor brownColor];
    _goodsTableView.dataSource = self;
    _goodsTableView.delegate = self;
    [self.view addSubview:_goodsTableView];
}

- (void)subNum
{
    if (_goodsNum > 1) {
        _goodsNum -= 1;
        _numLabel.text = [NSString stringWithFormat:@"%d", _goodsNum];
        if (_goodsNum == 1) {
            _subBtn.enabled = NO;
        }
    }
}

- (void)addNum
{
    _goodsNum += 1;
    _numLabel.text = [NSString stringWithFormat:@"%d", _goodsNum];
    _subBtn.enabled = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_detailGoods) {
        return 4;
    }else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return kDetailGoodsCellHeight;
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        return 100;
    }
    return 44;
}

#pragma mark - 创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (_detailGoods ) {
        if (indexPath.section == 0) {
            GoodsShowView * goodsShowView = [[GoodsShowView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kDetailGoodsCellHeight) andDetailGoods:_detailGoods];
            [cell.contentView addSubview:goodsShowView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else if (indexPath.section == 1) {
            cell.textLabel.text = @"商品信息";
             cell.accessoryView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"common_arrow.png"]];
        }else if (indexPath.section == 2){
            cell.textLabel.text = @"商品评价";
            cell.accessoryView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"common_arrow.png"]];
            for (int i = 0; i < _detailGoods.score; i ++) {
                UIImageView *starView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"starlight.png"]];
                starView.bounds = CGRectMake(0, 0, 10, 10);
                starView.center = CGPointMake(100 + 12 * i, cell.frame.size.height * 0.5);
                [cell addSubview:starView];
            }
            for (int i = 0; i < 5 - _detailGoods.score; i ++) {
                UIImageView *starView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"starlight.png"]];
                starView.bounds = CGRectMake(0, 0, 10, 10);
                starView.center = CGPointMake(100 + 12 *( i + _detailGoods.score ), cell.frame.size.height * 0.5);
                [cell addSubview:starView];
            }
            UILabel *scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
            scoreLabel.center = CGPointMake(175, cell.frame.size.height * 0.5);
            scoreLabel.text = [NSString stringWithFormat:@"(%d)", _detailGoods.evalNum] ;
            scoreLabel.textColor = [UIColor grayColor];
            scoreLabel.font = [UIFont systemFontOfSize:14];
            [cell addSubview:scoreLabel];
            
        }else if (indexPath.section == 3) {
            NSMutableAttributedString *AttributedStr = [NSMutableAttributedString mutableAttributedStringCreatedWithString:[NSString stringWithFormat:@"商家  %@", _detailGoods.companyName] rangeFrom:4 length:_detailGoods.companyName.length];
//            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"商家  %@", _detailGoods.companyName]];
//            
//            [AttributedStr addAttribute:NSForegroundColorAttributeName
//                                  value:kBackgroundGeenColor
//                                  range:NSMakeRange(4, _detailGoods.companyName.length)];
            
            cell.textLabel.attributedText = AttributedStr;
//            cell.textLabel.text = [NSString stringWithFormat:@"商家  %@", _detailGoods.companyName];
            if ([_detailGoods.companyName isEqualToString:@"商城自营"]) {
                cell.accessoryView = nil;
            }else{
                cell.accessoryView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"common_arrow.png"]];
            }
        }
//        else{
//            cell.textLabel.text = @"猜您喜欢";
//        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 3 && ![_detailGoods.companyName isEqualToString:@"商城自营"]) {
        CompanyController *companyController = [[CompanyController alloc]initWithStyle:UITableViewStyleGrouped];
        companyController.companyCode = _detailGoods.companyCode;
        [self.navigationController pushViewController:companyController animated:YES];
    }else if (indexPath.section == 1) {
        GoodsInformationController *goodsInfo = [[GoodsInformationController alloc]init];
        goodsInfo.detailCode = _detailCode;
        [self.navigationController pushViewController:goodsInfo animated:YES];
    }else if (indexPath.section == 2){
        GoodsEvaluateController *goodsEva = [[GoodsEvaluateController alloc]initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:goodsEva animated:YES];
    }
}

#pragma mark - 自动消失提示框
- (void)timerFireMethod:(NSTimer*)theTimer{//弹出框
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}
- (void)showAlert:(NSString *) _message{//时间
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:nil message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [NSTimer scheduledTimerWithTimeInterval:1.0f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}

@end
