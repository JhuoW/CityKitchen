//
//  UIAlertView+ZH.m
//  城市厨房
//
//  Created by 臧昊 on 15/3/1.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "UIAlertView+ZH.h"

@implementation UIAlertView (ZH)
- (void)timerFireMethod:(NSTimer*)theTimer{//弹出框
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
//    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}

+ (void)showAlert:(NSString *)message atTarget:(id)target{//时间
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [NSTimer scheduledTimerWithTimeInterval:1.5f
                                     target:target
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}
@end
