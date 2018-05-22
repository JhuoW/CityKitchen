//
//  PayTool.m
//  城市厨房
//
//  Created by 臧昊 on 15/3/12.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "PayTool.h"
#import <UIKit/UIKit.h>

// 支付宝
#import "OrderPay.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation PayTool
single_implementation(PayTool);



- (void)payWithOrderNo:(NSString *)orderCode ProductName:(NSString *)productName ProductDescription:(NSString *)productDescription Amount:(double)amount
{
    /*
     *点击获取prodcut实例并初始化订单信息
     */
    //    Product *product = [self.productList objectAtIndex:indexPath.row];
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088611714129222";
    NSString *seller = @"qlgds@qlgncp.com";
    NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAMnvH1EkmpWxnrSezH9KXzT4Wc/SSyUtg/yY/Wkrd13JzYdCiW4hVS6mtXJ5K7qxRfjAZDFFBFKjeqCC6bnWa639cHNlN3304QjaZ5tQ2LZRemWZ5t864P4UXuQiBB3lapN1KnRxxcAkqYLChLlMEoW2wXUz8bOdJ3Z1lV+IfMVHAgMBAAECgYBuP8zEW4y+r+QrTwvtb2h9nh5C1djLKoeGMO0iL2YTYauB7rTj2PUN7Fzia/+RBVpjjn7lW34ZtEGuQuti2AufT+q4cnDYX4yjUmW9E9mv2EAVSFjNkYKdtkX705dkGi4KFgRsu/1zy6GMesWsSjbYY5pEm21yVll/dGUGSSRrwQJBAP97YJmm4rkrOoAb0CCVPtkBlrmEwopvypy9wKPom6o8198XGYmpNZapHbuosU9kYxJLozgSCQkffv8+C4km8iECQQDKV/KnyE55ufpnT1bJGkBCO66n9hA5PqFn/dkCPNn8X85ft9szXNPAz7E21l8WnziCzNVbG9EoUbt6hBjR+hpnAkEA2dITNm22+DEHG5qbBGy6vMJCA8JRKz7M/H479IOp1KczVh2XxGrkKaPemdTl986bOUoLyw51bbXQzUXVCAaQgQJBALdA85kVBk2kK65I4pZ7WdsiZknjxkmx+UhPVKx8JAg3VJbH0pQv6+9hqmO5vqCkTu/XRxuek8zqSNrqq/fvhN0CQB3yLqjRdoOZyUX4VIADd1NsbjJCjRClnuFh/jfw/9TRXGV92i/HO/o+Y0LnpHf1IZj/ZzPLz6JiddN3BNp3NTg=";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    OrderPay *orderPay = [[OrderPay alloc] init];
    orderPay.partner = partner;
    orderPay.seller = seller;
    orderPay.tradeNO = orderCode; //订单ID（由商家自行制定）
    orderPay.productName = productName; //商品标题
    orderPay.productDescription = productDescription; //商品描述
    orderPay.amount = [NSString stringWithFormat:@"%.2f",amount]; //商品价格
    orderPay.notifyURL =  @"http://115.28.231.147/api/alipay/notifyUrl"; //回调URL
    
    orderPay.service = @"mobile.securitypay.pay";
    orderPay.paymentType = @"1";
    orderPay.inputCharset = @"utf-8";
    orderPay.itBPay = @"30m";
    orderPay.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"cscf";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [orderPay description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    NSLog(@"signedString = %@", signedString);
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            
        }];
    }
}

@end
