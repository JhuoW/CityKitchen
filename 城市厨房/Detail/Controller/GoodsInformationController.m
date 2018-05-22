//
//  GoodsInformationController.m
//  城市厨房
//
//  Created by 臧昊 on 15/3/6.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "GoodsInformationController.h"
#import "ModelManager.h"
#import "ModelRequestResult.h"
#import "MBProgressHUD.h"

@interface  GoodsInformationController() <UIWebViewDelegate>
{
    UIWebView *_webView;
    MBProgressHUD *_hud;
}

@end

@implementation GoodsInformationController

- (void)loadView
{
//    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    _webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view = _webView;
}

- (void)viewDidLoad{
    self.title = @"商品详细介绍";
    
    
    // 2.设置代理
    _webView.delegate = self;
    [[ModelManager sharedManager] httpRequestGetGoodsDetailInformationWithCode:_detailCode];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goodsDetailInformationFinished:) name:kModelRequestGetGoodsDetailInformation object:nil];
    // 显示指示器
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)goodsDetailInformationFinished: (NSNotification *)notification
{
    ModelRequestResult *result = [notification.userInfo objectForKey:DICT_MODEL_REQUEST_RESULT_KEY];
    if (result.succ) {
        NSString *detailIntroduction = [result.responseObject objectForKey:@"content"];
        // 1.加载登陆页面（获取未授权的Request Token）
//        NSString *urlStr = [NSString stringWithFormat:@"%@/api/product/queryDetail?productCode=%@",]];
//        NSURL *url = [NSURL URLWithString:urlStr];
//        NSURLRequest *request = [NSURLRequest requestWithURL:url];
//        [_webView loadRequest:request];
        [_webView loadHTMLString:detailIntroduction baseURL:nil];
        [_hud hide:YES];
    }
}

@end
