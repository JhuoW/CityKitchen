//
//  AddressCell.m
//  城市厨房
//
//  Created by 臧昊 on 15/2/22.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "AddressCell.h"

#import "MainController.h"

@interface AddressCell()
{
    UILabel *_nameLabel;
    UILabel *_telLabel;
    UILabel *_cityAddressLabel;
    UILabel *_definiteAddressLabel;
    BOOL isDefault;
    UIImageView *_defaultImg;
    
}

@end

@implementation AddressCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"common_arrow.png"]];
        [self addLabels];
        [self addDefaultImg];
    }
    return self;
}

- (void)addCheckboxBtn
{
//    _isSelectedToBuy = 1;
    
    _checkboxBtn = [[CheckButton alloc]initWithFrame:CGRectMake(0, 0, 50, 110)];
    //    _checkboxBtn.center = CGPointMake(25, 45);
    _checkboxBtn.selected = NO;
    
    [_checkboxBtn addTarget:self action:@selector(clickCheckboxBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_checkboxBtn];
}

- (void)clickCheckboxBtn{
    MainController *main = (MainController *)self.window.rootViewController;
    UINavigationController *nav = (UINavigationController *)main.selectedController;
    [nav popViewControllerAnimated:YES];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:_address forKey:@"address"];
    // 投送通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"checkThisAddress" object:nil userInfo:dict];
}

- (void)addLabels
{
    // name
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 5, self.frame.size.width, 25)];
    _nameLabel.font = [UIFont systemFontOfSize:18];
    [self addSubview:_nameLabel];
    
    // telephone
    _telLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 30, self.frame.size.width, 25)];
    _telLabel.font = [UIFont systemFontOfSize:16];
    _telLabel.textColor = [UIColor grayColor];
    [self addSubview:_telLabel];
    
    // cityAddress
    _cityAddressLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 55, self.frame.size.width, 25)];
    _cityAddressLabel.font = [UIFont systemFontOfSize:16];
    _cityAddressLabel.textColor = [UIColor grayColor];
    [self addSubview:_cityAddressLabel];
    
    // definiteAddress
    _definiteAddressLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 80, self.frame.size.width, 25)];
    _definiteAddressLabel.font = [UIFont systemFontOfSize:16];
    _definiteAddressLabel.textColor = [UIColor grayColor];
    [self addSubview:_definiteAddressLabel];
}

 - (void)setAddress:(Address *)address
{
    _address = address;
    _nameLabel.text = address.name;
    _telLabel.text = address.tel;
    _cityAddressLabel.text = [NSString stringWithFormat:@"%@ %@ %@", address.province, address.city, address.district];
    _definiteAddressLabel.text = address.definiteAddress;
    
    // 是否为默认收货地址
    if (address.isDefault) {
        [self addSubview:_defaultImg];
    }else{
        [_defaultImg removeFromSuperview];
    }
}

- (void)setIsCanCheck:(BOOL)isCanCheck
{
    // name
    _nameLabel.frame = CGRectMake(50, 5, self.frame.size.width, 25);
    
    // telephone
    _telLabel.frame = CGRectMake(50, 30, self.frame.size.width, 25);
    
    // cityAddress
    _cityAddressLabel.frame = CGRectMake(50, 55, self.frame.size.width, 25);
    
    // definiteAddress
    _definiteAddressLabel.frame = CGRectMake(50, 80, self.frame.size.width, 25);
    
    [self addCheckboxBtn];
}

- (void)addDefaultImg
{
    _defaultImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    _defaultImg.center = CGPointMake([UIScreen mainScreen].bounds.size.width - 70, 20);
    _defaultImg.backgroundColor = kBackgroundGeenColor;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(3, 0, 57, 20)];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:13];
    label.text = @"默认地址";
    [_defaultImg addSubview:label];
}

@end
