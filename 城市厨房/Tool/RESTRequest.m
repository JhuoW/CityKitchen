//
//  RESTRequest.m
//  airuishi
//
//  Created by 臧昊 on 15/1/25.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "RESTRequest.h"
#import "AppDelegate.h"


@implementation RESTRequest

@synthesize delegate;
@synthesize baseURL;



static RESTRequest *sharedRequest;

+(RESTRequest *)sharedRequest
{
    if(sharedRequest == Nil) sharedRequest = [[RESTRequest alloc] init];
    return sharedRequest;
}

-(id)init
{
    self = [super init];
    if(self)
    {
    }
    return self;
}

#pragma -mark 使用baseURL的请求
-(void)get:(NSString *)operation withParams:(NSDictionary *)params withUserInfo:(NSDictionary *)userInfo email:(NSString *)email{
    //根据baseURL拼接请求字符串
    NSString *urlStr = [baseURL stringByAppendingString:operation];
    
    [self getWithURL:urlStr withParams:params withUserInfo:userInfo email:email];
}

// get同步请求
-(void)getSynchronous:(NSString *)operation withParams:(NSDictionary *)params withUserInfo:(NSDictionary *)userInfo{
    //根据baseURL拼接请求字符串
    NSString *urlStr = [baseURL stringByAppendingString:operation];
    NSLog(@"%@", baseURL);
    [self getSynchronousWithURL:urlStr withParams:params withUserInfo:userInfo];
}

// get异步请求
-(void)get:(NSString *)operation withParams:(NSDictionary *)params withUserInfo:(NSDictionary *)userInfo{
    //根据baseURL拼接请求字符串
    NSString *urlStr = [baseURL stringByAppendingString:operation];
    NSLog(@"%@", baseURL);
    [self getWithURL:urlStr withParams:params withUserInfo:userInfo];
}

-(void)post:(NSString *)operation withParams:(NSDictionary *)params withUserInfo:(NSDictionary *)userInfo{
    NSString *urlStr = [baseURL stringByAppendingString:operation];
    [self postWithURL:urlStr withParams:params withUserInfo:userInfo];
}


- (void)delete:(NSString *)operation withParams:(NSDictionary *)params withUserInfo:(NSDictionary *)userInfo
{
    NSString *urlStr = [baseURL stringByAppendingString:operation];
    [self delete:urlStr withParams:params withUserInfo:userInfo];
}

-(void)put:(NSString *)operation withParams:(NSDictionary *)params withUserInfo:(NSDictionary *)userInfo{
    NSString *urlStr = [baseURL stringByAppendingString:operation];
    [self putWithURL:urlStr withParams:params withUserInfo:userInfo];
}

#pragma -mark 不使用baseURL的请求
-(void)getWithURL:(NSString *)operation withParams:(NSDictionary *)params withUserInfo:(NSDictionary *)userInfo email:(NSString *)email{
    NSString *paramStr = [self NSStirngFromNSDictionary:params];
    NSString *urlStr;
    
    if(paramStr != nil)
        urlStr = [operation stringByAppendingFormat:@"?%@",paramStr];
    else
        urlStr = operation;
    
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"&email=%@",email]];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSLog(@"url:%@",[url absoluteString]);
    
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    
//    //获取全局变量
//    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    //设置缓存方式
//    [request setDownloadCache:appDelegate.myCache];
//    //设置缓存数据存储策略，这里采取的是如果无更新或无法联网就读取缓存数据
//    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    
    request.delegate = self;
    request.requestMethod = @"GET";
    request.timeOutSeconds = 30;
    request.userInfo = userInfo;
    [request startAsynchronous];
}

-(void)getSynchronousWithURL:(NSString *)operation withParams:(NSDictionary *)params withUserInfo:(NSDictionary *)userInfo
{
    NSString *paramStr = [self NSStirngFromNSDictionary:params];
    NSString *urlStr;
    
    if(paramStr != nil)
        urlStr = [operation stringByAppendingFormat:@"?%@",paramStr];
    
    else
        urlStr = operation;
    //    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    urlStr = [urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSLog(@"url:%@",[url absoluteString]);
    
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    request.delegate = self;
    // 获取全局变量
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    // 设置缓存数据存储策略，这里采取的是如果无更新或无法联网就读取缓存数据
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    // 设置缓存方式
    [request setDownloadCache:appDelegate.myCache];
    
    
    request.requestMethod = @"GET";
    request.timeOutSeconds = 30;
    request.userInfo = userInfo;
    [request startSynchronous];
}

-(void)getWithURL:(NSString *)operation withParams:(NSDictionary *)params withUserInfo:(NSDictionary *)userInfo
{
    NSString *paramStr = [self NSStirngFromNSDictionary:params];
    NSString *urlStr;
    
    if(paramStr != nil)
        urlStr = [operation stringByAppendingFormat:@"?%@",paramStr];
   
    else
        urlStr = operation;
//    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    urlStr = [urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    urlStr = [urlStr stringByURLEncodingStringParameter];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    
    NSLog(@"url:%@",[url absoluteString]);
    
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    request.delegate = self;
    
    // 获取全局变量
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    
    // 设置缓存数据存储策略，这里采取的是如果无更新或无法联网就读取缓存数据
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    // 设置缓存方式
    [request setDownloadCache:appDelegate.myCache];
    
    
    request.requestMethod = @"GET";
    request.timeOutSeconds = 30;
    request.userInfo = userInfo;
    [request startAsynchronous];
}

-(void)postWithURL:(NSString *)operation withParams:(NSDictionary *)params  withUserInfo:(NSDictionary *)userInfo{
    NSURL *url = [NSURL URLWithString:operation];
    //NSLog(@"url:%@",[url absoluteString]);
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.delegate = self;
    request.requestMethod = @"POST";
    request.userInfo = userInfo;
    request.timeOutSeconds = 30;
    
    for(NSString *key in [params allKeys])
    {
        [request setPostValue:[params objectForKey:key] forKey:key];
    }
    
    [request startAsynchronous];
}


-(void)deleteWithURL:(NSString *)operation withParams:(NSDictionary *)params withUserInfo:(NSDictionary *)userInfo{
    NSURL *url = [NSURL URLWithString:operation];
    //NSLog(@"url:%@",[url absoluteString]);
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.delegate = self;
    request.userInfo = userInfo;
    for(NSString *key in [params allKeys])
    {
        [request setPostValue:[params objectForKey:key] forKey:key];
    }
    [request buildPostBody];
    request.requestMethod = @"DELETE";
    
    [request startAsynchronous];
}

-(void)putWithURL:(NSString *)operation withParams:(NSDictionary *)params  withUserInfo:(NSDictionary *)userInfo{
    NSURL *url = [NSURL URLWithString:operation];
    //NSLog(@"url:%@",[url absoluteString]);
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
    request.delegate = self;
    request.requestMethod = @"PUT";
    request.userInfo = userInfo;
    for(NSString *key in [params allKeys])
    {
        [request setPostValue:[params objectForKey:key] forKey:key];
    }
    
    [request startAsynchronous];
}

#pragma -mark ASIHTTPRequest Delegate

// **************代理没有使用
- (void)requestStarted:(ASIHTTPRequest *)request
{
    
    id obj = delegate;
    if([obj respondsToSelector:@selector(RESTRequestStarted:)])
        [delegate RESTRequestStarted:request];
}
// **************代理没有使用
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    id obj = delegate;
    if([obj respondsToSelector:@selector(request:didReceiveResponseHeaders:)])
        [delegate RESTRequest:request didReceiveResponseHeaders:responseHeaders];
}
// **************代理没有使用
- (void)request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL
{
    id obj = delegate;
    if([obj respondsToSelector:@selector(request:willRedirectToURL:)])
        [delegate RESTRequest:request willRedirectToURL:newURL];
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    id obj = delegate;
    if([obj respondsToSelector:@selector(RESTRequestFinished:)])
        [delegate RESTRequestFinished:request];
    
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    id obj = delegate;
    if([obj respondsToSelector:@selector(RESTRequestFailed:)])
        [delegate RESTRequestFailed:request];
}

// **************代理没有使用
- (void)requestRedirected:(ASIHTTPRequest *)request
{
    id obj = delegate;
    if([obj respondsToSelector:@selector(RESTRequestRedirected:)])
        [delegate RESTRequestRedirected:request];
}


#pragma -mark Tools
-(NSString *)NSStirngFromNSDictionary:(NSDictionary *)dic
{
    if(dic == nil || dic.count == 0) return nil;
    
    ASIFormDataRequest *formDataRequest = [ASIFormDataRequest requestWithURL:nil];
    
    NSString *result = [[NSString alloc] init];
    
    for(NSString *key in [dic allKeys])
    {
        NSString *encodedValue = nil;
        if ([[dic objectForKey:key] isKindOfClass:[NSString class]]) {
            encodedValue = [formDataRequest encodeURL:[dic objectForKey:key]];
            
        }else{
            encodedValue = [formDataRequest encodeURL:[[dic objectForKey:key] stringValue]];
            
        }
        result = [result stringByAppendingFormat:@"%@=%@&",key,encodedValue];
    }
    if(result.length > 0)
    {
        result = [result substringWithRange:NSMakeRange(0, result.length-1)];
    }
    //result = [result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return result;
}


@end

