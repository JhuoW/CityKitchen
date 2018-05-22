//
//  HttpTool.m
//  sina
//
//  Created by mac on 14-11-19.
//  Copyright (c) 2014年 ZH. All rights reserved.
//

#import "HttpTool.h"
#import "AFNetworking.h"

#import "UIImageView+WebCache.h"

@implementation HttpTool

+ (void)requestWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure method:(NSString *)method
{
    
    // 1.创建post请求
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://115.28.231.147"]];
    NSURLRequest *post = [client requestWithMethod:method path:path parameters:params];
    NSLog(@"%@",post);
    // 2.创建AFJSONRequestOperation对象
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:post success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (success == nil) {
            return ;
        }
        success(JSON);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (failure == nil) {
            return ;
        }
        failure(error);
    }];
    
    // 3.发送请求
    [op start];
}

+ (void)postWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{
    [self requestWithPath:path params:params success:success failure:failure method:@"POST"];
}

+ (void)getWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure
{
    [self requestWithPath:path params:params success:success failure:failure method:@"GET"];
}

+ (void)downloadImage:(NSString *)url placeHolder:(UIImage *)placeHolder imageView:(UIImageView *)imageView
{
    [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeHolder options:SDWebImageDownloaderLowPriority | SDWebImageRetryFailed];
}

@end
