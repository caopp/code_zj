//
//  HttpManager.h
//  BuyerCenturySquare
//
//  Created by longminghong on 15/7/9.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "DelImgDownloadDTO.h"
#import "GoodsInfoDTO.h"
#import "UpdateMerchantInfoModel.h"
#import "EditGoodsModel.h"
#import "ImageDownloadCallbackModel.h"
#import "SaveGoodsRecommendModel.h"
#import "ChatHistoryModel.h"
#import "UpdateGoodsInfoModel.h"
#import "UpdateGoodsStatusModel.h"
#import "GetGoodsInfoListDTO.h"
#import "PayPayDTO.h"
#import "BaseViewController.h"
#import "EditorFreightListModel.h"

typedef NS_ENUM(NSInteger, BCSHttpRequestStatus) {
    BCSHttpRequestStatusStable = 0,
    BCSHttpRequestParameterIsLack,
    BCSHttpRequestStatusHaveNotLogin,
};

@interface HttpManager : NSObject

/**
 *  3.1 登陆接口
 *
 *  @param memberAccount 大B账户
 *  @param password      密码
 *  @param success       请求成功，responseObject为请求到的数据
 *  @param failure       请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForLoginWithMemberAccount:(NSString *)memberAccount password:(NSString *)password success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.2	设置登录密码
 *
 *  @param account       登录账户
 *  @param passwd        密码
 *  @param success       请求成功，responseObject为请求到的数据
 *  @param failure       请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForSetPassword:(NSString *)account passwd:(NSString *)passwd success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.3	忘记密码校验接口
 *
 *  @param mobilePhone 手机号(注册手机号)
 *  @param success     请求成功，responseObject为请求到的数据
 *  @param failure     请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForForgetPwdCheckWithMobilePhone:(NSString *)mobilePhone success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 * 	3.4	用户修改密码接口√
 *
 *  @param account  登录账户(手机号)
 *  @param passwd   密码
 *  @param oldpwd   原始密码
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForUpdatePassword:(NSString *)account passwd:(NSString *)passwd oldpwd:(NSString *)oldpwd success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.5	大B商家店铺个人中心接口
 *  @param success    请求成功，responseObject为请求到的数据
 *  @param failure    请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetMerchantMain:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.6	大B商家中心主页商品阅读状态修改接口
 *  @param success    请求成功，responseObject为请求到的数据
 *  @param failure    请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForUpdateGoodsReadStatus:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 * 	3.7	大B商家信息接口
 *  @param success    请求成功，responseObject为请求到的数据
 *  @param failure    请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetMerchantInfo:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 * 	3.8	更改营业状态（包括歇业时间）
 *  @param operateStatus 营业状态(0:营业 1:歇业)
 *  @param closeStartTime 歇业开始时间(0:营业 1:歇业)
 *  @param closeEndTime 歇业结束时间
 
 *  @param success    请求成功，responseObject为请求到的数据
 *  @param failure    请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetUpdateMerchantBusiness:(NSString *)operateStatus closeStartTime:(NSString *)closeStartTime closeEndTime:(NSString *)closeEndTime success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 * 	3.9	歇业记录查询接口
 *  @param success    请求成功，responseObject为请求到的数据
 *  @param failure    请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetMerchantCloseLog:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 * 	3.10   修改全店混批条件
 *  @param batchAmountFlag 起批金额限制(0:开启 1:关闭)
 *  @param batchNumFlag 起批数量限制(0:开启 1:关闭)
 *  @param batchAmountLimit 起批金额
 *  @param batchNumLimit 起批数量
 *  @param success    请求成功，responseObject为请求到的数据
 *  @param failure    请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetUpdateMerchantBatchlimit:(NSString *)batchAmountFlag batchNumFlag:(NSString *)batchNumFlag batchAmountLimit:(NSNumber* )batchAmountLimit batchNumLimit:(NSNumber* )batchNumLimit success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


#pragma mark 3.66	大B和小B聊天推荐商品列表接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetGoodsByChat:(NSString *)memberNo  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/**
 * 	3.11	修改商家资料
 *  @param UpdateMerchantInfoModel 见文档
 *  @param success    请求成功，responseObject为请求到的数据
 *  @param failure    请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetUpdateMerchantInfo:(UpdateMerchantInfoModel *)updateMerchantInfoModel success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.12	大B获取商品分类接口
 *  @param success    请求成功，responseObject为请求到的数据
 *  @param failure    请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetGoodsCategoryList:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *  3.13  商品列表（店铺展示）接口
 *  @param pageNo 当前页码(默认1,类型:int)
 *  @param pageSize 每页显示数量(默认20条,类型:int)
 *  @param structureNo 分类结构体编号
 *  @param goodsType 商品类型0普通商品、1邮费专拍
 
 *  @param queryTime  查看类型(1：10天前、2：7天前、3：5天前、4：3天前、5：实时）
 *  @param success    请求成功，responseObject为请求到的数据
 *  @param failure    请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetShopGoodsList:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize structureNo:(NSString *)structureNo queryTime:(NSString *)queryTime goodsType:(NSString *)goodsType success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.14  商品列表（可编辑）接口
 *  @param editGoodsModel:见接口文档
 *  @param success    请求成功，responseObject为请求到的数据
 *  @param failure    请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetEditGoodsList:(EditGoodsModel *)editGoodsModel success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.15 大B商品详情接口
 *  @param goodsNo:   商品编码
 *  @param success    请求成功，responseObject为请求到的数据
 *  @param failure    请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetGoodsInfoList:(NSString *)goodsNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


#pragma mark 3.1	商品手记详情预览
+ (BCSHttpRequestStatus)sendHttpRequestForGetCDetailsByGoodsNo:(NSString *)goodsNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/**
 *  3.15 大B商品详情接口 3.0.0
 *  @param goodsNo:   商品编码
 *  @param success    请求成功，responseObject为请求到的数据
 *  @param failure    请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
#pragma mark 3.15 大B商品详情接口 3.0.0 新接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetNewGoodsInfoList:(NSString *)goodsNo withIsNotes:(BOOL)isNotes success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/**
 *  3.16	大B商品修改接口
 *  @param GetGoodsInfoListDTO:   见文档
 *  @param success    请求成功，responseObject为请求到的数据
 *  @param failure    请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetUpdateGoodsInfo:(GetGoodsInfoListDTO *)getGoodsInfoListDTO success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.17	邮费专拍详情接口
 *
 *  @param merchantNo  商家编号
 *  @param success     请求成功，responseObject为请求到的数据
 *  @param failure     请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetGoodsFeeInfo:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.17   大B商品上下架操作接口
 *  @param updateGoodsInfoModel:   见文档
 *  @param success    请求成功，responseObject为请求到的数据
 *  @param failure    请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetUpdateGoodsStatus:(UpdateGoodsStatusModel *)updateGoodsStatusModel success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *  3.18	大B站内信列表
 *  @param goodsNo:   商品编码(类型:int)
 *  @param success    请求成功，responseObject为请求到的数据
 *  @param failure    请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetNoticeStationList:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.19	大B站内信阅读状态修改接口
 *  @param Id:        站内信Id
 *  @param success    请求成功，responseObject为请求到的数据
 *  @param failure    请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetUpdateNoticeStatus:(NSString *)Id success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 3.23	获取历史聊天列表信息（openfire）
+(BCSHttpRequestStatus)sendHttpRequestForGetChantListWithMemberNo:(NSString *)memberNo pageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize success:(void (^)(AFHTTPRequestOperation *, id))success  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma mark 3.23	获取历史聊天详细信息（openfire）
+(BCSHttpRequestStatus)sendHttpRequestForGetChantHistoryWithUser:(NSString *)user withTime:(NSString *)time pageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize success:(void (^)(AFHTTPRequestOperation *, id))success  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


#pragma mark =====  3.46	大B获取服务器时间接口
+(BCSHttpRequestStatus)sendHttpRequestForGetChantTimeSuccess:(void (^)(AFHTTPRequestOperation *, id))success  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma mark =====  3.49	大B获取客服账号接口
+(BCSHttpRequestStatus)sendHttpRequestForGetCustomerAccountWithMemberNo:(NSString *)memberNo success:(void (^)(AFHTTPRequestOperation *, id))success  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//3.77	大B站内信未读数量
+ (BCSHttpRequestStatus)sendHttpRequestForLetterSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/**
 *  3.20	大B图片七日内下载限制设置接口
 *  @param downloadLimit7:    是否开启限制(0关闭、1开启)
 *  @param success    请求成功，responseObject为请求到的数据
 *  @param failure    请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetImgDownloadSetting:(NSString *)downloadLimit7 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.20 小B获取下载图片列表接口
 *
 *  @param imageDownloadArray      图片下载参数数组
 *  @param success      请求成功，responseObject为请求到的数据
 *  @param failure      请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetDownloadImageList:(NSMutableArray *)imageDownloadArray success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.21	大B图片下载完成回调接口
 *  @param goodsNo:        商品编号
 *  @param downLoadType:   下载类型3所有，0窗口图，1客观图 2:参考图
 *  @param success    请求成功，responseObject为请求到的数据
 *  @param failure    请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetImageDownloadCallBackListWithGoodsNo:(NSString *)goodsNo picType:(NSInteger)picType success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.22	大B商品图片下载历史查询接口

 *  @param pageNo:     当前页码（默认第1页,类型:int）
 *  @param pageSize:   每页显示数量（默认20条,类型:int）
 
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetImageHistoryList:(NSNumber* )pageNo pageSize:(NSNumber *)pageSize success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *  3.23	商家等级权限说明接口
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetMerchantPermissionList:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.25	付费上架
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetPayMerchantOnsale:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.25	付费下载
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetPayMerchantDownload:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.26	无权限提示接口
 *  @param authType 1:采购商等级权限 2:黑名单权限5:采购商下载权限设置 3:下载权限
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetMerchantNotAuthTip:(NSString *)authType success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *  3.29	大B销售统计接口
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetPortalStatistics:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.30	大B按照销售时间统计接口
 
 *  @param pastDays  查询类型1查询最近7天 2查询最近30天 3查询半年 4按时间段查询
 *  @param startDate 开始时间
 *  @param endDate   结束时间
 *  @param success   请求成功，responseObject为请求到的数据
 *  @param failure   请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetOrderSalesPerDays:(NSNumber *)pastDays startDate:(NSString *)startDate endDate:(NSString* ) endDate success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.31	大B统计采购商接口
 *  @param pastDays 查询类型0查询所有 1查询最近7天 2查询最近30天 3查询半年
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetPurchaserStatisticsPerDays:(NSNumber *)pastDays success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.32	大B单品统计接口
 *  @param queryType  7最近7天、1最近一个月、3最近3个月
 *  @param orderBy   排序类型1按销量，2按销售额
 
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetProductStatisticPerSale:(NSNumber *)queryType orderBy:(NSString*)orderBy success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.31	推荐商品记录列表接口
 *  @param pageNo    当前页码(默认1)
 *  @param pageSize  每页显示数量(默认20条)
 
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetRecommendRecordList:(NSNumber *)pageNo pageSize:(NSNumber* ) pageSize success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *  3.32	推荐商品记录详情接口
 *  @param Id       推荐记录id(类型:int)
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetRecommendRecordDetailsList:(NSNumber *)Id success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.33	推荐商品记录删除接口
 *  @param ids      选中的推荐记录ID 必填(多个ID之间用逗号隔开)
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForDeleteRecommendRecord:(NSString *)ids success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.34	推荐商品收件人列表接口
 *  @param pageNo   当前页码(默认1)(类型:int)
 *  @param pageSize 每页显示数量(默认20条)(类型:int)

 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+(BCSHttpRequestStatus)sendHttpRequestForGetRecommendReceiverList:(NSNumber *)pageNo pageSize:(NSNumber* ) pageSize   dayNum:(NSString* )dayNum success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.36	推荐商品记录发送接口
 *  @param pageNo   当前页码(默认1)(类型:int)
 
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+(BCSHttpRequestStatus)sendHttpRequestForGetSaveGoodsRecommend:(SaveGoodsRecommendModel *)saveGoodsRecommendModel success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.37	采购商-有交易的会员的列表接口
 *  @param orderBy  排序字段(1交易金额,2交易时间)
 *  @param pageNo   当前页码(默认1)(类型:int)
 *  @param pageSize 每页显示数量(默认20条)(类型:int)
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+(BCSHttpRequestStatus)sendHttpRequestForGetMemberTradeList:(NSString *)orderBy pageNo:(NSNumber* ) pageNo  pageSize:(NSNumber* ) pageSize  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.38	采购商-我邀请的会员的列表接口
 *  @param orderBy  排序字段(1交易金额,2交易时间)
 *  @param pageNo   当前页码(默认1)(类型:int)
 *  @param pageSize 每页显示数量(默认20条)(类型:int)
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+(BCSHttpRequestStatus)sendHttpRequestForGetMemberInviteList:(NSString *)orderBy pageNo:(NSNumber* ) pageNo  pageSize:(NSNumber* ) pageSize  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.39	采购商-黑名单列表接口
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+(BCSHttpRequestStatus)sendHttpRequestForGetMemberBlackList:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *  3.40	采购商-黑名单设置接口
 *  @param memberNo       采购商小B编号
 *  @param blackListFlag  操作类型(0,添加黑名单1,移除黑名单)
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+(BCSHttpRequestStatus)sendHttpRequestForGetUpdateMemberBlackList:(NSString* ) memberNo  blackListFlag:(NSString* ) blackListFlag  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *  3.41	采购商-详情接口
 *  @param memberNo       采购商小B编号
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+(BCSHttpRequestStatus)sendHttpRequestForGetMemberInfo:(NSString* ) memberNo  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.42	采购商-资料接口（申请资料）
 *  @param memberNo       小B编号
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+(BCSHttpRequestStatus)sendHttpRequestForGetMemberApplyInfo:(NSString* ) memberNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.43	采购商-店铺等级设置接口
 *  @param memberNo       采购商小B编号
 *  @param level          调整的级别(类型:int)
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+(BCSHttpRequestStatus)sendHttpRequestForGetMemberLevelSet:(NSString *)memberNo level:(NSNumber *) level success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.44	采购商-邀请接口
 *  @param mobileList 被邀请的手机号码和等级
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+(BCSHttpRequestStatus)sendHttpRequestForMemberInvite:(NSString *) mobileList success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.45	采购单列表
 *  @param orderStatus    采购单状态
 *  @param pageNo         当前页码(默认1)(类型:int)
 *  @param pageSize       每页显示数量(默认20条)(类型:int)
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+(BCSHttpRequestStatus)sendHttpRequestForGetOrderList:(NSString *) orderStatus pageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize channelType:(NSNumber *)channelType success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/** 3.46	采购单详情
 *  @param orderCode 采购单号
 *  @param success   请求成功，responseObject为请求到的数据
 *  @param failure   请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+(BCSHttpRequestStatus)sendHttpRequestForGetOrderDetail:(NSString *)orderCode success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/** 3.47	修改采购单总金额
 *  @param orderCode  采购单编号
 *  @param newAmount  修改金额(类型:double)
 
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+(BCSHttpRequestStatus)sendHttpRequestForGetModifyOrderAmount:(NSString *)orderCode newAmount:(NSString *) newAmount success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/** 3.48	取消交易
 *  @param orderCode    采购单编号
 *  @param success      请求成功，responseObject为请求到的数据
 *  @param failure      请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+(BCSHttpRequestStatus)sendHttpRequestForGetCancelOrder:(NSString *)orderCode success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/** 3.49	消息推送（openfire）
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

/** 3.50   获取历史聊天信息（openfire）
 *  @param ChatHistory  见接口文档
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+(BCSHttpRequestStatus)sendHttpRequestForGetChatHistory:(ChatHistory *)chatHistory success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.51 图片上传接口
 *
 *  @param appType     接口类型：1大B 2小B
 *  @param type        上传类型：1小B省份证，2小B营业执照 3 大B参考图 4：个人资料头像 5：快递单拍照上传 6:聊天图片上传
 *  @param orderCode   采购单编码（采购单号，类型是5时必传，其他类型忽略）
 *  @param goodsNo     商品编码，类型是3时必传，其他类型忽略
 *  @param file        文件（二进制流）
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForImgaeUploadWithAppType:(NSString *)appType type:(NSString *)type orderCode:(NSString *)orderCode goodsNo:(NSString *)goodsNo file:(NSData *)file success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/**
 *  3.52  设置已发货状态接口
 *
 *  @param orderCode 采购单编号
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForSetOrderDelivery:(NSString *)orderCode success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.52	大B意见反馈
 *
 *  @param type    大B：7、询单8、我的店9、采购单管理10、采购商管理11、商品管理12、统计 13、其他
 *  @param content 反馈内容
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetMerchantAddFeedback:(NSString *)type content:(NSString *)content success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.53	创建虚拟商品采购单接口
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
+ (BCSHttpRequestStatus)sendHttpRequestForaddVirtualOrder:(NSNumber *)piece goodsNo:(NSString *)goodsNo skuNo:(NSString *)skuNo serviceType:(NSString *)serviceType success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.54	采购单记录接口（按会员查询）
 *
 *  @param memberNo      会员编码
 *  @param pageSize      每页显示数量(int 默认 15个)
 
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetOrderByMemberNo:(NSString *)memberNo pageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/**
 *  3.55	查询参考图上传记录接口
 *
 *  @param goodsNo 商品编码
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetImageReferImageHistoryListWithGoodsNo:(NSString *)goodsNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.56	支付接口
 *  @param PayPayDTO 支付信息
 *  @param success   请求成功，responseObject为请求到的数据
 *  @param failure   请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetPayPay:(PayPayDTO *)PayPayDTO success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.57	验证手机联系号码能否接受邀请接口
 *  @param mobileList 手机联系号码
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+(BCSHttpRequestStatus)sendHttpRequestForGetMemberInviteList:(NSString *) mobileList success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.57 发送短信接口
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
 *  3.58 短信校验接口
 *
 *  @param phone   手机号码
 *  @param type    类型说明:
                     1：小B注册
                     2：小B找回登录密码
                     3：大B找回登录密码
                     4：小B找回支付密码
                     5：小B重置支付密码
                     14：小B修改密码验证
                     15：大B修改密码验证
 
 *  @param smsCode 短信验证码
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForVerifySmsCodeWithPhone:(NSString *)phone type:(NSString *)type smsCode:(NSString *)smsCode success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


+ (void)downLoadImageWithURL:(NSString *)url success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;



/**
 *  3.59 根据父ID获取省市区列表接口
 *
 *  @param parentId 父级ID（0是查询省份）
 *  @param success  请求成功，responseObject为请求到的数据
 *  @param failure  请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetAreaListByParentIdWithParentId:(NSNumber *)parentId success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

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
 *  3.59	大B获取反馈类型集合
 *
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestFeedBackTypeSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.60	大B积分记录按月统计接口
 
 *  @param time    查询年月 例如 2014-09
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetMerchantIntegralByMonth:(NSString *)time pageNo:(NSNumber *)pageNo pageSize:(NSNumber *) pageSize success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.61	大B积分记录查询接口

 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetMerchantIntegralLogList:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.62	采购商邀请号码验证接口
 
 *  @param mobilePhone  邀请人联系号码
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForValidateMemberInvite:(NSString*)mobilePhone success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *  设置登陆密码
 *
 *  @param mobilePhone <#mobilePhone description#>
 *  @param passwd      <#passwd description#>
 *  @param type        <#type description#>
 *  @param success     <#success description#>
 *  @param failure     <#failure description#>
 *
 *  @return <#return value description#>
 */
+ (BCSHttpRequestStatus)sendHttpRequestForLoginPasswordWithMobilePhone:(NSString *)mobilePhone passwd:(NSString *)passwd type:(NSString *)type Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/**
 *  查询子帐号列表
 *
 *  @return  如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常

 */
+ (BCSHttpRequestStatus)sendHttpRequestForShowChildAccountPageNo:(int)pageNo pageSize:(int)size success:(void(^)(AFHTTPRequestOperation *operation,id responseObject))sucess failure:(void(^)(AFHTTPRequestOperation *opeation,NSError *error))failure;



/**
 *  添加一个子账号
 *
 *  @param phone   用户手机号
 *  @param name    用户昵称
 *  @param success 请求成功获取数据
 *  @param failure 请求失败
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */

+(BCSHttpRequestStatus)sendHttpRequestForAddChildAccountMerchantAccount:(NSString *)phone nickName:(NSString *)name  status:(NSString *)status success:(void(^)(AFHTTPRequestOperation *operation ,id reqeustObject))success failure:(void(^)(AFHTTPRequestOperation *opeation, NSError *error))failure;

/**
 *  修改子帐号信息
 *
 *  @param nickName 昵称
 *  @param status   状态
 *  @param flag     是否再次开启
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */

+(BCSHttpRequestStatus)sendHttpRequestForChangeChildAccountMerchantAccountNickName:(NSString *)nickName status:(NSString *)status firstOpenFlag:(NSString *)flag merchantAccount:(NSString *)merchantAccount success:(void(^)(AFHTTPRequestOperation *operation, id requestObject))success failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 * 删除子账号细心
 *
 *  @param phone   手机号
 *  @param success 成功
 *  @param failure 失败
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */

+(BCSHttpRequestStatus)sendHttpRequestForChangeChildDel:(NSString *)phone success:(void(^)(AFHTTPRequestOperation *operation, id requestObject))success failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;


//大b交易记录接口
+(BCSHttpRequestStatus)sendHttpRequestForBuyRecordPageNo:(NSNumber *)PageNo pageSize:(NSNumber *)pageSize success:(void(^)(AFHTTPRequestOperation *operation, id requestObject))success failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *  3.75 修改商家头像接口
 
 *  @param iconUrl 商家头像地址
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForUpdateIconUrl:(NSString*)iconUrl success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/**
 *  3.68
 *
 *  @param content 内容
 *  @param type    帖子类型0:资讯1:款式测评
 *  @param url     图片路径多个逗号,分隔
 *  @param success
 *  @param failure
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */

+(BCSHttpRequestStatus)sendHttpRequestForeleasedMeasurementContent:(NSString *)content topicType:(NSString *)type imgUrls:(NSString *)url success:(void(^)(AFHTTPRequestOperation *operation ,id reqeustObject))success failure:(void(^)(AFHTTPRequestOperation *opeation, NSError *error))failure;

/**
 商家入驻
 */

+(BCSHttpRequestStatus)sendHttpRequestForMerchantApplyAdd:(NSMutableDictionary *)upDic success:(void(^)(AFHTTPRequestOperation *operation ,id reqeustObject))success failure:(void(^)(AFHTTPRequestOperation *opeation, NSError *error))failure;
#pragma  mark  3.89 商家入驻按钮显示接口
+ (BCSHttpRequestStatus)sendHttpRequestForSwitchsuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;






#pragma mark - 3.0.0最新****************

/**
 *  3.1	查询品牌列表接口
 *
 *  @param goodsNo 当前页码
 *  @param name    品牌名称查询条件
 *  @param no      当前页码
 *  @param size    每页显示数量
 *  @param success
 *  @param failure
 *
 *  @return 
 */
+(BCSHttpRequestStatus)sendHttpRequestForGoodsgetBrandList:(NSString *)goodsNo queryName:(NSString *)name pageNo:(NSNumber *)no pageSize:(NSNumber *)size  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.2	修改商品标签接口
 *
 *  @param nameStr 临时标签名称 多个名称,分隔
 *  @param Idstr   系统标签id 多个id,分隔
 *  @param success
 *  @param failure
 *
 *  @return 
 */

/**
 *  3.20 商家发货接口
 *
 *  @param orders  采购单号，多个采购单号“,”逗号分隔
 *  @param type    发货类型：1拍照发货，2快递单号发货
 *  @param url     快递单Url
 *  @param trackNo 快递单号
 *  @param code    快递公司代码
 *  @param name    快弟公司名称
 *  @param success
 *  @param failure
 *
 *  @return
 */
+ (BCSHttpRequestStatus)sendHttpRequestForOrderDeliverOrderCodes:(NSString *)orders type:(NSString *)type picUrl:(NSString *)url logisticTrackNo:(NSString *)trackNo logisticCode:(NSString *)code logisticName:(NSString *)name success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


+(BCSHttpRequestStatus)sendHttpRequestForGoodsUpdateGoodsLabelNameStr:(NSString *)nameStr labelIdStr:(NSString *)Idstr goodsNo:(NSString *)goodsNo  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/**
 *  3.2.1 合并发货采购单列表
 *
 *  @param merchantNo 商家编号
 *  @param pageNo     当前页码(默认1)
 *  @param pageSize   每页显示数量(默认20条)
 *  @param success
 *  @param failure
 *
 *  @return
 */
+(BCSHttpRequestStatus)sendHttpRequestForOrderDeliverListMerchantNo:(NSString *)merchantNo pageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;



#pragma mark - 3.26  大b 查看退换货详情

+(BCSHttpRequestStatus)sendHttpRequestForRefundDetailOrderCode:(NSString *)orderCode   Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - 3.27	大B处理退换货接口

+(BCSHttpRequestStatus)sendHttpRequestForRefundDealOrderCode:(NSString *)orderCode   refundNo:(NSString *)refundNo dealBy:(NSString*)dealBy dealReamark:(NSString *)dealReamark Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.3	获取所有商品标签接口
 *
 *  @param goodsNo 商品Id
 *  @param success
 *  @param failure
 *
 *  @return
 */
+(BCSHttpRequestStatus)sendHttpRequestForGoodsGetAllLabelLis:(NSString *)goodsNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.4 获取单个商品标签接口
 *
 *  @param goodsNo 商品Id
 *  @param success
 *  @param failure
 *
 *  @return 
 */
+(BCSHttpRequestStatus)sendHttpRequestForgoodsGetLabelListByGoodsNo:(NSString *)goodsNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.18	修改商品规格参数接口
 *
 *  @param goodsNo 商品编码
 *  @param attDict 商品属性数组
 *  @param success
 *  @param failure
 *
 *  @return
 */
+(BCSHttpRequestStatus)sendHttpRequestForGoodsAttrUpdateGoodsNo:(NSString *)goodsNo attrList:(NSArray *)list success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
    
/**
 *3.11	大B商品修改接口
 */
+(BCSHttpRequestStatus)sendHttpRequestGoodsInfoUpdateWithUpDic:(NSMutableDictionary *)upDic success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


#pragma mark 3.78	全部商品下载图片列表接口
+ (BCSHttpRequestStatus)sendHttpRequestForDownloadAllListWithPageNo:(int)pageNo  withPageSize:(int)pageSize    Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 3.19	查询快递公司列表接口
+ (BCSHttpRequestStatus)sendHttpRequestForExpressListSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 3.23	查询系统属性列表接口 判断是否请求新的快递公司数据
+ (BCSHttpRequestStatus)sendHttpRequestForJudgeWheterGetNewExpressListSuccesPropName:(NSString *)propName   Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 3.99	App上报错误日志接口
+ (BCSHttpRequestStatus)sendHttpRequestForApperrorAddWithList:(NSMutableArray *)errorList     Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 3.34	商品主页接口
+ (BCSHttpRequestStatus)sendHttpRequestForGoodsMainSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


#pragma mark 3.43	商品销售渠道批量更新接口
+ (BCSHttpRequestStatus)sendHttpRequestForSaleChannelUpdate:(NSString *)goodsNoArray channelListStr:(NSString *)channelList  Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark -3.45	大B推送数量清零接口
+ (BCSHttpRequestStatus)sendHttpRequestForclearBadgeCountSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma mark -----与h5进行交互-----


//采购商
+(void)memberOfTradeNetworkRequestWebView:(UIWebView *)webView;
//商家特权
+(void)privilegesNetworkRequestWebView:(UIWebView *)webView;
//采购商等级
+(void)purchaserLevelNetworkRequestWebView:(UIWebView *)webView;
//统计
+(void)statisticalNetworkRequestWebView:(UIWebView *)webView;
//统计需要传参数
+(void)statisticalNetworkRequestWebView:(UIWebView *)webView requestUrl:(NSString *)request;
//消费积分查询记录
+(void)scoreQueryNetworkRequestWebView:(UIWebView *)webView;
//采购商资料申请
+(void)buyersInformationDetailsNetworkRequestWebView:(UIWebView *)webView;
//!服务规则与协议
+(void)serviceRequestWebView:(UIWebView *)webView;

//更行导航栏进行h5申请

#pragma mark h5
//采购商
+(NSString *)memberOfTradeNetworkRequestWebView;
//商家特权
+(NSString *)privilegesNetworkRequestWebView;
//采购商等级
+(NSString *)purchaserLevelNetworkRequestWebView;
//统计
+(NSString *)statisticalNetworkRequestWebView;
//消费积分查询记录
+(NSString *)scoreQueryNetworkRequestWebView;
//采购商资料申请
+(NSString *)buyersInformationDetailsNetworkRequestWebView;
//!服务规则与协议
+(NSString *)serviceRequestWebView;
//!所有的h5域名和端口号
+(NSString *)allH5ServiceRequestWebView;
//!从app进入的采购商详情
+(NSString *)fromMessageToPurchaseMemberNo:(NSString *)memberNo;





//!从app进入的采购商详情
+(void)fromMessageToPurchase:(UIWebView *)webView withMemberNo:(NSString *)memberNo;

//大B首页
+(void)businessCircleHomeRequestWebView:(UIWebView *)webView;

//跳转的时候需要不停的跳转控制器
+(void)businessCircleHomeRequestWebView:(UIWebView *)webView withRequesUrl:(NSString *)requestUrl;


//发布后状态详情页
+ (void)AuditStatusRequestWebView:(UIWebView *)webView requestUrl:(NSString *)request;

//大B资讯详情页面
+ (void)AuditStatusRequestWebView:(UIWebView *)webView auditStatusID:(NSString *)auditStatusID;

//大B测评详情页面
+(void)assessmentRequestWebView:(UIWebView *)webView assessmentID:(NSString *)assessmentID;

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
 *  获取当前时间戳
 *
 *  @return 返回当前时间戳
 */
+ (NSString *)getTimesTamp;
//转化参数
+(NSMutableDictionary *)getParameterWithTimestamp:(NSString *)timestamp;





/**
 *  3.6 获取单个店铺标签接口
 *  @param iconUrl 店铺标签
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForUpdateStoreTagSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *  3.6 获取所有店铺标签接口
 *  @param iconUrl 店铺标签
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForUpdateAllStoreTagSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;




/**
 *  3.6 修改店铺标签接口
 *  @param iconUrl 店铺标签
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForUpdateModifyStoreTagLabelNameStr:(NSString *)labelNameStr   labelIdStr:(NSString *)labelIdStr     Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;



/**
 *  3.13	删除运费模版接口
 *  @param iconUrl 删除运费模版接口
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */

+ (BCSHttpRequestStatus)sendHttpRequestForFreightTemplateID:(NSNumber *)freightTemplateID success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *  3.15	查询运费模版列表接口
 *  @param iconUrl 运费模版列表
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForUpdateGetFreightTemplateListPageNo:(NSNumber *)pageNo   pageSize:(NSNumber *)pageSize     Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;



/**
 *  3.14 设置默认运费模版接口
 *  @param iconUrl 设置默认运费模版接口
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */

+ (BCSHttpRequestStatus)sendHttpRequestForDefultID:(NSNumber *)freightTemplateID success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;




/**
 *  3.16 查询运费模版详情接口
 *  @param iconUrl 查询运费模版详情接口
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */


+ (BCSHttpRequestStatus)sendHttpRequestForGetFreightTemplateInfo:(NSNumber *)freightTemplateID success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;




/**
 *  3.12	新增运费模版接口
 *  @param iconUrl 新增运费模版接口
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetFreightTemplateName:(NSString *)templateName type:(NSString *)type  setList:(NSMutableArray *)setList  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;




/**
 *  3.13	修改运费模版接口
 *  @param iconUrl 修改运费模版接口
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetFreightTemplateName:(NSString *)templateName type:(NSString *)type   templateNameID:(NSNumber *)templateNameID  setList:(NSMutableArray *)setList  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;



//3.22	大B商品运费模板修改接口
+ (BCSHttpRequestStatus)sendHttpRequestForFtGoodsNo:(NSString  *)goodsNo  ftTemplateId:(NSNumber *)ftTemplateId  isDefault:(NSString *)isDefault   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;



#pragma mark  ==快递网===
+ (BCSHttpRequestStatus)sendHttpRequestForExpressCode:(NSString *)shipperCode    logisticCode:(NSString *)logisticCode  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


+(NSString *)hostUrl;


#pragma 获取省市区列表接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetAreaListSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  3.30	查询运费模版列表接口
 *  @param iconUrl 运费模版列表
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForUpdateGetFreightTemplateListSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *  3.31 设置默认运费模版接口(V3.0.5)
 *  @param iconUrl 运费模版列表
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForUpdateGetFreightTemplateID:(NSNumber *)freightTemplateID  freightTemplateType:(NSNumber *)freightTemplateType  Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;



/**
 *  3.32	设置批发运费模版接口
 *  @param iconUrl 设置批发运费模版接口
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetFreightTemplateArrList:(NSMutableArray *)freightTemplateArrList Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *  3.33	设置零售运费模版接口
 *  @param iconUrl 新增运费模版接口
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetTemplateArrList:(NSMutableArray *)freightTemplateArrList Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/*
 入参说明：
 tokenId 用户登录标识	String	必填
 userId	会员id	int	N
 goodsNo	商品编码	String	N
 queryType	查询类型(1:未审核,2:通过,3:不通过,不填为查全部)	int	N
 pageNo	当前页码(默认1)	int	选填
 pageSize	每页显示数量(默认20条)	int	选填
 */
#pragma mark 3.35	商品提成审核列表（零售） db/goods/share/audit/list
+ (BCSHttpRequestStatus)sendHttpRequestForAuditListWtihtGoodNo:(NSString *)goodsNo withUserId:(NSNumber *)userId withQueryType:(NSNumber *)queryType pageNo:(NSNumber *)no pageSize:(NSNumber *)sizeNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/*
 tokenId 用户登录标识	String	必填
 queryParam	查询参数(用户昵称/账号)	String	选填
 pageNo	当前页码(默认1)	int	选填
 pageSize	每页显示数量(默认20条)	int	选填
 */
#pragma mark 3.36	会员列表【分享的商品次数】（零售）
+ (BCSHttpRequestStatus)sendHttpRequestForMemberListWtihtQueryParam:(NSString *)queryParam  pageNo:(NSNumber *)no pageSize:(NSNumber *)sizeNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/*
 tokenId 用户登录标识	String	必填
 queryParam	查询参数(货号/商品名称)	String	选填
 pageNo	当前页码(默认1)	int	选填
 pageSize	每页显示数量(默认20条)	int	选填
 */
#pragma mark 3.37	商品列表【分享次数】接口（零售）
+ (BCSHttpRequestStatus)sendHttpRequestForGoodsListWtihtQueryParam:(NSString *)queryParam  pageNo:(NSNumber *)no pageSize:(NSNumber *)sizeNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/*
 入参说明：
 tokenId 用户登录标识	String	必填
 lid	标签id	int	
 */
#pragma mark 3.38	#pragma mark 3.38 商品详情接口（零售）接口名称：db/goods/share/detail

+ (BCSHttpRequestStatus)sendHttpRequestForAuditDetailWtihLabelId:(NSNumber *)lId success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/*
 入参说明：
 tokenId 用户登录标识	String	必填
 lid	标签id	int
 auditType	1审核通过;2审核提成通过,图片审核不通过;3审核不通过	int	必填
 */
#pragma mark 3.39	零售商品分享及提成审核接口
+ (BCSHttpRequestStatus)sendHttpRequestForAuditWtihLabelId:(NSNumber *)lId withAuditType:(NSInteger)auditType success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/**
 *  3.40	商品默认参考图筛选列表接口
 *  @param iconUrl 新增运费模版接口
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */

+ (BCSHttpRequestStatus)sendHttpRequestForScreeningDefaultImagesQueryType:(NSNumber *)queryType  queryParam:(NSString *)queryParam pageNo:(NSNumber *)pageNo  pageSize:(NSNumber *)pageSize  Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;






/**
 *  3.41	商品默认分享图片列表
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */



+ (BCSHttpRequestStatus)sendHttpRequestFordefaultShareImagesImageType:(NSNumber *)imageType  goodsNo:(NSString *)goodsNo isDefault:(NSNumber *)isDefault   pageNo:(NSNumber *)pageNo  pageSize:(NSNumber *)pageSize  Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


//3.42	商品默认图设置接口

+ (BCSHttpRequestStatus)sendHttpRequestFordefaultShareImagespicId:(NSNumber *)picId  isDefault:(NSNumber *)isDefault Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end



























