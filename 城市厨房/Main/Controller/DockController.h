//
//  DockController.h
//  fuckthings
//
//  Created by 臧昊 on 15/1/13.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dock.h"

@interface DockController : UIViewController 
{
    Dock *_dock;
    
}
@property (nonatomic, strong) UIViewController *selectedController;
@end
