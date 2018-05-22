//
//  AppDelegate.h
//  城市厨房
//
//  Created by 臧昊 on 15/1/20.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIDownloadCache.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
//    ASIDownloadCache *myCache;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) ASIDownloadCache *myCache;

@end

