//
//  NSObject+PublicInterface.m
//  BuyerCenturySquare
//
//  Created by clz on 15/7/9.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "NSObject+PublicInterface.h"
#import "NSString+Hashing.h"
#import "AppInfoDTO.h"

static const NSString *appSecret = @"1dfa5cd879df472484138b41dbb6197e";

static const NSTimeInterval httpRequestTimeoutInterval = 20.0f;

static const BOOL isAllowInvalidCertificates = YES;

@implementation NSObject (PublicInterface)


- (BOOL)checkLegitimacyForData:(id)object{

    if (object && ![object isKindOfClass:[NSNull class]]) {
        return YES;
    }else{
        return NO;
    }
}

- (NSDictionary *)getParametersWithParameters:(NSDictionary *)parameters timesTamp:(NSString *)timesTamp{
    
    AppInfoDTO *appInfoDTO = [AppInfoDTO sharedInstance];
    
    NSMutableDictionary *parametersDic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:appInfoDTO.deviceType,@"deviceType",appInfoDTO.deviceToken,@"deviceSn",appInfoDTO.imei,@"imei",appInfoDTO.appVersion,@"appVersion",appInfoDTO.iosVersion,@"iosVersion",appInfoDTO.appKey,@"appKey",timesTamp,@"timestamp",@"2",@"appType",nil];
    
    [parametersDic addEntriesFromDictionary:parameters];
    
    return parametersDic;
}

- (NSString *)getSignWithDic:(NSDictionary *)parameters timestamp:(NSString *)timestamp{
    
    //排序
    NSArray *compositorArray = [parameters.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        if ([[obj1 substringToIndex:1] compare:[obj2 substringToIndex:1]options:NSCaseInsensitiveSearch]>0) {
            
            return YES;
            
        }else{
            
            return NO;
        }
    }];
    
    NSString *signStr;
    
    for (int i = 0; i<compositorArray.count; i++) {
        
        if (i == 0) {
            
            signStr = [NSString stringWithFormat:@"%@=%@",[compositorArray objectAtIndex:i],[parameters objectForKey:[compositorArray objectAtIndex:i]]];
        }else{
            
            signStr = [NSString stringWithFormat:@"%@%@=%@",signStr,[compositorArray objectAtIndex:i],[parameters objectForKey:[compositorArray objectAtIndex:i]]];
        }
    }
    
    signStr = [NSString stringWithFormat:@"%@%@",signStr,appSecret];
    
    NSLog(@"signStr = %@",signStr);

    return [signStr MD5Hash];
}

- (void)requestWithURL:(NSString *)requestURL parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
    
    operationManager.securityPolicy.allowInvalidCertificates = isAllowInvalidCertificates;
    
    operationManager.requestSerializer.timeoutInterval = httpRequestTimeoutInterval;
    
    operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [operationManager POST:requestURL parameters:parameters success:success failure:failure];
}
@end
