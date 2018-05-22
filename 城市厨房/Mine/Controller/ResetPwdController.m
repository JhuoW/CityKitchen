//
//  ResetPwdController.m
//  城市厨房
//
//  Created by 臧昊 on 15/2/26.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "ResetPwdController.h"
#import "UIImage+ZH.h"
#import "AccountTool.h"
#import <CommonCrypto/CommonCrypto.h>
#import "ModelManager.h"
#import "ModelRequestResult.h"
#pragma mark - 底部确认按钮
@interface VerifyButton : UIButton
@end

@implementation VerifyButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat x = 10;
    CGFloat y = 0;
    CGFloat width = contentRect.size.width - 2 * x;
    CGFloat height = contentRect.size.height;
    return CGRectMake(x, y, width, height);
}
@end

@interface ResetPwdController()
{
    UITextField *_oldPwd;
    UITextField *_newPwd_1;
    UITextField *_newPwd_2;
    VerifyButton *_verifyBtn;
}

@end

@implementation ResetPwdController
- (void)viewDidLoad
{
    self.title = @"修改密码";
    [self addVerifyBtn];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetPwdFinished:) name:kModelRequestResetUserPwd object:nil];
}

- (void)resetPwdFinished: (NSNotification *)notification
{
    ModelRequestResult *result = [notification.userInfo objectForKey:DICT_MODEL_REQUEST_RESULT_KEY];
    NSDictionary *dict = result.responseObject;
    if([dict[@"ret"] isEqualToString:@"success"]){
        [AccountTool sharedAccountTool].account.userPwd = _newPwd_1.text;
        UIAlertView *errorPwdView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码修改成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [errorPwdView show];
    }else if ([dict[@"ret"] isEqualToString:@"error"]){
        UIAlertView *errorPwdView = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@", dict[@"errorMsg"]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [errorPwdView show];
    }
}

- (void)addVerifyBtn
{
    VerifyButton *verifyBtn = [VerifyButton buttonWithType:UIButtonTypeCustom];
    
    [verifyBtn setImage:[UIImage resizedImage:@"common_button_big_red.png"] forState:UIControlStateNormal];
    [verifyBtn setImage:[UIImage resizedImage:@"common_button_big_red_highlighted.png"] forState:UIControlStateHighlighted];
    
    // tableFooterView的宽度不需要设置。默认就是整个tableView的宽度。
    verifyBtn.bounds = CGRectMake(0, 0, 0, 44);
    
    // 设置按钮文字
    [verifyBtn setTitle:@"确认修改 " forState:UIControlStateNormal];
    //    logout.contentEdgeInsets = UIEdgeInsetsMake(0, 100, 0, 100);
    
    // 设置tableView整体的边界
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    //    UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
    
    self.tableView.tableFooterView = verifyBtn;
    [verifyBtn addTarget:self action:@selector(clickVerifyBtn) forControlEvents:UIControlEventTouchUpInside];
    _verifyBtn = verifyBtn;
}

- (void)clickVerifyBtn
{
    // 原始密码错误
    if (![_oldPwd.text isEqualToString:[AccountTool sharedAccountTool].account.userPwd]) {
        NSLog(@"%@", _oldPwd.text);
        NSLog(@"%@", [AccountTool sharedAccountTool].account.userPwd);
        UIAlertView *errorPwdView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"现密码错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [errorPwdView show];
    // 没输入新密码
    }else if (!(_newPwd_1.text || _newPwd_2.text)){
        UIAlertView *nilNewPwdView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入新密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [nilNewPwdView show];
    // 两次输入新密码不同
    }else if (![_newPwd_1.text isEqualToString:_newPwd_2.text]){
        UIAlertView *nilNewPwdView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"两次输入新密码不同" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [nilNewPwdView show];
    // 发送修改密码网络请求
    }else if ([_oldPwd.text isEqualToString:_newPwd_1.text]){
        UIAlertView *nilNewPwdView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"现密码与欲修改密码相同" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [nilNewPwdView show];
    }
    else{
        [[ModelManager sharedManager]httpRequestUseUserCode:[AccountTool sharedAccountTool].account.userCode ResetOldPwd:[self getMd5_32Bit_String:[self getMd5_32Bit_String:_oldPwd.text]] withNewPwd:[self getMd5_32Bit_String:[self getMd5_32Bit_String:_newPwd_1.text]]];
    }
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
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
        _oldPwd = [[UITextField alloc]init];
        _oldPwd.placeholder = @"现密码";
//        _oldPwd.backgroundColor = [UIColor redColor];
        _oldPwd.frame = CGRectMake(20, 0, [UIScreen mainScreen].bounds.size.width - 20 , cell.frame.size.height);
        // 设置成“安全”模式输入
        _oldPwd.secureTextEntry = YES;
//        _oldPwd.delegate = self;
        [cell.contentView addSubview:_oldPwd];
    }else if (indexPath.row == 1){
        _newPwd_1 = [[UITextField alloc]init];
        _newPwd_1.placeholder = @"新密码";
//        _newPwd_1.backgroundColor = [UIColor redColor];
        _newPwd_1.frame = CGRectMake(20, 0, [UIScreen mainScreen].bounds.size.width - 20 , cell.frame.size.height);
        // 设置成“安全”模式输入
        _newPwd_1.secureTextEntry = YES;
        //        _oldPwd.delegate = self;
        [cell.contentView addSubview:_newPwd_1];
    }else{
        _newPwd_2 = [[UITextField alloc]init];
        _newPwd_2.placeholder = @"确认新密码";
//        _newPwd_2.backgroundColor = [UIColor redColor];
        _newPwd_2.frame = CGRectMake(20, 0, [UIScreen mainScreen].bounds.size.width - 20 , cell.frame.size.height);
        // 设置成“安全”模式输入
        _newPwd_2.secureTextEntry = YES;
        //        _oldPwd.delegate = self;
        [cell.contentView addSubview:_newPwd_2];
    }
    return cell;
}


@end
