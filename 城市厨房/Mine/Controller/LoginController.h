//
//  LoginController.h
//  城市厨房
//
//  Created by 臧昊 on 15/1/30.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LoginDelegate <NSObject>

- (void)loginSuccessToShowUserInformation;

@end
@interface LoginController : UITableViewController
@property (nonatomic, retain) UITextField *nameField;
@property (nonatomic, retain) UITextField *pwdField;
// 代理
@property (nonatomic,weak) id <LoginDelegate> delegate;
@end
