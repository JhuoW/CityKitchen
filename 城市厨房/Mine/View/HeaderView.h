//
//  HeaderView.h
//  城市厨房
//
//  Created by 臧昊 on 15/1/30.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UIView
@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *balanceLabel;
@property (nonatomic, strong) UILabel *discountLabel;
@property (nonatomic, strong) UILabel *evalLabel;
//- (UILabel *)addBottomBtn:(NSString *)optionName index:(int) i;

@end
