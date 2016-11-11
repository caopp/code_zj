//
//  HttpManager.m
//  BuyerCenturySquare
//
//  Created by longminghong on 15/7/9.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "HttpManager.h"
#import "LoginDTO.h"
#import "NSObject+PublicInterface.h"
#import "HttpMacro.h"
#import "AppInfoDTO.h"
#import "NSString+Hashing.h"
#import "SaveUserIofo.h"
#import "AdressListModel.h"


//static const NSString *host = @"http://portal.zjsj1492.com/api";
//static const NSString *hostH5 = @"http://portal.zjsj1492.com/h5/ddop/buyer/";
//static const NSString *hostNew = @"http://portal.zjsj1492.com/";

// !测试 --还需要修改聊天的ip!!!!
static const NSString *host = @"http://116.31.82.98:8189/api";
static const NSString *hostH5 = @"http://116.31.82.98:8189/h5/ddop/buyer/";
static const NSString *hostNew = @"http://116.31.82.98:8189/";

//开发
//static const NSString *host = @"http://116.31.82.98:8289/api";
//static const NSString *hostH5 = @"http://116.31.82.98:8289/h5/ddop/buyer/";
//static const NSString *hostNew = @"http://116.31.82.98:8289/";


static const NSString *appSecret = @"1dfa5cd879df472484138b41dbb6197e";

static const NSTimeInterval httpRequestTimeoutInterval = 60.0f;


#pragma mark-接口
//3.1 登陆接口
static const NSString *login = @"/xb/user/login";

//3.2 注册接口-验证手机号并且发送验证码
static const NSString *registerMobile = @"/xb/user/registerMobile";

//3.3 设置密码-注册、忘记密码
static const NSString *setPassword = @"/xb/user/setPassword";
//3.13	小B新增注册接口
static const NSString *setRegister = @"/xb/user/registMember";

//3.4 根据父ID获取省市区列表接口
static const NSString *getAreaListByParentId = @"/xb/user/getAreaListByParentId";

//3.5 小B补充申请资料
static const NSString *addApplyInfo = @"/xb/user/addApplyInfo";
//3.15	小B首次提交申请资料接口
static const NSString *addApplyInfoFirst = @"/xb/user/applyFirst";
//3.16	小B再次提交申请资料接口 接口名称：xb/user/applyAgain
static const NSString *addApplyInfoAgain = @"/xb/user/applyAgain";
//3.94	小B验证地推码
static const NSString *addApplyInfoCode = @"/xb/user/verifyPushedCode";
//3.6 小B查询申请资料
static const NSString *getApplyInfo = @"/xb/user/getApplyExtInfo";

//3.14	小B申请资料校验接口
static const NSString *valApplyInfo = @"/xb/user/valApplyInfo";

//3.7 小B验证邀请码
static const NSString *verifyRegisterKeyCode = @"/xb/user/verifyRegisterKeyCode";

//3.8 忘记密码校验接口-用于找回密码时校验手机号（手机号需要已经注册过）
static const NSString *forgetPwdCheck = @"/xb/user/forgetPwdCheck";

//3.9 用户修改密码接口
static const NSString *setUpdate = @"/xb/user/password/update";

//3.10 用户修改支付密码接口
static const NSString *payPasswdUpdate = @"/xb/pay/passwd/update";

//3.11 发送短信接口
static const NSString *sendSms = @"/sms/sendSms";

//3.12 短信校验接口-校验短信验证码
static const NSString *verifySmsCode = @"/sms/verifySmsCode";

//3.13 个人中心主页接口
static const NSString *personalCenter = @"/xb/user/main";

//3.14 商品分类接口
static const NSString *getCategoryList = @"/xb/category/getCategoryList";

//3.15 小B商品列表接口
static const NSString *getGoodsList = @"/xb/goods/getGoodsList";

//3.16 商品（下载）无权限提示接口
static const NSString *getGoodsNotLevelTip = @"/xb/goods/getGoodsNotLevelTip";

//3.17	小B获取商家邮费专拍商品接口
static const NSString *getGoodsFeeInfo = @"/xb/goods/getGoodsFeeInfo";


//3.17 小B商品详情接口
static const NSString *getGoodsInfoDetails = @"/xb/goods/getGoodsInfoDetails";

//3.17  3.0小B商品详情接口
static const NSString *getNewGoodsInfoDetails = @"/xb/goods/details";

//3.18 小B查看商家店铺列表接口
static const NSString *getMerchantList = @"/xb/merchant/getMerchantList";

//3.19 小B查看商家店铺详情接口
static const NSString *getMerchantShopDetail = @"/xb/merchant/getMerchantShopDetail";

//3.20 小B商品收藏新增接口
static const NSString *addGoodsFavorite = @"/xb/favorite/addGoodsFavorite";

//3.21 小B商品收藏取消接口
static const NSString *delFavorite = @"/xb/favorite/delFavorite";

//3.23	小B商品收藏列表接口(按时间排序)
static const NSString *getFavoriteListByTime = @"/xb/favorite/getFavoriteListByTime";

//3.24	小B商品收藏列表接口(按商家排序)
static const NSString *getFavoriteListByMerchant = @"/xb/favorite/getFavoriteListByMerchant";

//3.23 小B站内信列表接口
static const NSString *getMemberNoticeList = @"/xb/notice/getMemberNoticeList";

//3.24 小B站内信阅读状态修改接口
static const NSString *updateNoticeStatus = @"/xb/notice/updateNoticeStatus";
//3.24 小B站内信消息
static const NSString *getStationTopByXb = @"/xb/notice/getStationTopByXb";

//3.25 小B获取下载图片列表接口
static const NSString *getDownloadImageList = @"/xb/image/download/list";

//3.26 小B图片下载完成回调接口
static const NSString *imageDownloadCallback = @"/xb/image/download/callback";

//3.27 小B图片下载历史查询接口
static const NSString *getHistoryDownloadList = @"/xb/image/history/list";

//3.28 小B商品补货列表接口
static const NSString *getGoodsReplenishmentByTime = @"/xb/goods/replenishmentByTime";

//3.29 小B订购过的商家列表接口
static const NSString *getBoughtList = @"/xb/merchant/getBoughtList";

//3.30 小B查看个人资料接口
static const NSString *getMemberInfo = @"/xb/user/getMemberInfo";

//3.31 小B修改个人资料接口
static const NSString *updateMemberData = @"/xb/user/updateMemberData";

//3.32 小B保存收货地址
static const NSString *consigneeAdd = @"/xb/consignee/add";

//3.33 小B收货地址列表接口
static const NSString *consigneeGetList = @"/xb/consignee/getList";

//3.34 小B修改收货地址
static const NSString *consigneeUpdate = @"/xb/consignee/update";

//3.35 小B删除收货地址
static const NSString *consigneeDel = @"/xb/consignee/del";

//3.36	小B消费积分记录按月统计接口
static const NSString *getIntegralByMonth = @"/xb/statistics/getIntegralByMonth";

//3.37	小B消费积分记录查询接口
static const NSString *getIntegralList = @"/xb/statistics/getIntegralList";

//3.38	图片上传接口
static const NSString *imageUpload = @"/image/upload";

//3.39	付费下载
static const NSString *payDownload = @"/xb/user/pay/download";

//3.40	采购单列表
static const NSString *orderList = @"/xb/order/list";



//3.41	采购单详情
static const NSString *orderDetail = @"/xb/order/detail";

//3.42	加入采购车
static const NSString *cartAdd = @"/xb/cart/add";
//3.5	批量加入采购车
static const NSString *cartbatchAdd = @"/xb/cart/batchAdd";

//3.43	采购车列表
static const NSString *cartList = @"/xb/cart/list";

//3.44	更新采购车商品
static const NSString *cartUpdate = @"/xb/cart/update";

//3.45	采购单确认
static const NSString *cartConfirmGet = @"/xb/cart/confirm/get";

//3.46	生成采购单
static const NSString *orderAdd = @"/xb/order/add";

//3.47	获取支付方式
static const NSString *payGetMethod = @"/xb/pay/getMethod";

//3.48	支付密码验证
static const NSString *payPasswdVerify = @"/xb/pay/passwd/verify";

//3.49	创建支付密码
static const NSString *payPasswdAdd = @"/xb/pay/passwd/add";

//3.50	余额查询
static const NSString *payBalance = @"/xb/pay/balance";

//3.51	支付接口
static const NSString *getPayPay = @"/xb/pay/pay";

//3.52	创建支付交易单
static const NSString *paytradeAdd = @"/xb/pay/trade/add";

//3.53	采购商等级权限说明接口
static const NSString *memberPermissionList = @"/xb/member/permission/list";

//3.54	查询是否有支付密码
static const NSString *hasPaymentPassword = @"/xb/pay/hasPaymentPassword";

//3.55	删除采购车中的商品
static const NSString *cartDelete = @"/xb/cart/delete";

//3.56	设置已签收接口
static const NSString *orderReceived = @"/xb/order/received";

//3.57	取消未付款采购单
static const NSString *cancelUnpaid = @"/xb/order/cancelUnpaid";

//3.58	小B商品补货列表接口( 按商家时间倒序取)
static const NSString *getGoodsReplenishmentByMerchant = @"/xb/goods/replenishmentByMerchant";

//3.59	全店批发条件校验接口
static const NSString *wholesaleCondition = @"/xb/cart/wholesaleCondition";

//3.61	获取最新版本
static const NSString *getAppVersion = @"/version/getAppVersion";

//3.62	小B意见反馈
static const NSString *addFeedback = @"/xb/user/addFeedback";

//3.63	创建虚拟商品采购单
static const NSString *addVirtualOrder = @"/xb/order/addVirtualOrder";

//3.63	获取商品分享链接
static const NSString *getGoodsShareLink = @"/xb/goods/sharelink";

//3.64	预付货款收支记录接口
static const NSString *getPaymentsRecords = @"/xb/pay/paymentsRecords";

//3.65	采购单记录接口（按商家查询）
static const NSString *getOrderByMerchant = @"/xb/order/byMerchant";

//3.66	采购单记录接口（按商家查询）
static const NSString *confirmPay = @"/xb/pay/confirmPay";

//3.67	询单获取商家聊天帐号接口
static const NSString *getMerchantRelAccount = @"/xb/merchant/getMerchantRelAccount";

//3.69	询单获取客服聊天帐号接口
static const NSString *getCustomerAccount = @"/xb/merchant/getCustomerAccount";

//3.68	获取支付状态接口
static const NSString *getPaymentStatus = @"/xb/pay/paymentStatus";

//3.69	消息推送（IOS）
static const NSString *chatPusher = @"/chat/pusher";

static const NSString *feedbackType = @"/feedback/getFeedBackTypeList";

//3.70	小B设置延迟收货操作
static const NSString* setOrderAutoConfirm = @"/xb/user/setOrderAutoConfirm";
//3.71  预付货款充值记录
static const NSString *paymentRecord = @"/xb/pay/depositRecords";
//3.72 下载次数购买记录
static const NSString *buyRecord = @"/xb/pay/paidPicDownloads/list";

//3.81	小B预付货款获取升级列表接口
static const NSString * paymentUpgradeList = @"/xb/prepay/getUpgradeList";

//3.82 	小B预付货款金额校验接口
static const NSString *paymentCheckMoney = @"/xb/prepay/prepayVal";

//3.83	小B预付货款充值接口
static const NSString *paymentcharge =@"/xb/prepay/addPrepay";

//3.85 第三方平台
static const NSString *thirdParties = @"/sys/getDataDictList";

//3.86 获取预付货款银行列表接口
static const NSString *bankCardMessage = @"/xb/prepay/getPrepayBankList";
//!3.87	小B预付货款充值记录接口(银行转帐)
static const NSString *creditTransfer = @"/xb/pay/creditTransfer";

//!3.88 小B预付货款充值记录明细接口(银行转帐)
static const NSString *creditTransferDetail = @"/xb/pay/creditTransfer/detail";

//!3.89 小B预付货款充值记录明细接口(银行转帐)
static const NSString *deleteCreditTransfer = @"/xb/pay/creditTransfer/delete";


//3.90 小B注册开关接口
static const NSString *switchUrl = @"/sys/getLoginFlag";


static const NSString *addPrepay = @"/xb/prepay/addPrepay";

//!3.95	小B商家收藏新增接口
static const NSString *addMerchantFavorite = @"/xb/favorite/addMerchantFavorite";

//!3.96	小B商家收藏取消接口
static const NSString *delMerchantFavorite = @"/xb/favorite/delMerchantFavorite";

//!!!!!!!!!!!!-----------3.0.0接口

//!3.4	查询热门店铺标签接口
static const NSString * getHotLabelList = @"/xb/merchant/label/getHotLabelList";

//!3.2	小B频道接口
static const NSString * channelListUrl = @"/xb/channel/list";

//!3.3	小B频道商品列表接口
static const NSString * channelGoodsListUrl = @"/xb/channel/goods/list";

//!3.7 再次支付合并付款
 static const NSString *paymulitiConfirmPay = @"/xb/pay/mulitiConfirmPay";

//!3.8	小B搜索商家列表接口
static const NSString * seachMerchantListUrl = @"/xb/merchant/seachMerchantList";

//!3.9	小B查询商家10条商品数据接口
static const NSString *  queryGoodsTenNumUrl = @"/xb/goods/queryGoods10Num";

//!3.10	小B搜索商品列表接口
static const NSString *  seachGoodsListUrl = @"/xb/goods/seachGoodsList";

//3.27	小B推送数量清零接口
static const NSString *clearBadgeCount = @"/xb/notice/clearBadgeCount";
#pragma mark --------- 与h5交互
//订购过的商家
static const NSString * orderMerchantUrl = @"merchantOfBought.html";
//会员等级
static const NSString *membershipUpgradeUrl = @"privileges.html";
//收藏商品
static const NSString *collectionGoodsUrl = @"goodsOfCollected.html";
//申请资料
static const NSString *applicationMaterialsUrl = @"applicationInfo.html";
//会员等级规则
static const NSString *membershipGradeRulesUrl  = @"levelRules.html";
//消费积分记录
static const NSString *scoreRecordUrl = @"jifen.html";
//消费积分后面添加参数
static const NSString *fromParameter= @"?from=app";
//交易流水
static const NSString *advancePaymentUrl = @"advancePayment.html";
//预付货款交易记录
static const NSString *paymentrecordUrl = @"rechargeRecord.html";
//!服务与协议
static const NSString *serviceUrl = @"serviceRule.html";
//大B资讯详情页面
static const NSString *zxDetail = @"zone/zxDetail.html?id=";
//小b商圈
static const NSString *businessUrl = @"zone/default.html";


//!3.99	App上报错误日志接口
static const NSString * appErrorAddUrl = @"/sys/apperror/add";

//3.25	物流轨迹信息查询接口
static const NSString *logistic  = @"/xb/logistic/traces/get";
//3.12	查询省市区列表接口
static const NSString *allCityList = @"/sys/getAreaAllList";
//3.23	查询系统属性列表接口
static const NSString * propertyListUrl = @"/sys/property/list";

//＊＊＊＊＊＊＊退换货
//3.18  小B申请退换货接口
static const NSString *orderRefundApply = @"/xb/order/refund/apply";
//3.19	小B修改退换货接口
static const NSString *orderRefundUpdate = @"/xb/order/refund/update";
//3.20  小B取消退换货接口
static const NSString *orderRefundCancel = @"/xb/order/refund/cancel";
//3.21 查看退换货详情
static const NSString *orderRefundDetail = @"/xb/order/refund/detail";
//3.23	获取历史聊天列表信息（openfire）
static const NSString *chatList = @"/chat/history/list";
//3.24 3.24	获取历史聊天信息（openfire）
static const NSString *chatHistorys =@"/chat/historys";
//3.1	小B获取客服等待数量接口
static const NSString *countChat = @"/chat/count";
//3.26	小B获取广告路径接口
static const NSString * advertUrl = @"/sys/advert/url";

@implementation HttpManager

/**
 *  获取当前时间戳
 *
 *  @return 返回当前时间戳
 */
+ (NSString *)getTimesTamp{
    
    NSDate *nowDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    
    return [dateFormatter stringFromDate:nowDate];
    
    
}

/**
 *  http请求
 *
 *  @param requestURL 请求的URL
 *  @param parameter  请求参数
 *  @param success    请求成功，responseObject为请求到的数据
 *  @param failure    请求失败，错误为error
 */
+ (void)requestWithRequestURL:(NSString *)requestURL parameter:(NSString *)parameter success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:requestURL]
                                                               cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                           timeoutInterval:httpRequestTimeoutInterval];
    
    
    [request setValue:@"application/json;charse=UTF-8" forHTTPHeaderField:@"content-type"];//请求头
    
    [request setHTTPMethod:@"POST"];
    
    NSData *jsonData = [parameter dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:jsonData];
    
    AFHTTPRequestOperation *httpRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    httpRequestOperation.securityPolicy.allowInvalidCertificates = YES;
    
    [httpRequestOperation setCompletionBlockWithSuccess:success failure:failure];
    
    [httpRequestOperation start];
    
    
}

//二级数组排序
+(NSString *)Sort:(NSMutableArray *)currentArray
{
    long count = [currentArray count];
    NSString *signStr = nil;
    NSArray *compositorArray = [[NSArray alloc] init];
    NSDictionary* currentDic = [[NSDictionary alloc] init];
    
    for (int index = 0; index < count; index ++) {
        currentDic = [currentArray objectAtIndex:index];
        if (currentDic) {
            compositorArray = [currentDic.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                
                int i = 1;
                
                while (1) {
                    
                    if ([[obj1 substringToIndex:i] compare:[obj2 substringToIndex:i]options:NSLiteralSearch]>0) {
                        
                        return YES;
                        
                    }else if ([[obj1 substringToIndex:i] compare:[obj2 substringToIndex:i]options:NSLiteralSearch]==0){
                        
                        i++;
                        
                    }else{
                        
                        return NO;
                    }
                    
                }
                
                
            }];
        }
        
        for (int index = 0 ; index < [compositorArray count]; index ++) {
            if ( signStr == nil) {
                
                signStr = [NSString stringWithFormat:@"%@=%@",[compositorArray objectAtIndex:index],[currentDic objectForKey:[compositorArray objectAtIndex:index]]];
            }else{
                
                id currentValue = [currentDic objectForKey:[compositorArray objectAtIndex:index]];
                if (currentValue && [currentValue isKindOfClass:[NSMutableArray class]]) {
                    
                    NSString* currentStr = [HttpManager Sort:currentValue];
                    if (currentStr == nil) {
                        currentStr = @"";
                    }
                    signStr = [NSString stringWithFormat:@"%@%@=%@",signStr,[compositorArray objectAtIndex:index],currentStr];
                }
                else
                {
                    signStr = [NSString stringWithFormat:@"%@%@=%@",signStr,[compositorArray objectAtIndex:index],[currentDic objectForKey:[compositorArray objectAtIndex:index]]];
                }
                
              //  signStr = [NSString stringWithFormat:@"%@%@=%@",signStr,[compositorArray objectAtIndex:index],[currentDic objectForKey:[compositorArray objectAtIndex:index]]];
                
            }
        }
    }
    
    return signStr;
}

/**
 *  获取签名
 *
 *  @param parameter 必要的参数
 *  @param timestamp 时间戳
 *
 *  @return 返回签名
 */

+(NSString *)getSignWithParameter:(NSDictionary *)parameter timestamp:(NSString *)timestamp{
    
    AppInfoDTO *appInfoDTO  = [AppInfoDTO sharedInstance];
    
    NSMutableDictionary *necessaryParameters = [[NSMutableDictionary alloc]initWithObjectsAndKeys:appInfoDTO.deviceType,@"deviceType",appInfoDTO.deviceToken,@"deviceSn",appInfoDTO.imei,@"imei",appInfoDTO.appVersion,@"appVersion",appInfoDTO.iosVersion,@"iosVersion",appInfoDTO.appKey,@"appKey",timestamp,@"timestamp",appInfoDTO.appType,@"appType",appInfoDTO.screenType,@"screenType",appInfoDTO.appVersionInt,@"versionNo",nil];
    
    
    [necessaryParameters addEntriesFromDictionary:parameter];
    
    
    //排序
    NSArray *compositorArray = [necessaryParameters.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        int i = 1;
        
        while (1) {
            
            if ([[obj1 substringToIndex:i] compare:[obj2 substringToIndex:i]options:NSLiteralSearch]>0) {
                
                return YES;
                
            }else if ([[obj1 substringToIndex:i] compare:[obj2 substringToIndex:i]options:NSLiteralSearch]==0){
                
                i++;
                
                if (((NSString *)obj1).length<i || ((NSString *)obj2).length<i) {
                    //对比长度
                    if (((NSString *)obj1).length > ((NSString *)obj2).length) {
                        
                        return YES;
                        
                    }else{
                        
                        return NO;
                    }
                }
                
            }else{
                
                return NO;
            }
        }
        
    }];
    
    NSString *signStr;
    for (int i = 0; i<compositorArray.count; i++) {
        
        if (i == 0) {
            
            signStr = [NSString stringWithFormat:@"%@=%@",[compositorArray objectAtIndex:i],[necessaryParameters objectForKey:[compositorArray objectAtIndex:i]]];
        }else{
            
            id currentValue = [necessaryParameters objectForKey:[compositorArray objectAtIndex:i]];
            if (currentValue && [currentValue isKindOfClass:[NSMutableArray class]]) {
                
                NSString* currentStr = [HttpManager Sort:currentValue];
                if (currentStr == nil) {
                    currentStr = @"";
                }
                signStr = [NSString stringWithFormat:@"%@%@=%@",signStr,[compositorArray objectAtIndex:i],currentStr];
                
//                NSMutableArray * currenrValueArray = currentValue;
//                if (currenrValueArray.count) {//!数组里面有值
//                    
//                    //!如果数组里面是字典
//                    if ([currenrValueArray[0] isKindOfClass:[NSDictionary class]]) {
//                        
//                        NSString* currentStr = [HttpManager Sort:currentValue];
//                        if (currentStr == nil) {
//                            currentStr = @"";
//                        }
//                        signStr = [NSString stringWithFormat:@"%@%@=%@",signStr,[compositorArray objectAtIndex:i],currentStr];
//                        
//                    }else{
//                    //!如果数组里面不是字典
//                        
//                        signStr = [NSString stringWithFormat:@"%@%@=%@",signStr,[compositorArray objectAtIndex:i],[necessaryParameters objectForKey:[compositorArray objectAtIndex:i]]];
//                    
//                    }
//                    
//                }else{//!数组里面是空的
//                
//                    signStr = [NSString stringWithFormat:@"%@%@=%@",signStr,[compositorArray objectAtIndex:i],@""];
//                    
//                }
                
            }
            else
            {
                signStr = [NSString stringWithFormat:@"%@%@=%@",signStr,[compositorArray objectAtIndex:i],[necessaryParameters objectForKey:[compositorArray objectAtIndex:i]]];
            }
        }
    }
    
    signStr = [NSString stringWithFormat:@"%@%@",signStr,appSecret];
    

    return [[signStr MD5Hash]lowercaseString];

}

/**
 *  转化参数
 *
 *  @param parameter 字典参数
 *  @param timestamp 时间戳
 *
 *  @return 返回一个json字符串
 */
+(NSString *)getParameterWithParameter:(NSDictionary *)parameter timestamp:(NSString *)timestamp{
    
    AppInfoDTO *appInfoDTO  = [AppInfoDTO sharedInstance];
    
    NSMutableDictionary *necessaryParameters = [[NSMutableDictionary alloc]initWithObjectsAndKeys:appInfoDTO.deviceType,@"deviceType",appInfoDTO.deviceToken,@"deviceSn",appInfoDTO.imei,@"imei",appInfoDTO.appVersion,@"appVersion",appInfoDTO.iosVersion,@"iosVersion",appInfoDTO.appKey,@"appKey",timestamp,@"timestamp",appInfoDTO.appType,@"appType",appInfoDTO.screenType,@"screenType",appInfoDTO.appVersionInt,@"versionNo", nil];
    
    
    [necessaryParameters addEntriesFromDictionary:parameter];
    
    
    //将字典转成字符串
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:necessaryParameters options:NSJSONWritingPrettyPrinted error:&parseError];
    
    
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}



//转化参数
+(NSMutableDictionary *)getParameterWithTimestamp:(NSString *)timestamp{
    
    AppInfoDTO *appInfoDTO  = [AppInfoDTO sharedInstance];
    

    NSMutableDictionary *necessaryParameters = [[NSMutableDictionary alloc]initWithObjectsAndKeys:appInfoDTO.deviceType,@"deviceType",appInfoDTO.deviceToken,@"deviceSn",appInfoDTO.imei,@"imei",appInfoDTO.appVersion,@"appVersion",appInfoDTO.iosVersion,@"iosVersion",appInfoDTO.appKey,@"appKey",timestamp,@"timestamp",appInfoDTO.appType,@"appType",appInfoDTO.screenType,@"screenType",appInfoDTO.appVersionInt,@"versionNo", nil];
    
    return necessaryParameters;

    
}


/**
 *  获取签名
 *
 *  @param parameter 必要的参数
 *  @param timestamp 时间戳
 *
 *  @return 返回签名
 */
+(NSString *)getSignWithParameter:(NSMutableDictionary *)parameter {
    
    //排序
    NSArray *compositorArray = [parameter.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        int i = 1;
        
        while (1) {
            
            if ([[obj1 substringToIndex:i] compare:[obj2 substringToIndex:i]options:NSLiteralSearch]>0) {
                
                return YES;
                
            }else if ([[obj1 substringToIndex:i] compare:[obj2 substringToIndex:i]options:NSLiteralSearch]==0){
                
                i++;
                
                if (((NSString *)obj1).length<i || ((NSString *)obj2).length<i) {
                    //对比长度
                    if (((NSString *)obj1).length > ((NSString *)obj2).length) {
                        
                        return YES;
                        
                    }else{
                        
                        return NO;
                    }
                }
                
            }else{
                
                return NO;
            }
        }
        
    }];
    
    NSString *signStr;
    for (int i = 0; i<compositorArray.count; i++) {
        
        if (i == 0) {
            
            signStr = [NSString stringWithFormat:@"%@=%@",[compositorArray objectAtIndex:i],[parameter objectForKey:[compositorArray objectAtIndex:i]]];
        }else{
            
            id currentValue = [parameter objectForKey:[compositorArray objectAtIndex:i]];
            if (currentValue && [currentValue isKindOfClass:[NSMutableArray class]]) {
                
                NSString* currentStr = [HttpManager Sort:currentValue];
                if (currentStr == nil) {
                    currentStr = @"";
                }
                signStr = [NSString stringWithFormat:@"%@%@=%@",signStr,[compositorArray objectAtIndex:i],currentStr];
            }
            else
            {
                signStr = [NSString stringWithFormat:@"%@%@=%@",signStr,[compositorArray objectAtIndex:i],[parameter objectForKey:[compositorArray objectAtIndex:i]]];
            }
        }
    }
    
    signStr = [NSString stringWithFormat:@"%@%@",signStr,appSecret];
    
    
    return [[signStr MD5Hash]lowercaseString];
    
}







#pragma mark- 3.1 登陆接口
+ (BCSHttpRequestStatus)sendHttpRequestForLoginWithMemberAccount:(NSString *)memberAccount password:(NSString *)password success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == memberAccount || memberAccount.length<1 || nil == password || password.length<1){
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"memberAccount":memberAccount,
                                           
                                           @"passwd":[[password MD5Hash]lowercaseString]
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,login,sign];

    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;

}

#pragma mark- 3.2 注册接口-验证手机号并且发送验证码
+ (BCSHttpRequestStatus)sendHttpRequestForRegisterMobile:(NSString *)mobilePhone success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == mobilePhone || mobilePhone.length<1) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"mobilePhone":mobilePhone,
                                           
                                           };
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,registerMobile,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark- 3.3 设置登录密码
+ (BCSHttpRequestStatus)sendHttpRequestForSetPasswordWithMobilePhone:(NSString *)mobilePhone password:(NSString *)password type:(NSString *)type success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == mobilePhone || mobilePhone.length<1  ||  nil == password || password.length<1 || nil == type || type.length<1) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"mobilePhone":mobilePhone,
                                           
                                           @"passwd":[[password MD5Hash]lowercaseString],
                                           
                                           @"type":type
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,setPassword,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark- 3.13	小B新增注册接口
+ (BCSHttpRequestStatus)sendHttpRequestPassSetPasswordWithMobilePhone:(NSString *)mobilePhone password:(NSString *)password  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == mobilePhone || mobilePhone.length<1  ||  nil == password || password.length<1 ) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"mobilePhone":mobilePhone,
                                           
                                           @"passwd":[[password MD5Hash]lowercaseString]
                                           
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,setRegister,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}


#pragma mark-3.4	根据父ID获取省市区列表接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetAreaListByParentIdWithParentId:(NSNumber *)parentId success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == parentId || parentId.stringValue.length<1||!([LoginDTO sharedInstance].tokenId)) {
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"parentId":parentId.stringValue
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getAreaListByParentId,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.5	小B补充申请资料
+ (BCSHttpRequestStatus)sendHttpRequestForaddApplyInfoWithApplyInfo:(ApplyInfoDTO *)applyInfoDTO  shopName:(NSString *)shopName  otherPlatform:(NSString *) otherPlatform success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (YES == applyInfoDTO.IsParameter||!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];

    NSDictionary *parameterWithObject = @{
                                            @"tokenId":[LoginDTO sharedInstance].tokenId,
                                            
                                            @"memberNo":[LoginDTO sharedInstance].memberNo,
                                            
                                            @"memberName":applyInfoDTO.memberName,
                                            
                                            @"mobilePhone":applyInfoDTO.mobilePhone,
                                            
                                            @"provinceNo":applyInfoDTO.provinceNo.stringValue,
                                            
                                            @"cityNo":applyInfoDTO.cityNo.stringValue,
                                            
                                            @"countyNo":applyInfoDTO.countyNo.stringValue,
                                            
                                            @"detailAddress":applyInfoDTO.detailAddress,
                                            
                                            @"sex":applyInfoDTO.sex,
                                            
                                            @"identityNo":applyInfoDTO.identityNo,
                                            
                                            @"joinType":applyInfoDTO.joinType,
                                            
                                            @"telephone":applyInfoDTO.telephone,
                                            
                                            @"businessLicenseNo":applyInfoDTO.businessLicenseNo,
                                            
                                            @"businessDesc":applyInfoDTO.businessDesc,
                                            
                                            @"identityPicUrl":applyInfoDTO.identityPicUrl,
                                            
                                            @"businessLicenseUrl":applyInfoDTO.businessLicenseUrl,
                                            
                                            @"shopType":applyInfoDTO.shopType,
                                            
                                            @"shopName": shopName,
                                            
                                            @"otherPlatform":otherPlatform
                                            
                                            };
    
    NSMutableDictionary *parameterWithOutSign = [[NSMutableDictionary alloc] initWithDictionary:parameterWithObject];
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,addApplyInfo,sign];
    

    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
  
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.15	小B首次提交申请资料接口
+ (BCSHttpRequestStatus)sendHttpRequestForaddApplyInfoFirstWithApplyInfo:(ApplyInfoDTO *)applyInfoDTO  shopName:(NSString *)shopName whithPushCode:(NSString *)pushCode otherPlatform:(NSString *) otherPlatform success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (YES == applyInfoDTO.IsParameter||!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithObject = @{
                                          @"tokenId":[LoginDTO sharedInstance].tokenId,
                                          
                                          @"pushCode":applyInfoDTO.keyCode,
                                          
                                          @"memberName":applyInfoDTO.memberName,
                                          
                                          @"mobilePhone":applyInfoDTO.mobilePhone,
                                          
                                          @"provinceNo":applyInfoDTO.provinceNo.stringValue,
                                          
                                          @"cityNo":applyInfoDTO.cityNo.stringValue,
                                          
                                          @"countyNo":applyInfoDTO.countyNo.stringValue,
                                          
                                          @"detailAddress":applyInfoDTO.detailAddress,
                                          
                                          @"sex":applyInfoDTO.sex,
                                          
                                          @"identityNo":applyInfoDTO.identityNo,
                      
                                          @"telephone":applyInfoDTO.telephone,
                                          
                                          @"businessLicenseNo":applyInfoDTO.businessLicenseNo,
                                          
                                          @"businessDesc":applyInfoDTO.businessDesc,
                                          
                                          @"identityPicUrl":applyInfoDTO.identityPicUrl,
                                          
                                          @"businessLicenseUrl":applyInfoDTO.businessLicenseUrl,
                                          
                                          @"shopType":applyInfoDTO.shopType,
                                          
                                          @"shopName": shopName,
                                          
                                          @"otherPlatform":otherPlatform
                                          
                                          };
    
    NSMutableDictionary *parameterWithOutSign = [[NSMutableDictionary alloc] initWithDictionary:parameterWithObject];
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,addApplyInfoFirst,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}
#pragma mark-3.16	小B再次提交申请资料接口
+ (BCSHttpRequestStatus)sendHttpRequestForaddApplyInfoAgainWithApplyInfo:(ApplyInfoDTO *)applyInfoDTO  shopName:(NSString *)shopName otherPlatform:(NSString *) otherPlatform success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (YES == applyInfoDTO.IsParameter||!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithObject = @{
                                          @"tokenId":[LoginDTO sharedInstance].tokenId,
                                          
                                          
                                          @"memberName":applyInfoDTO.memberName,
                                          
                                          @"mobilePhone":applyInfoDTO.mobilePhone,
                                          
                                          @"provinceNo":applyInfoDTO.provinceNo.stringValue,
                                          
                                          @"cityNo":applyInfoDTO.cityNo.stringValue,
                                          
                                          @"countyNo":applyInfoDTO.countyNo.stringValue,
                                          
                                          @"detailAddress":applyInfoDTO.detailAddress,
                                          
                                          @"sex":applyInfoDTO.sex,
                                          
                                          @"identityNo":applyInfoDTO.identityNo,
                                          
                                          @"telephone":applyInfoDTO.telephone,
                                          
                                          @"businessLicenseNo":applyInfoDTO.businessLicenseNo,
                                          
                                          @"businessDesc":applyInfoDTO.businessDesc,
                                          
                                          @"identityPicUrl":applyInfoDTO.identityPicUrl,
                                          
                                          @"businessLicenseUrl":applyInfoDTO.businessLicenseUrl,
                                          
                                          @"shopType":applyInfoDTO.shopType,
                                          
                                          @"shopName": shopName,
                                          
                                          @"otherPlatform":otherPlatform
                                          
                                          };
    
    NSMutableDictionary *parameterWithOutSign = [[NSMutableDictionary alloc] initWithDictionary:parameterWithObject];
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,addApplyInfoAgain,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.94小B验证地推码
+ (BCSHttpRequestStatus)sendHttpRequestForaddCodeWithApplyInfo:(ApplyInfoDTO *)applyInfoDTO  shopName:(NSString *)shopName  otherPlatform:(NSString *) otherPlatform success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (YES == applyInfoDTO.IsParameter||!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithObject = @{
                                          @"keyCode":applyInfoDTO.keyCode,
                                          
                                          @"tokenId":[LoginDTO sharedInstance].tokenId,
                                          
                                          @"memberNo":[LoginDTO sharedInstance].memberNo,
                                          
                                          @"memberName":applyInfoDTO.memberName,
                                          
                                          @"mobilePhone":applyInfoDTO.mobilePhone,
                                          
                                          @"provinceNo":applyInfoDTO.provinceNo.stringValue,
                                          
                                          @"cityNo":applyInfoDTO.cityNo.stringValue,
                                          
                                          @"countyNo":applyInfoDTO.countyNo.stringValue,
                                          
                                          @"detailAddress":applyInfoDTO.detailAddress,
                                          
                                          @"sex":applyInfoDTO.sex,
                                          
                                          @"identityNo":applyInfoDTO.identityNo,
                                          
                                          @"joinType":applyInfoDTO.joinType,
                                          
                                          @"telephone":applyInfoDTO.telephone,
                                          
                                          @"businessLicenseNo":applyInfoDTO.businessLicenseNo,
                                          
                                          @"businessDesc":applyInfoDTO.businessDesc,
                                          
                                          @"identityPicUrl":applyInfoDTO.identityPicUrl,
                                          
                                          @"businessLicenseUrl":applyInfoDTO.businessLicenseUrl,
                                          
                                          @"shopType":applyInfoDTO.shopType,
                                          
                                          @"shopName": shopName,
                                          
                                          @"otherPlatform":otherPlatform
                                          
                                          };
    
    NSMutableDictionary *parameterWithOutSign = [[NSMutableDictionary alloc] initWithDictionary:parameterWithObject];
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,addApplyInfoCode,sign];
    
    
    
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.6 小B查询申请资料
+ (BCSHttpRequestStatus)sendHttpRequestForGetApplyInfoSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"id":[MemberInfoDTO sharedInstance].applyid?[MemberInfoDTO sharedInstance].applyid:@"",
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getApplyInfo,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}
#pragma mark-3.14	小B申请资料校验接口
+ (BCSHttpRequestStatus)sendHttpRequestForVerApplyInfoSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,valApplyInfo,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.7 小B验证邀请码
+ (BCSHttpRequestStatus)sendHttpRequestForVerifyRegisterKeyCode:(NSString *)keyCode mobilePhone:(NSString *)mobilePhone  shopType:(NSString *)shopType shopName:(NSString *)shopName otherPlatform:(NSString *)otherPlatform    businessLicenseNo:(NSString *)businessLicenseNo  businessLicenseUrl:(NSString *)businessLicenseUrl   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == keyCode || keyCode.length<1 || nil == mobilePhone || mobilePhone.length<1||!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                            
                                            @"tokenId":[LoginDTO sharedInstance].tokenId,
                                            
                                            @"keyCode":keyCode,
                                            
                                            @"mobilePhone":mobilePhone,
                                            
                                            @"shopType":shopType,
                                            
                                            @"shopName":shopName,
                                            
                                            @"otherPlatform":otherPlatform,
                                            
                                            @"businessLicenseUrl":businessLicenseUrl,
                                            
                                            @"businessLicenseNo":businessLicenseNo
                        
                                            };
    

    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,verifyRegisterKeyCode,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}


#pragma mark-3.7 2.10 小B验证邀请码 新 接口
+ (BCSHttpRequestStatus)sendHttpRequestForCodeVerifyRegisterKeyCode:(NSString *)keyCode mobilePhone:(NSString *)mobilePhone    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == keyCode || keyCode.length<1 || nil == mobilePhone || mobilePhone.length<1||!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"keyCode":keyCode,
                                           
                                           @"mobilePhone":mobilePhone,

                                           };
    
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,verifyRegisterKeyCode,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.8 忘记密码校验接口-用于找回密码时校验手机号（手机号需要已经注册过）
+ (BCSHttpRequestStatus)sendHttpRequestForForgetPwdCheckWithMobilePhone:(NSString *)mobilePhone success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == mobilePhone || mobilePhone.length<1) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                            @"mobilePhone":mobilePhone
                                            };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,forgetPwdCheck,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.9 用户修改密码接口
+ (BCSHttpRequestStatus)sendHttpRequestForModifyPasswordWithPhone:(NSString *)phone passwd:(NSString *)passwd oldpwd:(NSString *)oldpwd success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == phone || phone.length < 1 || nil == passwd || passwd.length < 1 || nil == oldpwd || oldpwd.length<1||!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                            @"tokenId":[LoginDTO sharedInstance].tokenId,
                                            
                                            @"phone":phone,
                                            
                                            @"passwd":[[passwd MD5Hash]lowercaseString],
                                            
                                            @"oldpwd":[[oldpwd MD5Hash]lowercaseString]
                                            
                                            };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,setUpdate,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark- 3.10 用户修改支付密码接口
+ (BCSHttpRequestStatus)sendHttpRequestForPayPasswdUpdateWithPhone:(NSString *)phone password:(NSString *)password originalPassword:(NSString *)originalPassword success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    
    if (nil == phone || phone.length < 1 || nil == password || password.length < 1 || nil == originalPassword || originalPassword.length<1||!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                            @"tokenId":[LoginDTO sharedInstance].tokenId,
                                            
                                            @"phone":phone,
                                            
                                            @"password":[[password MD5Hash] lowercaseString],
                                            
                                            @"originalPassword":[[originalPassword MD5Hash] lowercaseString]
                                            
                                            };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,payPasswdUpdate,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.11 发送短信接口
+ (BCSHttpRequestStatus)sendHttpRequestForSendSmsWithPhone:(NSString *)phone type:(NSString *)type success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    NSString* tokenId = nil;
    
    if (nil == phone || phone.length < 1 || nil == type || type.length < 1) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    if ([type isEqualToString:@"4"]||[type isEqualToString:@"5"]||[type isEqualToString:@"14"]) {
        tokenId = [LoginDTO sharedInstance].tokenId;

        if (!tokenId) {
            return BCSHttpRequestParameterIsLack;
        }
    }
    else
    {
        tokenId = @"";
    }

    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                            @"tokenId":tokenId,
                                            
                                            @"phone":phone,
                                            
                                            @"type":type,
                                            
                                            };
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,sendSms,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.12 短信校验接口
+ (BCSHttpRequestStatus)sendHttpRequestForVerifySmsCodeWithPhone:(NSString *)phone type:(NSString *)type smsCode:(NSString *)smsCode success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    NSString* tokenId = nil;
    if (nil == phone || phone.length < 1 || nil == type || type.length < 1) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    if ([type isEqualToString:@"4"]||[type isEqualToString:@"5"]||[type isEqualToString:@"14"]) {
        tokenId = [LoginDTO sharedInstance].tokenId;
        if (!tokenId){
            return BCSHttpRequestParameterIsLack;
        }

    }
    else
    {
        tokenId = @"";
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                            @"tokenId":tokenId,
                                            
                                            @"phone":phone,
                                            
                                            @"type":type,
                                            
                                            @"smsCode":smsCode
                                            
                                            };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,verifySmsCode,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.13	个人中心主页接口
+ (BCSHttpRequestStatus)sendHttpRequestForPersonalCenterSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    
    if ([LoginDTO sharedInstance].tokenId == nil || [LoginDTO sharedInstance].memberNo == nil||!([LoginDTO sharedInstance].tokenId) ) {
        
        return BCSHttpRequestStatusHaveNotLogin;
    
        
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"memberNo":[LoginDTO sharedInstance].memberNo,
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,personalCenter,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}

#pragma mark-3.14 商品分类接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetCategoryListWithMerchantNo:(NSString *)merchantNo withQueryType:(NSString *)queryType success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == merchantNo) {
        
        return BCSHttpRequestParameterIsLack;
    }
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestStatusHaveNotLogin;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                            @"tokenId":[LoginDTO sharedInstance].tokenId,
                                            
                                            @"merchantNo":merchantNo,
                                            
                                            @"queryType":queryType
                                            
                                            };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getCategoryList,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}

#pragma mark- 3.15 小B商品列表接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetGoodsListWithPageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize  merchantNo:(NSString *)merchantNo structureNo:(NSString *)structureNo rangeFlag:(NSString *)rangeFlag withGoodsSortDTO:(GoodsSortDTO *)sortDTO success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestStatusHaveNotLogin;
    }
    
    if (pageNo == nil) {
        
        pageNo = [NSNumber numberWithInteger:1];
        
    }
    
    if (pageSize == nil) {
        pageSize = [NSNumber numberWithInteger:20];
    }
    
    if (merchantNo == nil) {
        merchantNo = @"";
    }
    
    if (structureNo == nil) {
        structureNo = @"";
    }
    
    if (rangeFlag == nil) {
        rangeFlag = @"0";
    }
    
    //!上新时间 -15:15天内，15:15天前，20:20天前，30:30天前
    NSString * upDayNum = sortDTO.upDayNum;
    //!价格区间最小价格
    NSString * minPrice = sortDTO.minPrice;
    //!价格区间最大价格
    NSString * maxPrice = sortDTO.maxPrice;
    //!排序 1按时间，2按销量，3按价格,4推荐（desc）
    NSString * orderByField = sortDTO.orderByField;
    //!desc降序 asc 升序
    NSString * orderBy = sortDTO.orderBy;
    
    if (upDayNum == nil) {
        
        upDayNum = @"";
    }
    
    
    if (minPrice == nil) {
        
        minPrice = @"";
    }
    
    if (maxPrice == nil) {
        
        maxPrice = @"";
    }
    
    if (orderByField == nil) {//要求排序的类型为空，就不需要传是升序还是降序
        
        orderByField = @"";

    }
    
    if (orderBy == nil) {
        
        orderBy = @"";
    }
    
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"pageNo":pageNo.stringValue,
                                           
                                           @"pageSize":pageSize.stringValue,
                                           
                                           @"merchantNo":merchantNo,
                                           
                                           @"structureNo":structureNo,
                                           
                                           @"rangeFlag":rangeFlag,
                                           
                                           @"upDayNum":upDayNum,
                                          
                                           @"minPrice":minPrice,
                                           @"maxPrice":maxPrice,
                                           @"orderByField":orderByField,
                                           @"orderBy":orderBy
                                           
                                           };
    
    DebugLog(@"parameterWithOutSign:%@", parameterWithOutSign);
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getGoodsList,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];

    return BCSHttpRequestStatusStable;
    
}

#pragma mark-3.16 商品（下载）无权限提示接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetGoodsNotLevelTipWithGoodsNo:(NSString *)goodsNo authType:(NSString *)authType success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == goodsNo || goodsNo.length<1  || nil==authType || authType.length<1) {
        return BCSHttpRequestParameterIsLack;
    }
    
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"goodsNo":goodsNo,
                                           
                                           @"authType":authType,
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getGoodsNotLevelTip,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}

#pragma mark 3.17	小B获取商家邮费专拍商品接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetGoodsFeeInfo:(NSString *)merchantNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"merchantNo":merchantNo
                                           
                                           };
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getGoodsFeeInfo,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.17	小B商品详情接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetGoodsInfoDetailsWithGoodsNo:(NSString *)goodsNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == goodsNo || goodsNo.length<1||!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"goodsNo":goodsNo,
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getGoodsInfoDetails,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;

}
#pragma mark-3.17	3.0 小B商品详情接口 （新 3.0）
+ (BCSHttpRequestStatus)sendHttpRequestForGetNewGoodsInfoDetailsWithGoodsNo:(NSString *)goodsNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == goodsNo || goodsNo.length<1||!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"goodsNo":goodsNo,
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getNewGoodsInfoDetails,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}


#pragma mark-3.18	小B查看商家店铺列表接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetMerchantListWithMerchantNo:(NSString *)merchantNo pageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    
    if ([LoginDTO sharedInstance].tokenId == nil || [LoginDTO sharedInstance].tokenId.length <= 0 ) {
        
        return BCSHttpRequestStatusHaveNotLogin;
        
    }
    
    if (pageNo == nil) {
        pageNo = [NSNumber numberWithInteger:1];
    }
    
    if (pageSize == nil) {
        pageSize = [NSNumber numberWithInteger:20];
    }
    
    if (merchantNo == nil) {
        merchantNo = @"";
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"memberNo":[LoginDTO sharedInstance].memberNo,
                                           
                                           @"merchantNo":merchantNo,
                                           
                                           @"pageNo":pageNo.stringValue,
                                           
                                           @"pageSize":pageSize.stringValue
                                           
                                           
                                           };
    
    
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getMerchantList,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    
    return BCSHttpRequestStatusStable;

}

#pragma mark-3.19 小B查看商家店铺详情接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetMerchantShopDetailWithMerchantNo:(NSString *)merchantNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == merchantNo || merchantNo.length<1||!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"merchantNo":merchantNo,
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getMerchantShopDetail,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    
    return BCSHttpRequestStatusStable;

}

#pragma mark-3.20	小B商品收藏新增接口
+ (BCSHttpRequestStatus)sendHttpRequestForAddGoodsFavoriteWithGoodsNo:(NSString *)goodsNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == goodsNo || goodsNo.length<1||!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"memberNo":[LoginDTO sharedInstance].memberNo,
                                           
                                           @"goodsNo":goodsNo
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,addGoodsFavorite,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;    
}

#pragma mark-3.21	小B商品收藏取消接口
+ (BCSHttpRequestStatus)sendHttpRequestForDelFavoriteWithGoodsNo:(NSString *)goodsNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == goodsNo || goodsNo.length<1||!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"memberNo":[LoginDTO sharedInstance].memberNo,
                                           
                                           @"goodsNo":goodsNo
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,delFavorite,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}
#pragma mark-3.22	小B商品收藏列表接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetFavoriteListByTime:(NSString *)queryType success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    if ([queryType isEqualToString:@""]) {
        
        queryType = @"0";
    }

    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"memberNo":[LoginDTO sharedInstance].memberNo,
                                           
                                           @"queryType":queryType
                        
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getFavoriteListByTime,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.24	小B商品收藏列表接口(按商家排序)
+ (BCSHttpRequestStatus)sendHttpRequestForGetFavoriteListByMerchant:(NSString *)queryType success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([queryType isEqualToString:@""]) {
        
        queryType = @"0";
    }
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"memberNo":[LoginDTO sharedInstance].memberNo,
                                           
                                           @"queryType":queryType
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getFavoriteListByMerchant,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.23	小B站内信列表接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetMemberNoticeListWithPageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == pageNo) {
        pageNo = [NSNumber numberWithInteger:1];
    }
    
    if (nil == pageSize) {
        pageSize = [NSNumber numberWithInteger:20];
    }
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"memberNo":[LoginDTO sharedInstance].memberNo,
                                           
                                           @"pageNo":pageNo.stringValue,
                                           
                                           @"pageSize":pageSize.stringValue,
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getMemberNoticeList,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.24	小B站内信阅读状态修改接口
+ (BCSHttpRequestStatus)sendHttpRequestForUpdateNoticeStatusWithInsideLetterID:(NSString *)insideLetterId success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == insideLetterId || insideLetterId.length<1||!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"memberNo":[LoginDTO sharedInstance].memberNo,
                                           
                                           @"id":insideLetterId
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,updateNoticeStatus,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}
#pragma mark-3.92	小B站内信 未读
+ (BCSHttpRequestStatus)sendHttpRequestForLetterSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                  
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getStationTopByXb,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.25	小B获取下载图片列表接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetDownloadImageList:(NSMutableArray *)imageDownloadArray  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    
    if (nil == imageDownloadArray) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestStatusHaveNotLogin;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"list":imageDownloadArray
                                           };
    
    DebugLog(@"parameterWithOutSign：%@",parameterWithOutSign);

    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getDownloadImageList,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
    
}

#pragma mark-3.26	小B图片下载完成回调接口
+ (BCSHttpRequestStatus)sendHttpRequestForDownloadCompleteWithGoodsNo:(NSString *)goodsNo picType:(NSString *)picType success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == goodsNo || goodsNo.length<1 || nil == picType || picType.length<1||!([LoginDTO sharedInstance].tokenId)) {
        
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"goodsNo":goodsNo,
                                           
                                           @"picType":picType
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,imageDownloadCallback,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.27	小B图片下载历史查询接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetHistoryDownloadListWithPageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == pageNo) {
        pageNo = [NSNumber numberWithInteger:1];
    }
    
    if (nil == pageSize) {
        pageSize = [NSNumber numberWithInteger:20];
    }
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"memberNo":[LoginDTO sharedInstance].memberNo,
                                           
                                           @"pageNo":pageNo.stringValue,
                                           
                                           @"pageSize":pageSize.stringValue,
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getHistoryDownloadList,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.28	小B商品补货列表接口( 按购买时间倒序取)
+ (BCSHttpRequestStatus)sendHttpRequestForGetGoodsReplenishmentByTime:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"memberNo":[LoginDTO sharedInstance].memberNo
                                           
                                           };

    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getGoodsReplenishmentByTime,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.29	小B订购过的商家列表接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetBoughtListWithPageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == pageNo) {
        pageNo = [NSNumber numberWithInteger:1];
    }
    
    if (nil == pageSize) {
        pageSize = [NSNumber numberWithInteger:20];
    }
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"memberNo":[LoginDTO sharedInstance].memberNo,
                                           
                                           @"pageNo":pageNo.stringValue,
                                           
                                           @"pageSize":pageSize.stringValue,
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getBoughtList,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}

#pragma mark-小B查看个人资料接口
+ (BCSHttpRequestStatus)sendHttpRequestGetMemberInfoSuccess:(void (^)(AFHTTPRequestOperation *operation,id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation,
                                                               NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestStatusHaveNotLogin;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = [LoginDTO sharedInstance].memberNo?@{
                                 
                                 @"tokenId":[LoginDTO sharedInstance].tokenId,
                                 
                                 @"memberNo":[LoginDTO sharedInstance].memberNo,
                                 
                                 }:@{
                                     
                                     @"tokenId":[LoginDTO sharedInstance].tokenId,
                                     
                                     
                                     };
    
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getMemberInfo,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    
    return BCSHttpRequestStatusStable;
    
}

#pragma mark-3.31	小B修改个人资料接口
+ (BCSHttpRequestStatus)sendHttpRequestForUpdateMemberDataWithUserInfoDTO:(MemberInfoDTO *)memberInfoDTO success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
//    if (YES == memberInfoDTO.IsLackParameter) {
//        
//        return BCSHttpRequestParameterIsLack;
//    }
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"memberNo":[LoginDTO sharedInstance].memberNo,
                                           
                                           @"nickName":memberInfoDTO.nickName,
                                           
                                           @"memberName":memberInfoDTO.memberName,
                                           
                                           @"sex":memberInfoDTO.sex,
                                           
                                           @"mobilePhone":memberInfoDTO.mobilePhone,
                                           
                                           @"telephone":memberInfoDTO.telephone,
                                           
                                           @"wechatNo":memberInfoDTO.wechatNo,
                                           
                                           @"provinceNo":memberInfoDTO.provinceNo,
                                           
                                           @"cityNo":memberInfoDTO.cityNo,
                                           
                                           @"countyNo":memberInfoDTO.countyNo,
                                           
                                           @"detailAddress":memberInfoDTO.detailAddress,
                                           
                                           @"postalCode":memberInfoDTO.postalCode,
                                           
                                           @"iconUrl":memberInfoDTO.iconUrl,
                                           
                                           };
   
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,updateMemberData,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.32 小B保存收货地址
+ (BCSHttpRequestStatus)sendHttpRequestForAddConsignee:(ConsigneeAddressDTO *)consigneeAddressDTO success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (YES == consigneeAddressDTO.IsLackParameter ||!([LoginDTO sharedInstance].tokenId)) {
     
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];

    NSDictionary *parameterWithOutSign;
    if (consigneeAddressDTO.joinType) {
        
        
        parameterWithOutSign= @{
                                
                                @"tokenId":[LoginDTO sharedInstance].tokenId,
                                
                                @"memberNo":[LoginDTO sharedInstance].memberNo,
                                
                                @"consigneeName":consigneeAddressDTO.consigneeName,
                                
                                @"consigneePhone":consigneeAddressDTO.consigneePhone,
                                
                                @"provinceNo":consigneeAddressDTO.provinceNo.stringValue,
                                
                                @"cityNo":consigneeAddressDTO.cityNo.stringValue,
                                
                                @"countyNo":consigneeAddressDTO.countyNo.stringValue,
                                
                                @"detailAddress":consigneeAddressDTO.detailAddress,
                                
                                //                                           @"postalCode":consigneeAddressDTO.postalCode,
                                
                                @"defaultFlag":consigneeAddressDTO.defaultFlag,
                                @"joinType":consigneeAddressDTO.joinType
                                
                                };
        

    }else
    {
        
        parameterWithOutSign= @{
                                
                                @"tokenId":[LoginDTO sharedInstance].tokenId,
                                
                                @"memberNo":[LoginDTO sharedInstance].memberNo,
                                
                                @"consigneeName":consigneeAddressDTO.consigneeName,
                                
                                @"consigneePhone":consigneeAddressDTO.consigneePhone,
                                
                                @"provinceNo":consigneeAddressDTO.provinceNo.stringValue,
                                
                                @"cityNo":consigneeAddressDTO.cityNo.stringValue,
                                
                                @"countyNo":consigneeAddressDTO.countyNo.stringValue,
                                
                                @"detailAddress":consigneeAddressDTO.detailAddress,
                                
                                //                                           @"postalCode":consigneeAddressDTO.postalCode,
                                
                                @"defaultFlag":consigneeAddressDTO.defaultFlag,
//                                @"joinType":consigneeAddressDTO.joinType
                                
                                };
        

    }
       //签名

    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,consigneeAdd,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.33	小B收货地址列表接口
+ (BCSHttpRequestStatus)sendHttpRequestForConsigneeGetListSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,consigneeGetList,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.34	小B修改收货地址
+ (BCSHttpRequestStatus)sendHttpRequestForConsigneeUpdateWithConsigneeDTO:(AdressListModel*)consigneeDTO success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (YES == consigneeDTO.IsLackParameter||!([LoginDTO sharedInstance].tokenId)) {
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"merberNo":[LoginDTO sharedInstance].memberNo,
                                           
                                           @"id":consigneeDTO.Id.stringValue,
                                           
                                           @"consigneeName":consigneeDTO.consigneeName,
                                           
                                           @"consigneePhone":consigneeDTO.consigneePhone,
                                           
                                           @"provinceNo":consigneeDTO.provinceNo.stringValue,
                                           
                                           @"cityNo":consigneeDTO.cityNo.stringValue,
                                           
                                           @"countyNo":consigneeDTO.countyNo.stringValue,
                                           
                                           @"detailAddress":consigneeDTO.detailAddress,
                                           
//                                           @"postalCode":consigneeDTO.postalCode,
                                           
                                           @"defaultFlag":consigneeDTO.defaultFlag
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,consigneeUpdate,sign];
    
//    DebugLog(@"%@", <#args...#>)
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}

#pragma mark-3.35	小B删除收货地址
+ (BCSHttpRequestStatus)sendHttpRequestForConsigneeDelWithConsigneeID:(NSNumber *)consigneeID success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == consigneeID ||!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"id":consigneeID.stringValue,
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,consigneeDel,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.36	小B消费积分记录按月统计接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetIntegralByMonthSuccess:(NSString *)time  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    
    if (nil == time || time.length<1 ||!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }

    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"memberNo":[LoginDTO sharedInstance].memberNo,
                                           
                                           @"time":time
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getIntegralByMonth,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark- 3.37	小B消费积分记录查询接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetIntegralListWithTime:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"memberNo":[LoginDTO sharedInstance].memberNo
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getIntegralList,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}

#pragma mark- 3.38	图片上传接口(注意：为了简化接口,调整上传接口参数传递方式：tokenId、appType、type使用url方式,暂时不考虑参数签名)
+ (BCSHttpRequestStatus)sendHttpRequestForImgaeUploadWithAppType:(NSString *)appType type:(NSString *)type orderCode:(NSString *)orderCode goodsNo:(NSString *)goodsNo file:(NSData *)file  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    
    if (nil == appType || appType.length<1 || nil == type || type.length<1 || nil == file ) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    if (([type isEqualToString:@"5"]) &&(orderCode == nil)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    if (([type isEqualToString:@"3"]) &&(goodsNo == nil)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?tokenId=%@&appType=%@&type=%@&orderCode=%@&goodsNo=%@",host,imageUpload,[LoginDTO sharedInstance].tokenId,appType,type,orderCode,goodsNo];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:requestStr]
                                                               cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                           timeoutInterval:httpRequestTimeoutInterval];
    
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    
    //一连串上传头标签
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[@"Content-Disposition: form-data; name=userfile; filename=vim_go.png\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[NSData dataWithData:file]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    AFHTTPRequestOperation *httpRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    httpRequestOperation.securityPolicy.allowInvalidCertificates = YES;
    
    [httpRequestOperation setCompletionBlockWithSuccess:success failure:failure];
    
    [httpRequestOperation start];
    
    return BCSHttpRequestStatusStable;
}


#pragma mark-3.39	付费下载
+ (BCSHttpRequestStatus)sendHttpRequestForPayDownloadSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"memberNo":[LoginDTO sharedInstance].memberNo,
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,payDownload,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}


#pragma mark-3.40 采购单列表
+ (BCSHttpRequestStatus)sendHttpRequestForOrderListWithOrderStatus:(NSString *)orderStatus pageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == orderStatus) {
        orderStatus = @"";
    }
    if ([orderStatus isEqualToString:@"7"]) {
        orderStatus = @"";
        
    }
    
    if (nil == pageNo) {
        pageNo = [NSNumber numberWithInteger:1];
    }
    
    if (nil == pageSize) {
        pageSize = [NSNumber numberWithInteger:20];
    }
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"memberNo":[LoginDTO sharedInstance].memberNo,
                                        
                                           @"pageNo":pageNo.stringValue,
                                           
                                           @"pageSize":pageSize.stringValue,
                                           @"orderStatus":orderStatus
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,orderList,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}

#pragma mark-3.41	采购单详情
+ (BCSHttpRequestStatus)sendHttpRequestForOrderDetailWithOrderCode:(NSString *)orderCode success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == orderCode ||!([LoginDTO sharedInstance].tokenId)) {

        return  BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"memberNo":[LoginDTO sharedInstance].memberNo,
                                           
                                           @"orderCode":orderCode,
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,orderDetail,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}



//#pragma mark-3.42	加入采购车
+ (BCSHttpRequestStatus)sendHttpRequestForCartAdd:(CartAddDTO *)cartAddDTO success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    if (cartAddDTO.IsLackParameter == YES ||!([LoginDTO sharedInstance].tokenId)) {

        return BCSHttpRequestParameterIsLack;
    }
    NSLog(@"%@",cartAddDTO);
    NSString *timestamp =[HttpManager getTimesTamp];

    NSDictionary *parameterWithOutSign = @{

                                           @"tokenId":[LoginDTO sharedInstance].tokenId,

                                           @"merchantNo":cartAddDTO.merchantNo,

                                           @"goodsNo":cartAddDTO.goodsNo,

                                           @"cartType":cartAddDTO.cartType,

                                           @"price":cartAddDTO.price.stringValue,
                                           
                                           @"totalQuantity":cartAddDTO.totalQuantity.stringValue,
                                           
                                           @"skuList":cartAddDTO.skuDTOList,
                                           
                                           };

    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];

    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];

    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,cartAdd,sign];


    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];

    return BCSHttpRequestStatusStable;

}
//#pragma mark-3.5	批量加入采购车
+ (BCSHttpRequestStatus)sendHttpRequestForCartAddList:(NSArray *)cartAddArray success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSMutableArray *arrCarDic =[[NSMutableArray alloc] initWithCapacity:0];
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    
    for (CartAddDTO *cartAddDTO in cartAddArray) {
        if (cartAddDTO.IsLackParameter == YES) {
            
            return BCSHttpRequestParameterIsLack;
        }
        NSDictionary *dicCar = @{
                                 
                                 @"merchantNo":cartAddDTO.merchantNo,
                                 
                                 @"goodsNo":cartAddDTO.goodsNo,
                                 
                                 @"cartType":cartAddDTO.cartType,
                                 
                                 @"price":cartAddDTO.price.stringValue,
                                 
                                 @"totalQuantity":cartAddDTO.totalQuantity.stringValue,
                                 
                                 @"skuList":cartAddDTO.skuDTOList,
                                 };
        [arrCarDic addObject:dicCar];
    }
    


    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"cartParamList":arrCarDic,

                                           };
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameterWithOutSign
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,cartbatchAdd,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}
#pragma mark-3.43	采购车列表
+ (BCSHttpRequestStatus)sendHttpRequestForCartListSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"memberNo":[LoginDTO sharedInstance].memberNo,
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,cartList,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.44	更新采购车商品
+ (BCSHttpRequestStatus)sendHttpRequestForCartUpdateSuccess:(CartUpdateDTO *)cartUpdateDTO success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (cartUpdateDTO.IsLackParameter == YES ||!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"memberNo":[LoginDTO sharedInstance].memberNo,
                                           
                                           @"goodsNo":cartUpdateDTO.goodsNo,
                                           
                                           @"cartType":cartUpdateDTO.cartType,
                                           
                                           @"skuNo":cartUpdateDTO.skuNo,
                                           
                                           @"skuName":cartUpdateDTO.skuName,
                                           
                                           @"totalQuantityOnGoods":cartUpdateDTO.totalQuantityOnGoods,
                                           
                                           @"newQuantity":cartUpdateDTO.NewQuantity,
                                           
                                           @"type":cartUpdateDTO.type
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,cartUpdate,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark 3.45	选择结算商品/采购单确认
+ (BCSHttpRequestStatus)sendHttpRequestForGetCartConfirmWithCartKeyList:(NSArray *)cartKeyList templateIds:(NSArray *)templateIds provinceNo:(NSString *)provinceNo memberNo:(NSString *)memberNo  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == cartKeyList ||!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    if (provinceNo == nil) {
        provinceNo = @"";
    }
    if (memberNo == nil) {
        memberNo = @"";
    }
    
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"memberNo":[LoginDTO sharedInstance].memberNo,
                                           
                                           @"cartkeyList":cartKeyList,
                                           @"provinceNo":provinceNo,
                                           @"memberNo":memberNo,
                                           @"templateIds":templateIds
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSLog(@"parameterWithOutSign = %@",parameterWithOutSign);
    
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,cartConfirmGet,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}

#pragma mark-3.46	生成采购单
+ (BCSHttpRequestStatus)sendHttpRequestForOrderAddSuccess:(NSNumber* )addressId success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"memberNo":[LoginDTO sharedInstance].memberNo,
                                           
                                           @"addressId":addressId.stringValue
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,orderAdd,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.47	获取支付方式
+ (BCSHttpRequestStatus)sendHttpRequestForPayGetMethodSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"memberNo":[LoginDTO sharedInstance].memberNo,
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,payGetMethod,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.48	支付密码验证
+ (BCSHttpRequestStatus)sendHttpRequestForPaypasswdVerifyWithPassword:(NSString *)password success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == password || password.length<1 ||!([LoginDTO sharedInstance].tokenId)) {

        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"memberNo":[LoginDTO sharedInstance].memberNo,
                                           
                                           @"password":[[password MD5Hash]lowercaseString]
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,payPasswdVerify,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.49	创建支付密码
+ (BCSHttpRequestStatus)sendHttpRequestForPaypasswdAddWithPassword:(NSString *)password repeatPassword:(NSString *)repeatPassword success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == password || password.length<1 || nil == repeatPassword || repeatPassword.length<1 ||!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"memberNo":[LoginDTO sharedInstance].memberNo,
                                           
                                           @"password":[[password MD5Hash]lowercaseString],
                                           
                                           @"repeatPassword":[[repeatPassword MD5Hash]lowercaseString]
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,payPasswdAdd,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.50	余额查询
+ (BCSHttpRequestStatus)sendHttpRequestForGetPayBalance:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
  {
      if (!([LoginDTO sharedInstance].tokenId)) {
          
          return BCSHttpRequestParameterIsLack;
      }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"memberNo":[LoginDTO sharedInstance].memberNo
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,payBalance,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.51	支付接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetPayPay:(PayPayDTO *)payPayDTO success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (YES == payPayDTO.IsLackParameter ||!([LoginDTO sharedInstance].tokenId)) {

        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *balanceAmount = @"";
    NSString *payAmount = @"";
   
    
    if (payPayDTO.balanceAmount != nil) {
        balanceAmount = [payPayDTO.balanceAmount stringValue];
    }
    if (payPayDTO.payAmount != nil) {
        payAmount = [payPayDTO.payAmount stringValue];
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    
    DebugLog(@"payMethod = %@", payPayDTO.payMethod);
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"tradeNo":payPayDTO.tradeNo,
                                           @"useBalance":payPayDTO.useBalance,
                                           @"balanceAmount":balanceAmount,
                                           @"password":[[payPayDTO.password MD5Hash] lowercaseString],
                                           @"payMethod":payPayDTO.payMethod,
                                           @"payAmount":payAmount
                                          
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getPayPay,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.52	创建支付交易单
+ (BCSHttpRequestStatus)sendHttpRequestForPaytradeAddSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"memberNo":[LoginDTO sharedInstance].memberNo,
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,paytradeAdd,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.53	采购商等级权限说明接口
+ (BCSHttpRequestStatus)sendHttpRequestForMemberPermissionListSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"memberNo":[LoginDTO sharedInstance].memberNo,
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,memberPermissionList,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.54 查询是否有支付密码
+ (BCSHttpRequestStatus)sendHttpRequestForGetIsHasPaymentPassword:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"memberNo":[LoginDTO sharedInstance].memberNo,
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,hasPaymentPassword,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.55 删除采购车中的商品
+ (BCSHttpRequestStatus)sendHttpRequestForCartDelete:(NSString *)goodsNo cartType:(NSString*)cartType success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if([goodsNo isEqualToString:@""]||!([LoginDTO sharedInstance].tokenId)) {
   
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"memberNo":[LoginDTO sharedInstance].memberNo,
                                           
                                           @"goodsNo":goodsNo,
                                           
                                           @"cartType":cartType
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,cartDelete,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.56	设置已签收接口
+ (BCSHttpRequestStatus)sendHttpRequestForOrderReceived:(NSString *)orderCode success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if([orderCode isEqualToString:@""]||!([LoginDTO sharedInstance].tokenId))
    {
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"orderCode":orderCode
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,orderReceived,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.57	取消未付款采购单
+ (BCSHttpRequestStatus)sendHttpRequestForOrderCancelUnpaid:(NSString *)orderCode success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if([orderCode isEqualToString:@""]||!([LoginDTO sharedInstance].tokenId)) {
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"memberNo":[LoginDTO sharedInstance].memberNo,
                                           
                                           @"orderCode":orderCode
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,cancelUnpaid,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.58	小B商品补货列表接口( 按商家时间倒序取)
+ (BCSHttpRequestStatus)sendHttpRequestForGetGoodsReplenishmentByMerchant:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"memberNo":[LoginDTO sharedInstance].memberNo
                                           
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getGoodsReplenishmentByMerchant,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}





#pragma mark - 临时请求数据


+ (BCSHttpRequestStatus)sendHttpRequestForTempPhoneAndTypeMerchant:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           
                                           @"phone":@"13146976021",
                                           @"type":@"50"
                                           
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"http://116.31.82.98:8289/capi/sms/send?sign=%@",sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}






#pragma mark-3.59	全店批发条件校验接口
+ (BCSHttpRequestStatus)sendHttpRequestForSetCartWholeSaleCondition:(NSArray *)wholesaleConditionArray success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if([wholesaleConditionArray count] == 0 || wholesaleConditionArray == nil||!([LoginDTO sharedInstance].tokenId)) {

         return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"cartCountList":wholesaleConditionArray
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,wholesaleCondition,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}



#pragma mark-3.60	获取最新版本
+ (BCSHttpRequestStatus)sendHttpRequestForGetAppVersion:(NSString *)userType systemType:(NSString *)systemType success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([userType isEqualToString:@""]||[systemType isEqualToString:@""]) {
        
        return BCSHttpRequestParameterIsLack;
    }

    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"userType":userType,
                                           
                                           @"systemType":systemType
                                           
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getAppVersion,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.62	小B意见反馈
+ (BCSHttpRequestStatus)sendHttpRequestForaddFeedback:(NSString *)type content:(NSString *)content success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([type isEqualToString:@""]||[content isEqualToString:@""]||!([LoginDTO sharedInstance].tokenId)) {
 
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"type":type,
                                           
                                           @"content":content
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,addFeedback,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.63	创建虚拟商品采购单
+ (BCSHttpRequestStatus)sendHttpRequestForaddVirtualOrder:(NSNumber *)piece goodsNo:(NSString *)goodsNo skuNo:(NSString *)skuNo serviceType:(NSNumber *)serviceType success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"piece":piece.stringValue,
                                           
                                           @"goodsNo":goodsNo,
                                           
                                           @"skuNo":skuNo,
                                           
                                           @"serviceType":serviceType.stringValue
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,addVirtualOrder,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];

    return BCSHttpRequestStatusStable;
}
+ (BCSHttpRequestStatus)sendHttpRequestForaddVirtualOrder:(NSNumber *)piece goodsNo:(NSString *)goodsNo skuNo:(NSString *)skuNo serviceType:(NSNumber *)serviceType depositAmount:(NSNumber *)amount success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    NSString *pieceStr = [NSString stringWithFormat:@"%d",piece.intValue];
    
    
    if (pieceStr == nil) {
        pieceStr = @"";
    }
    if (goodsNo == nil) {
        goodsNo = @"";
        
    }
    if (skuNo == nil) {
        skuNo = @"";
    }
    
    NSString *serviceTypeStr = [NSString stringWithFormat:@"%d",serviceType.intValue];
    
    if (serviceTypeStr == nil) {
        serviceTypeStr  = @"";
        
    }
    
    
    if (amount == nil) {
        amount = [NSNumber numberWithInt:0];
        
    }
    
    
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"piece":pieceStr,
                                           
                                           @"goodsNo":goodsNo,
                                           
                                           @"skuNo":skuNo,
                                           
                                           @"serviceType":serviceTypeStr,
                                           
                                           @"depositAmount":amount
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,addVirtualOrder,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}
#pragma mark-3.63	获取商品分享链接
+ (BCSHttpRequestStatus)sendHttpRequestForGetGoodsShareLink:(NSString *)goodsNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                            
                                           @"goodsNo":goodsNo,
                                        
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getGoodsShareLink,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.64	预付货款收支记录接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetPaymentsRecords:(NSString *)type pageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"type":type,
                                           
                                           @"pageNo":pageNo.stringValue,
                                           
                                           @"pageSize":pageSize.stringValue
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getPaymentsRecords,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.65	采购单记录接口（按商家查询）
+ (BCSHttpRequestStatus)sendHttpRequestForGetOrderByMerchant:(NSString *)merchantNo pageNo:(NSNumber *)pageNo  pageSize:(NSNumber *)pageSize success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"merchantNo":merchantNo,
                                           
                                           @"pageNo":pageNo.stringValue,
                                
                                           @"pageSize":pageSize.stringValue
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getOrderByMerchant,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.66	再次支付接口（采购单列表页面支付）
+ (BCSHttpRequestStatus)sendHttpRequestForConfirmPay:(NSString *)orderCode success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"orderCode":orderCode,
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,confirmPay,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.67	询单获取商家聊天帐号接口
/*
+ (BCSHttpRequestStatus)sendHttpRequestForGetMerchantRelAccount:(NSString *)merchantNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];

    if (merchantNo == nil) {
        merchantNo = @"";
        
    }
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"merchantNo":merchantNo,
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getMerchantRelAccount,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}
 */
//#pragma mark - 询单客服 获取 客服聊天账号接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetMerchantRelAccount:(NSString *)merchantNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (!([LoginDTO sharedInstance].tokenId)||!merchantNo) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                         @"merchantNo":merchantNo
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getCustomerAccount,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}


#pragma mark-3.68	获取支付状态接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetPaymentStatus:(NSString *)tradeNo payMethod:(NSString *)payMethod success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"tradeNo":tradeNo,
                                           
                                           @"payMethod":payMethod,
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getPaymentStatus,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}
#pragma mark-3.69	消息推送（IOS）
+(BCSHttpRequestStatus)sendHttpRequestForGetChatPusher:(NSNumber *)type title:(NSString *)title acountType:(NSString *)acountType acounts:(NSString *)acounts targets:(NSString *)targets success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if (type == nil || title == nil || acountType == nil || acounts == nil || targets ==nil||!([LoginDTO sharedInstance].tokenId)) {
  
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"type":type.stringValue,
                                           
                                           @"title":title,
                                           
                                           @"acountType":acountType,
                                           
                                           @"acounts":acounts,
                                           
                                           @"targets":targets
                                           };
    
    NSLog(@"parameterWithOutSign = %@",parameterWithOutSign);
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,chatPusher,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}


+ (BCSHttpRequestStatus)sendHttpRequestFeedBackTypeSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"feedBackType":@"1"
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,feedbackType,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.70	小B设置延迟收货操作
+ (BCSHttpRequestStatus)sendHttpRequestForSetOrderAutoConfirm:(NSString *)orderCode success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"orderCode":orderCode
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,setOrderAutoConfirm,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}


#pragma mark 3.71  预付货款充值记录
+(BCSHttpRequestStatus)sendHttpRequestForPaymentRecordPageNo:(NSNumber *)PageNo pageSize:(NSNumber *)pageSize success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    if (PageNo == nil) {
        PageNo = [NSNumber numberWithInt:1];
    }
    if (pageSize == nil) {
        pageSize = [NSNumber numberWithInt:20];
    }

    NSString *timestamp =[HttpManager getTimesTamp];

    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId
                                             };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,paymentRecord,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    return BCSHttpRequestStatusStable;
    
}


#pragma  mark  3.72 下载次数购买记录

+(BCSHttpRequestStatus)sendHttpRequestForBuyRecordPageNo:(NSNumber *)PageNo pageSize:(NSNumber *)pageSize  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    if (PageNo == nil) {
        PageNo = [NSNumber numberWithInt:1];
    }
    if (pageSize == nil) {
        pageSize = [NSNumber numberWithInt:20];
    }
    
    

    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"PageNo":PageNo,
                                           @"pageSize":pageSize
                                            };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,buyRecord,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    return BCSHttpRequestStatusStable;
    
}

#pragma  mark 3.81	小B预付货款获取升级列表接口



+(BCSHttpRequestStatus)sendHttpRequestForPaymentUpgradeListSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId};
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,paymentUpgradeList,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    return BCSHttpRequestStatusStable;
    
    
}


#pragma mark 3.82	小B预付货款金额校验接口

+(BCSHttpRequestStatus)sendHttpRequestForpaymentCheckMoneylevel:(NSNumber *)levelNub amount:(NSNumber *)amountNub success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
 
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"level":levelNub,
                                           @"amount":amountNub
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,paymentCheckMoney,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    return BCSHttpRequestStatusStable;
    

}
#pragma  mark 3.83	小B预付货款充值接口

+(BCSHttpRequestStatus)sendHttpRequestForPaymentChargeBankCode:(NSString *)bankCode bankName:(NSString *)bankName level:(NSNumber *)level amount:(NSNumber*)amount userName:(NSString *)userName tradeNo:(NSString *)tradeNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
 
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"upgradeLevel":level,
                                           @"amount":amount,
                                           @"bankCode":bankCode,
                                           @"bankName":bankName,
                                           @"userName":userName,
                                           @"tradeNo":tradeNo,
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,paymentcharge,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    return BCSHttpRequestStatusStable;

}
#pragma  mark  3.85 第三方平台

+(BCSHttpRequestStatus)sendHttpRequestForThirdPartiesType:(NSString *)type    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"type":type
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,thirdParties,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    return BCSHttpRequestStatusStable;
    
}
#pragma mark 3.86 小B获取预付货款银行列表接口 
+(BCSHttpRequestStatus)sendHttpRequestForbankCardMessageSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,bankCardMessage,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    return BCSHttpRequestStatusStable;

}
#pragma mark 3.87 小B预付货款充值记录接口(银行转帐)
+(BCSHttpRequestStatus)sendHttpRequestForCreditTransfer:(NSDictionary *)upDic    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{


    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign =upDic;
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,creditTransfer,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;


}

#pragma mark 3.88 小B预付货款充值记录明细接口(银行转帐)
+(BCSHttpRequestStatus)sendHttpRequestForCreditTransferDetail:(NSDictionary *)upDic    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign =upDic;
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,creditTransferDetail,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;

    

}

#pragma mark 3.89 删除银行转账记录接口(审核不通过)
+(BCSHttpRequestStatus)sendHttpRequestForDeleteCreditTransfer:(NSDictionary *)upDic    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{


    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign =upDic;
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,deleteCreditTransfer,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    



}
#pragma  mark  3.90 注册按钮显示接口
+(BCSHttpRequestStatus)sendHttpRequestForSwitchsuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    
    NSString *timestamp =[HttpManager getTimesTamp];
    NSDictionary *parameterWithOutSign = @{
                                           //                                           @"tokenId":[LoginDTO sharedInstance].tokenId
                                           };
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,switchUrl,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    return BCSHttpRequestStatusStable;
    
}
#pragma mark 3.95 小B商家收藏新增接口
+(BCSHttpRequestStatus)sendHttpRequestForAddMerchantFavorite:(NSString *)merchantNo   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    NSDictionary *parameterWithOutSign = @{
                                            @"tokenId":[LoginDTO sharedInstance].tokenId,
                                            @"merchantNo":merchantNo
                                           };
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,addMerchantFavorite,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    return BCSHttpRequestStatusStable;
    
}
#pragma mark 3.96 小B商家收藏取消接口
+(BCSHttpRequestStatus)sendHttpRequestForDelMerchantFavorite:(NSString *)merchantNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"merchantNo":merchantNo
                                           };
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,delMerchantFavorite,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    return BCSHttpRequestStatusStable;
    
    
}

#pragma mark -  3.0.0的接口

#pragma makrk 3.4 查询热门店铺标签接口
+(BCSHttpRequestStatus)sendHttpRequestForHotLabelListSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId
                                           };
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getHotLabelList,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    return BCSHttpRequestStatusStable;


    
    
}
#pragma mark 3.2 小B频道接口
+(BCSHttpRequestStatus)sendHttpRequestFoChannelListSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    if ([LoginDTO sharedInstance].tokenId == nil || [LoginDTO sharedInstance].tokenId.length <= 0) {
        
        return BCSHttpRequestStatusHaveNotLogin;
    }
    
    
    NSString *timestamp =[HttpManager getTimesTamp];
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId
                                           };
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,channelListUrl,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    return BCSHttpRequestStatusStable;


}

#pragma mark 3.3	小B频道商品列表接口
+(BCSHttpRequestStatus)sendHttpRequestFoChannelGoodsListWithChannelId:(NSNumber *)channelId withRangeFlag:(NSString *)rangeFlag  withPageNo:(NSNumber *)pageNo withPageSize:(NSNumber *)pageSize  Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    if ([LoginDTO sharedInstance].tokenId == nil || [LoginDTO sharedInstance].tokenId.length <= 0) {
        
        return BCSHttpRequestStatusHaveNotLogin;
    }
    
    
    NSString *timestamp =[HttpManager getTimesTamp];
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"channelId":channelId,
                                           @"rangeFlag":rangeFlag,
                                           @"pageNo":pageNo,
                                           @"pageSize":pageSize
                                           };
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,channelGoodsListUrl,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    return BCSHttpRequestStatusStable;



}

#pragma mark 3.7  合并采购单再次支付接口

+(BCSHttpRequestStatus)sendHttpRequestForMulitiConfirmPayOrderCodes:(NSString *)orderCodes  Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil || [LoginDTO sharedInstance].tokenId.length <= 0) {
        
        return BCSHttpRequestStatusHaveNotLogin;
    }
    
    
    NSString *timestamp =[HttpManager getTimesTamp];
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"orderCode":orderCodes
    
                                           };
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,paymulitiConfirmPay,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    return BCSHttpRequestStatusStable;
    
    
    
}





#pragma mark 3.8	小B搜索商家列表接口
+(BCSHttpRequestStatus)sendHttpRequestFoSeachMerchantListWithQueryParam:(NSString *)queryParam  withCategoryNo:(NSString *)categoryNo withPageNo:(NSNumber *)pageNo withPageSize:(NSNumber *)pageSize  Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    if ([LoginDTO sharedInstance].tokenId == nil || [LoginDTO sharedInstance].tokenId.length <= 0) {
        
        return BCSHttpRequestStatusHaveNotLogin;
    }
    
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSMutableDictionary * parameterWithOutSign = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameterWithOutSign setObject:[LoginDTO sharedInstance].tokenId forKey:@"tokenId"];
    [parameterWithOutSign setObject:pageNo forKey:@"pageNo"];
    [parameterWithOutSign setObject:pageSize forKey:@"pageSize"];

    if (queryParam) {//!搜索
        
        [parameterWithOutSign setObject:queryParam forKey:@"queryParam"];
    }
    
    if (categoryNo) {//!筛选
        
        [parameterWithOutSign setObject:categoryNo forKey:@"categoryNo"];
    }
    
//    NSDictionary *parameterWithOutSign = @{
//                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
//                                           @"queryParam":queryParam,
//                                           @"pageNo":pageNo,
//                                           @"pageSize":pageSize
//                                           };
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,seachMerchantListUrl,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;


}
#pragma mark 3.9	小B查询商家10条商品数据接口
+(BCSHttpRequestStatus)sendHttpRequestFoQueryGoodsTenNum:(NSString *)merchantNo    Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    if ([LoginDTO sharedInstance].tokenId == nil || [LoginDTO sharedInstance].tokenId.length <= 0) {
        
        return BCSHttpRequestStatusHaveNotLogin;
    }
    
    
    NSString *timestamp =[HttpManager getTimesTamp];
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"merchantNo":merchantNo
                                           };
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,queryGoodsTenNumUrl,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;


}

#pragma mark 3.10	小B搜索商品列表接口
+(BCSHttpRequestStatus)sendHttpRequestFoSeachGoodsList:(NSNumber *)pageNo withPageSize:(NSNumber *)pageSize withQueryParam:(NSString *)queryParam withRangeFlag:(NSString *)rangeFlag  withGoodsSortDTO:(GoodsSortDTO *)sortDTO  Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    if ([LoginDTO sharedInstance].tokenId == nil || [LoginDTO sharedInstance].tokenId.length <= 0) {
        
        return BCSHttpRequestStatusHaveNotLogin;
    }
    
    //!上新时间 -15:15天内，15:15天前，20:20天前，30:30天前
    NSString * upDayNum = sortDTO.upDayNum;
    //!价格区间最小价格
    NSString * minPrice = sortDTO.minPrice;
    //!价格区间最大价格
    NSString * maxPrice = sortDTO.maxPrice;

    //!排序 1按时间，2按销量，3按价格,4推荐（desc）
    NSString * orderByField = sortDTO.orderByField;
    //!desc降序 asc 升序
    NSString * orderBy = sortDTO.orderBy;

    if (upDayNum == nil) {
        
        upDayNum = @"";
    }
    
    
    if (minPrice == nil) {
        
        minPrice = @"";
    }
    
    if (maxPrice == nil) {
        
        maxPrice = @"";
    }
    
    if (orderByField == nil) {//要求排序的类型为空，就不需要传是升序还是降序
        
        orderByField = @"";
        
    }
    
    if (orderBy == nil) {
        
        orderBy = @"";
    }
    
    
    
    
    NSString *timestamp =[HttpManager getTimesTamp];
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"pageNo":pageNo,
                                           @"pageSize":pageSize,
                                           @"queryParam":queryParam,
                                           @"rangeFlag":rangeFlag,
                                           
                                           @"upDayNum":upDayNum,
                                           @"minPrice":minPrice,
                                           @"maxPrice":maxPrice,
                                           @"orderByField":orderByField,
                                           @"orderBy":orderBy

                                           };
    
    
    DebugLog(@"parameterWithOutSign:%@", parameterWithOutSign);
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,seachGoodsListUrl,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    


}


#pragma mark 3.18  小B申请退换货接口

//orderRefundApply
+(BCSHttpRequestStatus)sendHttpRequestForRefundApplyOrderCode:(NSString *)orderCode refundType:(NSString *)refundType refundReason:(NSString *)refundReason goodsStatus:(NSString *)goodsStatus refundFee:(NSNumber *)refundFee remark:(NSString *)remark pics:(NSString *)pics  Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil || [LoginDTO sharedInstance].tokenId.length <= 0) {
        
        return BCSHttpRequestStatusHaveNotLogin;
    }
    
    if (orderCode == nil) {
        orderCode = @"";
    }
    if (refundType == nil) {
        orderCode = @"";
    }
    if (refundReason == nil) {
        refundReason = @"";
    }
    if (goodsStatus == nil) {
        goodsStatus = @"";
    }

    if (remark == nil) {
        remark = @"";
    }
    if (pics== nil) {
        pics = @"";
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"orderCode":orderCode,
                                           @"refundType":refundType,
                                           @"refundReason":refundReason,
                                           @"goodsStatus":goodsStatus,
                                           @"refundFee":refundFee,
                                           @"remark":remark,
                                           @"pics":pics
                                           };
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,orderRefundApply,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}




#pragma mark -3.20  小B取消退换货接口

+(BCSHttpRequestStatus)sendHttpRequestForRefundCancelrefundNo:(NSString *)refundNo   Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil || [LoginDTO sharedInstance].tokenId.length <= 0) {
        
        return BCSHttpRequestStatusHaveNotLogin;
    }
    
    if (refundNo == nil) {
        refundNo = @"";
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"refundNo":refundNo
                                           
                                           };
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,orderRefundCancel,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}




#pragma mark 3.21查看退换货详情

+(BCSHttpRequestStatus)sendHttpRequestForRefundDetailOrderCode:(NSString *)orderCode   Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil || [LoginDTO sharedInstance].tokenId.length <= 0) {
        
        return BCSHttpRequestStatusHaveNotLogin;
    }
    
    if (orderCode == nil) {
        orderCode = @"";
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"orderCode":orderCode
                                           
                                           };
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,orderRefundDetail,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}

#pragma mark 小b退换货申请
+(BCSHttpRequestStatus)sendHttpRequestFororderRefundApply:(NSDictionary *)upDic   Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    
    NSString *timestamp =[HttpManager getTimesTamp];
    NSDictionary *parameterWithOutSign = upDic;
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,orderRefundApply,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}

#pragma mark 小b退换货申请 修改
+(BCSHttpRequestStatus)sendHttpRequestForOrderRefundApplyUpdate:(NSDictionary *)upDic   Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    NSString *timestamp =[HttpManager getTimesTamp];
    NSDictionary *parameterWithOutSign = upDic;
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,orderRefundUpdate,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}

#pragma mark 3.23	获取历史聊天列表信息（openfire）
+(BCSHttpRequestStatus)sendHttpRequestForGetChantListWithMemberNo:(NSString *)memberNo pageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize success:(void (^)(AFHTTPRequestOperation *, id))success  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    if ([LoginDTO sharedInstance].tokenId == nil || [[LoginDTO sharedInstance].tokenId isEqualToString:@""]) {
        
        return BCSHttpRequestStatusHaveNotLogin;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"memberNo":memberNo,
                                           @"pageNo":pageNo,
                                           @"pageSize":pageSize,
                                           };

    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,chatList,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}

#pragma mark 3.23	获取历史聊天详细信息（openfire）
+(BCSHttpRequestStatus)sendHttpRequestForGetChantHistoryWithUser:(NSString *)mearchanNo withTime:(NSString *)time pageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize success:(void (^)(AFHTTPRequestOperation *, id))success  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    if ([LoginDTO sharedInstance].tokenId == nil || [[LoginDTO sharedInstance].tokenId isEqualToString:@""]||[LoginDTO sharedInstance].memberNo ==nil) {
        
        return BCSHttpRequestStatusHaveNotLogin;
    }
//    NSDate* now = [NSDate date];
//    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
//    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
//    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    NSString* dateString = [fmt stringFromDate:now];
    
    NSString *timestamp =[HttpManager getTimesTamp];
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"memberNo":[LoginDTO sharedInstance].memberNo,
                                           @"merchantNo":mearchanNo,
                                           @"time":time,
                                           @"pageNo":pageNo,
                                           @"pageSize":pageSize,
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,chatHistorys,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}
#pragma mark 3.1	小B获取客服等待数量接口
+ (BCSHttpRequestStatus)sendHttpRequestForNumbWithJid:(NSString *)jid success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil || [LoginDTO sharedInstance].tokenId.length <= 0||jid ==nil) {
        
        return BCSHttpRequestStatusHaveNotLogin;
    }
    
    
    NSString *timestamp =[HttpManager getTimesTamp];
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"account":jid
                                           };
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,countChat,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
    
}

#pragma mark 3.26	小B获取广告路径接口
+ (BCSHttpRequestStatus)sendHttpRequestForAdvertUrl:(NSString *)positionAlias Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    if ([LoginDTO sharedInstance].tokenId == nil || [LoginDTO sharedInstance].tokenId.length <= 0) {
        
        return BCSHttpRequestStatusHaveNotLogin;
    }
    
    
    NSString *timestamp =[HttpManager getTimesTamp];
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"positionAlias":positionAlias
                                           
                                           };
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,advertUrl,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    

}
#pragma mark -3.27	小B推送数量清零接口
+ (BCSHttpRequestStatus)sendHttpRequestForclearBadgeCountSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil || [[LoginDTO sharedInstance].tokenId isEqualToString:@""]||[MyUserDefault defaultLoadAppSetting_loginPhone]== nil) {
        
        return BCSHttpRequestStatusHaveNotLogin;
    }
    
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"account":[MyUserDefault defaultLoadAppSetting_loginPhone],
                                           };
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,clearBadgeCount,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return  BCSHttpRequestStatusStable;
    
    
    
    
}

#pragma mark 3.99	App上报错误日志接口
+ (BCSHttpRequestStatus)sendHttpRequestForApperrorAddWithList:(NSMutableArray *)errorList     Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil || [[LoginDTO sharedInstance].tokenId isEqualToString:@""]) {
        
        return BCSHttpRequestStatusHaveNotLogin;
    }
    
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"logList":errorList
                                           };
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,appErrorAddUrl,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return  BCSHttpRequestStatusStable;
    
    
}


#pragma mark --------- 与h5交互
#pragma mark 商品运营层
+(void)getCustomGoodsRequestWebView:(UIWebView *)webView withUrl:(NSString *)requestUrl{

    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",hostNew,requestUrl]];
    
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
    
    //!删除缓存
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:req];

    [webView loadRequest:req];


}

//h5页面进行网络请求采用的方法
//订购过的商家
+(void)orderMerchantNetworkRequestWebView:(UIWebView *)webView
{
    NSString *file = [NSString stringWithFormat:@"%@%@%@",hostH5,[HttpManager h5_version],orderMerchantUrl];
    
    NSURL *url = [NSURL URLWithString:file];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
    [webView loadRequest:req];
}


//会员等级
+(void)membershipUpgradeNetworkRequestWebView:(UIWebView *)webView
{
    NSString *file = [NSString stringWithFormat:@"%@%@%@",hostH5,[HttpManager h5_version],membershipUpgradeUrl];
    NSURL *url = [NSURL URLWithString:file];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
    [webView loadRequest:req];

}


//收藏商品
+(void)collectionGoodNetworkRequestWebView:(UIWebView *)webView
{
    NSString *file = [NSString stringWithFormat:@"%@%@%@",hostH5,[HttpManager h5_version],collectionGoodsUrl];
    NSURL *url = [NSURL URLWithString:file];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
    [webView loadRequest:req];
}


//申请资料
+(void)applicationMaterialNetworkRequestWebView:(UIWebView *)webView
{
    NSString *file = [NSString stringWithFormat:@"%@%@%@",hostH5,[HttpManager h5_version],applicationMaterialsUrl];
    NSURL *url = [NSURL URLWithString:file];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
    [webView loadRequest:req];
}



//会员等级规则
+(void)membershipNetworkRequestWebView:(UIWebView *)webView
{
    NSString *file = [NSString stringWithFormat:@"%@%@%@%@&index=1",hostH5,[HttpManager h5_version],membershipGradeRulesUrl,fromParameter];
    
    NSURL *url = [NSURL URLWithString:file];
//    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
    [webView loadRequest:req];
    
    
}


//消费积分记录
+(void)scoreRecordRequestWebView:(UIWebView *)webView
{

    
    
    NSString *file = [NSString stringWithFormat:@"%@%@%@%@",hostH5,[HttpManager h5_version],scoreRecordUrl,fromParameter];
    
    NSURL *url = [NSURL URLWithString:file];
    //    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
    [webView loadRequest:req];

}


//交易流水
+(void)advancePaymentRequestWebView:(UIWebView *)webView
{
   
    
    
    NSString *file = [NSString stringWithFormat:@"%@%@%@%@",hostH5,[HttpManager h5_version],advancePaymentUrl,fromParameter];
    
    NSURL *url = [NSURL URLWithString:file];
    //    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
    [webView loadRequest:req];

    
    
    
}


//预付货款记录
+(void)paymentRecordRequestWebView:(UIWebView *)webView
{
    
   NSString *file = [NSString stringWithFormat:@"%@%@%@%@",hostH5,[HttpManager h5_version],paymentrecordUrl,fromParameter];
    NSURL *url = [NSURL URLWithString:file];
    //    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
    [webView loadRequest:req];

}

//!服务规则与协议
+(void)serviceRequestWebView:(UIWebView *)webView{

    NSString *file = [NSString stringWithFormat:@"%@%@%@%@",hostH5,[HttpManager h5_version],serviceUrl,fromParameter];
    
    NSURL *url = [NSURL URLWithString:file];
//    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
    [webView loadRequest:req];
    
    
}
//小B资讯详情页面
+ (void)AuditStatusRequestWebView:(UIWebView *)webView auditStatusID:(NSString *)auditStatusID
{
   NSString  *key=@"CFBundleShortVersionString";
    //加载程序中info.plist文件（获取当前软件的版本号）
    NSString *currentVerionCode=[NSBundle mainBundle].infoDictionary[key];
    
    NSString *file = [NSString stringWithFormat:@"%@%@%@",hostH5,[HttpManager h5_version],auditStatusID];
    NSURL *url = [NSURL URLWithString:file];
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
    [webView loadRequest:req];
}

//小b商圈
+(void)businessCircleRequestWebView:(UIWebView *)webView{


    NSString *file = [NSString stringWithFormat:@"%@%@%@",hostH5,[HttpManager h5_version],businessUrl];
    
    
    NSURL *url = [NSURL URLWithString:file];
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
    [webView loadRequest:req];


}

+ (void)businessCircleRequestWebView:(UIWebView *)webView requestUrl:(NSString *)requestUrl
{
    
    NSString *file = [NSString stringWithFormat:@"%@%@%@",hostH5,[HttpManager h5_version],requestUrl];
    
    
    NSURL *url = [NSURL URLWithString:file];
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
    [webView loadRequest:req];

}

#pragma mark !创建充值接口
+ (BCSHttpRequestStatus)sendHttpRequestForAddPrepay:(NSDictionary *)upDic success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = upDic;
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,addPrepay,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}
/**
 *  H5版本控制
 *
 *  @return 返回版本号  x_x_x
 */
 + (NSString *)h5_version
{
    AppInfoDTO * appInfo = [AppInfoDTO sharedInstance];
    NSString *version =  appInfo.appVersion;
    version = [version stringByReplacingOccurrencesOfString:@"." withString:@"_"];
    version = [NSString stringWithFormat:@"v%@/",version];
    return version;

}


#pragma mark =======快递网======

+ (BCSHttpRequestStatus)sendHttpRequestForExpressCode:(NSString *)shipperCode    logisticCode:(NSString *)logisticCode  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    if (!([LoginDTO sharedInstance].tokenId)) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"shipperCode":shipperCode,
                                           
                                           @"logisticCode":logisticCode
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,logistic,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}



+(NSString *)hostUrl{
    NSString *strUrl = [host stringByReplacingOccurrencesOfString:@"/api" withString:@""];
    return strUrl;
}



//申请资料
+(NSString *)applicationMaterialRequestWebView
{
    NSString *file = [NSString stringWithFormat:@"%@%@%@",hostH5,[HttpManager h5_version],applicationMaterialsUrl];
    
    return file;
}
//会员等级规则
+(NSString *)membershipRequestWebView
{
    NSString *file = [NSString stringWithFormat:@"%@%@%@%@&index=1",hostH5,[HttpManager h5_version],membershipGradeRulesUrl,fromParameter];
    
    
     return file;
}

//订购过的商家
+(NSString *)orderMerchantNetworkRequestWebView{
    NSString *file = [NSString stringWithFormat:@"%@%@%@",hostH5,[HttpManager h5_version],orderMerchantUrl];
    
    return file;
}

//收藏商品
+(NSString *)collectionGoodNetworkRequestWebView
{
    NSString *file = [NSString stringWithFormat:@"%@%@%@",hostH5,[HttpManager h5_version],collectionGoodsUrl];
    
    return file;
}
//消费积分记录
+(NSString *)scoreRecordRequestWebView
{
    
    NSString *file = [NSString stringWithFormat:@"%@%@%@%@",hostH5,[HttpManager h5_version],scoreRecordUrl,fromParameter];
    
    return file;
}
//交易流水
+(NSString *)advancePaymentRequestWebView{

    NSString *file = [NSString stringWithFormat:@"%@%@%@%@",hostH5,[HttpManager h5_version],advancePaymentUrl,fromParameter];
    return file;
}

//预付货款记录
+(NSString *)paymentRecordRequestWebView
{
    
    NSString *file = [NSString stringWithFormat:@"%@%@%@%@",hostH5,[HttpManager h5_version],paymentrecordUrl,fromParameter];
    
    return file;
    
}

//全部夏季的h5页面
+(NSString *)nextPageInterface
{
    NSString *file = [NSString stringWithFormat:@"%@%@",hostH5,[HttpManager h5_version]];
    
    return file;
}

//!服务规则与协议
+(NSString *)serviceRequestWebView{
    
    NSString *file = [NSString stringWithFormat:@"%@%@%@%@",hostH5,[HttpManager h5_version],serviceUrl,fromParameter];
    
    return file;
    
}

//会员等级
+(NSString *)membershipUpgradeNetworkRequestWebView
{
    NSString *file = [NSString stringWithFormat:@"%@%@%@",hostH5,[HttpManager h5_version],membershipUpgradeUrl];
    
    return file;
    
}

//获取次级页面
+(NSString *)accessSecondaryPageURL
{
    NSString *file = [NSString stringWithFormat:@"%@%@",hostH5,[HttpManager h5_version]];
    return file;
}

#pragma 获取省市区列表接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetAreaListSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                         
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,allCityList,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark 3.23	查询系统属性列表接口 判断是否请求新的省市区数据
+ (BCSHttpRequestStatus)sendHttpRequestForJudgeWheterGetNewExpressListSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    
//    if ([LoginDTO sharedInstance].tokenId == nil || [[LoginDTO sharedInstance].tokenId isEqualToString:@""]) {
//        
//        return BCSHttpRequestStatusHaveNotLogin;
//    }
    
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
//                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"propName":@"area.data.version"
                                           };
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,propertyListUrl,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return  BCSHttpRequestStatusStable;
    
}



@end

