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


//static const NSString *host = @"http://protal.zjsj1492.com/api/";

//static const NSString *host = @"http://183.61.244.243:8180/api/";
static const NSString *host = @"http://218.97.53.34/api/";
static const NSString *appSecret = @"1dfa5cd879df472484138b41dbb6197e";

static const NSTimeInterval httpRequestTimeoutInterval = 20.0f;

#pragma mark-接口
//3.1 登陆接口
static const NSString *login = @"/xb/user/login";

//3.2 注册接口-验证手机号并且发送验证码
static const NSString *registerMobile = @"/xb/user/registerMobile";

//3.3 设置密码-注册、忘记密码
static const NSString *setPassword = @"/xb/user/setPassword";

//3.4 根据父ID获取省市区列表接口
static const NSString *getAreaListByParentId = @"/xb/user/getAreaListByParentId";

//3.5 小B补充申请资料
static const NSString *addApplyInfo = @"/xb/user/addApplyInfo";

//3.6 小B查询申请资料
static const NSString *getApplyInfo = @"/xb/user/getApplyInfo";

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
static const NSString *imageUpload = @"image/upload";

//3.39	付费下载
static const NSString *payDownload = @"/xb/user/pay/download";

//3.40	订单列表
static const NSString *orderList = @"/xb/order/list";

//3.41	订单详情
static const NSString *orderDetail = @"/xb/order/detail";

//3.42	加入购物车
static const NSString *cartAdd = @"/xb/cart/add";

//3.43	购物车列表
static const NSString *cartList = @"/xb/cart/list";

//3.44	更新购物车商品
static const NSString *cartUpdate = @"/xb/cart/update";

//3.45	订单确认
static const NSString *cartConfirmGet = @"/xb/cart/confirm/get";

//3.46	生成订单
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

//3.55	删除购物车中的商品
static const NSString *cartDelete = @"/xb/cart/delete";

//3.56	设置已签收接口
static const NSString *orderReceived = @"/xb/order/received";

//3.57	取消未付款订单
static const NSString *cancelUnpaid = @"/xb/order/cancelUnpaid";

//3.58	小B商品补货列表接口( 按商家时间倒序取)
static const NSString *getGoodsReplenishmentByMerchant = @"/xb/goods/replenishmentByMerchant";

//3.59	全店批发条件校验接口
static const NSString *wholesaleCondition = @"/xb/cart/wholesaleCondition";

//3.61	获取最新版本
static const NSString *getAppVersion = @"/version/getAppVersion";

//3.62	小B意见反馈
static const NSString *addFeedback = @"/xb/user/addFeedback";

//3.63	创建虚拟商品订单
static const NSString *addVirtualOrder = @"/xb/order/addVirtualOrder";

//3.63	获取商品分享链接
static const NSString *getGoodsShareLink = @"/xb/goods/sharelink";

//3.64	预付货款收支记录接口
static const NSString *getPaymentsRecords = @"/xb/pay/paymentsRecords";

//3.65	订单记录接口（按商家查询）
static const NSString *getOrderByMerchant = @"/xb/order/byMerchant";

//3.66	订单记录接口（按商家查询）
static const NSString *confirmPay = @"/xb/pay/confirmPay";

//3.67	询单获取商家聊天帐号接口
static const NSString *getMerchantRelAccount = @"xb/merchant/getMerchantRelAccount";

//3.68	获取支付状态接口
static const NSString *getPaymentStatus = @"xb/pay/paymentStatus";

//3.69	消息推送（IOS）
static const NSString *chatPusher = @"/chat/pusher";

static const NSString *feedbackType = @"/feedback/getFeedBackTypeList";

//3.70	小B设置延迟收货操作
static const NSString* setOrderAutoConfirm = @"/xb/user/setOrderAutoConfirm";

@implementation HttpManager

/**
 *  获取当前时间戳
 *
 *  @return 返回当前时间戳
 */
+ (NSString *)getTimesTamp{
    
    NSDate *nowDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    dateFormatter.dateFormat = @"yyyyMMddHHmmssSSS";
    
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
                
                signStr = [NSString stringWithFormat:@"%@%@=%@",signStr,[compositorArray objectAtIndex:index],[currentDic objectForKey:[compositorArray objectAtIndex:index]]];
                
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
    
    NSMutableDictionary *necessaryParameters = [[NSMutableDictionary alloc]initWithObjectsAndKeys:appInfoDTO.deviceType,@"deviceType",appInfoDTO.deviceToken,@"deviceSn",appInfoDTO.imei,@"imei",appInfoDTO.appVersion,@"appVersion",appInfoDTO.iosVersion,@"iosVersion",appInfoDTO.appKey,@"appKey",timestamp,@"timestamp",appInfoDTO.appType,@"appType", nil];
    
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
            }
            else
            {
                signStr = [NSString stringWithFormat:@"%@%@=%@",signStr,[compositorArray objectAtIndex:i],[necessaryParameters objectForKey:[compositorArray objectAtIndex:i]]];
            }
        }
    }
    
    signStr = [NSString stringWithFormat:@"%@%@",signStr,appSecret];
    
    NSLog(@"signStr = %@",signStr);

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
    
    NSMutableDictionary *necessaryParameters = [[NSMutableDictionary alloc]initWithObjectsAndKeys:appInfoDTO.deviceType,@"deviceType",appInfoDTO.deviceToken,@"deviceSn",appInfoDTO.imei,@"imei",appInfoDTO.appVersion,@"appVersion",appInfoDTO.iosVersion,@"iosVersion",appInfoDTO.appKey,@"appKey",timestamp,@"timestamp",appInfoDTO.appType,@"appType", nil];
    
    [necessaryParameters addEntriesFromDictionary:parameter];
    
    NSLog(@"necessaryParameters = %@",necessaryParameters);
    
    //将字典转成字符串
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:necessaryParameters options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
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
    
    NSLog(@"requestStr = %@",requestStr);
    
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.4	根据父ID获取省市区列表接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetAreaListByParentIdWithParentId:(NSNumber *)parentId success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == parentId || parentId.stringValue.length<1) {
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.5	小B补充申请资料
+ (BCSHttpRequestStatus)sendHttpRequestForaddApplyInfoWithApplyInfo:(ApplyInfoDTO *)applyInfoDTO success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (YES == applyInfoDTO.IsLackParameter) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];

    NSDictionary *parameterWithOutSign = @{
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
                                            
                                            @"businessLicenseUrl":applyInfoDTO.businessLicenseUrl
                                            
                                            };
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,addApplyInfo,sign];
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
  
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.6 小B查询申请资料
+ (BCSHttpRequestStatus)sendHttpRequestForGetApplyInfoSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"memberNo":[LoginDTO sharedInstance].memberNo,
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getApplyInfo,sign];
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.7 小B验证邀请码
+ (BCSHttpRequestStatus)sendHttpRequestForVerifyRegisterKeyCode:(NSString *)keyCode mobilePhone:(NSString *)mobilePhone success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == keyCode || keyCode.length<1 || nil == mobilePhone || mobilePhone.length<1) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                            
                                            @"tokenId":[LoginDTO sharedInstance].tokenId,
                                            
                                            @"keyCode":keyCode,
                                            
                                            @"mobilePhone":mobilePhone
                                            
                                            };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,verifyRegisterKeyCode,sign];
    
    NSLog(@"requestStr = %@",requestStr);
    
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.9 用户修改密码接口
+ (BCSHttpRequestStatus)sendHttpRequestForModifyPasswordWithPhone:(NSString *)phone passwd:(NSString *)passwd oldpwd:(NSString *)oldpwd success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == phone || phone.length < 1 || nil == passwd || passwd.length < 1 || nil == oldpwd || oldpwd.length<1) {
        
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark- 3.10 用户修改支付密码接口
+ (BCSHttpRequestStatus)sendHttpRequestForPayPasswdUpdateWithPhone:(NSString *)phone password:(NSString *)password originalPassword:(NSString *)originalPassword success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    
    if (nil == phone || phone.length < 1 || nil == password || password.length < 1 || nil == originalPassword || originalPassword.length<1) {
        
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
    
    NSLog(@"requestStr = %@",requestStr);
    
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
    
    NSLog(@"requestStr = %@",requestStr);
    
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.13	个人中心主页接口
+ (BCSHttpRequestStatus)sendHttpRequestForPersonalCenterSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}

#pragma mark-3.14 商品分类接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetCategoryListWithMerchantNo:(NSString *)merchantNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == merchantNo) {
        
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
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getCategoryList,sign];
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark- 3.15 小B商品列表接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetGoodsListWithPageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize  merchantNo:(NSString *)merchantNo structureNo:(NSString *)structureNo rangeFlag:(NSString *)rangeFlag success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
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
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"pageNo":pageNo.stringValue,
                                           
                                           @"pageSize":pageSize.stringValue,
                                           
                                           @"merchantNo":merchantNo,
                                           
                                           @"structureNo":structureNo,
                                           
                                           @"rangeFlag":rangeFlag
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getGoodsList,sign];
    
    NSLog(@"requestStr = %@",requestStr);
    
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}

#pragma mark 3.17	小B获取商家邮费专拍商品接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetGoodsFeeInfo:(NSString *)merchantNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
   
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.17	小B商品详情接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetGoodsInfoDetailsWithGoodsNo:(NSString *)goodsNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == goodsNo || goodsNo.length<1) {
        
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;

}

#pragma mark-3.18	小B查看商家店铺列表接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetMerchantListWithMerchantNo:(NSString *)merchantNo pageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    if ([LoginDTO sharedInstance].tokenId == nil || [LoginDTO sharedInstance].tokenId.length <= 0) {
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
    
    NSLog(@"pageSize.stringValue = %@ ,pageNo.stringValue = %@",pageSize.stringValue,pageNo.stringValue);
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getMerchantList,sign];
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;

}

#pragma mark-3.19 小B查看商家店铺详情接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetMerchantShopDetailWithMerchantNo:(NSString *)merchantNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == merchantNo || merchantNo.length<1) {
        
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    
    return BCSHttpRequestStatusStable;

}

#pragma mark-3.20	小B商品收藏新增接口
+ (BCSHttpRequestStatus)sendHttpRequestForAddGoodsFavoriteWithGoodsNo:(NSString *)goodsNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == goodsNo || goodsNo.length<1) {
        
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;    
}

#pragma mark-3.21	小B商品收藏取消接口
+ (BCSHttpRequestStatus)sendHttpRequestForDelFavoriteWithGoodsNo:(NSString *)goodsNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == goodsNo || goodsNo.length<1) {
        
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}
#pragma mark-3.22	小B商品收藏列表接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetFavoriteListByTime:(NSString *)queryType success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.24	小B商品收藏列表接口(按商家排序)
+ (BCSHttpRequestStatus)sendHttpRequestForGetFavoriteListByMerchant:(NSString *)queryType success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
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
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getFavoriteListByMerchant,sign];
    
    NSLog(@"requestStr = %@",requestStr);
    
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.24	小B站内信阅读状态修改接口
+ (BCSHttpRequestStatus)sendHttpRequestForUpdateNoticeStatusWithInsideLetterID:(NSString *)insideLetterId success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == insideLetterId || insideLetterId.length<1) {
        
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.25	小B获取下载图片列表接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetDownloadImageList:(NSMutableArray *)imageDownloadArray  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == imageDownloadArray) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"list":imageDownloadArray
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getDownloadImageList,sign];
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}

#pragma mark-3.26	小B图片下载完成回调接口
+ (BCSHttpRequestStatus)sendHttpRequestForDownloadCompleteWithGoodsNo:(NSString *)goodsNo picType:(NSString *)picType success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == goodsNo || goodsNo.length<1 || nil == picType || picType.length<1) {
        
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
    
    NSLog(@"requestStr = %@",requestStr);
    
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.28	小B商品补货列表接口( 按购买时间倒序取)
+ (BCSHttpRequestStatus)sendHttpRequestForGetGoodsReplenishmentByTime:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
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
    
    NSLog(@"requestStr = %@",requestStr);
    
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}

#pragma mark-小B查看个人资料接口
+ (BCSHttpRequestStatus)sendHttpRequestGetMemberInfoSuccess:(void (^)(AFHTTPRequestOperation *operation,id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation,
                                                               NSError *error))failure{
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                 
                                 @"tokenId":[LoginDTO sharedInstance].tokenId,
                                 
                                 @"memberNo":[LoginDTO sharedInstance].memberNo,
                                 
                                 };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getMemberInfo,sign];
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.31	小B修改个人资料接口
+ (BCSHttpRequestStatus)sendHttpRequestForUpdateMemberDataWithUserInfoDTO:(MemberInfoDTO *)memberInfoDTO success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
//    if (YES == memberInfoDTO.IsLackParameter) {
//        
//        return BCSHttpRequestParameterIsLack;
//    }
    
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.32 小B保存收货地址
+ (BCSHttpRequestStatus)sendHttpRequestForAddConsignee:(ConsigneeAddressDTO *)consigneeAddressDTO success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (YES == consigneeAddressDTO.IsLackParameter) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"memberNo":[LoginDTO sharedInstance].memberNo,
                                           
                                           @"consigneeName":consigneeAddressDTO.consigneeName,
                                           
                                           @"consigneePhone":consigneeAddressDTO.consigneePhone,
                                           
                                           @"provinceNo":consigneeAddressDTO.provinceNo.stringValue,
                                           
                                           @"cityNo":consigneeAddressDTO.cityNo.stringValue,
                                           
                                           @"countyNo":consigneeAddressDTO.countyNo.stringValue,
                                           
                                           @"detailAddress":consigneeAddressDTO.detailAddress,
                                           
                                           @"postalCode":consigneeAddressDTO.postalCode,
                                           
                                           @"defaultFlag":consigneeAddressDTO.defaultFlag
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,consigneeAdd,sign];
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.33	小B收货地址列表接口
+ (BCSHttpRequestStatus)sendHttpRequestForConsigneeGetListSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,consigneeGetList,sign];
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.34	小B修改收货地址
+ (BCSHttpRequestStatus)sendHttpRequestForConsigneeUpdateWithConsigneeDTO:(ConsigneeDTO *)consigneeDTO success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (YES == consigneeDTO.IsLackParameter) {
        
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
                                           
                                           @"postalCode":consigneeDTO.postalCode,
                                           
                                           @"defaultFlag":consigneeDTO.defaultFlag
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,consigneeUpdate,sign];
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}

#pragma mark-3.35	小B删除收货地址
+ (BCSHttpRequestStatus)sendHttpRequestForConsigneeDelWithConsigneeID:(NSNumber *)consigneeID success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == consigneeID) {
        
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.36	小B消费积分记录按月统计接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetIntegralByMonthSuccess:(NSString *)time  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    
    if (nil == time || time.length<1) {
        
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark- 3.37	小B消费积分记录查询接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetIntegralListWithTime:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
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
    
    NSLog(@"requestStr = %@",requestStr);
    
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}


#pragma mark-3.40 订单列表
+ (BCSHttpRequestStatus)sendHttpRequestForOrderListWithOrderStatus:(NSString *)orderStatus pageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == orderStatus) {
        orderStatus = @"";
    }
    if (nil == pageNo) {
        pageNo = [NSNumber numberWithInteger:1];
    }
    
    if (nil == pageSize) {
        pageSize = [NSNumber numberWithInteger:20];
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"memberNo":[LoginDTO sharedInstance].memberNo,
                                           
                                           @"orderStatus":orderStatus,
                                           
                                           @"pageNo":pageNo.stringValue,
                                           
                                           @"pageSize":pageSize.stringValue
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,orderList,sign];
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.41	订单详情
+ (BCSHttpRequestStatus)sendHttpRequestForOrderDetailWithOrderCode:(NSString *)orderCode success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == orderCode) {
        
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}

//#pragma mark-3.42	加入购物车
+ (BCSHttpRequestStatus)sendHttpRequestForCartAdd:(CartAddDTO *)cartAddDTO success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    if (cartAddDTO.IsLackParameter == YES) {

        return BCSHttpRequestParameterIsLack;
    }

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

    NSLog(@"requestStr = %@",requestStr);

    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];

    return BCSHttpRequestStatusStable;

}

#pragma mark-3.43	购物车列表
+ (BCSHttpRequestStatus)sendHttpRequestForCartListSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.44	更新购物车商品
+ (BCSHttpRequestStatus)sendHttpRequestForCartUpdateSuccess:(CartUpdateDTO *)cartUpdateDTO success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (cartUpdateDTO.IsLackParameter == YES) {
        
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.45	选择结算商品/订单确认
+ (BCSHttpRequestStatus)sendHttpRequestForGetCartConfirmWithCartKeyList:(NSArray *)cartKeyList success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == cartKeyList) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"memberNo":[LoginDTO sharedInstance].memberNo,
                                           
                                           @"cartkeyList":cartKeyList
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,cartConfirmGet,sign];
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}

#pragma mark-3.46	生成订单
+ (BCSHttpRequestStatus)sendHttpRequestForOrderAddSuccess:(NSNumber* )addressId success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.47	获取支付方式
+ (BCSHttpRequestStatus)sendHttpRequestForPayGetMethodSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.48	支付密码验证
+ (BCSHttpRequestStatus)sendHttpRequestForPaypasswdVerifyWithPassword:(NSString *)password success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == password || password.length<1) {
        
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.49	创建支付密码
+ (BCSHttpRequestStatus)sendHttpRequestForPaypasswdAddWithPassword:(NSString *)password repeatPassword:(NSString *)repeatPassword success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == password || password.length<1 || nil == repeatPassword || repeatPassword.length<1) {
        
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.50	余额查询
+ (BCSHttpRequestStatus)sendHttpRequestForGetPayBalance:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
  {

    
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.51	支付接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetPayPay:(PayPayDTO *)payPayDTO success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (YES == payPayDTO.IsLackParameter) {
        
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.52	创建支付交易单
+ (BCSHttpRequestStatus)sendHttpRequestForPaytradeAddSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.53	采购商等级权限说明接口
+ (BCSHttpRequestStatus)sendHttpRequestForMemberPermissionListSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.54 查询是否有支付密码
+ (BCSHttpRequestStatus)sendHttpRequestForGetIsHasPaymentPassword:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.55 删除购物车中的商品
+ (BCSHttpRequestStatus)sendHttpRequestForCartDelete:(NSString *)goodsNo cartType:(NSString*)cartType success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if([goodsNo isEqualToString:@""])
    {
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.56	设置已签收接口
+ (BCSHttpRequestStatus)sendHttpRequestForOrderReceived:(NSString *)orderCode success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if([orderCode isEqualToString:@""])
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.57	取消未付款订单
+ (BCSHttpRequestStatus)sendHttpRequestForOrderCancelUnpaid:(NSString *)orderCode success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if([orderCode isEqualToString:@""])
    {
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.58	小B商品补货列表接口( 按商家时间倒序取)
+ (BCSHttpRequestStatus)sendHttpRequestForGetGoodsReplenishmentByMerchant:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.59	全店批发条件校验接口
+ (BCSHttpRequestStatus)sendHttpRequestForSetCartWholeSaleCondition:(NSArray *)wholesaleConditionArray success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if([wholesaleConditionArray count] == 0 || wholesaleConditionArray == nil)
    {
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
    
    NSLog(@"requestStr = %@",requestStr);
    
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.62	小B意见反馈
+ (BCSHttpRequestStatus)sendHttpRequestForaddFeedback:(NSString *)type content:(NSString *)content success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([type isEqualToString:@""]||[content isEqualToString:@""]) {
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.63	创建虚拟商品订单
+ (BCSHttpRequestStatus)sendHttpRequestForaddVirtualOrder:(NSNumber *)piece goodsNo:(NSString *)goodsNo skuNo:(NSString *)skuNo serviceType:(NSNumber *)serviceType success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.63	获取商品分享链接
+ (BCSHttpRequestStatus)sendHttpRequestForGetGoodsShareLink:(NSString *)goodsNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.64	预付货款收支记录接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetPaymentsRecords:(NSString *)type pageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.65	订单记录接口（按商家查询）
+ (BCSHttpRequestStatus)sendHttpRequestForGetOrderByMerchant:(NSString *)merchantNo  pageSize:(NSNumber *)pageSize success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"merchantNo":merchantNo,
                                
                                           @"pageSize":pageSize.stringValue
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getOrderByMerchant,sign];
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.66	再次支付接口（订单列表页面支付）
+ (BCSHttpRequestStatus)sendHttpRequestForConfirmPay:(NSString *)orderCode success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.67	询单获取商家聊天帐号接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetMerchantRelAccount:(NSString *)merchantNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"merchantNo":merchantNo,
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getMerchantRelAccount,sign];
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.68	获取支付状态接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetPaymentStatus:(NSString *)tradeNo payMethod:(NSString *)payMethod success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}
#pragma mark-3.69	消息推送（IOS）
+(BCSHttpRequestStatus)sendHttpRequestForGetChatPusher:(NSNumber *)type title:(NSString *)title acountType:(NSString *)acountType acounts:(NSString *)acounts targets:(NSString *)targets success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if (type == nil || title == nil || acountType == nil || acounts == nil || targets ==nil ) {
        
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}


+ (BCSHttpRequestStatus)sendHttpRequestFeedBackTypeSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.70	小B设置延迟收货操作
+ (BCSHttpRequestStatus)sendHttpRequestForSetOrderAutoConfirm:(NSString *)orderCode success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
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
    
    NSLog(@"requestStr = %@",requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}
@end
