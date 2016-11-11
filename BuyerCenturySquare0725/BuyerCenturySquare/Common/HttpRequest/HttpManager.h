//
//  HttpManager.h
//  BuyerCenturySquare
//
//  Created by longminghong on 15/7/9.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "ApplyInfoDTO.h"
#import "UserInfoDTO.h"
#import "ConsigneeAddressDTO.h"
#import "ConsigneeDTO.h"
#import "PayPayDTO.h"
#import "MemberInfoDTO.h"
#import "CartAddDTO.h"
#import "CartUpdateDTO.h"
#import "CartCountDTO.h"
#import "AdressListModel.h"
#import "GoodsSortDTO.h"//!商品排序、筛选的DTO

//#define IPAddress @"116.31.82.98"// !聊天的ip

typedef NS_ENUM(NSInteger, BCSHttpRequestStatus) {
    BCSHttpRequestStatusStable = 0,
    BCSHttpRequestParameterIsLack,
    BCSHttpRequestStatusHaveNotLogin
};
@interface HttpManager : NSObject

/**
 *  3.1登陆接口
 *
 *  @param memberAccount 小B账户
 *  @param password      密码
 *  @param success       请求成功，responseObject为请求到的数据
 *  @param failure       请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForLoginWithMemberAccount:(NSString *)memberAccount password:(NSString *)password success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;



/**
 *  3.2	注册接口-验证手机号并且发送验证码
 *
 *  @param mobile  验证的手机号码
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForRegisterMobile:(NSString *)mobilePhone success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.3	设置登录密码
 *
 *  @param mobilePhone 用户手机号
 *  @param password    密码
 *  @param type        0：注册 1：忘记密码
 *  @param success     请求成功，responseObject为请求到的数据
 *  @param failure     请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForSetPasswordWithMobilePhone:(NSString *)mobilePhone password:(NSString *)password type:(NSString *)type success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark- 3.13	小B新增注册接口
/**
 *  3.13	小B新增注册接口
 *
 *  @param mobilePhone 用户手机号
 *  @param password    密码
 *  @param success     请求成功，responseObject为请求到的数据
 *  @param failure     请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestPassSetPasswordWithMobilePhone:(NSString *)mobilePhone password:(NSString *)password  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/**
 *  3.4	根据父ID获取省市区列表接口
 *
 *  @param parentId 父级ID（0是查询省份）
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetAreaListByParentIdWithParentId:(NSNumber *)parentId success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *  3.5	小B补充申请资料
 *
 *  @param applyInfoDTO ApplyInfoDTO对象
 *  @param success      请求成功，responseObject为请求到的数据
 *  @param failure      请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForaddApplyInfoWithApplyInfo:(ApplyInfoDTO *)applyInfoDTO  shopName:(NSString *)shopName  otherPlatform:(NSString *) otherPlatform success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/**
 *  3.15	小B首次提交申请资料接口
 *
 *  @param applyInfoDTO ApplyInfoDTO对象
 *  @param success      请求成功，responseObject为请求到的数据
 *  @param failure      请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForaddApplyInfoFirstWithApplyInfo:(ApplyInfoDTO *)applyInfoDTO  shopName:(NSString *)shopName whithPushCode:(NSString *)pushCode otherPlatform:(NSString *) otherPlatform success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/**
 *  3.16	小B再次提交申请资料接口
 *
 *  @param applyInfoDTO ApplyInfoDTO对象
 *  @param success      请求成功，responseObject为请求到的数据
 *  @param failure      请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */

+ (BCSHttpRequestStatus)sendHttpRequestForaddApplyInfoAgainWithApplyInfo:(ApplyInfoDTO *)applyInfoDTO  shopName:(NSString *)shopName otherPlatform:(NSString *) otherPlatform success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.94	小B验证地推码
 *
 *  @param applyInfoDTO ApplyInfoDTO对象
 *  @param success      请求成功，responseObject为请求到的数据
 *  @param failure      请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
#pragma mark-3.94小B验证地推码
+ (BCSHttpRequestStatus)sendHttpRequestForaddCodeWithApplyInfo:(ApplyInfoDTO *)applyInfoDTO  shopName:(NSString *)shopName  otherPlatform:(NSString *) otherPlatform success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/**
 * 3.6 小B查询申请资料
 *
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetApplyInfoSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/**
 
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 *
 */
#pragma mark-3.14	小B申请资料校验接口
+ (BCSHttpRequestStatus)sendHttpRequestForVerApplyInfoSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.7	小B验证邀请码
 *
 *  @param keyCode     邀请码
 *  @param mobilePhone 手机号码
 *  @param success     请求成功，responseObject为请求到的数据
 *  @param failure     请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForVerifyRegisterKeyCode:(NSString *)keyCode mobilePhone:(NSString *)mobilePhone  shopType:(NSString *)shopType shopName:(NSString *)shopName otherPlatform:(NSString *)otherPlatform    businessLicenseNo:(NSString *)businessLicenseNo  businessLicenseUrl:(NSString *)businessLicenseUrl   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/**
 *  3.7	小B验证邀请码  2.10版本
 *
 *  @param keyCode     邀请码
 *  @param mobilePhone 手机号码
 *  @param success     请求成功，responseObject为请求到的数据
 *  @param failure     请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
#pragma mark-3.7 2.10 小B验证邀请码 新 接口
+ (BCSHttpRequestStatus)sendHttpRequestForCodeVerifyRegisterKeyCode:(NSString *)keyCode mobilePhone:(NSString *)mobilePhone    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *  3.8	忘记密码校验接口
 *
 *  @param mobilePhone 手机号(注册手机号)
 *  @param success     请求成功，responseObject为请求到的数据
 *  @param failure     请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForForgetPwdCheckWithMobilePhone:(NSString *)mobilePhone success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.9	用户修改密码接口
 *
 *  @param phone    手机号码
 *  @param passwd   密码
 *  @param oldpwd   原始密码
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForModifyPasswordWithPhone:(NSString *)phone passwd:(NSString *)passwd oldpwd:(NSString *)oldpwd success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *  3.10 用户修改支付密码接口
 *
 *  @param phone              手机号码
 *  @param password           密码
 *  @param originalPassword   原始密码
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForPayPasswdUpdateWithPhone:(NSString *)phone password:(NSString *)password originalPassword:(NSString *)originalPassword success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.11 发送短信接口
 *
 *  @param phone   手机号码
 *  @param type    类型说明:
                 1：小B注册
                 2：小B找回登录密码
                 3：大B找回登录密码
                 4：小B找回支付密码
                 5：小B重置支付密码
                 14：小B修改密码获取验证码
                 15：大B修改密码获取验证码
 
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForSendSmsWithPhone:(NSString *)phone type:(NSString *)type success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.12 短信校验接口
 *
 *  @param phone   手机号码
 *  @param type    类型说明:
                     1：小B注册
                     2：小B找回登录密码
                     3：大B找回登录密码
                     4：小B找回支付密码
                     5：小B重置支付密码
                     14：小B修改登录密码验证
                     15：大B修改登录密码验证
 
 *  @param smsCode 短信验证码
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForVerifySmsCodeWithPhone:(NSString *)phone type:(NSString *)type smsCode:(NSString *)smsCode success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.13 个人中心主页接口
 *
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForPersonalCenterSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.14 商品分类接口
 *
 *  @param merchantNo 商家编号(没有则查询所有)
 *  @param queryType  0查询商家 1:查询商品 3.0.3版本增加
 *  @param success    请求成功，responseObject为请求到的数据
 *  @param failure    请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetCategoryListWithMerchantNo:(NSString *)merchantNo  withQueryType:(NSString *)queryType success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.15 小B商品列表接口
 *
 *  @param pageNo      当前页码
 *  @param pageSize    每页显示数量
 *  @param merchantNo  商家编号(没有则查询所有)
 *  @param structureNo 分类结构体编码(01-02)
 *  @param rangeFlag   查询范围(0:全部（默认） 1:等级可见)
 
 *  @param success     请求成功，responseObject为请求到的数据
 *  @param failure     请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetGoodsListWithPageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize  merchantNo:(NSString *)merchantNo structureNo:(NSString *)structureNo rangeFlag:(NSString *)rangeFlag withGoodsSortDTO:(GoodsSortDTO *)sortDTO success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.16 商品（下载）无权限提示接口
 *
 *  @param goodsNo  商品编号
 *  @param authType 1:商品资料 2:图片下载 3:分享权限 4:收藏权限
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */

+ (BCSHttpRequestStatus)sendHttpRequestForGetGoodsNotLevelTipWithGoodsNo:(NSString *)goodsNo authType:(NSString *)authType success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.17  小B获取商家邮费专拍商品接口
 *
 *  @param merchantNo  商家编号
 *  @param success     请求成功，responseObject为请求到的数据
 *  @param failure     请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetGoodsFeeInfo:(NSString *)merchantNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.17 小B商品详情接口
 *
 *  @param goodsNo 商品编号
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetGoodsInfoDetailsWithGoodsNo:(NSString *)goodsNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/**
 *  3.17  3.0 小B商品详情接口
 *
 *  @param goodsNo 商品编号
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
#pragma mark-3.17	3.0 小B商品详情接口 （新 3.0）
+ (BCSHttpRequestStatus)sendHttpRequestForGetNewGoodsInfoDetailsWithGoodsNo:(NSString *)goodsNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/**
 *  3.18 小B查看商家店铺列表接口
 
 *  @param merchantNo 商家编码（获取单个商家)
 *  @param pageNo   当前页码（默认1）
 *  @param pageSize 每页显示数量(默认20条)
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetMerchantListWithMerchantNo:(NSString *)merchantNo pageNo:(NSNumber*)pageNo pageSize:(NSNumber*)pageSize success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.19 小B查看商家店铺详情接口
 *
 *  @param merchantNo 商家编码
 *  @param success    请求成功，responseObject为请求到的数据
 *  @param failure    请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetMerchantShopDetailWithMerchantNo:(NSString *)merchantNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.20 小B商品收藏新增接口
 *
 *  @param goodsNo 商品编码
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForAddGoodsFavoriteWithGoodsNo:(NSString *)goodsNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.21 小B商品收藏取消接口
 *
 *  @param goodsNo 商品编码
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForDelFavoriteWithGoodsNo:(NSString *)goodsNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.22 小B商品收藏列表接口
 *
 *  @param queryType  查询类型(0:正常 1:失效)
 *  @param pageNo     当前页码（默认1）
 *  @param pageSize   每页显示数量（默认20）
 
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetFavoriteListByTime:(NSString *)queryType success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.24	小B商品收藏列表接口(按商家排序)
 *
 *  @param queryType  查询类型(0:正常 1:失效)
 *  @param pageNo     当前页码（默认1）
 *  @param pageSize   每页显示数量（默认20）
 
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetFavoriteListByMerchant:queryType  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.23小B站内信列表接口
 *
 *  @param pageNo   当前页码(默认1)
 *  @param pageSize 每页显示数量（默认20）
 *  @param success  请求成功，responseObject为请求到的数据 
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetMemberNoticeListWithPageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.24 小B站内信阅读状态修改接口
 *
 *  @param insideLetterId 站内信Id
 *  @param success        请求成功，responseObject为请求到的数据
 *  @param failure        请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForUpdateNoticeStatusWithInsideLetterID:(NSString *)insideLetterId success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/*
 3.92	小B站内信阅读状态修改接口
 @param tokenId 用户登录标识
 */
+ (BCSHttpRequestStatus)sendHttpRequestForLetterSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/**
 *  3.25 小B获取下载图片列表接口
 *
 *  @param imageDownloadArray      图片下载参数数组
 *  @param success      请求成功，responseObject为请求到的数据
 *  @param failure      请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetDownloadImageList:(NSMutableArray *)imageDownloadArray success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.26 小B图片下载完成回调接口
 *
 *  @param goodsNo 商品编号
 *  @param picType 0窗口图，1客观图
 
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForDownloadCompleteWithGoodsNo:(NSString *)goodsNo picType:(NSString *)picType  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.27 小B图片下载历史查询接口
 *
 *  @param pageNo   当前页码 (默认第一页)
 *  @param pageSize 每页显示数量（默认20）
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetHistoryDownloadListWithPageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.28 小B商品补货列表接口( 按购买时间倒序取)
 *
 *  @param pageNo     当前页码 (默认第一页)
 *  @param pageSize   每页显示数量（默认20）

 *  @param success    请求成功，responseObject为请求到的数据
 *  @param failure    请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetGoodsReplenishmentByTime:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.29 小B订购过的商家列表接口
 *
 *  @param pageNo   当前页码 (默认第一页)
 *  @param pageSize 每页显示数量（默认20）
 
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetBoughtListWithPageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.30 小B查看个人资料接口
 *
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */

+ (BCSHttpRequestStatus)sendHttpRequestGetMemberInfoSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.31 小B修改个人资料接口
 *
 *  @param MemberInfoDTO 请参考MemberInfoDTO.h
 *  @param success     请求成功，responseObject为请求到的数据
 *  @param failure     请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForUpdateMemberDataWithUserInfoDTO:(MemberInfoDTO *)memberInfoDTO success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.32 小B保存收货地址
 *
 *  @param consigneeAddressDTO 请参考ConsigneeAddressDTO.h
 *  @param success             请求成功，responseObject为请求到的数据
 *  @param failure             请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForAddConsignee:(ConsigneeAddressDTO *)consigneeAddressDTO success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.33 小B收货地址列表接口
 *
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForConsigneeGetListSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.34 小B修改收货地址
 *
 *  @param consigneeDTO 请参考consigneeDTO.h
 *  @param success      请求成功，responseObject为请求到的数据
 *  @param failure      请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForConsigneeUpdateWithConsigneeDTO:(AdressListModel*)consigneeDTO success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.35 小B删除收货地址
 *
 *  @param consigneeID 收货地址Id
 *  @param success     请求成功，responseObject为请求到的数据
 *  @param failure     请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForConsigneeDelWithConsigneeID:(NSNumber *)consigneeID success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.36 小B消费积分记录按月统计接口
 *
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetIntegralByMonthSuccess:(NSString *)time  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.37 小B消费积分记录查询接口
 *
 *  @param time    查询年月例2014-09
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetIntegralListWithTime:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.38 图片上传接口
 *
 *  @param appType 接口类型：1大B 2小B
 *  @param type    上传类型：1小B省份证，2小B营业执照 3 大B参考图 4：个人资料头像 5：快递单拍照上传6:聊天图片上传
 *  @param file    文件（二进制流）
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForImgaeUploadWithAppType:(NSString *)appType type:(NSString *)type orderCode:(NSString *)orderCode goodsNo:(NSString *)goodsNo file:(NSData *)file  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *  3.39 付费下载
 *
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForPayDownloadSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *  3.40 采购单列表
 *
 *  @param orderStatus 采购单状态
 *  @param pageNo      当前页码(默认1)
 *  @param pageSize    每页显示数量（默认20）
 *  @param success     请求成功，responseObject为请求到的数据
 *  @param failure     请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForOrderListWithOrderStatus:(NSString *)orderStatus pageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.41 采购单详情
 *
 *  @param orderCode 采购单号
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForOrderDetailWithOrderCode:(NSString *)orderId success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.42 加入采购车
 *
 *  @param CartAddDTO 见文档
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForCartAdd:(CartAddDTO *)cartAddDTO success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.5	批量加入采购车
 *
 *  @param cartAddArray  CartAddDTO 见文档
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
//#pragma mark-3.5	批量加入采购车
+ (BCSHttpRequestStatus)sendHttpRequestForCartAddList:(NSArray *)cartAddArray success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/**
 *  3.43 采购车列表

 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForCartListSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.44 更新采购车商品
 
 *  @param CartUpdateDTO
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForCartUpdateSuccess:(CartUpdateDTO *)cartUpdateDTO success: (void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.45	选择结算商品/采购单确认
 *
 *  @param cartKeyList 将getCart返回的数据, 按找用户选择的商品 , 原格式传到这个参数中
 *  @param provinceNo  发货地址省份编码
 *  @param memberNo    小B编码
 *  @param success     请求成功，responseObject为请求到的数据
 *  @param failure     请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetCartConfirmWithCartKeyList:(NSArray *)cartKeyList templateIds:(NSArray *)templateIds provinceNo:(NSString *)provinceNo memberNo:(NSString *)memberNo  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.46 生成采购单
 *  @param addressId  收货地址号(类型 int)
 *  @param success    请求成功，responseObject为请求到的数据
 *  @param failure    请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForOrderAddSuccess:(NSNumber* )addressId success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.47 获取支付方式
 *
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForPayGetMethodSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.48 支付密码验证
 *
 *  @param password 支付密码（加密后）
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForPaypasswdVerifyWithPassword:(NSString *)password success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.49 创建支付密码
 *
 *  @param password       支付密码
 *  @param repeatPassword 再次输入的支付密码
 *  @param success        请求成功，responseObject为请求到的数据
 *  @param failure        请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForPaypasswdAddWithPassword:(NSString *)password repeatPassword:(NSString *)repeatPassword success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.50 余额查询
 *
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetPayBalance:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.51	支付接口
 *  @param PayPayDTO 支付信息
 *  @param success   请求成功，responseObject为请求到的数据
 *  @param failure   请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetPayPay:(PayPayDTO *)PayPayDTO success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.52 创建支付交易单
 *
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForPaytradeAddSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *  3.53 采购商等级权限说明接口
 *
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForMemberPermissionListSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.54	查询是否有支付密码
 *
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetIsHasPaymentPassword:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.55	删除采购车中的商品
 
 *  @param goodsNo 商品编码
 *  @param cartType 商品类型
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForCartDelete:(NSString *)goodsNo cartType:(NSString*)cartType success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.56	设置已签收接口
 *
 *  @param orderCode 采购单编号
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForOrderReceived:(NSString *)orderCode success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.57	取消未付款采购单
 
 *  @param orderCode 会员编码
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForOrderCancelUnpaid:(NSString *)orderCode success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.58	小B商品补货列表接口( 按商家时间倒序取)
 *
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetGoodsReplenishmentByMerchant:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.59   全店批发条件校验接口
 *
 *  @param wholesaleConditionArray  采购车统计列表
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForSetCartWholeSaleCondition:(NSArray *)wholesaleConditionArray success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.60	获取最新版本
 *
 *  @param userType    用户类型(1大B,2小B)
 *  @param systemType  APP类型(1:ios，2:安卓)
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetAppVersion:(NSString *)userType systemType:(NSString *)systemType success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *  3.62	小B意见反馈
 *
 *  @param type    小B：1、商品浏览2、采购车3、询单4、图片下载5、个人中心6、其他
 *  @param content 反馈内容
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForaddFeedback:(NSString *)type content:(NSString *)content success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.63	创建虚拟商品采购单
 *
 *  @param piece    虚拟商品购买的份数 , 不是总数
 *  @param goodsNo  商品编码
 *  @param skuNo    SKU编码
 *  @param serviceType    购买服务类型(3-购买下载次数的服务  4-预付款会员升级)(int)
 
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForaddVirtualOrder:(NSNumber *)piece goodsNo:(NSString *)goodsNo skuNo:(NSString *)skuNo serviceType:(NSNumber *)serviceType success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//3.63_2  用于预付货款请求---比3.63多一个参数depositAmount预付款金额
+ (BCSHttpRequestStatus)sendHttpRequestForaddVirtualOrder:(NSNumber *)piece goodsNo:(NSString *)goodsNo skuNo:(NSString *)skuNo serviceType:(NSNumber *)serviceType depositAmount:(NSNumber *)amount success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.63	获取商品分享链接
 *
 *  @param goodsNo  商品编码

 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetGoodsShareLink:(NSString *)goodsNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.64	预付货款收支记录接口
 *
 *  @param type    支付类型（空为全部，默认为空，1为充值）
 *  @param pageNo      当前页码(int)
 *  @param pageSize    每页显示数量(int)
 
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetPaymentsRecords:(NSString *)type pageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.65	采购单记录接口（按商家查询）
 *
 *  @param merchantNo    商家编码
 *  @param pageSize      每页显示数量(int 默认 15个)
 
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetOrderByMerchant:(NSString *)merchantNo pageNo:(NSNumber *)pageNo  pageSize:(NSNumber *)pageSize success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.66	再次支付接口（采购单列表页面支付）
 *
 *  @param orderCode     采购单号

 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForConfirmPay:(NSString *)orderCode  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.67	询单获取商家聊天帐号接口
 *  @param merchantNo     商家编码
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetMerchantRelAccount:(NSString *)merchantNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.68	获取支付状态接口
 *  @param tradeNo       支付交易号
 *  @param payMethod     支付方式(AlipayQuick, WeChatMobile)
 
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetPaymentStatus:(NSString *)tradeNo payMethod:(NSString *)payMethod success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/** 3.69	消息推送（openfire）
 *  @param type         消息标题
 *  @param title        消息内容
 *  @param acountType   账号类型
 *  @param acounts      账户集合
 *  @param targets      商品编码或者消息id
 
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+(BCSHttpRequestStatus)sendHttpRequestForGetChatPusher:(NSNumber *)type title:(NSString *)title acountType:(NSString *)acountType acounts:(NSString *)acounts targets:(NSString *)targets success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  意见反馈类型
 *
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestFeedBackTypeSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/** 3.70	小B设置延迟收货操作
 *  @param orderCode 采购单编码

 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+(BCSHttpRequestStatus)sendHttpRequestForSetOrderAutoConfirm:(NSString *)orderCode success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;




/** 3.71	小B预付货款充值记录
 *  @param orderCode 采购单编码
 
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+(BCSHttpRequestStatus)sendHttpRequestForPaymentRecordPageNo:(NSNumber *)PageNo pageSize:(NSNumber *)pageSize success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/** 3.72 下载次数购买记录
 *  @param orderCode 采购单编码
 
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+(BCSHttpRequestStatus)sendHttpRequestForBuyRecordPageNo:(NSNumber *)PageNo pageSize:(NSNumber *)pageSize  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.81	小B预付货款获取升级列表接口
 *
 *  @param success 请求成功
 *  @param failure 请求失败
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */

+(BCSHttpRequestStatus)sendHttpRequestForPaymentUpgradeListSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/**
 *  3.82	小B预付货款金额校验接口
 *
 *  @param level   当前用户等级
 *  @param amount  充值钱数
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+(BCSHttpRequestStatus)sendHttpRequestForpaymentCheckMoneylevel:(NSNumber *)levelNub amount:(NSNumber *)amountNub success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.83	小B预付货款充值接口
 *
 *  @param bankCode 银行代码
 *  @param bankName 银行名称
 *  @param level    升级级别
 *  @param amount   充值金额
 *  @param userName 开户人姓名
 *  @param tradeNo  交易采购单号
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+(BCSHttpRequestStatus)sendHttpRequestForPaymentChargeBankCode:(NSString *)bankCode bankName:(NSString *)bankName level:(NSNumber *)level amount:(NSNumber*)amount userName:(NSString *)userName tradeNo:(NSString *)tradeNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


#pragma  mark  3.85 第三方平台

/**
 *   3.85 第三方平台
 *
 *  @param type    bank_account：银行帐号列表    other_platform：第三方平台列表
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */

+(BCSHttpRequestStatus)sendHttpRequestForThirdPartiesType:(NSString *)type    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark  3.86	小B获取预付货款银行列表接口 
/**
 *  小B获取预付货款银行列表接口
 *
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+(BCSHttpRequestStatus)sendHttpRequestForbankCardMessageSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 3.87 小B预付货款充值记录接口(银行转帐)
+(BCSHttpRequestStatus)sendHttpRequestForCreditTransfer:(NSDictionary *)upDic    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


#pragma mark 3.88 小B预付货款充值记录明细接口(银行转帐)
+(BCSHttpRequestStatus)sendHttpRequestForCreditTransferDetail:(NSDictionary *)upDic    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 3.89 删除银行转账记录接口(审核不通过)
+(BCSHttpRequestStatus)sendHttpRequestForDeleteCreditTransfer:(NSDictionary *)upDic    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


#pragma  mark  3.90 注册按钮显示接口
+(BCSHttpRequestStatus)sendHttpRequestForSwitchsuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 3.95 小B商家收藏新增接口
+(BCSHttpRequestStatus)sendHttpRequestForAddMerchantFavorite:(NSString *)merchantNo   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 3.96 小B商家收藏取消接口
+(BCSHttpRequestStatus)sendHttpRequestForDelMerchantFavorite:(NSString *)merchantNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 3.0.0的接口

#pragma mark 3.2 小B频道接口
+(BCSHttpRequestStatus)sendHttpRequestFoChannelListSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 3.3	小B频道商品列表接口
+(BCSHttpRequestStatus)sendHttpRequestFoChannelGoodsListWithChannelId:(NSNumber *)channelId withRangeFlag:(NSString *)rangeFlag  withPageNo:(NSNumber *)pageNo withPageSize:(NSNumber *)pageSize  Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


#pragma makrk 3.4 查询热门店铺标签接口
+(BCSHttpRequestStatus)sendHttpRequestForHotLabelListSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 3.7  合并采购单再次支付接口 合并发货
+(BCSHttpRequestStatus)sendHttpRequestForMulitiConfirmPayOrderCodes:(NSString *)orderCodes  Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 3.8	小B搜索商家列表接口
+(BCSHttpRequestStatus)sendHttpRequestFoSeachMerchantListWithQueryParam:(NSString *)queryParam  withCategoryNo:(NSString *)categoryNo  withPageNo:(NSNumber *)pageNo withPageSize:(NSNumber *)pageSize  Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 3.9	小B查询商家10条商品数据接口
+(BCSHttpRequestStatus)sendHttpRequestFoQueryGoodsTenNum:(NSString *)merchantNo    Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 3.10	小B搜索商品列表接口
+(BCSHttpRequestStatus)sendHttpRequestFoSeachGoodsList:(NSNumber *)pageNo withPageSize:(NSNumber *)pageSize withQueryParam:(NSString *)queryParam withRangeFlag:(NSString *)rangeFlag  withGoodsSortDTO:(GoodsSortDTO *)sortDTO  Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma mark - 3.18小B申请退换货接口
/**
 *  小B申请退换货接口
 *
 *  @param orderCode    订单编号
 *  @param refundType   退换货类型：0-退货退款 1-仅退款 2-换货
 *  @param refundReason 退换货原因  0-质量问题 1-尺码问题 2-少件/破损 3-卖家发错货 4-未按约定时间发货5-多拍/拍错/不想要6-快递/物流问题7-空包裹/少货8-其他
 *  @param goodsStatus  货物状态 0-未收到货 1-已收到货
 *  @param refundFee    退款金额
 *  @param remark       备注
 *  @param pics         凭证集合
 *  @param success
 *  @param failure
 *
 *  @return 
 */
+(BCSHttpRequestStatus)sendHttpRequestForRefundApplyOrderCode:(NSString *)orderCode refundType:(NSString *)refundType refundReason:(NSString *)refundReason goodsStatus:(NSString *)goodsStatus refundFee:(NSNumber *)refundFee remark:(NSString *)remark pics:(NSString *)pics  Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


#pragma mark - 3.20 小b 取消退换货
+(BCSHttpRequestStatus)sendHttpRequestForRefundCancelrefundNo:(NSString *)refundNo   Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;




#pragma mark 3.21	查看退换货详情
+(BCSHttpRequestStatus)sendHttpRequestForRefundDetailOrderCode:(NSString *)orderCode   Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 3.23	获取历史聊天列表信息（openfire）
+(BCSHttpRequestStatus)sendHttpRequestForGetChantListWithMemberNo:(NSString *)memberNo pageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize success:(void (^)(AFHTTPRequestOperation *, id))success  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma mark 3.23	获取历史聊天详细信息（openfire）
+(BCSHttpRequestStatus)sendHttpRequestForGetChantHistoryWithUser:(NSString *)user withTime:(NSString *)time pageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize success:(void (^)(AFHTTPRequestOperation *, id))success  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma mark 3.1	小B获取客服等待数量接口
+ (BCSHttpRequestStatus)sendHttpRequestForNumbWithJid:(NSString *)jid success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma mark -3.27	小B推送数量清零接口
+ (BCSHttpRequestStatus)sendHttpRequestForclearBadgeCountSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma mark 3.99	App上报错误日志接口
+ (BCSHttpRequestStatus)sendHttpRequestForApperrorAddWithList:(NSMutableArray *)errorList     Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 小b退换货申请
+(BCSHttpRequestStatus)sendHttpRequestFororderRefundApply:(NSDictionary *)upDic   Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 小b退换货申请 修改
+(BCSHttpRequestStatus)sendHttpRequestForOrderRefundApplyUpdate:(NSDictionary *)upDic   Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 3.26	小B获取广告路径接口
+ (BCSHttpRequestStatus)sendHttpRequestForAdvertUrl:(NSString *)positionAlias Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;



#pragma mark --------- 与h5交互

#pragma mark 商品运营层
+(void)getCustomGoodsRequestWebView:(UIWebView *)webView withUrl:(NSString *)requestUrl;

//h5页面进行网络请求采用的方法
//订购过的商家
+(void)orderMerchantNetworkRequestWebView:(UIWebView *)webView;
//会员等级
+(void)membershipUpgradeNetworkRequestWebView:(UIWebView *)webView;
//收藏商品
+(void)collectionGoodNetworkRequestWebView:(UIWebView *)webView;
//申请资料
+(void)applicationMaterialNetworkRequestWebView:(UIWebView *)webView;
//会员等级规则
+(void)membershipNetworkRequestWebView:(UIWebView *)webView;
//消费积分记录
+(void)scoreRecordRequestWebView:(UIWebView *)webView;
//交易流水
+(void)advancePaymentRequestWebView:(UIWebView *)webView;
//预付货款记录
+(void)paymentRecordRequestWebView:(UIWebView *)webView;
//!服务规则与协议
+(void)serviceRequestWebView:(UIWebView *)webView;

+(NSString *)applicationMaterialRequestWebView;
+(NSString *)membershipRequestWebView;
//订购过的商家
+(NSString *)orderMerchantNetworkRequestWebView;
//收藏商品
+(NSString *)collectionGoodNetworkRequestWebView;
//消费积分记录
+(NSString *)scoreRecordRequestWebView;
//交易流水
+(NSString *)advancePaymentRequestWebView;
//预付货款记录
+(NSString *)paymentRecordRequestWebView;
//全部夏季的h5页面
+(NSString *)nextPageInterface;
//!服务规则与协议
+(NSString *)serviceRequestWebView;
//会员等级
+(NSString *)membershipUpgradeNetworkRequestWebView;
//获取次级页面
+(NSString *)accessSecondaryPageURL;

//小b商圈
+(void)businessCircleRequestWebView:(UIWebView *)webView;



/**
 *  获取当前时间戳
 *
 *  @return 返回当前时间戳
 */
+ (NSString *)getTimesTamp;

/**
 *  获取签名
 *
 *  @param parameter 必要的参数
 *  @param timestamp 时间戳
 *
 *  @return 返回签名
 */
+(NSString *)getSignWithParameter:(NSDictionary *)parameter timestamp:(NSString *)timestamp;
/**
 *  转化参数
 *
 *  @param parameter 字典参数
 *  @param timestamp 时间戳
 *
 *  @return 返回一个json字符串
 */
+(NSString *)getParameterWithParameter:(NSDictionary *)parameter timestamp:(NSString *)timestamp;





#pragma mark - 临时请求数据

+ (BCSHttpRequestStatus)sendHttpRequestForTempPhoneAndTypeMerchant:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


#pragma mark -----h5采用---
//转化参数
+(NSMutableDictionary *)getParameterWithTimestamp:(NSString *)timestamp;
/**
 *  获取签名
 *
 *  @param parameter 必要的参数
 *  @param timestamp 时间戳
 *
 *  @return 返回签名
 */
+(NSString *)getSignWithParameter:(NSMutableDictionary *)parameter;



/**
 *  请求页面
 *
 *  @param webView
 *  @param requestUrl 请求连接
 */
+ (void)businessCircleRequestWebView:(UIWebView *)webView requestUrl:(NSString *)requestUrl;


+ (void)AuditStatusRequestWebView:(UIWebView *)webView auditStatusID:(NSString *)auditStatusID;


#pragma mark !创建充值接口
+ (BCSHttpRequestStatus)sendHttpRequestForAddPrepay:(NSDictionary *)upDic success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark  ==快递网===
+ (BCSHttpRequestStatus)sendHttpRequestForExpressCode:(NSString *)shipperCode    logisticCode:(NSString *)logisticCode  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+(NSString *)hostUrl;
#pragma 获取省市区列表接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetAreaListSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma mark 3.23	查询系统属性列表接口 判断是否请求新的省市区数据
+ (BCSHttpRequestStatus)sendHttpRequestForJudgeWheterGetNewExpressListSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
