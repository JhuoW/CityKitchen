//
//  HelpController.m
//  城市厨房
//
//  Created by 臧昊 on 15/3/7.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "HelpController.h"
#import "MBProgressHUD.h"

@interface HelpController()<UIWebViewDelegate>
{
    UIWebView *_webView;
    MBProgressHUD *_hud;
}

@end

@implementation HelpController

- (void)loadView
{
    _webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view = _webView;
}

- (void)viewDidLoad
{
    self.title = @"帮助中心";
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/sys/help.html", kBaseURL];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
    _webView.delegate = self;
}

#pragma mark -webview代理方法
#pragma mark 当WebView开始加载请求就会调用
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // 显示指示器
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

#pragma mark 当webView开始加载请求就会调用
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 关闭指示器
    [_hud hide:YES];
}

@end
