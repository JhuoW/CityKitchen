//
//  CompanyController.m
//  城市厨房
//
//  Created by 臧昊 on 15/3/1.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "CompanyController.h"
#import "ModelManager.h"
#import "ModelRequestResult.h"
#import "Company.h"
#import "GoodsListController.h"
#import "UIImageView+WebCache.h"

@interface CompanyController()< UIAlertViewDelegate>
{
    Company *_company;
}

@end

@implementation CompanyController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"商家信息";
    self.view.backgroundColor = BackgroundColor;
    if (kCheckNetStatus) {
        [[ModelManager sharedManager]httpRequestGetCompanyInformationWithCompanyCode:_companyCode];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(companyInformationFinished:) name:kModelRequestGetCompanyInformation object:nil];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络出错了，请检查网络设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    } 
}

- (void)companyInformationFinished:(NSNotification *)notification
{
    ModelRequestResult *result = [notification.userInfo objectForKey:DICT_MODEL_REQUEST_RESULT_KEY];
    NSDictionary *dict = result.responseObject;
    if ([dict[@"ret"] isEqualToString:@"success"]) {
        _company = [[Company alloc]initWithDict:dict[@"companyObj"]];
        [self.tableView reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_company) {
        if (section == 0) {
            return 1;
        }else{
            return 4;
        }
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return 44;
    }else{
        return [UIScreen mainScreen].bounds.size.width * 0.5 + 44;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
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
        UIImageView *logoImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * 0.5)];
        if (_company.logo) {    // 判断是否存在logo
            if ([_company.logo rangeOfString:@"http"].length) {
                [logoImg sd_setImageWithURL:[NSURL URLWithString:_company.logo] placeholderImage:[UIImage imageNamed:@"defualt_iv_400.png"]];
            }else{
                NSString *imageUrl = [kImageURL stringByAppendingString:_company.logo];
                [logoImg sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"defualt_iv_400.png"]];
            }
        }
        [cell.contentView addSubview:logoImg];
     
        UILabel *productNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.width * 0.5, [UIScreen mainScreen].bounds.size.width / 3, 44)];
        productNumLabel.textAlignment = NSTextAlignmentCenter;
        productNumLabel.font = [UIFont systemFontOfSize:14];
        productNumLabel.numberOfLines = 0;
        productNumLabel.textColor = [UIColor grayColor];
        productNumLabel.text = [NSString stringWithFormat:@"100\n全部商品"];
        [cell addSubview:productNumLabel];
        
        UILabel *scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 3, [UIScreen mainScreen].bounds.size.width * 0.5, [UIScreen mainScreen].bounds.size.width / 3, 44)];
        scoreLabel.textAlignment = NSTextAlignmentCenter;
        scoreLabel.font = [UIFont systemFontOfSize:14];
        scoreLabel.numberOfLines = 0;
        scoreLabel.textColor = [UIColor grayColor];
        scoreLabel.text = [NSString stringWithFormat:@"%d\n评分",_company.score];
        [cell addSubview:scoreLabel];
        
        UILabel *viewNumLabel = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 3 * 2, [UIScreen mainScreen].bounds.size.width * 0.5, [UIScreen mainScreen].bounds.size.width / 3, 44)];
        viewNumLabel.textAlignment = NSTextAlignmentCenter;
        viewNumLabel.font = [UIFont systemFontOfSize:14];
        viewNumLabel.numberOfLines = 0;
        viewNumLabel.textColor = [UIColor grayColor];
        viewNumLabel.text = [NSString stringWithFormat:@"%d\n浏览量",_company.viewNum];
        [cell addSubview:viewNumLabel];
        
        UIImageView *divider_1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_card_bottom_line.png"]];
        divider_1.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 3,  [UIScreen mainScreen].bounds.size.width * 0.5 + 44 / 2);
        [cell.contentView addSubview:divider_1];
        
        UIImageView *divider_2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_card_bottom_line.png"]];
        divider_2.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 3 * 2, [UIScreen mainScreen].bounds.size.width * 0.5 + 44 / 2);
        [cell.contentView addSubview:divider_2];
        
        
    }else{
        if (indexPath.row == 0) {
            cell.textLabel.text = @"商家名称";
            UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 0, [UIScreen mainScreen].bounds.size.width - 90, 44)];
            nameLabel.textColor = [UIColor grayColor];
            nameLabel.text = _company.name;
            [cell.contentView addSubview:nameLabel];
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"商家地址";
            UILabel *addrLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 0, [UIScreen mainScreen].bounds.size.width - 90, 44)];
            addrLabel.textColor = [UIColor grayColor];
            addrLabel.text = _company.address;
            [cell.contentView addSubview:addrLabel];
        }else if (indexPath.row == 2){
            cell.textLabel.text = @"商家电话";
            UILabel *telLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 0, [UIScreen mainScreen].bounds.size.width - 90, 44)];
            telLabel.textColor = [UIColor grayColor];
            telLabel.text = _company.tel;
            [cell.contentView addSubview:telLabel];
            cell.accessoryView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"common_arrow.png"]];
        }else{
            cell.textLabel.text = @"查看店铺商品";
            cell.accessoryView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"common_arrow.png"]];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if(indexPath.row == 3){
            GoodsListController *goodListController = [[GoodsListController alloc]init];
            goodListController.companyCode = _companyCode;
            [self.navigationController pushViewController:goodListController animated:YES];
        }else if (indexPath.row == 2){
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定拨打该商家电话吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *string = [NSString stringWithFormat:@"tel://%@", _company.tel];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
    }
}
@end
