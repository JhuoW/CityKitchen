//
//  FeedbackController.m
//  城市厨房
//
//  Created by 臧昊 on 15/3/7.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "FeedbackController.h"
#import "ModelManager.h"
#import "ModelRequestResult.h"

@interface FeedbackController()<UITextViewDelegate, UIAlertViewDelegate>
{
    UITextField *_emailField;
    UITextView *_suggestionField;
    UILabel *_suggestionLabel;
}

@end

@implementation FeedbackController

- (void)viewDidLoad
{
    self.title = @"意见反馈";
    self.view.backgroundColor = BackgroundColor;
    [self createSubView];
    [self addNav];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sumbitFeedbackFinished:) name:kModelRequestSumbitFeedback object:nil];
}

- (void)createSubView
{
    _emailField = [[UITextField alloc]init];
    _emailField.placeholder = @"您的邮箱地址（选填）";
    _emailField.font = [UIFont systemFontOfSize:17];
    _emailField.frame = CGRectMake(20, 0, self.view.frame.size.width - 40, 44);
    
    _suggestionField = [[UITextView alloc]init];
    _suggestionField.delegate = self;
    _suggestionField.font = [UIFont systemFontOfSize:17];
    _suggestionField.frame = CGRectMake(20, 0, self.view.frame.size.width - 40, 200);
    
    _suggestionLabel = [[UILabel alloc]initWithFrame:CGRectMake(23, 8, self.view.frame.size.width, 20)];
    _suggestionLabel.textColor = RGB(190, 190, 196);
    _suggestionLabel.font = [UIFont systemFontOfSize:17];
    _suggestionLabel.text = @"您的反馈意见";
//    _suggestionLabel.enabled = NO;  // 必须设置为不可用
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 300, self.view.frame.size.width - 40, 60)];
    label.textColor = [UIColor grayColor];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:16];
    label.text = @"您的反馈意见将有助于我们优化城市厨房客户端，同时，我们也将拿出礼品奖励用心的反馈用户。";
    [self.view addSubview:label];
}

- (void)addNav
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    //    btn.backgroundColor = [UIColor redColor];
    //    button1.enabled = NO;
    btn.bounds = CGRectMake(0, 0, 30, 15);
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [btn addTarget:self action:@selector(clickSumbitBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (void)sumbitFeedbackFinished:(NSNotification *)notification
{
    ModelRequestResult *result = [notification.userInfo objectForKey:DICT_MODEL_REQUEST_RESULT_KEY];
    NSDictionary *dict = result.responseObject;
    if([dict[@"ret"] isEqualToString:@"success"])
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"提交成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"提交失败！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickSumbitBtn
{
    if (_suggestionField.text.length) {
        [[ModelManager sharedManager]httpRequestSubmitFeedback:_suggestionField.text ByEmail:_emailField.text];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入您的反馈意见" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section) {
        return 44.0;
    }else{
        return 200.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section) {
        return 0.01;
    }else{
        return 20;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
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
    
    if(indexPath.section){
        
        //        _nameField.delegate = self;
        //        accountTextfield.center = CGPointMake(60 + cell.frame.size.width * 0.5, cell.textLabel.center.y);
        [cell.contentView addSubview:_emailField];
    }else{
        
        //        _nameField.delegate = self;
        //        accountTextfield.center = CGPointMake(60 + cell.frame.size.width * 0.5, cell.textLabel.center.y);
        [cell.contentView addSubview:_suggestionField];
        [cell.contentView addSubview:_suggestionLabel];
    }
    
    return cell;
}

#pragma mark - UITextView代理
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        _suggestionLabel.text = @"您的反馈意见";
    }else{
        _suggestionLabel.text = @"";
    }
}

@end
