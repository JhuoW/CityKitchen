//
//  MoreController.m
//  城市厨房
//
//  Created by 臧昊 on 15/1/20.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "MoreController.h"
#import "SettingController.h"
#import "FeedbackController.h"
#import "HelpController.h"
#import "AboutController.h"
#import "ModelManager.h"
#import "ModelRequestResult.h"

@interface MoreController ()<UIAlertViewDelegate>
{
    NSArray *_data;
}
@end

@implementation MoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"更多";
    
    [self loadPlist];
    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(examineVersionFinished:) name:kModelRequestExamineVersion object:nil];
}

//- (void)examineVersionFinished:(NSNotification *)notification
//{
//    ModelRequestResult *result = [notification.userInfo objectForKey:DICT_MODEL_REQUEST_RESULT_KEY];
//    NSDictionary *dict = result.responseObject;
//    if (result.succ) {
//        if ([dict[@"ret"] isEqualToString:@"success"]) {
//            // 服务器的版本号
//            CGFloat serverVersion = [dict[@"version"] floatValue];
//            
//            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
//            //CFShow((__bridge CFTypeRef)(infoDic));
//            NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
//            CGFloat localVerion = [currentVersion floatValue];
//            
//            if (serverVersion == localVerion) {
//                UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"提示" message:@"该版本已是最新版本" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                [alertView show];
//            }else{
//                UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"提示" message:@"有新版本，去看看吧" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                [alertView show];
//            }
//        }
//    }
//}

// 加载plist文件
- (void)loadPlist
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"More" withExtension:@"plist"];
    
    _data = [NSArray arrayWithContentsOfURL:url];
//    NSLog(@"%@",_data);
}

// 返回组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _data.count;
}

// 返回每组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return [_data[section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    NSDictionary *dict = _data[indexPath.section][indexPath.row];
    cell.textLabel.text = dict[@"name"];
    UIImage *icon = [UIImage imageNamed:dict[@"icon"]];
    cell.imageView.image = icon;
        
    cell.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    //设置acceseoryView
    cell.accessoryView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"common_arrow.png"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 40;
    }
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self.navigationController pushViewController:[[SettingController alloc]initWithStyle:UITableViewStyleGrouped] animated:YES];
    }else if (indexPath.section == 1)
    {
        if (indexPath.row == 2){
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"拨打客服电话15205200076吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
            alertView.tag = 1;
            [alertView show];
        }else if (indexPath.row == 1){
            [self.navigationController pushViewController:[[FeedbackController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
        }else{
            [self.navigationController pushViewController:[[HelpController alloc] init] animated:YES];
        }
    }else{
//        if (indexPath.row) {
            [self.navigationController pushViewController:[[AboutController alloc] init] animated:YES];
//        }else{
//            [[ModelManager sharedManager]httpRequestExamineVersionWithDeviceType:@"ios"];
//        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://15205200076"]];
        }
    }
}

@end
