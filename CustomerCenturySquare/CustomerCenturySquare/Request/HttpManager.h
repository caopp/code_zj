//
//  HttpManager.h
//  BuyerCenturySquare
//
//  Created by longminghong on 15/7/9.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#import "AFHTTPSessionManager.h"
typedef NS_ENUM(NSInteger, BCSHttpRequestStatus) {
    BCSHttpRequestStatusStable = 0,
    BCSHttpRequestParameterIsLack,
    BCSHttpRequestStatusHaveNotLogin
};

@interface HttpManager : NSObject
///**
// *  3.1登陆接口
// *
// *  @param memberAccount 小B账户
// *  @param password      密码
// *  @param success       请求成功，responseObject为请求到的数据
// *  @param failure       请求失败，错误为error
// *
// *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
// */
//+ (BCSHttpRequestStatus)sendHttpRequestForLoginWithMemberAccount:(NSString *)memberAccount password:(NSString *)password success:(void (^)(AFHTTPRequestSerializer *operation, id responseObject))success failure:(void (^)(AFHTTPRequestSerializer *operation, NSError *error))failure;


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




@end
