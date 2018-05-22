//
//  LoginController.m
//  城市厨房
//
//  Created by 臧昊 on 15/1/30.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "LoginController.h"
#import "UIImage+ZH.h"
#import <CommonCrypto/CommonCrypto.h>
#import "ModelManager.h"
#import "ModelRequestResult.h"
#import "AccountTool.h"
#import "MainController.h"

@interface LoginController () //<UITextFieldDelegate>
@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackgroundColor;
    
    self.title = @"登录";
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 25)];
    [leftButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(loginCancel) forControlEvents:UIControlEventTouchUpInside];
    self.navigationController.navigationBar.topItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    // 登录按钮
    UIButton *loginButton = [[UIButton alloc]init];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [loginButton setBackgroundImage:[UIImage resizedImage:@"common_button_big_red.png"] forState:UIControlStateNormal];
    loginButton.frame = CGRectMake(25, 150, self.view.frame.size.width - 50, 45);
    [loginButton addTarget:self action:@selector(clickLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userCodeFinished:) name:kModelRequestGetUserCode object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInformationFinished:) name:kModelRequestGetUserInformation object:nil];
    
//    NSLog(@"%@", [self getMd5_32Bit_String:[self getMd5_32Bit_String:@"aaa"]]);
}

- (void)clickLoginBtn
{
    
    if (kCheckNetStatus) {
        if (self.nameField.text.length == 0) {
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        }
        // 密码位数
//        else if (self.pwdField.text.length < 6){
//            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"密码不能少于6位" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alert show];
//            return;
//        }
        [[ModelManager sharedManager] httpRequestGetUserCodeWithLoginKey:_nameField.text andPassword:[self getMd5_32Bit_String:[self getMd5_32Bit_String:_pwdField.text]]];
    }else{
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络好像出错了..." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
}

// 获取到userCode值
- (void)userCodeFinished: (NSNotification *)notification
{
    ModelRequestResult *result = [notification.userInfo objectForKey:DICT_MODEL_REQUEST_RESULT_KEY];
    NSDictionary *dict = result.responseObject;
    if ([dict[@"ret"] isEqualToString:@"success"]) {
        
        if (kCheckNetStatus) {
            // 获取用户信息
            [[ModelManager sharedManager] httpRequestGetUserInformationWithUserCode:dict[@"userCode"]];
        }
        
        
    }else{
        // 弹出错误提示框
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@", dict[@"errorMsg"]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

// 获取到用户信息
- (void)userInformationFinished: (NSNotification *)notification
{
    ModelRequestResult *result = [notification.userInfo objectForKey:DICT_MODEL_REQUEST_RESULT_KEY];
    NSDictionary *dict = result.responseObject;
    if ([dict[@"ret"] isEqualToString:@"success"]) {
        NSDictionary *userObjDict = dict[@"userObj"];
        // 保存账户和code值
        Account *account = [[Account alloc]init];
        
        account.userPwd = _pwdField.text;
        
        account.userCode = userObjDict[@"usercode"];
        account.userName = userObjDict[@"name"];
        account.cartNum = [userObjDict[@"cartNum"] intValue];
        account.evalNum = [userObjDict[@"evalNum"] intValue];
        account.orderNum = [userObjDict[@"orderNum"] intValue];
        [[AccountTool sharedAccountTool] saveAccount:account];
        
        // 投送通知
        [[NSNotificationCenter defaultCenter]postNotificationName:@"loginSuccess" object:nil];
        
//        if ([_delegate respondsToSelector:@selector(loginSuccessToShowUserInformation)]) {
//            [_delegate loginSuccessToShowUserInformation];
//        }
//        MainController *main = (MainController *) self.view.window.rootViewController;
//        if (main.childViewControllers[3]) {
//            UITableView *t = (UITableView *)[[main.childViewControllers[3] rootViewController] view];
//            [t reloadData];
//        }
        // 退出登录视图
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        // 弹出错误提示框
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@", dict[@"errorMsg"]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"账号";
        _nameField = [[UITextField alloc]init];
        _nameField.placeholder = @"请输入账号";
        _nameField.frame = CGRectMake(80, 0, cell.frame.size.width - 60, cell.frame.size.height);
//        _nameField.delegate = self;
//        accountTextfield.center = CGPointMake(60 + cell.frame.size.width * 0.5, cell.textLabel.center.y);
        [cell.contentView addSubview:_nameField];
    }else {
        cell.textLabel.text = @"密码";
        _pwdField = [[UITextField alloc]init];
        _pwdField.placeholder = @"请输入密码";
        _pwdField.frame = CGRectMake(80, 0, cell.frame.size.width - 60, cell.frame.size.height);
        // 设置成“安全”模式输入
        _pwdField.secureTextEntry = YES;
//        _pwdField.delegate = self;
        [cell.contentView addSubview:_pwdField];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)loginCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
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
