//
//  AddressCell.h
//  城市厨房
//
//  Created by 臧昊 on 15/2/22.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Address.h"
#import "CheckButton.h"


@interface AddressCell : UITableViewCell
@property (nonatomic, strong)Address *address;
@property (nonatomic, assign)BOOL isCanCheck;
@property (nonatomic, strong)CheckButton *checkboxBtn;
@end
