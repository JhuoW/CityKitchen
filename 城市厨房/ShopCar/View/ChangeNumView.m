//
//  ChangeNumView.m
//  城市厨房
//
//  Created by 臧昊 on 15/2/27.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "ChangeNumView.h"
#import "ShopCarGoodsCell.h"

@interface ChangeNumView()
{
    UIButton *_subBtn;
    UIButton *_addBtn;
    int _goodsNum;
}

@end

@implementation ChangeNumView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addBtnAndLabel];
    }
    return self;
}

- (void)addBtnAndLabel
{
    // 减少按钮
    _subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _subBtn.bounds = CGRectMake(0, 0, 30, 30);
    _subBtn.center = CGPointMake(self.frame.size.width * 0.5 - 30, 25);
    [_subBtn setBackgroundImage:[UIImage imageNamed:@"numberSub.png"] forState:UIControlStateNormal];
    [_subBtn addTarget:self action:@selector(subNum) forControlEvents:UIControlEventTouchUpInside];
    // 默认为1，所以减号按钮设为disabled
//    _subBtn.enabled = NO;
    [self addSubview:_subBtn];
    // 添加按钮
    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addBtn.bounds = CGRectMake(0, 0, 30, 30);
    _addBtn.center = CGPointMake(self.frame.size.width * 0.5 + 30, 25);
    [_addBtn setBackgroundImage:[UIImage imageNamed:@"numberAdd.png"] forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(addNum) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addBtn];
    
    // 数量label
//    _goodsNum = 1;
    _numLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    _numLabel.center = CGPointMake(self.frame.size.width * 0.5, 25);
//    _numLabel.text = [NSString stringWithFormat:@"%d", _goodsNum];
    _numLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_numLabel];
    
        UIImageView *lineView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 1)];
    lineView1.center = CGPointMake(self.frame.size.width * 0.5, 10);
        lineView1.backgroundColor = RGB(234, 234, 234);
        [self addSubview:lineView1];
        UIImageView *lineView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 1)];
    lineView2.center = CGPointMake(self.frame.size.width * 0.5, 40);
        lineView2.backgroundColor = RGB(234, 234, 234);
        [self addSubview:lineView2];
}

//- (void)setNumLabel:(UILabel *)numLabel
//{
//    _numLabel = numLabel;
//    _goodsNum = [_numLabel.text intValue];
//}

- (void)subNum
{
    _goodsNum = [_numLabel.text intValue];
    if (_goodsNum > 1) {
        _goodsNum -= 1;
        _numLabel.text = [NSString stringWithFormat:@"%d", _goodsNum];
//        if (_goodsNum == 1) {
//            _subBtn.enabled = NO;
//        }
    }
}

- (void)addNum
{
    _goodsNum = [_numLabel.text intValue];
    _goodsNum += 1;
    _numLabel.text = [NSString stringWithFormat:@"%d", _goodsNum];
//    _subBtn.enabled = YES;
}

@end
