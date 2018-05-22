//
//  Dock.h
//  fuckthings
//
//  Created by 臧昊 on 15/1/13.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Dock;
@protocol DockDelegate <NSObject>
@optional
-(void)dock:(Dock *)dock itemSelectedFrom:(NSInteger)from To:(NSInteger)to;

@end

@interface Dock : UIView

- (void )addDockItemWithIcon:(NSString *)icon andSelectedImage:(NSString *)selectedIcon title:(NSString *)title;

// 代理
@property (nonatomic,weak) id <DockDelegate> delegate;

// dock索引
@property (nonatomic, assign) NSInteger selectedIndex;
@end
