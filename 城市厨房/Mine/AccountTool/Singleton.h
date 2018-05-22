//
//  Singleton.h
//  fuckthings
//
//  Created by 臧昊 on 15/1/19.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#ifndef fuckthings_Singleton_h
#define fuckthings_Singleton_h

// .h
#define single_interface(class)  + (class *)shared##class;

// .m
// \ 代表下一行也属于宏
// ## 是分隔符
#define single_implementation(class) \
static class *_instance; \
\
+ (class *)shared##class \
{ \
if (_instance == nil) { \
_instance = [[self alloc] init]; \
} \
return _instance; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
}

#endif
