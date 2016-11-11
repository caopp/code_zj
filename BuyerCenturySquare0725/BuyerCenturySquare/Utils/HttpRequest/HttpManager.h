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
+ (BCSHttpRequestStatus)sendHttpRequestForaddApplyInfoWithApplyInfo:(ApplyInfoDTO *)applyInfoDTO success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

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
 *  3.7	小B验证邀请码
 *
 *  @param keyCode     邀请码
 *  @param mobilePhone 手机号码
 *  @param success     请求成功，responseObject为请求到的数据
 *  @param failure     请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForVerifyRegisterKeyCode:(NSString *)keyCode mobilePhone:(NSString *)mobilePhone success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

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
 *  @param success    请求成功，responseObject为请求到的数据
 *  @param failure    请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetCategoryListWithMerchantNo:(NSString *)merchantNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

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
+ (BCSHttpRequestStatus)sendHttpRequestForGetGoodsListWithPageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize  merchantNo:(NSString *)merchantNo structureNo:(NSString *)structureNo rangeFlag:(NSString *)rangeFlag success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

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
+ (BCSHttpRequestStatus)sendHttpRequestForConsigneeUpdateWithConsigneeDTO:(ConsigneeDTO *)consigneeDTO success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

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
 *  3.40 订单列表
 *
 *  @param orderStatus 订单状态
 *  @param pageNo      当前页码(默认1)
 *  @param pageSize    每页显示数量（默认20）
 *  @param success     请求成功，responseObject为请求到的数据
 *  @param failure     请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForOrderListWithOrderStatus:(NSString *)orderStatus pageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.41 订单详情
 *
 *  @param orderCode 订单号
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForOrderDetailWithOrderCode:(NSString *)orderId success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.42 加入购物车
 *
 *  @param CartAddDTO 见文档
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForCartAdd:(CartAddDTO *)cartAddDTO success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.43 购物车列表

 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForCartListSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.44 更新购物车商品
 
 *  @param CartUpdateDTO
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForCartUpdateSuccess:(CartUpdateDTO *)cartUpdateDTO success: (void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.45	选择结算商品/订单确认
 *
 *  @param cartKeyList 将getCart返回的数据, 按找用户选择的商品 , 原格式传到这个参数中
 *  @param success     请求成功，responseObject为请求到的数据
 *  @param failure     请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetCartConfirmWithCartKeyList:(NSArray *)cartKeyList success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *  3.46 生成订单
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
 *  3.55	删除购物车中的商品
 
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
 *  @param orderCode 订单编号
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForOrderReceived:(NSString *)orderCode success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.57	取消未付款订单
 
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
 *  @param wholesaleConditionArray  购物车统计列表
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
 *  @param type    小B：1、商品浏览2、购物车3、询单4、图片下载5、个人中心6、其他
 *  @param content 反馈内容
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForaddFeedback:(NSString *)type content:(NSString *)content success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.63	创建虚拟商品订单
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
 *  3.65	订单记录接口（按商家查询）
 *
 *  @param merchantNo    商家编码
 *  @param pageSize      每页显示数量(int 默认 15个)
 
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetOrderByMerchant:(NSString *)merchantNo  pageSize:(NSNumber *)pageSize success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.66	再次支付接口（订单列表页面支付）
 *
 *  @param orderCode     订单号

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
 *  @param orderCode 订单编码

 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+(BCSHttpRequestStatus)sendHttpRequestForSetOrderAutoConfirm:(NSString *)orderCode success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
