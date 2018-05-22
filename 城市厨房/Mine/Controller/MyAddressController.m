//
//  MyAddressController.m
//  城市厨房
//
//  Created by 臧昊 on 15/2/22.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "MyAddressController.h"
#import "ModelManager.h"
#import "ModelRequestResult.h"
#import "AccountTool.h"
#import "Address.h"
#import "AddressCell.h"
#import "AddAddressController.h"
#import "ResetAddressController.h"


@interface MyAddressController()
{
    NSMutableArray *_addArray;
    UILabel *_nilLabel;
}

@end

@implementation MyAddressController

- (void)viewDidLoad
{
    self.title = @"我的收货地址";
    [self addNavAndNilLabel];
    _addArray = [NSMutableArray array];
    if (_isCanDelate) {
        self.tableView.tag = 1;
    }else{
        self.tableView.tag = 0;
    }
    if (kCheckNetStatus) {
        [[ModelManager sharedManager]httpRequestGetUserAddressWithUserCode:[AccountTool sharedAccountTool].account.userCode];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAddressFinished:) name:kModelRequestGetUserAddress object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeUserAddressFinished:) name:kModelRequestRemoveUserAddress object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kModelRequestRemoveUserAddress object:nil];
}


- (void)userAddressFinished: (NSNotification *)notification
{
    ModelRequestResult *result = [notification.userInfo objectForKey:DICT_MODEL_REQUEST_RESULT_KEY];
    NSDictionary *dict = result.responseObject;
//    NSLog(@"%@",dict);
    if ([dict[@"ret"] isEqualToString:@"success"]) {
        NSArray *array = dict[@"deliveryAddress"];
        // 判断是否为空（删除或修改时需要重新加载地址）
        if(_addArray){
            [_addArray removeAllObjects];
        }
        if (array.count) {
            [_nilLabel removeFromSuperview];
            for (NSDictionary *dictionary in array) {
                Address *address = [[Address alloc]initWithDict:dictionary];
                [_addArray addObject:address];
                //            NSLog(@"%@", [_addArray[0] definiteAddress]);
            }
        }else{
            
            [self.tableView addSubview:_nilLabel];
        }
        
        [self.tableView reloadData];
    }
}

- (void)removeUserAddressFinished:(NSNotification *)notification
{
    ModelRequestResult *result = [notification.userInfo objectForKey:DICT_MODEL_REQUEST_RESULT_KEY];
    NSDictionary *dict = result.responseObject;
    if ([dict[@"ret"]isEqualToString:@"success"]) {
        [self showAlert:@"删除成功"];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _addArray.count;
//    NSLog(@"aaaaaa%d", (int) _addArray.count);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

#pragma mark - 创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.address = _addArray[indexPath.row];
    if (!_isCanDelate) {
        // set方法实现添加checkBox
        cell.isCanCheck = 1;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ResetAddressController *resetAddressController = [[ResetAddressController alloc]init];
    resetAddressController.address = _addArray[indexPath.row];
    [self.navigationController pushViewController:resetAddressController animated:YES];
}


#pragma mark 删除cell代理
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        if (editingStyle==UITableViewCellEditingStyleDelete) {
            // 获取选中删除行索引值
            NSInteger row = [indexPath row];
            [[ModelManager sharedManager]httpRequestRemoveUserAddress:[_addArray[row] addressId] WithUserCode:[AccountTool sharedAccountTool].account.userCode];
            // 通过获取的索引值删除数组中的值
            [_addArray removeObjectAtIndex:row];
            // 删除单元格的某一行时，在用动画效果实现删除过程
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
    }
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        return UITableViewCellEditingStyleDelete;
    }else{
        return UITableViewCellEditingStyleNone;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)addNavAndNilLabel
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"添加" forState:UIControlStateNormal];
//    btn.backgroundColor = [UIColor redColor];
//    button1.enabled = NO;
    btn.bounds = CGRectMake(0, 0, 30, 15);
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [btn addTarget:self action:@selector(clickAddBtn) forControlEvents:UIControlEventTouchUpInside];
    
    _nilLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    _nilLabel.center = self.view.center;
    _nilLabel.textAlignment = NSTextAlignmentCenter;
    _nilLabel.text = @"尚未添加收货地址~";
    _nilLabel.textColor = [UIColor grayColor];
}

- (void)clickAddBtn
{
    [self.navigationController pushViewController:[[AddAddressController alloc]initWithStyle:UITableViewStyleGrouped] animated:YES];
}

#pragma mark - 自动消失提示框
- (void)timerFireMethod:(NSTimer*)theTimer{//弹出框
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}
- (void)showAlert:(NSString *) _message{//时间
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:nil message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [NSTimer scheduledTimerWithTimeInterval:1.5f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}

@end
