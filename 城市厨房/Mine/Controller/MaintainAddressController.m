//
//  MaintainAddressController.m
//  城市厨房
//
//  Created by 臧昊 on 15/3/11.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "MaintainAddressController.h"
#import "ModelManager.h"
#import "ModelRequestResult.h"
#import "AccountTool.h"
#import "Address.h"
#import "AddAddressController.h"
#import "ResetAddressController.h"

@interface MaintainAddressController()
{
    NSMutableArray *_addArray;
}

@end

@implementation MaintainAddressController

- (void)viewDidLoad
{
    self.title = @"收货地址信息维护";
//    [self addNavAndNilLabel];
    _addArray = [NSMutableArray array];
    if (kCheckNetStatus) {
        [[ModelManager sharedManager]httpRequestGetUserAddressWithUserCode:[AccountTool sharedAccountTool].account.userCode];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAddressFinished:) name:kModelRequestGetUserAddress object:nil];
}

@end
