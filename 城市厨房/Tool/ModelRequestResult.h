//
//  ModelRequestResult.h
//  城市厨房
//
//  Created by 臧昊 on 15/2/1.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//
#define DICT_MODEL_REQUEST_RESULT_KEY @"DICT_MODEL_REQUEST_RESULT_KEY"

#import <Foundation/Foundation.h>

@interface ModelRequestResult : NSObject
{
    BOOL _succ;
    int _errorCode;          // 只有在_succ为NO的时候有用
    NSString * _errorMsg;    // 只有在_succ为NO的时候有用
    
    NSInteger _unsucc;
}

@property (nonatomic,assign) BOOL succ;
@property (nonatomic,assign) int errorCode;
@property (nonatomic,retain) NSString * errorMsg;

@property (nonatomic,assign) NSInteger unsucc;
@property (nonatomic, strong) NSData *responseData;
@property (nonatomic, strong) NSString *responseString;
@property (nonatomic, strong) id responseObject;

@end
