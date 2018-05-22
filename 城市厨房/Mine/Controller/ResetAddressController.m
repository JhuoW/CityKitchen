//
//  ResetAddressController.m
//  城市厨房
//
//  Created by 臧昊 on 15/3/9.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "ResetAddressController.h"
#import "SetAddressCell.h"
#import "UIImage+ZH.h"
#import "ModelManager.h"
#import "ModelRequestResult.h"
#import "AccountTool.h"

@interface ResetAddressButton : UIButton
@end

@implementation ResetAddressButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat x = 10;
    CGFloat y = 0;
    CGFloat width = contentRect.size.width - 2 * x;
    CGFloat height = contentRect.size.height;
    return CGRectMake(x, y, width, height);
}
@end

@interface ResetAddressController()<UIAlertViewDelegate>
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

@implementation ResetAddressController
- (void)viewDidLoad
{
    self.view.backgroundColor = BackgroundColor;
    self.title = @"修改收货地址";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addNav];
    [self addResetAddressButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeUserAddressFinished:) name:kModelRequestRemoveUserAddress object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetUserAddressFinished:) name:kModelRequestResetUserAddress object:nil];
}

- (void)addNav
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"删除" forState:UIControlStateNormal];
    //    btn.backgroundColor = [UIColor redColor];
    //    button1.enabled = NO;
    btn.bounds = CGRectMake(0, 0, 30, 15);
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [btn addTarget:self action:@selector(clickRemoveBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (void)removeUserAddressFinished:(NSNotification *)notification
{
    ModelRequestResult *result = [notification.userInfo objectForKey:DICT_MODEL_REQUEST_RESULT_KEY];
    NSDictionary *dict = result.responseObject;
    if ([dict[@"ret"]isEqualToString:@"success"]) {
        [[ModelManager sharedManager]httpRequestGetUserAddressWithUserCode:[AccountTool sharedAccountTool].account.userCode];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"删除成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alertView.tag = 2;
        [alertView show];
    }
}

- (void)resetUserAddressFinished:(NSNotification *)notification
{
    ModelRequestResult *result = [notification.userInfo objectForKey:DICT_MODEL_REQUEST_RESULT_KEY];
    NSDictionary *dict = result.responseObject;
    if ([dict[@"ret"]isEqualToString:@"success"]) {
        [[ModelManager sharedManager]httpRequestGetUserAddressWithUserCode:[AccountTool sharedAccountTool].account.userCode];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"修改成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alertView.tag = 3;
        [alertView show];
    }
}

- (void)clickRemoveBtn
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定要删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 1;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            [[ModelManager sharedManager]httpRequestRemoveUserAddress:_address.addressId WithUserCode:[AccountTool sharedAccountTool].account.userCode];
        }
    }else if (alertView.tag == 2 || alertView.tag == 3){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)addResetAddressButton
{
    ResetAddressButton *resetAddressBtn = [ResetAddressButton buttonWithType:UIButtonTypeCustom];
    
    [resetAddressBtn setImage:[UIImage resizedImage:@"common_button_big_red.png"] forState:UIControlStateNormal];
    [resetAddressBtn setImage:[UIImage resizedImage:@"common_button_big_red_highlighted.png"] forState:UIControlStateHighlighted];
    
    // tableFooterView的宽度不需要设置。默认就是整个tableView的宽度。
    resetAddressBtn.bounds = CGRectMake(0, 0, 0, 44);
    
    // 设置按钮文字
    [resetAddressBtn setTitle:@"确认修改 " forState:UIControlStateNormal];
    //    logout.contentEdgeInsets = UIEdgeInsetsMake(0, 100, 0, 100);
    
    // 设置tableView整体的边界
    //    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    //    UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
    
    self.tableView.tableFooterView = resetAddressBtn;
    [resetAddressBtn addTarget:self action:@selector(clickResetAddressBtn) forControlEvents:UIControlEventTouchUpInside];
//    _verifyBtn = verifyBtn;
}

- (void)clickResetAddressBtn
{
    NSLog(@"%@",_nameTextField.text);
    NSLog(@"%@", _addressTextField.text);
    NSLog( @"%@", _telTextField.text);
    if ([_nameTextField.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"姓名为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }else{
        if ([_areaTextField.text isEqualToString:@""]) {
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
                    [[ModelManager sharedManager] httpRequestResetUserAddressId:_address.addressId definiteAddress:_addressTextField.text andProvince:@"江苏" andCity:@"徐州" andDistrict:_areaTextField.text andPostCode:_postCodeTextField.text andTel:_telTextField.text andName:_nameTextField.text andIsDefault:_isDefaultAddress WithUserCode:[AccountTool sharedAccountTool].account.userCode];
                }
            }
        }
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
            _nameTextField.text = _address.name;
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"地区";
            [cell addStarLabel];
            _districtLabel = [cell addDistrictLabel];
            _districtLabel.text = @"江苏省 徐州市";
            _areaTextField = [[UITextField alloc]initWithFrame:CGRectMake(190, 0, 150, 44)];
            // _areaTextField.backgroundColor = [UIColor greenColor];
            _areaTextField.placeholder = @"（区、县）";
            _areaTextField.textColor = [UIColor grayColor];
            _areaTextField.text = _address.district;
            [cell.contentView addSubview:_areaTextField];
        }else if (indexPath.row == 2){
            cell.textLabel.text = @"地址";
            [cell addStarLabel];
            _addressTextField = [cell addTextField];
            _addressTextField.text = _address.definiteAddress;
        }else if (indexPath.row == 3){
            cell.textLabel.text = @"手机";
            [cell addStarLabel];
            _telTextField = [cell addTextField];
            _telTextField.text = _address.tel;
        }else {
            cell.textLabel.text = @"邮编";
            _postCodeTextField = [cell addTextField];
            if (_address.postCode) {
                _postCodeTextField.text = _address.postCode;
            }
        }
    }else{
        cell.textLabel.text = @"默认地址";
        // cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        _isDefaultAddress = _address.isDefault;
        if (_isDefaultAddress) {
            UIImage *checkedImg = [UIImage imageNamed:@"checkbox_checked.png"];
            UIImageView *accessoryView = [[UIImageView alloc]initWithImage:checkedImg];
            accessoryView.bounds = CGRectMake(0, 0, checkedImg.size.width * 0.7, checkedImg.size.height * 0.7);
            [self.tableView cellForRowAtIndexPath:indexPath].accessoryView = accessoryView;
            cell.accessoryView = accessoryView;
            
        }else{
            UIImage *uncheckedImg = [UIImage imageNamed:@"checkbox_unchecked.png"];
            UIImageView *accessoryView = [[UIImageView alloc]initWithImage:uncheckedImg];
            accessoryView.bounds = CGRectMake(0, 0, uncheckedImg.size.width * 0.7, uncheckedImg.size.height * 0.7);
            [self.tableView cellForRowAtIndexPath:indexPath].accessoryView = accessoryView;
            cell.accessoryView = accessoryView;
        }
        
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
