//
//  AccountTool.m
//  fuckthings
//
//  Created by 臧昊 on 15/1/19.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "AccountTool.h"


@implementation AccountTool

single_implementation(AccountTool);

- (instancetype)init
{
    if (self = [super init]) {
        // 文件路径
        NSString *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *file = [doc stringByAppendingPathComponent:@"account.data"];
        // 解档
        _account = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
    }
    return self;
}

- (void)saveAccount: (Account *)account
{
    _account = account;
    NSString *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *file = [doc stringByAppendingPathComponent:@"account.data"];
    [NSKeyedArchiver archiveRootObject:account toFile:file];
}

- (void)removeAccount
{
    // 文件路径
    NSString *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *file = [doc stringByAppendingPathComponent:@"account.data"];
    // 删除该路径文件
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    [defaultManager removeItemAtPath:file error:nil];
    // 删除单例中account信息
    _account = nil;
}

@end
