//
//  ModelManager.h
//  城市厨房
//
//  Created by 臧昊 on 15/1/31.
//  Copyright (c) 2015年 臧昊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelManager : NSObject
+ (ModelManager *)sharedManager;
- (void)httpRequestGetAdvertisement;
- (void)httpRequestGetHomeGoods;

- (void)httpRequestGetGoodsDetailInformationWithCode: (NSString *)code;
- (void)httpRequestGetGoodsSimpleInformationWithCode: (NSString *)code;
// 首页——列表加载商品列表信息
- (void)httpRequestGetGoodsListInformationWithCode: (NSString *)code PageNo:(int)pageNo Field:(NSString *)field Sort:(NSString *)sort;
// 商家信息--加载商家信息
- (void)httpRequestGetCompanyInformationWithCompanyCode: (NSString *)companyCode;
// 商家信息--加载商家所有商品
- (void)httpRequestGetCompanyGoodsWithCompanyCode: (NSString *)companyCode PageNo:(int)pageNo Field:(NSString *)field Sort:(NSString *)sort;
// 分类--加载分类
- (void)httpRequestGetCategoryTop;
- (void)httpRequestGetCategoryChildWithCode: (NSString *)code;
// 购物车--查询用户购物车商品
- (void)httpRequestGetUserShopCarGoodsWithUserCode: (NSString *)userCode;
// 商品详情--加入购物车
- (void)httpRequestAddGoods:(NSString *)productCode inNum: (int)number WithProductPriceId:(NSString *)productPriceId UserCode: (NSString *)userCode;

// 购物车--修改购物车单个商品数量
- (void)httpRequestResetCartItemId:(NSString *)cartItemId number:(int)num WithUserCode:(NSString *)userCode;
// 购物车--删除购物车中单个商品
- (void)httpRequestRemoveCartItemId:(NSString *)cartItemId WithUserCode:(NSString *)userCode;
// 购物车--生成订单
- (void)httpRequestCreateOrder:(NSString *)cartIdArray WithUserCode:(NSString *)userCode AndCustAddrId:(NSString *)custAddrId;
// 购物车--查询订单
- (void)httpRequestQueryOrderWithOrderCode:(NSString *)orderCode;
// 我的--注册
- (void)httpRequestRegisterLoginName:(NSString *)loginName andPwd:(NSString *)password withTel:(NSString *)tel;
// 我的--登录
- (void)httpRequestGetUserCodeWithLoginKey:(NSString *)loginKey andPassword:(NSString *)password;
// 我的--获取用户信息
- (void)httpRequestGetUserInformationWithUserCode:(NSString *)usercode;
// 我的——我的优惠券
- (void)httpRequestGetUserCouponsWithUserCode:(NSString *)userCode PageNo:(int)pageNo;
// 我的--我的账号--获取收货地址
- (void)httpRequestGetUserAddressWithUserCode:(NSString *)userCode;
// 我的--我的账号--添加收货地址
- (void)httpRequestAddUserAddress:(NSString *)address andProvince:(NSString *)province andCity:(NSString *)city andDistrict:(NSString *)district andPostCode: (NSString *)postcode andTel:(NSString *)tel andName:(NSString *)name andIsDefault:(BOOL)isDefault WithUserCode:(NSString *)userCode;
// 我的--我的账号--添加收货地址
- (void)httpRequestResetUserAddressId:(NSString *)addressId definiteAddress:(NSString *)address andProvince:(NSString *)province andCity:(NSString *)city andDistrict:(NSString *)district andPostCode: (NSString *)postcode andTel:(NSString *)tel andName:(NSString *)name andIsDefault:(BOOL)isDefault WithUserCode:(NSString *)userCode;
// 我的--我的账号--删除收货地址
- (void)httpRequestRemoveUserAddress:(NSString *)addressId WithUserCode:(NSString *)userCode;
// 我的——我的账号——修改用户密码
- (void)httpRequestUseUserCode:(NSString *)userCode ResetOldPwd:(NSString *)oldPwd withNewPwd:(NSString *)newPwd;
// 我的——我的订单--获取用户订单
- (void)httpRequestGetUserOrderWithUserCode:(NSString *)userCode PageNo:(int)pageNo;
// 我的——我的收藏
- (void)httpRequestGetUserCollectWithUserCode:(NSString *)userCode PageNo:(int)pageNo;
// 我的--删除我的收藏单个商品
- (void)httpRequestRemoveCollectedProduct:(NSString *)productCode WithUserCode:(NSString *)userCode;
// 我的--添加我的收藏单个商品
- (void)httpRequestAddCollectedProduct:(NSString *)productCode WithUserCode:(NSString *)userCode;

// 更多--提交意见反馈
- (void)httpRequestSubmitFeedback:(NSString *)content ByEmail:(NSString *)email;
// 更多--检查版本
- (void)httpRequestExamineVersionWithDeviceType:(NSString *)type;
@end
