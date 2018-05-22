//
//  RESTRequest.h
//  airuishi
//
//  Created by 臧昊 on 15/1/25.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import <CommonCrypto/CommonDigest.h>

typedef enum{
    
    kRequestStarted,
    kRequestResponse,
    kRequestRedirect,       // 没使用
    kRequestFinished,
    kRequestFailed,
    kRequestRedirected,
    kNoNotification
    
    
}RequestStatus;






@protocol RESTRequestDelegate


@optional

- (void)RESTRequestStarted:(ASIHTTPRequest *)request;    // 代理没使用
- (void)RESTRequest:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders;  // 代理没使用
- (void)RESTRequest:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL;  // 代理没使用

- (void)RESTRequestFinished:(ASIHTTPRequest *)request;
- (void)RESTRequestFailed:(ASIHTTPRequest *)request;

- (void)RESTRequestRedirected:(ASIHTTPRequest *)request;   // 代理没使用

@end




@interface RESTRequest : NSObject<ASIHTTPRequestDelegate>
{
    id<RESTRequestDelegate> __unsafe_unretained delegate;
}
@property(unsafe_unretained)id<RESTRequestDelegate> delegate;

@property(nonatomic,strong) NSString *baseURL;

//获取到数据之后返回给delegate
-(void)get:(NSString *)operation withParams:(NSDictionary *)params withUserInfo:(NSDictionary *)userInfo email:(NSString *)email;
-(void)get:(NSString *)operation withParams:(NSDictionary *)params withUserInfo:(NSDictionary *) userInfo;
-(void)post:(NSString *)operation withParams:(NSDictionary *)params withUserInfo:(NSDictionary *) userInfo;

-(void)delete:(NSString *)operation withParams:(NSDictionary *)params withUserInfo:(NSDictionary *) userInfo;
-(void)put:(NSString *)operation withParams:(NSDictionary *)params withUserInfo:(NSDictionary *) userInfo;

// get同步请求
-(void)getSynchronous:(NSString *)operation withParams:(NSDictionary *)params withUserInfo:(NSDictionary *)userInfo;



//不通过baseURL 直接请求完整的地址，方便临时性拼接URL请求
// get同步
-(void)getSynchronousWithURL:(NSString *)operation withParams:(NSDictionary *)params withUserInfo:(NSDictionary *)userInfo;
// get异步
-(void)getWithURL:(NSString *)operation withParams:(NSDictionary *)params withUserInfo:(NSDictionary *) userInfo;
-(void)postWithURL:(NSString *)operation withParams:(NSDictionary *)params withUserInfo:(NSDictionary *) userInfo;
-(void)deleteWithURL:(NSString *)operation withParams:(NSDictionary *)params withUserInfo:(NSDictionary *) userInfo;
-(void)putWithURL:(NSString *)operation withParams:(NSDictionary *)params withUserInfo:(NSDictionary *) userInfo;


+(RESTRequest *)sharedRequest;

-(NSString *)NSStirngFromNSDictionary:(NSDictionary *)dic;


@end
