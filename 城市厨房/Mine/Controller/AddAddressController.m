//
//  AddAddressController.m
//  城市厨房
//
//  Created by 臧昊 on 15/3/2.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "AddAddressController.h"
#import "SetAddressCell.h"
#import "UIImage+ZH.h"
#import "ModelManager.h"
#import "ModelRequestResult.h"
#import "AccountTool.h"

#pragma mark - 底部添加按钮
@interface AddressButton : UIButton
@end

@implementation AddressButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat x = 10;
    CGFloat y = 0;
    CGFloat width = contentRect.size.width - 2 * x;
    CGFloat height = contentRect.size.height;
    return CGRectMake(x, y, width, height);
}
@end

@interface AddAddressController()<UIAlertViewDelegate, UITextFieldDelegate>
{
    UITextField *_nameTextField;
    UITextField *_areaTextField;
    UITextField *_addressTextField;
    UITextField *_telTextField;
    UITextField *_postCodeTextField;
    UILabel *_districtLabel;
    BOOL _isDefaultAddress;
    NSString *_districtString;
}

@end

@implementation AddAddressController
- (void)viewDidLoad
{
    self.view.backgroundColor = BackgroundColor;
    self.title = @"添加收货地址";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _isDefaultAddress = 1;
//    _districtString = @"铜山";
    [self addNav];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addUserAddressFinished:) name:kModelRequestAddUserAddress object:nil];
}

- (void)addUserAddressFinished:(NSNotification *)notification
{
    ModelRequestResult *result = [notification.userInfo objectForKey:DICT_MODEL_REQUEST_RESULT_KEY];
    NSDictionary *dict = result.responseObject;
    NSLog(@"%@",dict);
    if ([dict[@"ret"] isEqualToString:@"success"]) {
        [self showAlertView];
        [[ModelManager sharedManager]httpRequestGetUserAddressWithUserCode:[AccountTool sharedAccountTool].account.userCode];
    }
}

- (void)addNav
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    //    btn.backgroundColor = [UIColor redColor];
    //    button1.enabled = NO;
    btn.bounds = CGRectMake(0, 0, 30, 15);
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [btn addTarget:self action:@selector(clickAddressBtn) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark 点击添加地址按钮
- (void)clickAddressBtn
{
    NSLog(@"轻轻巧巧%@",_nameTextField.text);
    NSLog(@"%@", _addressTextField.text);
    NSLog( @"%@", _telTextField.text);
    if (!_nameTextField.text) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"姓名为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }else{
        if (!_areaTextField.text) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"区、县为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }else{
            if ([_addressTextField.text isEqualToString:@""]) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"地址为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
            }else{
                if ([_telTextField.text isEqualToString:@""]) {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"手机号码为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alertView show];
                }else{
                    [[ModelManager sharedManager] httpRequestAddUserAddress:_addressTextField.text andProvince:@"江苏" andCity:@"徐州" andDistrict:_areaTextField.text andPostCode:_postCodeTextField.text andTel:_telTextField.text andName:_nameTextField.text andIsDefault:_isDefaultAddress WithUserCode:[AccountTool sharedAccountTool].account.userCode];
                }
            }
        }
    }
}

- (void)showAlertView
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"添加成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    alertView.tag = 1;
    [alertView show];
}

// 根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section) {
        return 1;
    }else{
        return 5;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

#pragma mark - 创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SetAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SetAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height - 0.5, self.view.frame.size.width, 0.5)];
        lineImageView.backgroundColor = BackgroundColor;
        [cell.contentView addSubview:lineImageView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"姓名";
            [cell addStarLabel];
            _nameTextField = [cell addTextField];
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"地区";
            [cell addStarLabel];
            _districtLabel = [cell addDistrictLabel];
            _districtLabel.text = @"江苏省 徐州市";
            _areaTextField = [[UITextField alloc]initWithFrame:CGRectMake(190, 0, 150, 44)];
//            _areaTextField.backgroundColor = [UIColor greenColor];
            _areaTextField.placeholder = @"（区、县）";
            _areaTextField.textColor = [UIColor grayColor];
            [cell.contentView addSubview:_areaTextField];
        }else if (indexPath.row == 2){
            cell.textLabel.text = @"地址";
            [cell addStarLabel];
            _addressTextField = [cell addTextField];
        }else if (indexPath.row == 3){
            cell.textLabel.text = @"手机";
            [cell addStarLabel];
            _telTextField = [cell addTextField];
        }else {
            cell.textLabel.text = @"邮编";
            _postCodeTextField = [cell addTextField];
        }
    }else{
        cell.textLabel.text = @"默认地址";
//        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        UIImage *checkedImg = [UIImage imageNamed:@"checkbox_checked.png"];
        UIImageView *accessoryView = [[UIImageView alloc]initWithImage:checkedImg];
        accessoryView.bounds = CGRectMake(0, 0, checkedImg.size.width * 0.7, checkedImg.size.height * 0.7);
        cell.accessoryView = accessoryView;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        _isDefaultAddress = !_isDefaultAddress;
        if (_isDefaultAddress) {
            UIImage *checkedImg = [UIImage imageNamed:@"checkbox_checked.png"];
            UIImageView *accessoryView = [[UIImageView alloc]initWithImage:checkedImg];
            accessoryView.bounds = CGRectMake(0, 0, checkedImg.size.width * 0.7, checkedImg.size.height * 0.7);
            [self.tableView cellForRowAtIndexPath:indexPath].accessoryView = accessoryView;
            
        }else{
             UIImage *uncheckedImg = [UIImage imageNamed:@"checkbox_unchecked.png"];
            UIImageView *accessoryView = [[UIImageView alloc]initWithImage:uncheckedImg];
            accessoryView.bounds = CGRectMake(0, 0, uncheckedImg.size.width * 0.7, uncheckedImg.size.height * 0.7);
            [self.tableView cellForRowAtIndexPath:indexPath].accessoryView = accessoryView;
        }
    }
}



@end
