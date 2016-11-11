
//
//  HttpManager.m
//  BuyerCenturySquare
//
//  Created by longminghong on 15/7/9.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "HttpManager.h"
#import "NSObject+PublicInterface.h"
#import "HttpMacro.h"
#import "AppInfoDTO.h"
#import "NSString+Hashing.h"
#import "LoginDTO.h"
#import "Reachability.h"
// !上线
//static const NSString *host = @"http://portal.zjsj1492.com/api";
//static const NSString *hostH5 = @"http://portal.zjsj1492.com/h5/ddop/seller/";
//static const NSString *hostbuyerH5 = @"http://portal.zjsj1492.com/h5/ddop/buyer/";

//!开发
//static const NSString *host = @"http://116.31.82.98:8289/api";
//static const NSString *hostH5 = @"http://116.31.82.98:8289/h5/ddop/seller/";
//static const NSString *hostbuyerH5 = @"http://116.31.82.98:8289/h5/ddop/buyer/";

//!测试
static const NSString *host = @"http://116.31.82.98:8189/api";
static const NSString *hostH5 = @"http://116.31.82.98:8189/h5/ddop/seller/";
static const NSString *hostbuyerH5 = @"http://116.31.82.98:8189/h5/ddop/buyer/";

//!首都在线
//static const NSString *host = @"http://mportal.zjsj1492.com/api";
//static const NSString *hostH5 = @"http://mportal.zjsj1492.com/h5/ddop/seller/";
//static const NSString *hostbuyerH5 = @"http://mportal.zjsj1492.com/h5/ddop/buyer/";


static const NSString *appSecret = @"1dfa5cd879df472484138b41dbb6197e";
static const NSTimeInterval httpRequestTimeoutInterval = 60.0f;


//请求接口

//与h5交互
//采购商
static const NSString *memberOfTrade = @"memberOfTrade.html";
//商家特权
static const NSString *privileges = @"privileges.html";
//采购商等级
static const NSString *purchaserLevel = @"privilegesOfMerchant.html";
//统计
static const NSString *statistics = @"statistics.html";
//消费积分查询记录
static const NSString *scoreQuery = @"jifen.html";

//采购商资料详情页面
static const NSString *memberDetail= @"memberDetail.html?m=";

//添加参数
static const NSString *parameterURL = @"?from=app";

//!服务与协议
static const NSString *serviceUrl = @"serviceRule.html";


//大B叮当商圈首页
static const NSString *businessHome = @"zone/default.html";

//大B资讯详情页面
static const NSString *zxDetail = @"zone/zxDetail.html?id=";

//大B测评详情页面
static const NSString *cpDetail = @"zone/cpDetail.html?id=";
//3.12	查询省市区列表接口
static const NSString *allCityList = @"/sys/getAreaAllList";



//3.1  大B登陆接口
static const NSString *login = @"/db/user/login";

//3.2	设置登录密码
static const NSString *setPassword = @"/db/user/setPassword";

//3.3   大B忘记密码校验接口-用于找回密码时校验手机号（手机号需要已经注册过）
static const NSString *forgetPwdCheck = @"/db/user/forgetPwdCheck";
//3.4	大B用户修改密码接口
static const NSString *updatePassword = @"/db/user/updatePassword";

//3.5	大B商家中心主页接口
static const NSString *getMerchantMain = @"/db/merchant/main";

//3.6 大B商家中心主页商品阅读状态修改接口
static const NSString *UpdateGoodsReadStatus = @"/db/goods/read/status/update";

//3.7	大B商家信息接口
static const NSString *getMerchantInfo = @"/db/merchant/info";

//3.8	更改营业状态（包括歇业时间）
static const NSString *getUpdateMerchantBusiness = @"/db/merchant/business/update";

//3.9	修改全店混批条件
static const NSString *getUpdateMerchantBatchlimit = @"/db/merchant/batchlimit/update";

//3.9	歇业记录查询接口
static const NSString *getMerchantCloseLog =   @"/db/merchant/getCloseLog";



//3.10	修改商家资料
static const NSString *getUpdateMerchantInfo = @"/db/merchant/info/update";
//3.66	大B和小B聊天推荐商品列表接口
static const NSString *getGoodsByChat = @"/db/goods/getGoodsByChat";
//3.11 大B获取商品分类接口
static const NSString *getGoodsCategoryList = @"/db/goods/getGoodsCategoryList";

//3.12	商品列表（店铺展示）接口
static const NSString *getShopGoodsList = @"/db/goods/shop/list";

//3.13	商品列表（可编辑）接口
static const NSString *getEditGoodsList = @"/db/goods/edit/list";

//3.1	商品手记详情预览
static const NSString *getCDetails =@"/db/goods/getCDetailsByGoodsNo";
//3.15	大B商品详情接口
static const NSString *getGoodsInfoList = @"/db/goods/getGoodsInfo";
//3.15	大B商品详情接口 3.0.0
static const NSString *getNewGoodsInfoList = @"/db/goods/details";

//3.16	大B商品修改接口
static const NSString *updateGoodsInfo = @"/db/goods/updateGoodsInfo";

//3.17   获取商家邮费专拍商品接口
static const NSString *getGoodsFeeInfo = @"/db/goods/getGoodsFeeInfo";

//3.17	大B商品上下架操作接口
static const NSString *updateGoodsStatus = @"/db/goods/updateGoodsStatus";

//3.18	大B站内信列表
static const NSString *getNoticeStationList = @"/db/notice/getNoticeStationList";

//3.19	大B站内信阅读状态修改接口
static const NSString *updateNoticeStatus = @"/db/notice/updateNoticeStatus";
//3.77	大B站内信未读数量
static const NSString *getStationTopByDb = @"/db/notice/getStationTopByDb";
//3.20	大B商品图片下载权限设置接口
static const NSString *getImgDownloadSetting = @"/db/image/imgDownloadSetting";

//3.21	大B商品下载图片列表接口
static const NSString *getImgDownloadList = @"/db/image/download/list";

//3.22	大B图片下载完成回调接口
static const NSString *getImageDownloadCallBack = @"/db/image/download/callback";

//3.23	大B商品图片下载历史查询接口
static const NSString *getImageHistoryList = @"/db/image/history/list";

//3.24	商家等级权限说明接口
static const NSString *getMerchantPermissionList = @"/db/merchant/permission/list";

//3.25	付费上架
static const NSString *getPayMerchantOnsale = @"/db/merchant/pay/onsale";

//3.26	付费下载
static const NSString *getPayMerchantDownload = @"/db/merchant/pay/download";

//3.27	无权限提示接口
static const NSString *getMerchantNotAuthTip = @"/db/merchant/notAuthTip";

//3.28	大B销售统计接口
static const NSString *getPortalStatistics = @"/db/statistic/getPortalStatistics";

//3.29	大B按照销售时间统计接口
static const NSString *getOrderSalesPerDays = @"/db/statistic/getOrderSalesPerDays";

//3.30	大B按照时间统计采购商接口
static const NSString *getPurchaserStatisticsPerDays =  @"/db/statistic/getPurchaserStatisticsPerDays";

//3.31	大B单品统计接口
static const NSString *getProductStatisticPerSale = @"/db/statistic/getProductStatisticPerSale";

//3.32	推荐商品记录列表接口
static const NSString *getRecommendRecordList = @"/db/goods/getRecommendRecordList";

//3.33	推荐商品记录详情接口
static const NSString *getRecommendRecordDetailsList = @"/db/goods/getRecommendRecordDetails";

//3.34	推荐商品记录删除接口
static const NSString *deleteRecommendRecord = @"/db/goods/deleteRecommendRecord";

//3.35	推荐商品收件人列表接口
static const NSString *getRecommendReceiverList = @"/db/goods/getRecommendReceiverList";

//3.36	推荐商品记录发送接口
static const NSString *getSaveGoodsRecommend =  @"/db/goods/saveGoodsRecommend";
//3.36	推荐商品记录发送接口 3.0.0
static const NSString *saveGoodsRecommendV3 =  @"/db/goods/saveGoodsRecommendV3";

//3.37	采购商-有交易的会员的列表接口
static const NSString * getsecondMemberTradeList = @"/db/member/getMemberTradeList";

//3.38	采购商-我邀请的会员的列表接口
static const NSString * getMemberInviteList = @"/db/member/getMemberInviteList";

//3.39	采购商-黑名单列表接口
static const NSString *getMemberBlackList = @"/db/member/blacklist/list";



//3.40	采购商-黑名单设置接口

static const NSString *getUpdateMemberBlackList = @"/db/member/blacklist/update";

//3.41	采购商-详情接口
static const NSString *getMemberInfo = @"/db/member/getMemberInfo";

//3.42	采购商-资料接口（申请资料）
static const NSString *getMemberApplyInfo = @"/db/member/getMemberApplyInfo";

//3.43	采购商-店铺等级设置接口
static const NSString *getMemberLevelSet = @"/db/member/memberLevelSet";

//3.44	采购商-邀请接口
static const NSString *getMemberInvite = @"/db/member/memberInvite";

//3.45	采购单列表
static const NSString *getOrderList = @"/db/order/list";

//3.46	采购单详情
static const NSString *getOrderDetail =@"/db/order/detail";

//3.47	修改采购单总金额
static const NSString *modifyOrderAmount = @"/db/order/modifyOrderAmount";

//3.48	取消交易
static const NSString *getCancelOrder = @"/db/order/cancel";

//3.50	消息推送（IOS）
static const NSString *chatPusher = @"/chat/pusher";

//3.50	图片上传接口
static const NSString *imageUpload = @"/image/upload";

//3.51	获取历史聊天信息（openfire）
static const NSString *getChatHistory = @"/chat/history";

//3.52	大B意见反馈
static const NSString *getMerchantAddFeedback = @"/db/merchant/addFeedback";

//3.53	创建虚拟商品采购单
static const NSString *addVirtualOrder = @"/db/order/addVirtualOrder";

//3.54	采购单记录接口（按会员查询）
static const NSString *getOrderByMemberNo = @"/db/order/byMember";

//3.55	查询参考图上传记录接口
static const NSString *getImageReferImageHistoryList = @"/db/image/referImageHistory/list";

//3.51	支付接口
static const NSString *getPayPay = @"/db/pay/pay";

//3.57 发送短信接口
static const NSString *sendSms = @"/sms/sendSms";

//3.57	验证手机联系号码能否接受邀请接口
static const NSString *getInvMobileList = @"/db/member/getInvMobileList";

//3.58 短信校验接口-校验短信验证码
static const NSString *verifySmsCode = @"/sms/verifySmsCode";

//3.59 根据父ID获取省市区列表接口
static const NSString *getAreaListByParentId = @"/xb/user/getAreaListByParentId";

//3.60	获取最新版本
static const NSString *getAppVersion = @"/version/getAppVersion";

//3.59	大B获取反馈类型集合
static const NSString *feedback = @"/feedback/getFeedBackTypeList";

//3.60	大B积分记录按月统计接口
static const NSString *getMerchantIntegralByMonth = @"/db/merchant/getMerchantIntegralByMonth";


//3.61	大B积分记录查询接口
static const NSString *getMerchantIntegralLogList = @"/db/merchant/getMerchantIntegralLogList";

//3.62	采购商邀请号码验证接口
static const NSString *validateMemberInvite = @"/db/member/validateMemberInvite";

//3.63	查询子帐号列表接口
static const NSString *childAccountList = @"/db/user/accountList";

//3.64	新增子帐号接口
static const NSString *addChildAccount = @"/db/user/addAccount";

//3.65	修改子帐号信息接口
static const NSString *changeChildAccount = @"/db/user/updateAccountStatus";

//3.66	删除子帐号接口
static const NSString *delChildAccount = @"/db/user/delAccount";


//3.67 大b下载购买次数记录接口

static const  NSString *tansactionRecord = @"/db/pay/paidPicDownloads/list";


//3.68	大B发布资讯、测评接口
//api/db/topic/addTopicInfo
static const  NSString *releasedMeasurement = @"/db/topic/addTopicInfo";


//3.75 3.75	修改商家头像接口

static const  NSString *updateIconUrl = @"/db/merchant/iconUrl/update";


//3.76 商家入驻
static const NSString * merchantsApplyAdd = @"/db/merchant/apply/add";
//3.89 小B注册开关接口
static const NSString *switchUrl = @"/sys/getLoginFlag";

static const NSString * downloadAllListUrl = @"/db/image/download/all/list";

#pragma mark 3.0.0新接口

//3.1	查询品牌列表接口
static const NSString *goodsGetBarandList = @"/db/goods/getBrandList";

//3.2	修改商品标签接口
static const NSString *goodsUpdataGoodsLabel = @"/db/goods/updateGoodsLabel";

//3.3	获取所有商品标签接口
static const NSString *goodsGetAllLabelList = @"/db/goods/getAllLabelList";

//db/goods/getLabelListByGoodsNo
//3.4	获取单个商品标签接口
static const NSString *goodsGetLabelListByGoodsNo = @"/db/goods/getLabelListByGoodsNo";


//3.9	商品列表（可编辑）接口
static const NSString * goodsListEditUrl = @"/db/goods/list4edit";


//3.18	修改商品规格参数接口
static const NSString *goodsAttrUpdate = @"/db/goods/attr/update";
//3.11	大B商品修改接口
static const NSString * goodsInfoUpdate = @"/db/goods/info/update";


//获取单个店铺接口
static const NSString * getMerchantLabelList = @"/db/merchant/label/getMerchantLabelList";

//获取所有店铺接口
static const NSString * getAllLabelList = @"/db/merchant/label/getAllLabelList";
//修改店铺接口
static const NSString * updateLabel = @"/db/merchant/label/updateLabel";
//3.15	查询运费模版列表接口
static const NSString * getFreightTemplateList = @"/db/merchant/freight/getFreightTemplateList";
//3.13	删除运费模版接口
static const NSString * delFreightTemplate = @"/db/merchant/freight/delFreightTemplate";
//3.14	设置默认运费模版接口
static const NSString * setFreightDefault = @"/db/merchant/freight/setFreightDefault";

//3.16	查询运费模版详情接口

static const NSString * getFreightTemplateInfo = @"/db/merchant/freight/getFreightTemplateInfo";


//3.12	新增运费模版接口
static const NSString * addFreightTemplate = @"/db/merchant/freight/addFreightTemplate";


//3.13	修改运费模版接口
static const NSString * updateFreightTemplate = @"/db/merchant/freight/updateFreightTemplate";

//3.20 商家发货接口
static const NSString *orderDeliver = @"/db/order/deliver";


//3.21	合并发货采购单列表
static const NSString *orderDeliverList = @"/db/order/deliver/list";


//3.22	大B商品运费模板修改接口
static const NSString *ftTemplate = @"/db/goods/ftTemplate/update";


//!3.19	查询快递公司列表接口
static const NSString * expressListUrl = @"/db/merchant/express/list";

//!3.23	查询系统属性列表接口
static const NSString * propertyListUrl = @"/sys/property/list";

//!3.99	App上报错误日志接口
static const NSString * appErrorAddUrl = @"/sys/apperror/add";

//!3.34	商品主页接口
static const NSString * goodsMainUrl = @"/db/goods/main";


//3.25	物流轨迹信息查询接口
static const NSString *logistic  = @"/db/logistic/traces/get";

//3.26 查看退换货详情
static const NSString *orderRefundDetail = @"/db/order/refund/detail";
//3.27 大B处理退换货接口
static const NSString *orderRefundDeal = @"/db/order/refund/deal";



//3.30	查询运费模版列表接口(V3.0.5)
static const NSString *templateList = @"/db/merchant/freight/template/list";
//3.31	设置默认运费模版接口(V3.0.5)
static const NSString *defaultTemplate = @"/db/merchant/freight/defaultTemplate/set";
//3.32	设置批发运费模版接口
static const NSString *wholesaleTemplate = @"/db/merchant/freight/wholesaleTemplate/set";
//3.33	设置零售运费模版接口
static const NSString *retailTemplate = @"/db/merchant/freight/retailTemplate/set";
//3.35	商品提成审核列表（零售）
static const NSString *auditList = @"/db/goods/share/audit/list";

//3.36	会员列表【分享的商品次数】（零售）
static const NSString *memberList = @"/db/goods/share/member/list";
//3.37	商品列表【分享次数】接口（零售）
static const NSString *shareList = @"/db/goods/share/list";
//3.38	商品详情接口（零售）
static const NSString *auditDetail = @"/db/goods/share/detail";
//3.39	零售商品分享及提成审核接口
static const NSString *auditShare =@"/db/goods/share/audit";
//!3.43	商品销售渠道批量更新接口
static const NSString *saleChannelUpdate = @"/db/goods/salechannel/batch/update";


//!3.40	商品默认参考图筛选列表接口
static const NSString *shareFilter = @"/db/goods/share/filter/pic/list";
//3.41	商品默认分享图片列表
static const NSString *sharePicList = @"/db/goods/share/pic/list";
//3.42	商品默认图设置接口
static const NSString *defaultPicSet = @"/db/goods/share/default/pic/set";
//3.45	大B推送数量清零接口
static const NSString *clearBadgeCount = @"/db/notice/clearBadgeCount";
//3.23	获取历史聊天列表信息（openfire）
static const NSString *chatList = @"/chat/db/history/list";
//3.24 3.24	获取历史聊天信息（openfire）
static const NSString *chatHistorys =@"/chat/db/historys";
//3.46	大B获取服务器时间接口
static const NSString *chatTime = @"/db/user/time";
//3.49 大B 获取 客服账号接口
static const NSString *getCustomerAccount = @"/db/member/getCustomerAccount";
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


//转化参数
+(NSMutableDictionary *)getParameterWithTimestamp:(NSString *)timestamp{
    AppInfoDTO *appInfoDTO  = [AppInfoDTO sharedInstance];
    
    NSMutableDictionary *necessaryParameters = [[NSMutableDictionary alloc]initWithObjectsAndKeys:appInfoDTO.deviceType,@"deviceType",appInfoDTO.deviceToken,@"deviceSn",appInfoDTO.imei,@"imei",appInfoDTO.appVersion,@"appVersion",appInfoDTO.iosVersion,@"iosVersion",appInfoDTO.appKey,@"appKey",timestamp,@"timestamp",appInfoDTO.appType,@"appType",appInfoDTO.screenType,@"screenType",appInfoDTO.appVersionInt,@"versionNo", nil];
    
    return necessaryParameters;

}



+ (NSString *)transformationData:(id)data{
    
    if ([data isKindOfClass:[NSString class]]) {
        
        return data;
        
    }else if ([data isKindOfClass:[NSNumber class]]){
        
        NSNumber *number = (NSNumber *)data;
        
        return number.stringValue;
    }else{
        return @"";
    }
}

+ (BOOL)isNetworkConnect{
    
    BOOL isExistenceNetwork = YES;
    
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    switch ([reach currentReachabilityStatus]) {
            
        case NotReachable:
            
            isExistenceNetwork = NO;
            
            break;
        case ReachableViaWiFi:
            
            isExistenceNetwork = YES;
            
            break;
        case ReachableViaWWAN:
            
            isExistenceNetwork = YES;
            
            break;
            
        default:
            
            isExistenceNetwork = YES;
            
            break;
    }
    
    return isExistenceNetwork;
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
    
    //判断网络连接
//    if (![HttpManager isNetworkConnect]) {
//        
//        dispatch_queue_t queue= dispatch_queue_create("HttpManagerAlert", NULL);
//        dispatch_async(queue, ^{
//            
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查您的网络连接" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [alert show];
//            });
//        });
//        
//    }else{
        // !忽略缓存
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:requestURL]
                                                                   cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                               timeoutInterval:60];
        
        
        [request setValue:@"application/json;charse=UTF-8" forHTTPHeaderField:@"content-type"];//请求头
        
        [request setHTTPMethod:@"POST"];
        
        NSData *jsonData = [parameter dataUsingEncoding:NSUTF8StringEncoding];
        
        [request setHTTPBody:jsonData];
        
        AFHTTPRequestOperation *httpRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        [httpRequestOperation setCompletionBlockWithSuccess:success failure:failure];
        
        [httpRequestOperation start];
    
    
//    }
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
    
    NSMutableDictionary *necessaryParameters = [[NSMutableDictionary alloc]initWithObjectsAndKeys:appInfoDTO.deviceType,@"deviceType",appInfoDTO.deviceToken,@"deviceSn",appInfoDTO.imei,@"imei",appInfoDTO.appVersion,@"appVersion",appInfoDTO.iosVersion,@"iosVersion",appInfoDTO.appKey,@"appKey",timestamp,@"timestamp",appInfoDTO.appType,@"appType", appInfoDTO.screenType,@"screenType",appInfoDTO.appVersionInt,@"versionNo",nil];


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
                
//                if ([currentValue[0] isKindOfClass:[NSString class]]) {//!如果数组里面是字符串
//                    
//                    signStr = [NSString stringWithFormat:@"%@%@=%@",signStr,[compositorArray objectAtIndex:i],currentValue];
//                    
//                    
//                }else{
                
                    NSString* currentStr = [HttpManager Sort:currentValue];
                    if (currentStr == nil) {
                        currentStr = @"";
                    }
                    signStr = [NSString stringWithFormat:@"%@%@=%@",signStr,[compositorArray objectAtIndex:i],currentStr];

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
    
    NSMutableDictionary *necessaryParameters = [[NSMutableDictionary alloc]initWithObjectsAndKeys:appInfoDTO.deviceType,@"deviceType",appInfoDTO.deviceToken,@"deviceSn",appInfoDTO.imei,@"imei",appInfoDTO.appVersion,@"appVersion",appInfoDTO.iosVersion,@"iosVersion",appInfoDTO.appKey,@"appKey",timestamp,@"timestamp",appInfoDTO.appType,@"appType",appInfoDTO.screenType,@"screenType",appInfoDTO.appVersionInt,@"versionNo",nil];
    
    [necessaryParameters addEntriesFromDictionary:parameter];
    
    
    //将字典转成字符串
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:necessaryParameters options:NSJSONWritingPrettyPrinted error:&parseError];
    
    if (jsonData == nil) {
        NSLog(@"The jsonData is nil\n");
        NSLog(@"The error description is %@\n",[parseError localizedDescription]);
    }
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}








#pragma mark 3.1 登陆接口
//登陆
+ (BCSHttpRequestStatus)sendHttpRequestForLoginWithMemberAccount:(NSString *)memberAccount password:(NSString *)password success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == memberAccount || memberAccount.length<1 || nil == password || password.length<1){
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"account":memberAccount,
                                           
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

#pragma mark 3.2 登陆
+ (BCSHttpRequestStatus)sendHttpRequestForSetPassword:(NSString *)account passwd:(NSString *)passwd success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if (nil == account || account.length<1 || nil == passwd || passwd.length<1){
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"account":account,
                                           @"passwd":[[passwd MD5Hash]lowercaseString]

                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,login,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}



#pragma mark 3.3 忘记密码校验接口
+ (BCSHttpRequestStatus)sendHttpRequestForForgetPwdCheckWithMobilePhone:(NSString *)mobilePhone success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == mobilePhone || mobilePhone.length<1 || [LoginDTO sharedInstance].tokenId ==nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
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

#pragma mark 3.4 用户修改密码接口
+ (BCSHttpRequestStatus)sendHttpRequestForUpdatePassword:(NSString *)account passwd:(NSString *)passwd oldpwd:(NSString *)oldpwd success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ( nil == passwd || passwd.length < 1 || nil == oldpwd || oldpwd.length<1 || [LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"account":account,
                                           
                                           @"passwd":[[passwd MD5Hash] lowercaseString],
                                           
                                           @"oldpwd":[[oldpwd MD5Hash] lowercaseString]
                                          
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,updatePassword,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark 3.5 大B商家中心主页接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetMerchantMain:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
  
    if ([LoginDTO sharedInstance].tokenId == nil || [LoginDTO sharedInstance].merchantNo == nil) {
        
        return BCSHttpRequestParameterIsLack;

    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSLog(@"%@",[LoginDTO sharedInstance].tokenId);
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"merchantNo":[LoginDTO sharedInstance].merchantNo
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getMerchantMain,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark 3.6 大B商家中心主页商品阅读状态修改接口
+ (BCSHttpRequestStatus)sendHttpRequestForUpdateGoodsReadStatus:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    if ([LoginDTO sharedInstance].tokenId == nil || [LoginDTO sharedInstance].merchantNo == nil) {
        
        return BCSHttpRequestParameterIsLack;
        
    }

    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSLog(@"%@",[LoginDTO sharedInstance].tokenId);
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"merchantNo":[LoginDTO sharedInstance].merchantNo
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,UpdateGoodsReadStatus,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}
//3.77	大B站内信未读数量
+ (BCSHttpRequestStatus)sendHttpRequestForLetterSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
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
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getStationTopByDb,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark 3.7 大B商家信息接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetMerchantInfo:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];

    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"merchantNo":[LoginDTO sharedInstance].merchantNo
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getMerchantInfo,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}

#pragma mark 3.8 更改营业状态（包括歇业时间）
+ (BCSHttpRequestStatus)sendHttpRequestForGetUpdateMerchantBusiness:(NSString *)operateStatus closeStartTime:(NSString *)closeStartTime closeEndTime:(NSString *)closeEndTime success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == operateStatus || operateStatus.length < 1 || [LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    if ([operateStatus compare:@"1"] == NSOrderedSame ) {
        if (nil == closeStartTime || closeStartTime.length < 1 || nil == closeEndTime || closeEndTime.length < 1) {
            
            return BCSHttpRequestParameterIsLack;
        }
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"merchantNo":[LoginDTO sharedInstance].merchantNo,
                                           
                                           @"operateStatus":operateStatus,
                                           
                                           @"closeStartTime":closeStartTime,
                                           
                                           @"closeEndTime":closeEndTime,
                                           };
    
    NSLog(@"parameterWithOutSign = %@",parameterWithOutSign);
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getUpdateMerchantBusiness,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark 3.9	歇业记录查询接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetMerchantCloseLog:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil || [LoginDTO sharedInstance].merchantNo == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }

    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"merchantNo":[LoginDTO sharedInstance].merchantNo
                                           
                                           };
    
    NSString *timestamp =[HttpManager getTimesTamp];

//    NSLog(@"parameterWithOutSign = %@",parameterWithOutSign);
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getMerchantCloseLog,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark 3.9 修改全店混批条件
+ (BCSHttpRequestStatus)sendHttpRequestForGetUpdateMerchantBatchlimit:(NSString *)batchAmountFlag batchNumFlag:(NSString *)batchNumFlag batchAmountLimit:(NSNumber* )batchAmountLimit batchNumLimit:(NSNumber* )batchNumLimit success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    if (nil == batchAmountFlag || nil == batchNumFlag || nil == batchAmountLimit || nil == batchNumLimit || [LoginDTO sharedInstance].tokenId == nil){

        return BCSHttpRequestParameterIsLack;
    }

    NSString *timestamp =[HttpManager getTimesTamp];

    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,

                                           @"merchantNo":[LoginDTO sharedInstance].merchantNo,

                                           @"batchAmountFlag":batchAmountFlag,

                                           @"batchNumFlag":batchNumFlag,

                                           @"batchAmountLimit":batchAmountLimit.stringValue,

                                           @"batchNumLimit":batchNumLimit.stringValue,

                                           };

    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];

    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];

    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getUpdateMerchantBatchlimit,sign];


    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];

    return BCSHttpRequestStatusStable;
}
#pragma mark 3.11	修改商家资料
+ (BCSHttpRequestStatus)sendHttpRequestForGetUpdateMerchantInfo:(UpdateMerchantInfoModel *)updateMerchantInfoModel success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    

    if (updateMerchantInfoModel.IsLackParameter == YES || [LoginDTO sharedInstance].tokenId == nil) {
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSMutableDictionary *parameterWithOutSign = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                                @"tokenId":[LoginDTO sharedInstance].tokenId,
                                                                                                
                                                                                                @"merchantNo":[LoginDTO sharedInstance].merchantNo,
                                                                                                
                                                                                                @"shopkeeper":updateMerchantInfoModel.shopkeeper,
                                                                                                
                                                                                                @"identityNo":updateMerchantInfoModel.identityNo,
                                                                                                
                                                                                                @"provinceNo":updateMerchantInfoModel.provinceNo.stringValue,
                                                                                                
                                                                                                @"cityNo":updateMerchantInfoModel.cityNo.stringValue,
                                                                                                
                                                                                                @"countyNo":updateMerchantInfoModel.countyNo.stringValue,
                                                                                                
                                                                                                @"detailAddress":updateMerchantInfoModel.detailAddress,
                                                                                                
                                                                                                @"contractNo":updateMerchantInfoModel.contractNo,
                                                                                                
                                                                                                @"sex":updateMerchantInfoModel.sex,
                                                                                                
                                                                                                @"mobilePhone":updateMerchantInfoModel.mobilePhone,
                                                                                                
                                                                                                @"telephone":updateMerchantInfoModel.telephone,
                                                                                                
                                                                                                @"description":updateMerchantInfoModel.Description,
                                                                                                
                                                                                                }];
    
    
    if (![updateMerchantInfoModel.iconUrl isEqualToString:@""] && updateMerchantInfoModel.iconUrl != nil ) {
        
        [parameterWithOutSign setObject:updateMerchantInfoModel.iconUrl forKey:@"iconUrl"];
        
    }
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getUpdateMerchantInfo,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}


#pragma mark 3.12 大B获取商品分类接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetGoodsCategoryList:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }

    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"merchantNo":[LoginDTO sharedInstance].merchantNo,
                
                                           };
    
    NSLog(@"parameterWithOutSign = %@",parameterWithOutSign);
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getGoodsCategoryList,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}
#pragma mark 3.66	大B和小B聊天推荐商品列表接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetGoodsByChat:(NSString *)memberNo  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    
    if (memberNo == nil) {
        memberNo = @"";
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"memberNo":memberNo
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getGoodsByChat,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}


#pragma mark 3.13 商品列表（店铺展示）接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetShopGoodsList:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize structureNo:(NSString *)structureNo queryTime:(NSString *)queryTime goodsType:(NSString *)goodsType success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    if (pageNo == nil) {
        
        pageNo = [NSNumber numberWithInteger:1];
        
    }
    
    if (pageSize == nil) {
        pageSize = [NSNumber numberWithInteger:20];
    }

    if (structureNo == nil) {
        structureNo = @"";
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"merchantNo":[LoginDTO sharedInstance].merchantNo,
                                           
                                           @"pageNo":pageNo.stringValue,
                                           
                                           @"pageSize":pageSize.stringValue,
                                           
                                           @"structureNo":structureNo,
                                           
                                           @"queryTime":queryTime,
                                           
                                           @"goodsType":goodsType
                                           
                                           };
    
    NSLog(@"parameterWithOutSign = %@",parameterWithOutSign);
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getShopGoodsList,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark 3.14  商品列表（可编辑）接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetEditGoodsList:(EditGoodsModel *)editGoodsModel success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (editGoodsModel.IsLackParameter == YES || [LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    
    NSMutableDictionary * parameterWithOutSign = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameterWithOutSign setObject:[LoginDTO sharedInstance].tokenId forKey:@"tokenId"];
    [parameterWithOutSign setObject:editGoodsModel.goodsStatus forKey:@"goodsStatus"];
    [parameterWithOutSign setObject:editGoodsModel.pageNo forKey:@"pageNo"];
    [parameterWithOutSign setObject:editGoodsModel.pageSize forKey:@"pageSize"];
    [parameterWithOutSign setObject:editGoodsModel.queryType forKey:@"queryType"];
    [parameterWithOutSign setObject:editGoodsModel.param forKey:@"param"];

    
//    NSDictionary *parameterWithOutSign = @{
//                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
//                                           
//                                           @"goodsStatus":editGoodsModel.goodsStatus,
//                                           
//                                           @"pageNo":editGoodsModel.pageNo.stringValue,
//                                           
//                                           @"pageSize":editGoodsModel.pageSize.stringValue,
//                                           
//                                           @"queryType":editGoodsModel.queryType,
//                                           
//                                           @"param":editGoodsModel.param,
//                                           
//                                           @"channelType":editGoodsModel.channelType
//                                           };
    if (editGoodsModel.channelType) {
        
        [parameterWithOutSign setObject:editGoodsModel.channelType forKey:@"channelType"];

    }
        
    
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,goodsListEditUrl,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}

#pragma mark 3.15 大B商品详情接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetGoodsInfoList:(NSString *)goodsNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (goodsNo == nil || [LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"goodsNo":goodsNo,
                                           
                                           @"merchantNo":[LoginDTO sharedInstance].merchantNo,
                                           
            
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getGoodsInfoList,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}
#pragma mark 3.1	商品手记详情预览
+ (BCSHttpRequestStatus)sendHttpRequestForGetCDetailsByGoodsNo:(NSString *)goodsNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (goodsNo == nil || [LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"goodsNo":goodsNo,
                                           
                                           @"merchantNo":[LoginDTO sharedInstance].merchantNo,
                                           
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getCDetails,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}
#pragma mark 3.15 大B商品详情接口 3.0.0 新接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetNewGoodsInfoList:(NSString *)goodsNo  withIsNotes:(BOOL)isNotes success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (goodsNo == nil || [LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"goodsNo":goodsNo,
                                           
                                           @"merchantNo":[LoginDTO sharedInstance].merchantNo,
                                           
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,isNotes?getCDetails:getNewGoodsInfoList,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}
//3.16	大B商品修改接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetUpdateGoodsInfo:(GetGoodsInfoListDTO *)getGoodsInfoListDTO success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    

    if (getGoodsInfoListDTO.IsLackParameter == YES || [LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }

//    NSString* samplePrice;
//    
//    if ([getGoodsInfoListDTO.sampleFlag isEqual:@"2"]) {
//        
//        samplePrice = @"";
//    }
//    else
//    {
//        
//        samplePrice = [HttpManager transformationData:getGoodsInfoListDTO.samplePrice];
//    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"goodsNo":getGoodsInfoListDTO.goodsNo,
                                           
                                           @"merchantNo":[LoginDTO sharedInstance].merchantNo,
                                           
                                           @"goodsStatus":getGoodsInfoListDTO.goodsStatus,
                                           
                                           @"goodsName":getGoodsInfoListDTO.goodsName,
                                           
                                           @"price":getGoodsInfoListDTO.price.stringValue,
                                           
                                           @"sampleFlag":getGoodsInfoListDTO.sampleFlag,
                                           
                                           @"samplePrice":[self transformationData:getGoodsInfoListDTO.samplePrice],

                                           @"skuList":getGoodsInfoListDTO.skuDTOList,
                                           
                                           @"stepList":getGoodsInfoListDTO.stepDTOList
                                           
                                           };
    
    DebugLog(@"-------------->parameterWithOutSign = %@",parameterWithOutSign);
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,updateGoodsInfo,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}

#pragma mark 3.17	邮费专拍详情接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetGoodsFeeInfo:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
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
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getGoodsFeeInfo,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

//3.17	大B商品上下架操作接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetUpdateGoodsStatus:(UpdateGoodsStatusModel *)updateGoodsStatusModel success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (updateGoodsStatusModel.goodsNo == nil || updateGoodsStatusModel.goodsStatus == nil || [LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"merchantNo":[LoginDTO sharedInstance].merchantNo,
                                           
                                           @"goodsNos":updateGoodsStatusModel.goodsNo ,
                                           
                                           @"goodsStatus":updateGoodsStatusModel.goodsStatus
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,updateGoodsStatus,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}

#pragma mark 3.18 大B站内信列表
+ (BCSHttpRequestStatus)sendHttpRequestForGetNoticeStationList:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    if (pageNo == nil) {
        
        pageNo = [NSNumber numberWithInteger:1];
        
    }
    
    if (pageSize == nil) {
        pageSize = [NSNumber numberWithInteger:20];
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"merchantNo":[LoginDTO sharedInstance].merchantNo,
                                           
                                           @"pageNo":pageNo.stringValue,
                                           
                                           @"pageSize":pageSize.stringValue,
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getNoticeStationList,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark 3.19	大B站内信阅读状态修改接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetUpdateNoticeStatus:(NSString *)Id success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (Id == nil || [LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"id":Id,
                                           
                                           @"merchantNo":[LoginDTO sharedInstance].merchantNo
                            
                                           };
    
    NSLog(@"parameterWithOutSign = %@",parameterWithOutSign);
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,updateNoticeStatus,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

//3.20	大B图片七日内下载限制设置接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetImgDownloadSetting:(NSString *)downloadLimit7 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (downloadLimit7 == nil || [LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"merchantNo":[LoginDTO sharedInstance].merchantNo,
                                           
                                           @"downloadLimit7":downloadLimit7
                                           };
    
    NSLog(@"parameterWithOutSign = %@",parameterWithOutSign);
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getImgDownloadSetting,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}


//3.20	大B商品下载图片列表接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetDownloadImageList:(NSMutableArray *)imageDownloadArray  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == imageDownloadArray || [LoginDTO sharedInstance].tokenId == nil) {
        
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
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getImgDownloadList,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}


//3.21	大B图片下载完成回调接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetImageDownloadCallBackListWithGoodsNo:(NSString *)goodsNo picType:(NSInteger)picType success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"merchantNo":[LoginDTO sharedInstance].merchantNo,
                                           
                                           @"goodsNo":goodsNo,
                                           
                                           @"picType":[NSString stringWithFormat:@"%ld",(long)picType]

                                           
                                           };
    
    NSLog(@"parameterWithOutSign = %@",parameterWithOutSign);
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getImageDownloadCallBack,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

//3.22	大B商品图片下载历史查询接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetImageHistoryList:(NSNumber* )pageNo pageSize:(NSNumber *)pageSize success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
        
    }
    
    if (pageNo == nil) {
        
        pageNo = [NSNumber numberWithInteger:1];
        
    }
    
    if (pageSize == nil) {
        pageSize = [NSNumber numberWithInteger:20];
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"pageNo":pageNo,
                                           
                                           @"pageSize":pageSize
                                           
                                           
                                           };
    
    NSLog(@"parameterWithOutSign = %@",parameterWithOutSign);
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getImageHistoryList,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}

// 3.23	商家等级权限说明接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetMerchantPermissionList:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
        
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"merchantNo":[LoginDTO sharedInstance].merchantNo
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getMerchantPermissionList,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

//3.25	付费上架
+ (BCSHttpRequestStatus)sendHttpRequestForGetPayMerchantOnsale:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
        
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"merchantNo":[LoginDTO sharedInstance].merchantNo
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getPayMerchantOnsale,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

// 3.25	付费下载
+ (BCSHttpRequestStatus)sendHttpRequestForGetPayMerchantDownload:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
        
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"merchantNo":[LoginDTO sharedInstance].merchantNo
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getPayMerchantDownload,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

// 3.26	无权限提示接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetMerchantNotAuthTip:(NSString *)authType success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (authType == nil || [LoginDTO sharedInstance].tokenId == nil) {
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"authType":authType
                                           
                                           };
    
    
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getMerchantNotAuthTip,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}


//3.27	大B销售统计接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetPortalStatistics:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
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
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getPortalStatistics,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

//3.28	大B按照销售时间统计接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetOrderSalesPerDays:(NSNumber *)pastDays startDate:(NSString *)startDate endDate:(NSString* ) endDate success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (startDate == nil || endDate == nil || pastDays == nil || [LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"pastDays":[pastDays stringValue],
                                           
                                           @"startDate":startDate,
                                           
                                           @"endDate":endDate
                                           
                                           };
    

    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getOrderSalesPerDays,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

//3.29	大B按照时间统计采购商接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetPurchaserStatisticsPerDays:(NSNumber *)pastDays success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (pastDays == nil || [LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"pastDays":[pastDays stringValue]
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getPurchaserStatisticsPerDays,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

//3.31	大B单品统计接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetProductStatisticPerSale:(NSNumber *)queryType orderBy:(NSString*)orderBy success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (queryType == nil || orderBy == nil || [LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"queryType":[queryType stringValue],
                                           
                                           @"orderBy":orderBy
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getProductStatisticPerSale,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

//3.32	推荐商品记录列表接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetRecommendRecordList:(NSNumber *)pageNo pageSize:(NSNumber* ) pageSize success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }

    
    if (pageNo == nil) {
        
        pageNo = [NSNumber numberWithInteger:1];
        
    }
    
    if (pageSize == nil) {
        pageSize = [NSNumber numberWithInteger:20];
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"pageNo":pageNo,
                                           
                                           @"pageSize":pageSize
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getRecommendRecordList,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

//3.32	推荐商品记录详情接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetRecommendRecordDetailsList:(NSNumber *)Id success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (Id == nil || [LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"merchantNo":[LoginDTO sharedInstance].merchantNo,
                                           
                                           @"id":Id.stringValue
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getRecommendRecordDetailsList,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

//  3.34	推荐商品记录删除接口
+ (BCSHttpRequestStatus)sendHttpRequestForDeleteRecommendRecord:(NSString *)ids success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (ids == nil || [LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"ids":ids
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,deleteRecommendRecord,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}

// 3.35	推荐商品收件人列表接口
+(BCSHttpRequestStatus)sendHttpRequestForGetRecommendReceiverList:(NSNumber *)pageNo pageSize:(NSNumber* ) pageSize  dayNum:(NSString* )dayNum success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (dayNum == nil || [LoginDTO sharedInstance].tokenId == nil) {
        return BCSHttpRequestParameterIsLack;
    }
    if (pageNo == nil) {
        
        pageNo = [NSNumber numberWithInteger:1];
        
    }
    
    if (pageSize == nil) {
        pageSize = [NSNumber numberWithInteger:20];
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                    
                                           @"pageNo":pageNo,
                                           
                                           @"pageSize":pageSize,
                                           
                                           @"dayNum":dayNum
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getRecommendReceiverList,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}


//3.36	推荐商品记录发送接口
+(BCSHttpRequestStatus)sendHttpRequestForGetSaveGoodsRecommend:(SaveGoodsRecommendModel *)saveGoodsRecommendModel success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (saveGoodsRecommendModel.IsLackParameter == YES || [LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"merchantNo":[LoginDTO sharedInstance].merchantNo,
                                               
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"goodsNum":saveGoodsRecommendModel.goodsNum,
                                           
                                           @"memberNum":saveGoodsRecommendModel.memberNum,
                                           
                                           @"content":saveGoodsRecommendModel.content,
                                           
                                           @"goodsNos":saveGoodsRecommendModel.goodsNos,
                                           
                                           @"memberNos":saveGoodsRecommendModel.memberNos
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,saveGoodsRecommendV3,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

// 3.37	采购商-有交易的会员的列表接口
+(BCSHttpRequestStatus)sendHttpRequestForGetMemberTradeList:(NSString *)orderBy pageNo:(NSNumber* ) pageNo  pageSize:(NSNumber* ) pageSize  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (orderBy == nil || pageNo == nil || pageSize == nil || [LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"merchantNo":[LoginDTO sharedInstance].merchantNo,
                                           
                                           @"orderBy":orderBy,
                                           
                                           @"pageNo":pageNo,
                                           
                                           @"pageSize":pageSize
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getsecondMemberTradeList,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}

// 3.38	采购商-我邀请的会员的列表接口
+(BCSHttpRequestStatus)sendHttpRequestForGetMemberInviteList:(NSString *)orderBy pageNo:(NSNumber* ) pageNo  pageSize:(NSNumber* ) pageSize  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (orderBy == nil || [LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
    if (pageNo == nil) {
        
        pageNo = [NSNumber numberWithInteger:1];
        
    }
    
    if (pageSize == nil) {
        pageSize = [NSNumber numberWithInteger:20];
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"merchantNo":[LoginDTO sharedInstance].merchantNo,
                                           
                                           @"orderBy":orderBy,
                                           
                                           @"pageNo":pageNo,
                                           
                                           @"pageSize":pageSize
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getMemberInviteList,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}

// 3.39	采购商-黑名单列表接口
+(BCSHttpRequestStatus)sendHttpRequestForGetMemberBlackList:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"merchantNo":[LoginDTO sharedInstance].merchantNo,
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getMemberBlackList,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}

//3.40	采购商-黑名单设置接口
+(BCSHttpRequestStatus)sendHttpRequestForGetUpdateMemberBlackList:(NSString* ) memberNo  blackListFlag:(NSString* ) blackListFlag  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ( memberNo == nil || blackListFlag == nil || [LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"merchantNo":[LoginDTO sharedInstance].merchantNo,
                                           
                                           @"memberNo":memberNo,
                                           
                                           @"blackListFlag":blackListFlag
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getUpdateMemberBlackList,sign];
    

    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}

//3.41	采购商-详情接口
+(BCSHttpRequestStatus)sendHttpRequestForGetMemberInfo:(NSString* ) memberNo  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ( memberNo == nil || [LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"memberNo":memberNo
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getMemberInfo,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}

//3.42	采购商-资料接口（申请资料）
+(BCSHttpRequestStatus)sendHttpRequestForGetMemberApplyInfo:(NSString* ) memberNo success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"memberNo":memberNo
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getMemberApplyInfo,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}


//3.43	采购商-店铺等级设置接口
+(BCSHttpRequestStatus)sendHttpRequestForGetMemberLevelSet:(NSString *)memberNo level:(NSNumber *) level success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (memberNo == nil || level == nil || [LoginDTO sharedInstance].tokenId == nil) {
        
         return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"merchantNo":[LoginDTO sharedInstance].merchantNo,
                                           
                                           @"memberNo":memberNo,
                                           
                                           @"level":level.stringValue
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getMemberLevelSet,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}

//3.44	采购商-邀请接口
+(BCSHttpRequestStatus)sendHttpRequestForMemberInvite:(NSString *) mobileList success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (mobileList == nil || [LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"merchantNo":[LoginDTO sharedInstance].merchantNo,
                                           
                                           @"mobileList":mobileList
                
                
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getMemberInvite,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

//3.45	采购单列表
+(BCSHttpRequestStatus)sendHttpRequestForGetOrderList:(NSString *) orderStatus pageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize channelType:(NSNumber *)channelType success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    if (orderStatus == nil) {
        
        orderStatus = @"";
    }
    if (pageNo == nil) {
        
        pageNo = [NSNumber numberWithInteger:1];
        
    }
    

    
    if ([orderStatus isEqualToString:@"7"]) {
        orderStatus = @"";
        
    }
    
    if (pageSize == nil) {
        pageSize = [NSNumber numberWithInteger:20];
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"merchantNo":[LoginDTO sharedInstance].merchantNo,
                                           
                                           @"orderStatus":orderStatus,
                                           
                                           @"pageNo":pageNo.stringValue,
                                           
                                           @"pageSize":pageSize.stringValue,
                                           
                                           @"channelType":channelType
                                           };
    
    //!channelType  0：批发 1:零售
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getOrderList,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}

//3.46	采购单详情
+(BCSHttpRequestStatus)sendHttpRequestForGetOrderDetail:(NSNumber *)orderCode success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (orderCode == nil || [LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"merchantNo":[LoginDTO sharedInstance].merchantNo,
                                           
                                           @"orderCode":orderCode
                                        
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getOrderDetail,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}

//3.47	修改采购单总金额
+(BCSHttpRequestStatus)sendHttpRequestForGetModifyOrderAmount:(NSString *)orderCode newAmount:(NSString *) newAmount success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (orderCode == nil || newAmount == nil || [LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"merchantNo":[LoginDTO sharedInstance].merchantNo,
                                           
                                           @"orderCode":orderCode,
                                           
                                           @"newAmount":newAmount
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,modifyOrderAmount,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}

//3.48	取消交易
+(BCSHttpRequestStatus)sendHttpRequestForGetCancelOrder:(NSString *)orderCode success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (orderCode == nil || [LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"merchantNo":[LoginDTO sharedInstance].merchantNo,
                                           
                                           @"orderCode":orderCode
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getCancelOrder,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}

//3.49 消息推送（openfire）
+(BCSHttpRequestStatus)sendHttpRequestForGetChatPusher:(NSNumber *)type title:(NSString *)title acountType:(NSString *)acountType acounts:(NSString *)acounts targets:(NSString *)targets success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if (type == nil || title == nil || acountType == nil || acounts == nil || targets ==nil || [LoginDTO sharedInstance].tokenId == nil) {
        
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
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,chatPusher,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}
//3.50	获取历史聊天信息（openfire）
+(BCSHttpRequestStatus)sendHttpRequestForGetChatHistory:(ChatHistory *)chatHistory success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (chatHistory.IsLackParameter == YES || [LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"from":chatHistory.from,
                                           @"to":chatHistory.to,
                                           @"time":chatHistory.time,
                                           @"pageNo":chatHistory.pageNo.stringValue,
                                           @"pageSize":chatHistory.pageSize.stringValue
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getChatHistory,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

//多张批量上传
+ (NSString *)postRequestWithURL: (NSString *)url
                      postParems: (NSMutableDictionary *)postParems
                     picFilePath: (NSMutableArray *)picFilePath
                     picFileName: (NSMutableArray *)picFileName
{
    
    
    NSString *hyphens = @"--";
    NSString *boundary = @"*****";
    NSString *end = @"\r\n";
    
    NSMutableData *myRequestData1=[NSMutableData data];
    
    //遍历数组，添加多张图片
    for (int i = 0; i < picFilePath.count; i ++) {
        NSData* data;
        UIImage *image=[UIImage imageWithContentsOfFile:[picFilePath objectAtIndex:i]];
        //判断图片是不是png格式的文件
        if (UIImagePNGRepresentation(image)) {
            //返回为png图像。
            data = UIImagePNGRepresentation(image);
        }else {
            //返回为JPEG图像。
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        
        //所有字段的拼接都不能缺少，要保证格式正确
        [myRequestData1 appendData:[hyphens dataUsingEncoding:NSUTF8StringEncoding]];
        [myRequestData1 appendData:[boundary dataUsingEncoding:NSUTF8StringEncoding]];
        [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSMutableString *fileTitle=[[NSMutableString alloc]init];
        //要上传的文件名和key，服务器端用file接收
        [fileTitle appendFormat:@"Content-Disposition:form-data;name=\"%@\";filename=\"%@\"",[NSString stringWithFormat:@"file%d",i+1],[NSString stringWithFormat:@"image%d.png",i+1]];
        
        [fileTitle appendString:end];
        
        [fileTitle appendString:[NSString stringWithFormat:@"Content-Type:application/octet-stream%@",end]];
        [fileTitle appendString:end];
        
        [myRequestData1 appendData:[fileTitle dataUsingEncoding:NSUTF8StringEncoding]];
        
        [myRequestData1 appendData:data];
        
        [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    
    
    [myRequestData1 appendData:[hyphens dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData1 appendData:[boundary dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData1 appendData:[hyphens dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData1 appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //参数的集合的所有key的集合
    NSArray *keys= [postParems allKeys];
    
    //添加其他参数
    for(int i=0;i<[keys count];i++)
    {
        
        NSMutableString *body=[[NSMutableString alloc]init];
        [body appendString:hyphens];
        [body appendString:boundary];
        [body appendString:end];
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //添加字段名称
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"",key];
        
        [body appendString:end];
        
        [body appendString:end];
        //添加字段的值
        [body appendFormat:@"%@",[postParems objectForKey:key]];
        
        [body appendString:end];
        
        [myRequestData1 appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"添加字段的值==%@",[postParems objectForKey:key]);
    }
    
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:20];
    
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",boundary];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData1 length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData1];
    //http method
    [request setHTTPMethod:@"POST"];
    
    NSHTTPURLResponse *urlResponese = nil;
    NSError *error = [[NSError alloc]init];
    
    NSData* resultData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponese error:&error];
    
    assert(resultData!=nil);
    
    NSString* result= [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    
    if([urlResponese statusCode] >=200&&[urlResponese statusCode]<300){
        NSLog(@"返回结果=====%@",result);
        
        //        SBJsonParser *parser = [[SBJsonParser alloc ] init];
        //        NSDictionary *jsonobj = [parser objectWithString:result];
        //
        //        if (jsonobj == nil || (id)jsonobj == [NSNull null] || [[jsonobj objectForKey:@"flag"] intValue] == 0)
        //        {
        //
        //            dispatch_async(dispatch_get_main_queue(), ^{
        //                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"提交失败." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        //                [alert show];
        //            });
        //        }
        //        else
        //        {
        //            dispatch_async(dispatch_get_main_queue(), ^{
        //                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        //                [Singleton sharedSingleton].shopId = [[jsonobj objectForKey:@"shopId"]stringValue];
        //                [alert show];
        //            });
        //        }
        
        return result;
    }
    else if (error) {
        NSLog(@"error is %@",[error localizedDescription]);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"dissmissSVP" object:nil];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"提交失败." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return nil;
        
    }
    else
        return nil;
    
}
#pragma mark- 3.50	图片上传接口(注意：为了简化接口,调整上传接口参数传递方式：tokenId、appType、type使用url方式,暂时不考虑参数签名)
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

//3.51	设置已发货状态接口
+(BCSHttpRequestStatus)sendHttpRequestForSetOrderDelivery:(NSString *)orderCode success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (orderCode == nil || [LoginDTO sharedInstance].tokenId == nil) {
        
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
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getGoodsInfoList,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

//3.51	设置已发货状态接口
+(BCSHttpRequestStatus)sendHttpRequestForGetMerchantAddFeedback:(NSString *)type content:(NSString *)content success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (content == nil || [LoginDTO sharedInstance].tokenId == nil) {
        
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
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getMerchantAddFeedback,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.53	创建虚拟商品采购单接口
+ (BCSHttpRequestStatus)sendHttpRequestForaddVirtualOrder:(NSNumber *)piece goodsNo:(NSString *)goodsNo skuNo:(NSString *)skuNo serviceType:(NSString *)serviceType success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"piece":piece.stringValue,
                                           
                                           @"goodsNo":goodsNo,
                                           
                                           @"skuNo":skuNo,
                                           
                                           @"serviceType":serviceType
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,addVirtualOrder,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}


#pragma mark-3.54	采购单记录接口（按会员查询）
+ (BCSHttpRequestStatus)sendHttpRequestForGetOrderByMemberNo:(NSString *)memberNo pageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"memberNo":memberNo,
                                           
                                           @"pageNo":pageNo.stringValue,
                                           
                                           @"pageSize":pageSize.stringValue
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getOrderByMemberNo,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

//3.55	查询参考图上传记录接口
+(BCSHttpRequestStatus)sendHttpRequestForGetImageReferImageHistoryListWithGoodsNo:(NSString *)goodsNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (goodsNo == nil || [LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"goodsNo":goodsNo
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getImageReferImageHistoryList,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

#pragma mark-3.56	支付接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetPayPay:(PayPayDTO *)payPayDTO success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (YES == payPayDTO.IsLackParameter || [LoginDTO sharedInstance].tokenId == nil) {
        
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
                                           @"password":payPayDTO.password,
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

#pragma mark-3.57 发送短信接口
+ (BCSHttpRequestStatus)sendHttpRequestForSendSmsWithPhone:(NSString *)phone type:(NSString *)type success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    NSString* tokenId = nil;
    
    if (nil == phone || phone.length < 1 || nil == type || type.length < 1) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    if ([type isEqualToString:@"15"]) {
        
        tokenId = [LoginDTO sharedInstance].tokenId;
        if (tokenId == nil) {//!防止空的判断
            
            tokenId = @"";
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

//3.57	验证手机联系号码能否接受邀请接口
+(BCSHttpRequestStatus)sendHttpRequestForGetMemberInviteList:(NSString *) mobileList success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (mobileList == nil || [LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"merchantNo":[LoginDTO sharedInstance].merchantNo,
                                           
                                           @"mobileList":mobileList
                                           
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getInvMobileList,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}


#pragma mark-3.58 短信校验接口
+ (BCSHttpRequestStatus)sendHttpRequestForVerifySmsCodeWithPhone:(NSString *)phone type:(NSString *)type smsCode:(NSString *)smsCode success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    NSString* tokenId = nil;
    if (nil == phone || phone.length < 1 || nil == type || type.length < 1) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    if ([type isEqualToString:@"15"]) {
        tokenId = [LoginDTO sharedInstance].tokenId;
        
        if (tokenId == nil) {
            
            tokenId = @"";
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


+ (void)downLoadImageWithURL:(NSString *)url success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
//    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];//text/html  application/zip
    
    [operationManager GET:url parameters:nil success:success failure:failure];
    
    //
}


#pragma mark-3.59	根据父ID获取省市区列表接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetAreaListByParentIdWithParentId:(NSNumber *)parentId success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == parentId || parentId.stringValue.length<1 || [LoginDTO sharedInstance].tokenId == nil) {
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


+ (BCSHttpRequestStatus)sendHttpRequestFeedBackTypeSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"feedBackType":@"2"
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,feedback,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

+ (BCSHttpRequestStatus)sendHttpRequestForGetMerchantIntegralByMonth:(NSString *)time pageNo:(NSNumber *)pageNo pageSize:(NSNumber *) pageSize success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }

    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"time":time,
                                           
                                           @"pageNo":pageNo.stringValue,
                                           
                                           @"pageSize":pageSize.stringValue
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getMerchantIntegralByMonth,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

+ (BCSHttpRequestStatus)sendHttpRequestForGetMerchantIntegralLogList:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
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
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getMerchantIntegralLogList,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

+ (BCSHttpRequestStatus)sendHttpRequestForValidateMemberInvite:(NSString*)mobilePhone success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }

    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"mobilePhone":mobilePhone
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,validateMemberInvite,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

+ (BCSHttpRequestStatus)sendHttpRequestForLoginPasswordWithMobilePhone:(NSString *)mobilePhone passwd:(NSString *)passwd type:(NSString *)type Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"account":mobilePhone,
                                           
                                           @"passwd":[[passwd MD5Hash]lowercaseString],
                                           
                                           @"type":type
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,setPassword,sign];
    
    DebugLog(@"requestStr--------->%@", requestStr);
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;

}



+ (BCSHttpRequestStatus)sendHttpRequestForShowChildAccountPageNo:(int)pageNo pageSize:(int)size success:(void(^)(AFHTTPRequestOperation *operation,id responseObject))success failure:(void(^)(AFHTTPRequestOperation *opeation,NSError *error))failure
{
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }

    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
//                                           @"pageNo":[NSNumber numberWithInt:pageNo],
//                                           @"pageSize":[NSNumber numberWithInt:size],
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];

    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,childAccountList,sign];

    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    return  BCSHttpRequestStatusStable;
    

}

+(BCSHttpRequestStatus)sendHttpRequestForAddChildAccountMerchantAccount:(NSString *)phone nickName:(NSString *)name  status:(NSString *)status success:(void(^)(AFHTTPRequestOperation *operation ,id reqeustObject))success failure:(void(^)(AFHTTPRequestOperation *opeation, NSError *error))failure
{
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }

    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{

                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"merchantAccount":phone,
                                           @"nickName":name,
                                           @"status":status
                                           
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,addChildAccount,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    return  BCSHttpRequestStatusStable;
    
}


+(BCSHttpRequestStatus)sendHttpRequestForeleasedMeasurementContent:(NSString *)content topicType:(NSString *)type imgUrls:(NSString *)url success:(void(^)(AFHTTPRequestOperation *operation ,id reqeustObject))success failure:(void(^)(AFHTTPRequestOperation *opeation, NSError *error))failure
{
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }

    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"content":content,
                                           @"imgUrls":url,
                                           @"topicType":type
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,releasedMeasurement,sign];
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    return  BCSHttpRequestStatusStable;
}

+(BCSHttpRequestStatus)sendHttpRequestForChangeChildAccountMerchantAccountNickName:(NSString *)nickName status:(NSString *)status firstOpenFlag:(NSString *)flag merchantAccount:(NSString *)merchantAccount success:(void(^)(AFHTTPRequestOperation *operation, id requestObject))success failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }

    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"nickName":nickName,
                                           @"status":status,
                                           @"firstOpenFlag":flag,
                                           @"merchantAccount":merchantAccount
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,changeChildAccount,sign];
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    return  BCSHttpRequestStatusStable;

}
+(BCSHttpRequestStatus)sendHttpRequestForChangeChildDel:(NSString *)phone success:(void(^)(AFHTTPRequestOperation *operation, id requestObject))success failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }

    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"merchantAccount":phone,
                                        
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,delChildAccount,sign];
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    return  BCSHttpRequestStatusStable;
}


//3.67 大b下载次数购买记录jiekou

+(BCSHttpRequestStatus)sendHttpRequestForBuyRecordPageNo:(NSNumber *)PageNo pageSize:(NSNumber *)pageSize success:(void(^)(AFHTTPRequestOperation *operation, id requestObject))success failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
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
                                                };
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,tansactionRecord,sign];

    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    return  BCSHttpRequestStatusStable;
}

/**
 商家入驻
 */

+(BCSHttpRequestStatus)sendHttpRequestForMerchantApplyAdd:(NSMutableDictionary *)upDic success:(void(^)(AFHTTPRequestOperation *operation ,id reqeustObject))success failure:(void(^)(AFHTTPRequestOperation *opeation, NSError *error))failure{

    NSString *timestamp =[HttpManager getTimesTamp];
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:upDic timestamp:timestamp];
    
    NSString *parameter = [HttpManager getParameterWithParameter:upDic timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,merchantsApplyAdd,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    return  BCSHttpRequestStatusStable;
}
#pragma  mark  3.89 商家入驻按钮显示接口
+ (BCSHttpRequestStatus)sendHttpRequestForSwitchsuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString *timestamp =[HttpManager getTimesTamp];
    NSDictionary *parameterWithOutSign = @{
                                           
                                           };
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,switchUrl,sign];
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    return BCSHttpRequestStatusStable;
}

#pragma mark 3.78	全部商品下载图片列表接口
+ (BCSHttpRequestStatus)sendHttpRequestForDownloadAllListWithPageNo:(int)pageNo  withPageSize:(int)pageSize    Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }

    if (!pageNo) {
        
        pageNo = 1;
    
    }
    if (!pageSize) {
        
        pageSize = 20;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"pageNo":[NSNumber numberWithInt:pageNo],
                                           @"pageSize":[NSNumber numberWithInt:pageSize]
                                
                                           };
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,downloadAllListUrl,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return  BCSHttpRequestStatusStable;



}
#pragma mark 3.19	查询快递公司列表接口
+ (BCSHttpRequestStatus)sendHttpRequestForExpressListSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    if ([LoginDTO sharedInstance].tokenId == nil || [[LoginDTO sharedInstance].tokenId isEqualToString:@""]) {
        
        return BCSHttpRequestStatusHaveNotLogin;
    }
    
    
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId
                                           };
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,expressListUrl,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
   
    return  BCSHttpRequestStatusStable;



}
#pragma mark 3.23	查询系统属性列表接口 判断是否请求新的快递公司数据
+ (BCSHttpRequestStatus)sendHttpRequestForJudgeWheterGetNewExpressListSuccesPropName:(NSString *)propName   Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{


//    if ([LoginDTO sharedInstance].tokenId == nil || [[LoginDTO sharedInstance].tokenId isEqualToString:@""]) {
//        
//        return BCSHttpRequestStatusHaveNotLogin;
//    }
    

    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"propName":propName
                                           
                                           };
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,propertyListUrl,sign];
    
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
#pragma mark 3.34	商品主页接口
+ (BCSHttpRequestStatus)sendHttpRequestForGoodsMainSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{


    if ([LoginDTO sharedInstance].tokenId == nil || [[LoginDTO sharedInstance].tokenId isEqualToString:@""]) {
        
        return BCSHttpRequestStatusHaveNotLogin;
    }
    
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId
                                           
                                           };
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,goodsMainUrl,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return  BCSHttpRequestStatusStable;
    

}

#pragma mark 3.35	商品提成审核列表（零售） db/goods/share/audit/list
+ (BCSHttpRequestStatus)sendHttpRequestForAuditListWtihtGoodNo:(NSString *)goodsNo withUserId:(NSNumber *)userId withQueryType:(NSNumber *)queryType pageNo:(NSNumber *)no pageSize:(NSNumber *)sizeNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    if (goodsNo) {
        [dic setObject:goodsNo forKey:@"goodsNo"];
    }
    if (userId) {
        [dic setObject:userId forKey:@"userId"];
    }
    if (queryType) {
        [dic setObject:queryType forKey:@"queryType"];
    }
    if ([LoginDTO sharedInstance].tokenId == nil || [[LoginDTO sharedInstance].tokenId isEqualToString:@""]) {
        
        return BCSHttpRequestStatusHaveNotLogin;
    }
 
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"pageNo":no,
                                           @"pageSize":sizeNo
                                           };
    
    [dic setValuesForKeysWithDictionary:parameterWithOutSign];
    //签名
    NSString *sign = [HttpManager getSignWithParameter:dic timestamp:timestamp];
    
    NSString *parameter = [HttpManager getParameterWithParameter:dic timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,auditList,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return  BCSHttpRequestStatusStable;
    
    
}
#pragma mark 3.36	会员列表【分享的商品次数】（零售）
+ (BCSHttpRequestStatus)sendHttpRequestForMemberListWtihtQueryParam:(NSString *)queryParam  pageNo:(NSNumber *)no pageSize:(NSNumber *)sizeNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    
    if ([LoginDTO sharedInstance].tokenId == nil || [[LoginDTO sharedInstance].tokenId isEqualToString:@""]) {
        
        return BCSHttpRequestStatusHaveNotLogin;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                          
                                           @"queryParam":queryParam,
                                           @"pageNo":no,
                                           @"pageSize":sizeNo
                                           };
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,memberList,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return  BCSHttpRequestStatusStable;
    
    
}
#pragma mark 3.37	商品列表【分享次数】接口（零售）
+ (BCSHttpRequestStatus)sendHttpRequestForGoodsListWtihtQueryParam:(NSString *)queryParam  pageNo:(NSNumber *)no pageSize:(NSNumber *)sizeNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    
    if ([LoginDTO sharedInstance].tokenId == nil || [[LoginDTO sharedInstance].tokenId isEqualToString:@""]) {
        
        return BCSHttpRequestStatusHaveNotLogin;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"queryParam":queryParam,
                                           @"pageNo":no,
                                           @"pageSize":sizeNo
                                           };
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,shareList,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return  BCSHttpRequestStatusStable;
    
    
}
#pragma mark 3.38 商品详情接口（零售）接口名称：db/goods/share/detail
+ (BCSHttpRequestStatus)sendHttpRequestForAuditDetailWtihLabelId:(NSNumber *)lId success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    
    if ([LoginDTO sharedInstance].tokenId == nil || [[LoginDTO sharedInstance].tokenId isEqualToString:@""]||lId==nil) {
        
        return BCSHttpRequestStatusHaveNotLogin;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"labelId":lId
                                           };
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,auditDetail,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return  BCSHttpRequestStatusStable;
}

#pragma mark 3.39	零售商品分享及提成审核接口
+ (BCSHttpRequestStatus)sendHttpRequestForAuditWtihLabelId:(NSNumber *)lId withAuditType:(NSInteger)auditType success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    
    if ([LoginDTO sharedInstance].tokenId == nil || [[LoginDTO sharedInstance].tokenId isEqualToString:@""]||lId==nil) {
        
        return BCSHttpRequestStatusHaveNotLogin;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    NSNumber *numberAudit = [NSNumber numberWithInteger:auditType];
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"labelId":lId,
                                           @"auditType":numberAudit
                                           };
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,auditShare,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return  BCSHttpRequestStatusStable;
}
#pragma mark 3.43	商品销售渠道批量更新接口
+ (BCSHttpRequestStatus)sendHttpRequestForSaleChannelUpdate:(NSString *)goodsNoArray channelListStr:(NSString *)channelList  Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    if ([LoginDTO sharedInstance].tokenId == nil || [[LoginDTO sharedInstance].tokenId isEqualToString:@""]) {
        
        return BCSHttpRequestStatusHaveNotLogin;
    }
    
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"goodsNoList":goodsNoArray,
                                           @"channelList":channelList
                                           
                                           };
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,saleChannelUpdate,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return  BCSHttpRequestStatusStable;
    
    

    
}

#pragma mark -3.45	大B推送数量清零接口
+ (BCSHttpRequestStatus)sendHttpRequestForclearBadgeCountSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil || [[LoginDTO sharedInstance].tokenId isEqualToString:@""]||[LoginDTO sharedInstance].merchantAccount==nil) {
        
        return BCSHttpRequestStatusHaveNotLogin;
    }
    
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"account":[LoginDTO sharedInstance].merchantAccount,
                                                                                     };
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,clearBadgeCount,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return  BCSHttpRequestStatusStable;
    
    
    
    
}

#pragma mark h5
//采购商
+(void)memberOfTradeNetworkRequestWebView:(UIWebView *)webView
{
    NSString *file = [NSString stringWithFormat:@"%@%@%@",hostH5,[HttpManager h5_version],memberOfTrade];
    NSURL *url = [NSURL URLWithString:file];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
    [webView loadRequest:req];
}
//商家特权
+(void)privilegesNetworkRequestWebView:(UIWebView *)webView
{
    NSString *file = [NSString stringWithFormat:@"%@%@%@",hostH5,[HttpManager h5_version],privileges];
    NSURL *url = [NSURL URLWithString:file];
    
//    [webView loadRequest:[NSURLRequest requestWithURL:url]];
//    
//    
//    NSString *file = [NSString stringWithFormat:@"%@%@",hostH5,serviceUrl];
//    
//    NSURL *url = [NSURL URLWithString:file];
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
    [webView loadRequest:req];
    

}


//http://116.31.82.98:8289/ddop/seller/zone/default.html

//采购商等级
+(void)purchaserLevelNetworkRequestWebView:(UIWebView *)webView
{
    
    NSString *file = [NSString stringWithFormat:@"%@%@%@",hostbuyerH5,[HttpManager h5_version],purchaserLevel];
    NSURL *url = [NSURL URLWithString:file];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
    [webView loadRequest:req];
}

//统计
+(void)statisticalNetworkRequestWebView:(UIWebView *)webView
{
     NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",hostH5,[HttpManager h5_version],statistics]];
     NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
    [webView loadRequest:req];
}

//统计 需要传参数
+(void)statisticalNetworkRequestWebView:(UIWebView *)webView requestUrl:(NSString *)request
{
    NSString *urlStr =[NSString stringWithFormat:@"%@%@%@",hostH5,[HttpManager h5_version],request];
    NSString * encodingString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    

    NSURL *url = [NSURL URLWithString:encodingString];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
    [webView loadRequest:req];
}


//消费积分查询记录
+(void)scoreQueryNetworkRequestWebView:(UIWebView *)webView
{
    NSString *file = [NSString stringWithFormat:@"%@%@%@%@",hostH5,[HttpManager h5_version],scoreQuery,parameterURL];
    
    NSURL *url = [NSURL URLWithString:file];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
    [webView loadRequest:req];
}
//采购商资料申请
+(void)buyersInformationDetailsNetworkRequestWebView:(UIWebView *)webView
{

    NSString *file = [NSString stringWithFormat:@"%@%@%@%@",hostH5,[HttpManager h5_version],memberDetail,[LoginDTO sharedInstance].merchantNo];
    
    NSURL *url = [NSURL URLWithString:file];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
    [webView loadRequest:req];
}

//!服务规则与协议
+(void)serviceRequestWebView:(UIWebView *)webView{
    
    NSString *file = [NSString stringWithFormat:@"%@%@%@",hostH5,[HttpManager h5_version],serviceUrl];
    
    NSURL *url = [NSURL URLWithString:file];
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
    [webView loadRequest:req];

    
}

#pragma mark h5
//采购商
+(NSString *)memberOfTradeNetworkRequestWebView
{
    NSString *file = [NSString stringWithFormat:@"%@%@%@",hostH5,[HttpManager h5_version],memberOfTrade];
    return file;
}
//商家特权
+(NSString *)privilegesNetworkRequestWebView
{
    NSString *file = [NSString stringWithFormat:@"%@%@%@",hostH5,[HttpManager h5_version],privileges];
    return file;
}
//采购商等级
+(NSString *)purchaserLevelNetworkRequestWebView
{
    NSString *file = [NSString stringWithFormat:@"%@%@%@",hostbuyerH5,[HttpManager h5_version],purchaserLevel];
    return file;
}
//统计
+(NSString *)statisticalNetworkRequestWebView
{
     NSString *file =[NSString stringWithFormat:@"%@%@%@",hostH5,[HttpManager h5_version],statistics];
    return file;
}
//消费积分查询记录
+(NSString *)scoreQueryNetworkRequestWebView{
    NSString *file = [NSString stringWithFormat:@"%@%@%@%@",hostH5,[HttpManager h5_version],scoreQuery,parameterURL];
    return file;
}
//采购商资料申请
+(NSString *)buyersInformationDetailsNetworkRequestWebView{
    NSString *file = [NSString stringWithFormat:@"%@%@%@%@",hostH5,[HttpManager h5_version],memberDetail,[LoginDTO sharedInstance].merchantNo];
    return file;
}
//!服务规则与协议
+(NSString *)serviceRequestWebView{
    NSString *file = [NSString stringWithFormat:@"%@%@%@",hostH5,[HttpManager h5_version],serviceUrl];
    return file;
}

//所有的h5域名和端口号
+(NSString *)allH5ServiceRequestWebView{
    NSString *file = [NSString stringWithFormat:@"%@%@",hostH5,[HttpManager h5_version]];
    return file;
}
//!从app进入的采购商详情
+(NSString *)fromMessageToPurchaseMemberNo:(NSString *)memberNo{
    
    
    NSString *file = [NSString stringWithFormat:@"%@%@%@%@&from=app",hostH5,[HttpManager h5_version],memberDetail,memberNo];
    
       return  file;
    
}

////!从app进入的采购商详情
//+(void)fromMessageToPurchase:(UIWebView *)webView withMemberNo:(NSString *)memberNo{
//
//    
//    NSString *file = [NSString stringWithFormat:@"%@%@%@%@&from=app",hostH5,[HttpManager h5_version],memberDetail,memberNo];
//    
//    NSURL *url = [NSURL URLWithString:file];
//    
//    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:1];
//    
//    [webView loadRequest:req];
//    
//
//}


//大B首页

+(void)businessCircleHomeRequestWebView:(UIWebView *)webView
{
    NSString *file = [NSString stringWithFormat:@"%@%@%@",hostH5,[HttpManager h5_version],businessHome];
    NSURL *url = [NSURL URLWithString:file];
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
    [webView loadRequest:req];
    
    
    
}








/**
 *  跳转的时候需要不停的跳转
 *
 *  @param webView
 *  @param requestUrl 请求的URL
 */
+(void)businessCircleHomeRequestWebView:(UIWebView *)webView withRequesUrl:(NSString *)requestUrl
{
    NSString *file = [NSString stringWithFormat:@"%@%@%@",hostH5,[HttpManager h5_version],requestUrl];
    NSURL *url = [NSURL URLWithString:file];
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
    [webView loadRequest:req];
    
    
    
}






//大B资讯详情页面
+ (void)AuditStatusRequestWebView:(UIWebView *)webView auditStatusID:(NSString *)auditStatusID
{
    NSString *file = [NSString stringWithFormat:@"%@%@%@%@",hostH5,[HttpManager h5_version],zxDetail,auditStatusID];
    NSURL *url = [NSURL URLWithString:file];
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
    [webView loadRequest:req];
}

+ (void)AuditStatusRequestWebView:(UIWebView *)webView requestUrl:(NSString *)request
{
    NSString *file = [NSString stringWithFormat:@"%@%@%@",hostH5,[HttpManager h5_version],request];
    NSURL *url = [NSURL URLWithString:file];
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
    [webView loadRequest:req];
    

}


//大B测评详情页面
+(void)assessmentRequestWebView:(UIWebView *)webView assessmentID:(NSString *)assessmentID
{
    NSString *file = [NSString stringWithFormat:@"%@%@%@%@",hostH5,[HttpManager h5_version],cpDetail,assessmentID];
    NSURL *url = [NSURL URLWithString:file];
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
    [webView loadRequest:req];
    
}







/**
 *  3.75 修改商家头像接口
 
 *  @param iconUrl 商家头像地址
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForUpdateIconUrl:(NSString*)iconUrl success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }

    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{@"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"iconUrl":iconUrl};
    
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,updateIconUrl,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;


}

#pragma mark - *****3.0.0 最新接口/goods/getAllLabelLis

//3.1	查询品牌列表接口

+(BCSHttpRequestStatus)sendHttpRequestForGoodsgetBrandList:(NSString *)goodsNo queryName:(NSString *)name pageNo:(NSNumber *)no pageSize:(NSNumber *)size  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }

    
    NSString *timestamp =[HttpManager getTimesTamp];
    if (goodsNo == nil) {
        goodsNo = @"";
    }
    
    if (name == nil) {
        name = @"";
    }
    
    if (no == nil) {
        no = [NSNumber numberWithInteger:1];
    }
    
    if (size == nil) {
        size = [NSNumber numberWithInteger:20];
    }
    
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"goodsNo":goodsNo,
                                           @"queryName":name,
                                           @"pageNo":no,
                                           @"pageSize":size
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,goodsGetBarandList,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}

#pragma mark 3.11	大B商品修改接口
+(BCSHttpRequestStatus)sendHttpRequestGoodsInfoUpdateWithUpDic:(NSMutableDictionary *)upDic success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    
    NSString *timestamp =[HttpManager getTimesTamp];
    

    //签名
    NSString *sign = [HttpManager getSignWithParameter:upDic timestamp:timestamp];
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:upDic timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,goodsInfoUpdate,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;


}




#pragma mark 3.2 修改商品标签接口db/goods/updateGoodsLabel

+(BCSHttpRequestStatus)sendHttpRequestForGoodsUpdateGoodsLabelNameStr:(NSString *)nameStr labelIdStr:(NSString *)Idstr goodsNo:(NSString *)goodsNo  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }

    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    if (nameStr == nil) {
        
        nameStr = @"";
    }
    
    if (Idstr == nil) {
        Idstr = @"";
    }
    
    if (goodsNo == nil) {
        goodsNo =@"";
    }

    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"labelNameStr":nameStr,
                                           @"labelIdStr":Idstr,
                                           @"goodsNo":goodsNo
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,goodsUpdataGoodsLabel,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}



#pragma mark - 3.20 商家发货接口
+ (BCSHttpRequestStatus)sendHttpRequestForOrderDeliverOrderCodes:(NSString *)orders type:(NSString *)type picUrl:(NSString *)url logisticTrackNo:(NSString *)trackNo logisticCode:(NSString *)code logisticName:(NSString *)name success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }

    
    NSString *timestamp =[HttpManager getTimesTamp];
    if (orders == nil) {
        orders = @"";
    }
    if (type == nil) {
        type = @"";
    }
    if (url == nil) {
        url = @"";
    }
    if (trackNo == nil) {
        trackNo = @"";
    }
    if (code == nil) {
        code = @"";
    }
    if (name == nil) {
        name = @"";
    }
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"orderCodes":orders,
                                            @"type":type,
                                               @"picUrl":url,
                                               @"logisticTrackNo":trackNo,
                                               @"logisticCode":code,
                                               @"logisticName":name
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,orderDeliver,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}


#pragma mark 3.26查看退换货详情



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

//orderRefundDeal
#pragma mark - 3.27 大B处理退换货接口

+(BCSHttpRequestStatus)sendHttpRequestForRefundDealOrderCode:(NSString *)orderCode   refundNo:(NSString *)refundNo dealBy:(NSString*)dealBy dealReamark:(NSString *)dealReamark Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil || [LoginDTO sharedInstance].tokenId.length <= 0) {
        
        return BCSHttpRequestStatusHaveNotLogin;
    }
    
    if (orderCode == nil) {
        orderCode = @"";
    }
    if (refundNo == nil) {
        refundNo = @"";
    }
    
    if (dealBy == nil) {
        dealBy = @"";
    }
    if (dealReamark==nil) {
        dealReamark = @"";
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"orderCode":orderCode,
                                           @"refundNo":refundNo,
                                           @"dealBy":dealBy,
                                           @"dealReamark":dealReamark
                                           };
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,orderRefundDeal,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}



#pragma mark 3.2.1合并发货采购单列表
//order/deliver/list

+(BCSHttpRequestStatus)sendHttpRequestForOrderDeliverListMerchantNo:(NSString *)merchantNo pageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }

    NSString *timestamp =[HttpManager getTimesTamp];
    if (merchantNo == nil) {
        merchantNo = @"";
        
    }
    if (pageNo == nil) {
        pageNo = [NSNumber numberWithInteger:1];
    }
    if (pageSize == nil) {
        pageSize = [NSNumber numberWithInteger:20];
    }
    
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"merchantNo":merchantNo,
                                           @"pageNo":pageNo,
                                           @"pageSize":pageSize
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,orderDeliverList,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}



//3.3	获取所有商品标签接口

+(BCSHttpRequestStatus)sendHttpRequestForGoodsGetAllLabelLis:(NSString *)goodsNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }

    NSString *timestamp =[HttpManager getTimesTamp];
    if (goodsNo == nil) {
        goodsNo = @"";
        
    }
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"goodsNo":goodsNo
                              
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,goodsGetAllLabelList,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}

//3.4	获取单个商品已有标签接口

+(BCSHttpRequestStatus)sendHttpRequestForgoodsGetLabelListByGoodsNo:(NSString *)goodsNo success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }

    
    if (goodsNo == nil) {
        goodsNo = @"";
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"goodsNo":goodsNo
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,goodsGetLabelListByGoodsNo,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}

//3.18	修改商品规格参数接口
+(BCSHttpRequestStatus)sendHttpRequestForGoodsAttrUpdateGoodsNo:(NSString *)goodsNo attrList:(NSArray *)list success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }

    if (goodsNo == nil) {
        goodsNo = @"";
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"goodsNo":goodsNo,
                                           @"attrList":list
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,goodsAttrUpdate,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
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



/**
 *  3.6 获取单个店铺标签接口
 *  @param iconUrl 店铺标签
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForUpdateStoreTagSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }

    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{@"tokenId":[LoginDTO sharedInstance].tokenId};
    
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getMerchantLabelList,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}









/**
 *  3.6 获取所有店铺标签接口
 *  @param iconUrl 店铺标签
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForUpdateAllStoreTagSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }

    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{@"tokenId":[LoginDTO sharedInstance].tokenId};
    
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getAllLabelList,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}

/**
 *  3.6 修改店铺标签接口
 *  @param iconUrl 店铺标签
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForUpdateModifyStoreTagLabelNameStr:(NSString *)labelNameStr   labelIdStr:(NSString *)labelIdStr     Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
   
    NSString *timestamp =[HttpManager getTimesTamp];
    
    
    if (labelNameStr == nil) {
        
        labelNameStr = @"";
    }
    
    if (labelIdStr == nil) {
        labelIdStr = @"";
    }
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                          
                                           @"labelIdStr":labelIdStr,
                                           @"labelNameStr":labelNameStr
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,updateLabel,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}




/**
 *  3.15	查询运费模版列表接口
 *  @param iconUrl 运费模版列表
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForUpdateGetFreightTemplateListPageNo:(NSNumber *)pageNo   pageSize:(NSNumber *)pageSize     Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }

    if (pageNo == nil) {
        pageNo = [NSNumber numberWithInteger:1];
    }
    
    if (pageSize == nil) {
        pageSize = [NSNumber numberWithInteger:20];
    }

    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"pageNo":pageNo.stringValue,
                                           @"pageSize":pageSize.stringValue
                                           
                                           };
    
    
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getFreightTemplateList,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}



/**
 *  3.13	删除运费模版接口
 *  @param iconUrl 删除运费模版接口
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */

+ (BCSHttpRequestStatus)sendHttpRequestForFreightTemplateID:(NSNumber *)freightTemplateID success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == freightTemplateID || [LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"id":freightTemplateID.stringValue,
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,delFreightTemplate,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}




/**
 *  3.14 设置默认运费模版接口
 *  @param iconUrl 设置默认运费模版接口
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */

+ (BCSHttpRequestStatus)sendHttpRequestForDefultID:(NSNumber *)freightTemplateID success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == freightTemplateID || [LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"id":freightTemplateID.stringValue,
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,setFreightDefault,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}





/**
 *  3.16 查询运费模版详情接口
 *  @param iconUrl 查询运费模版详情接口
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */


+ (BCSHttpRequestStatus)sendHttpRequestForGetFreightTemplateInfo:(NSNumber *)freightTemplateID success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == freightTemplateID || [LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           
                                           @"id":freightTemplateID.stringValue,
                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getFreightTemplateInfo,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}


/**
 *  3.12	新增运费模版接口
 *  @param iconUrl 新增运费模版接口
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetFreightTemplateName:(NSString *)templateName type:(NSString *)type  setList:(NSMutableArray *)setList  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    
    if (nil == templateName || [LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    if (nil == type) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    if (nil == setList) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"templateName":templateName,
                                           
                                           @"type":type,
                                           
                                           @"setList":setList                                           
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    // 参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,addFreightTemplate,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}

/**
 *  3.13	修改运费模版接口
 *  @param iconUrl 修改运费模版接口
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetFreightTemplateName:(NSString *)templateName  type:(NSString *)type   templateNameID:(NSNumber *)templateNameID  setList:(NSMutableArray *)setList  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if (nil == templateName || [LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    if (nil == type) {
        
        return BCSHttpRequestParameterIsLack;
    }
    
    if (nil == setList) {
    
            return BCSHttpRequestParameterIsLack;
    }
    
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"type":type,
                                           @"id":templateNameID,
                                           @"setList":setList,
                                           @"templateName":templateName
                                           };
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    // 参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,updateFreightTemplate,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}




//3.22	大B商品运费模板修改接口
+ (BCSHttpRequestStatus)sendHttpRequestForFtGoodsNo:(NSString  *)goodsNo  ftTemplateId:(NSNumber *)ftTemplateId  isDefault:(NSString *)isDefault   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;

    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"goodsNo":goodsNo,
                                           @"ftTemplateId":ftTemplateId,
                                           @"isDefault":isDefault
                                           };
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,ftTemplate,sign];
    
    
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
                                           @"merchantNo":memberNo,
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
+(BCSHttpRequestStatus)sendHttpRequestForGetChantHistoryWithUser:(NSString *)memberNo withTime:(NSString *)time pageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize success:(void (^)(AFHTTPRequestOperation *, id))success  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    if ([LoginDTO sharedInstance].tokenId == nil || [[LoginDTO sharedInstance].tokenId isEqualToString:@""]||[LoginDTO sharedInstance].merchantNo ==nil) {
        
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
                                           @"memberNo":memberNo,
                                           @"merchantNo":[LoginDTO sharedInstance].merchantNo,
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
#pragma mark =====  3.46	大B获取服务器时间接口
+(BCSHttpRequestStatus)sendHttpRequestForGetChantTimeSuccess:(void (^)(AFHTTPRequestOperation *, id))success  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    if ([LoginDTO sharedInstance].tokenId == nil || [[LoginDTO sharedInstance].tokenId isEqualToString:@""]) {
        
        return BCSHttpRequestStatusHaveNotLogin;
    }
  
    
    NSString *timestamp =[HttpManager getTimesTamp];
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                         
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,chatTime,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}
#pragma mark =====  3.49	大B获取客服账号接口
+(BCSHttpRequestStatus)sendHttpRequestForGetCustomerAccountWithMemberNo:(NSString *)memberNo success:(void (^)(AFHTTPRequestOperation *, id))success  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    if ([LoginDTO sharedInstance].tokenId == nil || [[LoginDTO sharedInstance].tokenId isEqualToString:@""]||memberNo == nil) {
        
        return BCSHttpRequestStatusHaveNotLogin;
    }
    
    
    NSString *timestamp =[HttpManager getTimesTamp];
    NSDictionary *parameterWithOutSign = @{
                                           
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"memberNo":memberNo
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,getCustomerAccount,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}

#pragma mark =======快递网======
+ (BCSHttpRequestStatus)sendHttpRequestForExpressCode:(NSString *)shipperCode    logisticCode:(NSString *)logisticCode  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
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


#pragma 获取省市区列表接口
+ (BCSHttpRequestStatus)sendHttpRequestForGetAreaListSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:nil timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:nil timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,allCityList,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}







/**
 *  3.30	查询运费模版列表接口
 *  @param iconUrl 运费模版列表
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForUpdateGetFreightTemplateListSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
        
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId};
    
    
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,templateList,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}


/**
 *  3.31 设置默认运费模版接口(V3.0.5)
 *  @param iconUrl 运费模版列表
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForUpdateGetFreightTemplateID:(NSNumber *)freightTemplateID  freightTemplateType:(NSNumber *)freightTemplateType  Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
        
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"id":freightTemplateID,
                                           @"templateType":freightTemplateType
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,defaultTemplate,sign];
    
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
}



/**
 *  3.32	设置批发运费模版接口
 *  @param iconUrl 新增运费模版接口
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetFreightTemplateArrList:(NSMutableArray *)freightTemplateArrList Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
        
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"templateList":freightTemplateArrList
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,wholesaleTemplate,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];

    return BCSHttpRequestStatusStable;
    
}



/**
 *  3.33	设置零售运费模版接口
 *  @param iconUrl 新增运费模版接口
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */
+ (BCSHttpRequestStatus)sendHttpRequestForGetTemplateArrList:(NSMutableArray *)freightTemplateArrList Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
        
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"templateList":freightTemplateArrList
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,retailTemplate,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}







/**
 *  3.40	商品默认参考图筛选列表接口
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */

+ (BCSHttpRequestStatus)sendHttpRequestForScreeningDefaultImagesQueryType:(NSNumber *)queryType  queryParam:(NSString *)queryParam pageNo:(NSNumber *)pageNo  pageSize:(NSNumber *)pageSize  Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
        
    }
    
    if (pageNo == nil) {
        pageNo = [NSNumber numberWithInteger:1];
    }
    
    if (pageSize == nil) {
        pageSize = [NSNumber numberWithInteger:20];
    }

    
    if (queryType == nil) {
        queryType = [NSNumber numberWithInt:0];
    }
    
    if (queryParam == nil) {
        queryParam = @"";
    }
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"queryType":queryType,
                                           @"queryParam":queryParam,
                                           @"pageNo":pageNo,
                                           @"pageSize":pageSize
                                           };
    
    
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,shareFilter,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}


/**
 *  3.41	商品默认分享图片列表
 *  @param success 请求成功，responseObject为请求到的数据
 *  @param failure 请求失败，错误为error
 *
 *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
 */



+ (BCSHttpRequestStatus)sendHttpRequestFordefaultShareImagesImageType:(NSNumber *)imageType  goodsNo:(NSString *)goodsNo isDefault:(NSNumber *)isDefault   pageNo:(NSNumber *)pageNo  pageSize:(NSNumber *)pageSize  Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
        
    }
    if (pageNo == nil) {
        pageNo = [NSNumber numberWithInteger:1];
    }
    
    if (pageSize == nil) {
        pageSize = [NSNumber numberWithInteger:20];
    }
    
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"imageType":imageType,
                                           @"goodsNo":goodsNo,
                                           @"isDefault":isDefault,
                                           @"pageSize":pageSize,
                                           @"pageNo":pageNo
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,sharePicList,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}


+ (BCSHttpRequestStatus)sendHttpRequestFordefaultShareImagespicId:(NSNumber *)picId  isDefault:(NSNumber *)isDefault Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    
    if ([LoginDTO sharedInstance].tokenId == nil) {
        
        return BCSHttpRequestParameterIsLack;
        
    }
    
    NSString *timestamp =[HttpManager getTimesTamp];
    
    NSDictionary *parameterWithOutSign = @{
                                           @"tokenId":[LoginDTO sharedInstance].tokenId,
                                           @"picId":picId,
                                           @"isDefault":isDefault
                                           };
    
    //签名
    NSString *sign = [HttpManager getSignWithParameter:parameterWithOutSign timestamp:timestamp];
    
    //参数
    NSString *parameter = [HttpManager getParameterWithParameter:parameterWithOutSign timestamp:timestamp];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",host,defaultPicSet,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}


















@end
