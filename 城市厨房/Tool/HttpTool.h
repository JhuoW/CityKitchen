//
//  HttpTool.h
//  sina
//
//  Created by mac on 14-11-19.
//  Copyright (c) 2014年 ZH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^HttpSuccessBlock)(id JSON);
typedef void (^HttpFailureBlock)(NSError *error);

@interface HttpTool : NSObject

+ (void)postWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;
+ (void)getWithPath:(NSString *)path params:(NSDictionary *)params success:(HttpSuccessBlock)success failure:(HttpFailureBlock)failure;


+ (void)downloadImage:(NSString *)url placeHolder:(UIImage *)placeHolder imageView:(UIImageView *)imageView;
@end
