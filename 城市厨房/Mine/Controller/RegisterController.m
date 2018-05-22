//
//  RegisterController.m
//  城市厨房
//
//  Created by 臧昊 on 15/1/30.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "RegisterController.h"
#import "UIImage+ZH.h"
#import "ModelManager.h"
#import "ModelRequestResult.h"
#import <CommonCrypto/CommonCrypto.h>

@interface RegisterController ()<UITextFieldDelegate, UIAlertViewDelegate>
{
    UITextField *_telField;
    UITextField *_userNameField;
    UITextField *_pwdField_1;
    UITextField *_pwdField_2;
}
@end

@implementation RegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    self.title = @"注册";
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 25)];
    [leftButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(registerCancel) forControlEvents:UIControlEventTouchUpInside];
    self.navigationController.navigationBar.topItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
//
    UIButton *registerButton = [[UIButton alloc]init];
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [registerButton setBackgroundImage:[UIImage resizedImage:@"common_button_big_red.png"] forState:UIControlStateNormal];
    registerButton.frame = CGRectMake(25, 200, self.view.frame.size.width - 50, 45);
    [registerButton addTarget:self action:@selector(clickRegisterBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerFinished:) name:kModelRequestRegister object:nil];
    
}

- (void)registerFinished: (NSNotification *)notification
{
    ModelRequestResult *result = [notification.userInfo objectForKey:DICT_MODEL_REQUEST_RESULT_KEY];
    NSDictionary *dict = result.responseObject;
    if (kCheckNetStatus) {
        if([dict[@"ret"] isEqualToString:@"error"]){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@", dict[@"errorMsg"]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注册成功"delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alertView.tag = 1;
            [alertView show];
        }
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)clickRegisterBtn
{
    
    if ([self isMobileNumber:_telField.text]) {
//        NSLog(@"success" );
        if ([_userNameField.text isEqualToString:@""]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            
        }else if ([_pwdField_1.text isEqualToString:@""] && [_pwdField_2.text isEqualToString:@""]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }else if ([_pwdField_1.text isEqualToString:_pwdField_2.text]){
            // 提交注册
            [[ModelManager sharedManager]httpRequestRegisterLoginName:_userNameField.text andPwd:[self getMd5_32Bit_String:[self getMd5_32Bit_String:_pwdField_1.text]] withTel:_telField.text];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"两次输入密码不一致" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"手机号码输入有误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
}

- (void)registerCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"手机";
        _telField = [[UITextField alloc]init];
        _telField.placeholder = @"请输入手机号码";
        _telField.keyboardType = UIKeyboardTypePhonePad;
//        _telField.delegate = self;
//        [_telField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventTouchDown];
        _telField.frame = CGRectMake(100, 0, cell.frame.size.width - 60, cell.frame.size.height);
        [cell.contentView addSubview:_telField];
    }else if (indexPath.row == 1) {
        cell.textLabel.text = @"账号";
        _userNameField = [[UITextField alloc]init];
        _userNameField.placeholder = @"请输入账号";
        _userNameField.returnKeyType = UIReturnKeyDone;
        _userNameField.delegate = self;
        _userNameField.frame = CGRectMake(100, 0, cell.frame.size.width - 60, cell.frame.size.height);
        [cell.contentView addSubview:_userNameField];
    }else if (indexPath.row == 2){
        cell.textLabel.text = @"密码";
        _pwdField_1 = [[UITextField alloc]init];
        _pwdField_1.placeholder = @"请输入密码";
        _pwdField_1.secureTextEntry = YES;
        _pwdField_1.returnKeyType = UIReturnKeyDone;
        _pwdField_1.delegate = self;
        _pwdField_1.frame = CGRectMake(100, 0, cell.frame.size.width - 60, cell.frame.size.height);
        [cell.contentView addSubview:_pwdField_1];
    }else{
        cell.textLabel.text = @"确认密码";
        _pwdField_2 = [[UITextField alloc]init];
        _pwdField_2.placeholder = @"再次输入密码";
        _pwdField_2.secureTextEntry = YES;
        _pwdField_2.returnKeyType = UIReturnKeyDone;
        _pwdField_2.delegate = self;
        _pwdField_2.frame = CGRectMake(100, 0, cell.frame.size.width - 60, cell.frame.size.height);
        [cell.contentView addSubview:_pwdField_2];
    }
    return cell;
}
//按下Done按钮时调用这个方法，可让按钮消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}

//重写数字键盘的方法
//-(void)textFieldDone:(id)sender{
//    [_telField resignFirstResponder];
//}

#pragma mark 判断手机号是否正确
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
//    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
//    /**
//     10         * 中国移动：China Mobile
//     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     12         */
//    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
//    /**
//     15         * 中国联通：China Unicom
//     16         * 130,131,132,152,155,156,185,186
//     17         */
//    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
//    /**
//     20         * 中国电信：China Telecom
//     21         * 133,1349,153,180,189
//     22         */
//    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
//    /**
//     25         * 大陆地区固话及小灵通
//     26         * 区号：010,020,021,022,023,024,025,027,028,029
//     27         * 号码：七位或八位
//     28         */
//    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
//    
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//    
//    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
//        || ([regextestcm evaluateWithObject:mobileNum] == YES)
//        || ([regextestct evaluateWithObject:mobileNum] == YES)
//        || ([regextestcu evaluateWithObject:mobileNum] == YES))
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
//    
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobileNum];

}

//32位MD5加密方式
- (NSString *)getMd5_32Bit_String:(NSString *)srcString{
    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}

@end
