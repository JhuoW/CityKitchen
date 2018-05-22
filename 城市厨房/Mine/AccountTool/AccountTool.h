//
//  AccountTool.h
//  fuckthings
//
//  Created by 臧昊 on 15/1/19.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"
#import "Singleton.h"

@interface AccountTool : NSObject

single_interface(AccountTool);

@property (nonatomic,readonly) Account *account;

- (void)saveAccount: (Account *)account;

- (void)removeAccount;

@end
