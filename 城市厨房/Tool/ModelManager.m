//
//  ModelManager.m
//  城市厨房
//
//  Created by 臧昊 on 15/1/31.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import "ModelManager.h"
#import "RESTRequest.h"
#import "ModelRequestResult.h"

static ModelManager *sharedManager;
@interface ModelManager()<RESTRequestDelegate>

@end

@implementation ModelManager

+ (ModelManager *) sharedManager
{
    if(!sharedManager)
    {
        sharedManager = [[ModelManager alloc] init];
    }
    return sharedManager;
}
- (id) init
{
    self = [super init];
    if(self)
    {
        [RESTRequest sharedRequest].delegate = self;
        [RESTRequest sharedRequest].baseURL = @"http://115.28.231.147/api/";
    }
    
    return self;
}

#pragma mark - 各种网络请求
#pragma mark 首页加载广告图片
-(void)httpRequestGetAdvertisement
{
    //    http://www.appbees.net/wp-json/posts?type=page&filter[posts_per_page]=5
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys: kModelRequestGetAdvetisement, @"notification", nil];
    NSDictionary *requestParams = nil;
    [[RESTRequest sharedRequest] get:@"sys/ad" withParams:requestParams withUserInfo:userInfo];
}
#pragma mark 首页加载商品
- (void)httpRequestGetHomeGoods
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys: kModelRequestGetHomeGoods, @"notification", nil];
    NSDictionary *requestParams = nil;
    [[RESTRequest sharedRequest] get:@"sys/index" withParams:requestParams withUserInfo:userInfo];
}

#pragma mark 首页——列表加载商品列表信息
- (void)httpRequestGetGoodsListInformationWithCode: (NSString *)code PageNo:(int)pageNo Field:(NSString *)field Sort:(NSString *)sort
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys: kModelRequestGetGoodsListInformation, @"notification", nil];
    NSDictionary *requestParams = @{@"categoryCode":code, @"pageNo":@(pageNo), @"pageSize":@(12), @"field":field, @"sort":sort };
    [[RESTRequest sharedRequest] get:@"company/products" withParams:requestParams withUserInfo:userInfo];
}

#pragma mark 首页——详情加载商品详细介绍
- (void)httpRequestGetGoodsDetailInformationWithCode: (NSString *)code
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys: kModelRequestGetGoodsDetailInformation, @"notification", nil];
    NSDictionary *requestParams = @{@"productCode":code};
    [[RESTRequest sharedRequest] get:@"product/queryDetail" withParams:requestParams withUserInfo:userInfo];
}

#pragma mark 首页——详情加载商品简要信息
- (void)httpRequestGetGoodsSimpleInformationWithCode: (NSString *)code
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys: kModelRequestGetGoodsSimpleInformation, @"notification", nil];
    NSDictionary *requestParams = @{@"productCode":code};
    [[RESTRequest sharedRequest] get:@"product/query" withParams:requestParams withUserInfo:userInfo];
}

#pragma mark 商家信息--加载商家信息
- (void)httpRequestGetCompanyInformationWithCompanyCode: (NSString *)companyCode
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys: kModelRequestGetCompanyInformation, @"notification", nil];
    NSDictionary *requestParams = @{@"companyCode":companyCode};
    [[RESTRequest sharedRequest] get:@"company" withParams:requestParams withUserInfo:userInfo];
}

#pragma mark 商家信息--加载商家所有商品
- (void)httpRequestGetCompanyGoodsWithCompanyCode: (NSString *)companyCode PageNo:(int)pageNo Field:(NSString *)field Sort:(NSString *)sort
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys: kModelRequestGetCompanyAllGoods, @"notification", nil];
    NSDictionary *requestParams = @{@"companyCode":companyCode, @"pageNo":@(pageNo), @"pageSize":@(12), @"field":field, @"sort":sort};
    [[RESTRequest sharedRequest] get:@"company/products" withParams:requestParams withUserInfo:userInfo];
}

#pragma mark 分类--顶级分类加载
- (void)httpRequestGetCategoryTop
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys: kModelRequestGetCategoryTop, @"notification", nil];
    NSDictionary *requestParams = nil;
    [[RESTRequest sharedRequest] get:@"category/queryTop" withParams:requestParams withUserInfo:userInfo];
}

#pragma mark 分类--子分类加载
- (void)httpRequestGetCategoryChildWithCode: (NSString *)code
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys: kModelRequestGetCategoryChild, @"notification", nil];
    NSDictionary *requestParams = @{@"parentCode":code};
    [[RESTRequest sharedRequest] getSynchronous:@"category/queryChild" withParams:requestParams withUserInfo:userInfo];
}

#pragma mark 商品详情--加入购物车
- (void)httpRequestAddGoods:(NSString *)productCode inNum: (int)number WithProductPriceId:(NSString *)productPriceId UserCode: (NSString *)userCode
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys: kModelRequestAdd2ShopCar, @"notification", nil];
    NSDictionary *requestParams = @{@"userCode":userCode, @"productCode":productCode, @"number":@(number), @"productPriceId":productPriceId};
    [[RESTRequest sharedRequest] get:@"product/add2cart" withParams:requestParams withUserInfo:userInfo];
}

#pragma mark 购物车--查询用户购物车商品
- (void)httpRequestGetUserShopCarGoodsWithUserCode: (NSString *)userCode
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys: kModelRequestGetUserShopCar, @"notification", nil];
    NSDictionary *requestParams = @{@"userCode":userCode, @"pageSize":@(100)};
    [[RESTRequest sharedRequest] get:@"user/cart" withParams:requestParams withUserInfo:userInfo];
}

#pragma mark 购物车--修改购物车单个商品数量
- (void)httpRequestResetCartItemId:(NSString *)cartItemId number:(int)num WithUserCode:(NSString *)userCode
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys: kModelRequestResetShopCarGoodsNum, @"notification", nil];
    NSDictionary *requestParams = @{@"userCode":userCode, @"cartItemId":cartItemId, @"num":@(num)};
    [[RESTRequest sharedRequest] get:@"user/updateCart" withParams:requestParams withUserInfo:userInfo];
}

#pragma mark 购物车--删除购物车中单个商品
- (void)httpRequestRemoveCartItemId:(NSString *)cartItemId WithUserCode:(NSString *)userCode
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys: kModelRequestRemoveShopCarGoods, @"notification", nil];
    NSDictionary *requestParams = @{@"userCode":userCode, @"cartItemId":cartItemId};
    [[RESTRequest sharedRequest] get:@"user/cartDelete" withParams:requestParams withUserInfo:userInfo];
}

#pragma mark 购物车--生成订单
- (void)httpRequestCreateOrder:(NSString *)cartIdArray WithUserCode:(NSString *)userCode AndCustAddrId:(NSString *)custAddrId
{
    NSString *string =  [cartIdArray stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys: kModelRequestCreateOrder, @"notification", nil];
    NSDictionary *requestParams = @{@"cartIdArray":string, @"userCode":userCode, @"custAddrId":custAddrId};
    [[RESTRequest sharedRequest] get:@"order/create" withParams:requestParams withUserInfo:userInfo];
}

#pragma mark 购物车--查询订单
- (void)httpRequestQueryOrderWithOrderCode:(NSString *)orderCode
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys: kModelRequestQueryOrder, @"notification", nil];
    NSDictionary *requestParams = @{@"orderCode":orderCode};
    [[RESTRequest sharedRequest] get:@"order/query" withParams:requestParams withUserInfo:userInfo];
}



#pragma mark 我的--注册
- (void)httpRequestRegisterLoginName:(NSString *)loginName andPwd:(NSString *)password withTel:(NSString *)tel
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys: kModelRequestRegister, @"notification", nil];
    NSDictionary *requestParams = @{@"tel":tel, @"loginName":loginName, @"password":password};
    [[RESTRequest sharedRequest] get:@"user/regist" withParams:requestParams withUserInfo:userInfo];
}

#pragma mark 我的--登录
- (void)httpRequestGetUserCodeWithLoginKey:(NSString *)loginKey andPassword:(NSString *)password
{
     NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys: kModelRequestGetUserCode, @"notification", nil];
        NSDictionary *requestParams = @{@"loginKey":loginKey, @"password":password};
    [[RESTRequest sharedRequest] get:@"user/login" withParams:requestParams withUserInfo:userInfo];
}

#pragma mark 我的--获取用户信息
- (void)httpRequestGetUserInformationWithUserCode:(NSString *)userCode
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys: kModelRequestGetUserInformation, @"notification", nil];
    NSDictionary *requestParams = @{@"userCode":userCode};
    [[RESTRequest sharedRequest] get:@"user/query" withParams:requestParams withUserInfo:userInfo];
}

#pragma mark 我的--我的账号--获取收货地址
- (void)httpRequestGetUserAddressWithUserCode:(NSString *)userCode
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys: kModelRequestGetUserAddress, @"notification", nil];
    NSDictionary *requestParams = @{@"userCode":userCode};
    [[RESTRequest sharedRequest] get:@"user/queryDeliveryAddress" withParams:requestParams withUserInfo:userInfo];
}

#pragma mark 我的--我的账号--添加收货地址
- (void)httpRequestAddUserAddress:(NSString *)address andProvince:(NSString *)province andCity:(NSString *)city andDistrict:(NSString *)district andPostCode: (NSString *)postcode andTel:(NSString *)tel andName:(NSString *)name andIsDefault:(BOOL)isDefault WithUserCode:(NSString *)userCode
{
//    NSString *string =  [cartIdArray stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys: kModelRequestAddUserAddress, @"notification", nil];
    NSDictionary *requestParams = @{@"userCode":userCode, @"province":[province stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], @"city":[city stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], @"district":[district stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], @"address":[address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], @"postcode":postcode, @"tel":tel, @"name":[name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], @"isDefault":@(isDefault)};
    [[RESTRequest sharedRequest] get:@"user/saveDeliveryAddress" withParams:requestParams withUserInfo:userInfo];
}
#pragma mark 我的--我的账号--修改收货地址
- (void)httpRequestResetUserAddressId:(NSString *)addressId definiteAddress:(NSString *)address andProvince:(NSString *)province andCity:(NSString *)city andDistrict:(NSString *)district andPostCode: (NSString *)postcode andTel:(NSString *)tel andName:(NSString *)name andIsDefault:(BOOL)isDefault WithUserCode:(NSString *)userCode
{
    //    NSString *string =  [cartIdArray stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys: kModelRequestResetUserAddress, @"notification", nil];
    NSDictionary *requestParams = @{@"id":addressId, @"userCode":userCode, @"province":[province stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], @"city":[city stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], @"district":[district stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], @"address":[address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], @"postcode":postcode, @"tel":tel, @"name":[name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], @"isDefault":@(isDefault)};
    [[RESTRequest sharedRequest] get:@"user/saveDeliveryAddress" withParams:requestParams withUserInfo:userInfo];
}

#pragma mark 我的--我的账号--删除收货地址
- (void)httpRequestRemoveUserAddress:(NSString *)addressId WithUserCode:(NSString *)userCode
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys: kModelRequestRemoveUserAddress, @"notification", nil];
    NSDictionary *requestParams = @{@"userCode":userCode, @"deliveryId":addressId};
    [[RESTRequest sharedRequest] get:@"user/deleteDeliveryAddress" withParams:requestParams withUserInfo:userInfo];
}
#pragma mark 我的——我的账号——修改用户密码
- (void)httpRequestUseUserCode:(NSString *)userCode ResetOldPwd:(NSString *)oldPwd withNewPwd:(NSString *)newPwd
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys: kModelRequestResetUserPwd, @"notification", nil];
    NSDictionary *requestParams = @{@"userCode":userCode, @"oldPwd":oldPwd, @"newPwd":newPwd};
    [[RESTRequest sharedRequest] get:@"user/resetPassword" withParams:requestParams withUserInfo:userInfo];
}

#pragma mark 我的——我的优惠券
- (void)httpRequestGetUserCouponsWithUserCode:(NSString *)userCode PageNo:(int)pageNo
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys: kModelRequestGetUserCoupons, @"notification", nil];
    NSDictionary *requestParams = @{@"userCode":userCode, @"pageNo":@(pageNo), @"pageSize":@(12)};
    [[RESTRequest sharedRequest] get:@"user/coupons" withParams:requestParams withUserInfo:userInfo];
}

#pragma mark 我的——我的订单
- (void)httpRequestGetUserOrderWithUserCode:(NSString *)userCode PageNo:(int)pageNo
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys: kModelRequestGetUserOrder, @"notification", nil];
    NSDictionary *requestParams = @{@"userCode":userCode, @"pageNo":@(pageNo), @"pageSize":@(12)};
    [[RESTRequest sharedRequest] get:@"order/user" withParams:requestParams withUserInfo:userInfo];
}

#pragma mark 我的——我的收藏
- (void)httpRequestGetUserCollectWithUserCode:(NSString *)userCode PageNo:(int)pageNo
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys: kModelRequestGetUserCollect, @"notification", nil];
    NSDictionary *requestParams = @{@"userCode":userCode, @"pageNo":@(pageNo), @"pageSize":@(12)};
    [[RESTRequest sharedRequest] get:@"user/collect" withParams:requestParams withUserInfo:userInfo];
}

#pragma mark 我的-- 删除我的收藏单个商品
- (void)httpRequestRemoveCollectedProduct:(NSString *)productCode WithUserCode:(NSString *)userCode
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys: kModelRequestRemoveCollectedProduct, @"notification", nil];
    NSDictionary *requestParams = @{@"userCode":userCode, @"productCode":productCode};
    [[RESTRequest sharedRequest] get:@"user/collectDelete" withParams:requestParams withUserInfo:userInfo];
}

#pragma mark 我的-- 添加我的收藏单个商品
- (void)httpRequestAddCollectedProduct:(NSString *)productCode WithUserCode:(NSString *)userCode
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys: kModelRequestAddCollectedProduct, @"notification", nil];
    NSDictionary *requestParams = @{@"userCode":userCode, @"productCode":productCode};
    [[RESTRequest sharedRequest] get:@"product/collect" withParams:requestParams withUserInfo:userInfo];
}

#pragma mark 更多--提交意见反馈
- (void)httpRequestSubmitFeedback:(NSString *)content ByEmail:(NSString *)email
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys: kModelRequestSumbitFeedback, @"notification", nil];
    NSDictionary *requestParams = @{@"content":content, @"email":email};
    [[RESTRequest sharedRequest] get:@"sys/feedback" withParams:requestParams withUserInfo:userInfo];
}

#pragma mark 更多--检查版本
- (void)httpRequestExamineVersionWithDeviceType:(NSString *)type
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys: kModelRequestExamineVersion, @"notification", nil];
    NSDictionary *requestParams = @{@"type":type};
    [[RESTRequest sharedRequest] get:@"sys/version" withParams:requestParams withUserInfo:userInfo];
}

#pragma mark 网络连接 post 结束
// *******************************************************传输数据**************************************************************
- (void) requestFinished:(ASIHTTPRequest *)request
{
    //    CLog(@"%@", @"requestFinished.");
//    NSString *response = [request responseString];
//    NSLog(@"666666666666666666666%@", response);
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
    NSDictionary *userInfo = request.userInfo;
    NSString *notification = [userInfo objectForKey: @"notification"];
    ModelRequestResult *result = [[ModelRequestResult alloc] init];
//    NSLog(@"response = %@",response);
    
    if (error) {
        NSLog(@"%@", error.localizedDescription);
        result.succ = NO;
    }else{
        result.succ = YES;
        result.responseObject = jsonObject;
    }
    result.responseData = request.responseData;
//    NSString *aString = [[NSString alloc] initWithData:result.responseData encoding:NSUTF8StringEncoding];
//    NSLog(@"7777777777777777777777%@", aString);
    result.responseString = request.responseString;
//    NSLog(@"8888888888888888888888%@", request.responseString);
//    NSLog(@"999999999999999999999999999999999999%@", result.responseObject);
    NSDictionary * notificationUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                           result, DICT_MODEL_REQUEST_RESULT_KEY,
                                           nil];
    [[NSNotificationCenter defaultCenter] postNotificationName: notification
                                                        object:self
                                                      userInfo:notificationUserInfo];
    
}

#pragma mark 网络连接失败
- (void) requestFailed:(ASIHTTPRequest *) request
{
//    NSLog(@"%@", @"requestFailed.");
    NSLog(@"error %@", request.error.localizedDescription);
    
    NSDictionary *userInfo = request.userInfo;
    NSString *notification = [userInfo objectForKey: @"notification"];
    ModelRequestResult *result = [[ModelRequestResult alloc] init];
    result.succ = NO;
    result.errorMsg = request.error.localizedDescription;
    NSDictionary * notificationUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                           result, DICT_MODEL_REQUEST_RESULT_KEY,
                                           nil];
    [[NSNotificationCenter defaultCenter] postNotificationName: notification
                                                        object:self
                                                      userInfo:notificationUserInfo];
}

- (void)RESTRequestFinished:(ASIHTTPRequest *)request
{
    [self requestFinished:request];
}
- (void)RESTRequestFailed:(ASIHTTPRequest *)request
{
    [self requestFailed:request];
}

@end
