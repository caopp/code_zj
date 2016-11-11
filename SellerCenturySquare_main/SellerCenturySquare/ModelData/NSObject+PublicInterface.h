//
//  NSObject+PublicInterface.h
//  BuyerCenturySquare
//
//  Created by clz on 15/7/9.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface NSObject (PublicInterface)

/**
 *  检查数据合法
 *
 *  @param object 传入数据（判断数据是否存在 或者 是否为NSNull）
 *
 *  @return YES(数据合法)，NO(数据不合法)
 */
- (BOOL)checkLegitimacyForData:(id)object;


/**
 *  将参数按字母排序，md5加密得到sign，将sign加到参数当中去
 *
 *  @param parameters 字典参数
 *
 *  @return 返回最终需要的请求参数
 */
- (NSString *)getSignWithDic:(NSDictionary *)parameters timestamp:(NSString *)timestamp;

- (NSString *)getSignWithDic:(NSDictionary *)parameters;

- (NSDictionary *)getParametersWithParameters:(NSDictionary *)parameters timesTamp:(NSString *)timesTamp;

/**
 *  http请求
 *
 *  @param requestURL 请求的url
 *  @param parameters 请求的参数
 *  @param success    请求成功，请求到的数据为responseObject
 *  @param failure    请求失败，错误为error
 */
//- (void)requestWithURL:(NSString *)requestURL parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


@end
