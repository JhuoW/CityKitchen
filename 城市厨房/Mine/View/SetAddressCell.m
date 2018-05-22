//
//  SetAddressCell.m
//  城市厨房
//
//  Created by 臧昊 on 15/3/2.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "SetAddressCell.h"

@interface SetAddressCell()<UITextFieldDelegate>
{
    
}

@end

@implementation SetAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)addStarLabel
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 10, self.frame.size.height * 0.5)];
    label.center = CGPointMake(60, self.frame.size.height * 0.5);
    label.text = @"*";
    label.font = [UIFont systemFontOfSize:24];
    label.textColor = [UIColor redColor];
    [self addSubview:label];
}

- (UITextField *)addTextField
{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(75, 0, [UIScreen mainScreen].bounds.size.width - 85, self.frame.size.height)];
    [self.contentView addSubview:textField];
    textField.textColor = [UIColor grayColor];
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyDone;
    return textField;
}

- (UILabel *)addDistrictLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(75, 0, 115, self.frame.size.height)];
    [self.contentView addSubview:label];
    return label;
}

//按下Done按钮时调用这个方法，可让按钮消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
