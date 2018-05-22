//
//  AccountController.m
//  城市厨房
//
//  Created by 臧昊 on 15/2/21.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "MyAccountController.h"
#import "MyAddressController.h"
#import "AccountTool.h"
#import "ResetPwdController.h"
@interface MyAccountController()


@end
@implementation MyAccountController
- (void)viewDidLoad
{
    self.title = @"我的账号";
    self.view.backgroundColor = BackgroundColor;
    
}

#pragma tableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else{
        return 1;
    }
}

#pragma mark - 创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"昵称";
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.3, 0, self.view.frame.size.width * 0.7 - 20, 44)];
            label.text = [AccountTool sharedAccountTool].account.userName;
            label.textAlignment = NSTextAlignmentRight;
            label.textColor = [UIColor grayColor];
            [cell addSubview:label];
        }else{
            cell.textLabel.text = @"会员等级";
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.3, 0, self.view.frame.size.width * 0.7 - 20, 44)];
            label.textAlignment = NSTextAlignmentRight;
//            label.text = [NSString stringWithFormat:@"%d", [AccountTool sharedAccountTool].account.evalNum];
            label.text = @"普通会员";
            label.textColor = [UIColor grayColor];
            [cell addSubview:label];
        }
    }else if (indexPath.section == 1){
        cell.textLabel.text = @"我的收货地址";
        cell.accessoryView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"common_arrow.png"]];
    }else{
//        if (indexPath.row == 0) {
//            cell.textLabel.text = @"账号";
//            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.3, 0, self.view.frame.size.width * 0.7 - 20, 44)];
//            label.textAlignment = NSTextAlignmentRight;
//            label.text = [AccountTool sharedAccountTool].account.userName;
//            label.textColor = [UIColor grayColor];
//            [cell addSubview:label];
//        }else{
            cell.textLabel.text = @"修改密码";
            cell.accessoryView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"common_arrow.png"]];
//        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        MyAddressController *myAddressController = [[MyAddressController alloc] initWithStyle:UITableViewStyleGrouped];
        myAddressController.isCanDelate = 1;
        [self.navigationController pushViewController:myAddressController animated:YES];
    }else if (indexPath.section == 2)
    {
        [self.navigationController pushViewController:[[ResetPwdController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
    }
}

@end
