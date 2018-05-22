//
//  HomeOddCell.m
//  城市厨房
//
//  Created by 臧昊 on 15/2/10.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "HomeOddCell.h"
#import "UIColor+ZH.h"
#import "HomeGoodsShow.h"
#import "GoodsList.h"
#import "GoodsDetail.h"
#import "GoodsDetailButton.h"
#import "UIImageView+WebCache.h"
#import "DetailController.h"
#import "GoodsListButton.h"
#import "GoodsListController.h"

#define kTitleHeight 30
#define kCellHeight (30 + [UIScreen mainScreen].bounds.size.width * 0.5 + 50)
#define kCellWidth [UIScreen mainScreen].bounds.size.width
#define kListDockHeight 50

@interface HomeOddCell()
{
    UILabel *_titleLabel;
    NSArray *_listBtnArray;
    GoodsDetailButton *_detailBtn0;
    GoodsDetailButton *_detailBtn1;
    GoodsDetailButton *_detailBtn2;
    NSMutableArray *_detailBtnArray;
}
@end

@implementation HomeOddCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addtitleViews];
        [self addLines];
        [self addDetailBtns];
    }
    return self;
}

- (void)addLines
{
    UIImageView *line1 = [[UIImageView alloc]init];
    line1.backgroundColor = RGB(228, 228, 228);
    line1.frame = CGRectMake([UIScreen mainScreen].bounds.size.width * 0.5, 30, 1, [UIScreen mainScreen].bounds.size.width * 0.5);
//    NSLog(@"%f", self.frame.size.width);
    [self addSubview:line1];
    
    UIImageView *line2 = [[UIImageView alloc]init];
    line2.backgroundColor = RGB(228, 228, 228);
    line2.frame = CGRectMake([UIScreen mainScreen].bounds.size.width * 0.5, 30 + [UIScreen mainScreen].bounds.size.width * 0.25, [UIScreen mainScreen].bounds.size.width * 0.5, 1);
    [self addSubview:line2];
}

- (void)addtitleViews
{
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(8, 11, 8, 8);
    view.backgroundColor = [UIColor randomColor];
    [self addSubview:view];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(24, 0, [UIScreen mainScreen].bounds.size.width, 30)];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:_titleLabel];
}

- (void)addListBtnsWithNum:(NSInteger)listBtnNum
{
    NSMutableArray *listMutableArray = [NSMutableArray array];
    for (int i = 0; i < listBtnNum; i ++)
    {
        GoodsListButton *listBtn = [[GoodsListButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
        listBtn.center = CGPointMake(kCellWidth / (listBtnNum * 2) * (2 * i + 1),kCellHeight - kListDockHeight * 0.5);
        
        [self addSubview:listBtn];
        [listMutableArray addObject:listBtn];
    }
    _listBtnArray = [NSArray arrayWithArray:listMutableArray];
    
}


- (void)addDetailBtns
{
    _detailBtnArray = [NSMutableArray array];
    
    _detailBtn0 = [[GoodsDetailButton alloc]initWithFrame:CGRectMake(0, kTitleHeight, kCellWidth * 0.5, kCellWidth * 0.5)];
    [self addSubview:_detailBtn0];
    [_detailBtnArray addObject:_detailBtn0];
    
    _detailBtn1 = [[GoodsDetailButton alloc]initWithFrame:CGRectMake(kCellWidth * 0.5, kTitleHeight, kCellWidth * 0.5, kCellWidth * 0.25)];
    // 重写标题label大小
    _detailBtn1.goodsDetailTitle.frame = CGRectMake(5, 5, _detailBtn1.frame.size.width * 0.8, 16);
    _detailBtn1.goodsDetailTitle.numberOfLines = 1;
    [self addSubview:_detailBtn1];
    [_detailBtnArray addObject:_detailBtn1];
    
    
    _detailBtn2 = [[GoodsDetailButton alloc]initWithFrame:CGRectMake(kCellWidth * 0.5, kTitleHeight + kCellWidth * 0.25, kCellWidth * 0.5, kCellWidth * 0.25)];
    // 重写标题label大小
    _detailBtn2.goodsDetailTitle.frame = CGRectMake(5, 5, _detailBtn2.frame.size.width * 0.8, 16);
    _detailBtn2.goodsDetailTitle.numberOfLines = 1;
    [self addSubview:_detailBtn2];
    [_detailBtnArray addObject:_detailBtn2];
}

- (void)setHomeGoods:(HomeGoodsShow *)homeGoods
{
    _titleLabel.text = homeGoods.title;
    if (homeGoods.goodsListArray)
    {
        [self addListBtnsWithNum:homeGoods.goodsListArray.count];
        for (int i = 0; i < homeGoods.goodsListArray.count; i ++)
        {
            [_listBtnArray[i] setTitle:[homeGoods.goodsListArray[i] listTitle]  forState:UIControlStateNormal];
            
            GoodsListButton *listBtn = _listBtnArray[i];
            listBtn.listCode = [homeGoods.goodsListArray[i] listCode];
            [_listBtnArray[i] addTarget:self action:@selector(clickListBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    if (homeGoods.goodsDetailArray) {
//        NSString *url = [homeGoods.goodsDetailArray[0] goodsImageUrl];
//        
//        NSString *imageUrl = [NSString stringWithFormat:@"http://115.28.231.147%@", url];
////        UIImageView *imageView0 = [[UIImageView alloc]init];
//        [_detailBtn0.goodsImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"defualt_goods_img.png"]];
////        [_detailBtn0 setImage:imageView0.image forState:UIControlStateNormal];
//        _detailBtn0.goodsDetailTitle.text = [homeGoods.goodsDetailArray[0] goodsTitle];
//        NSLog(@"%@", [homeGoods.goodsDetailArray[0] goodsTitle]);
//        _detailBtn0.goodsDetailPrice.text = [NSString stringWithFormat:@"特价:\n%0.1f元",[homeGoods.goodsDetailArray[0] goodsPrice]];
        
        for (int i = 0; i < homeGoods.goodsDetailArray.count; i ++)
        {
            NSString *url = [homeGoods.goodsDetailArray[i] goodsImageUrl];
//            NSString *imageBaseUrl = kImageURL;
            NSString *imageUrl = [kImageURL stringByAppendingString:url];
            //        UIImageView *imageView0 = [[UIImageView alloc]init];
            GoodsDetailButton *btn = _detailBtnArray[i];
            [[btn goodsImage] sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"defualt_goods_img.png"]];
            //        [_detailBtn0 setImage:imageView0.image forState:UIControlStateNormal];
            [btn goodsDetailTitle].text = [homeGoods.goodsDetailArray[i] goodsTitle];
//            NSLog(@"%@", [homeGoods.goodsDetailArray[i] goodsTitle]);
            [btn goodsDetailPrice].text = [NSString stringWithFormat:@"特价:\n%0.1f元",[homeGoods.goodsDetailArray[i] goodsPrice]];
            btn.detailCode = [homeGoods.goodsDetailArray[i] detailCode];
            [btn addTarget:self action:@selector(clickDetailBtn:) forControlEvents:UIControlEventTouchUpInside];

        }
    }
}

- (void)clickDetailBtn:(GoodsDetailButton *)detailBtn
{
    DetailController *detail = [[DetailController alloc] init];
    detail.detailCode = detailBtn.detailCode;
    MainController *main = (MainController *)self.window.rootViewController;
    UINavigationController *nav = (UINavigationController *)main.selectedController;
    [nav pushViewController:detail animated:YES];
}

- (void)clickListBtn:(GoodsListButton *)listBtn
{
    // push商品列表控制器
    NSLog(@"%@",listBtn.listCode);
    GoodsListController *list = [[GoodsListController alloc] init];
    list.listCode = listBtn.listCode;
    MainController *main = (MainController *)self.window.rootViewController;
    UINavigationController *nav = (UINavigationController *)main.selectedController;
    [nav pushViewController:list animated:YES];
}

@end
