#import "HttpManager.h"


@implementation HttpManager


/**
 *
 * 获取当前网络状态
 *
 */
-(void)afnetWorking
{
    //1.创建网络状态监测管理者
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    
    //2.监听改变
    [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        /*
         AFNetworkReachabilityStatusUnknown          = -1,
         AFNetworkReachabilityStatusNotReachable     = 0,
         AFNetworkReachabilityStatusReachableViaWWAN = 1,
         AFNetworkReachabilityStatusReachableViaWiFi = 2,
         */
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"3G|4G");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi");
                break;
            default:
                break;
        }
    }];
}
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
+ (void)requestWithRequestURL:(NSString *)requestURL parameter:(NSString *)parameter success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:requestURL]
                                                               cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                           timeoutInterval:HttpRequestTimeoutInterval];
    
    
    [request setValue:@"application/json;charse=UTF-8" forHTTPHeaderField:@"content-type"];//请求头
    
    [request setHTTPMethod:@"POST"];
    
    NSData *jsonData = [parameter dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:jsonData];
    
    AFHTTPSessionManager *httpRequestManager = [AFHTTPSessionManager manager];
    
    httpRequestManager.securityPolicy.allowInvalidCertificates = YES;
    
    [httpRequestManager POST:@"" parameters:nil success:success failure:failure];
    
    
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
    
  //  AppInfoDTO *appInfoDTO  = [AppInfoDTO sharedInstance];
    
    NSMutableDictionary *necessaryParameters;// = [[NSMutableDictionary alloc]initWithObjectsAndKeys:appInfoDTO.deviceType,@"deviceType",appInfoDTO.deviceToken,@"deviceSn",appInfoDTO.imei,@"imei",appInfoDTO.appVersion,@"appVersion",appInfoDTO.iosVersion,@"iosVersion",appInfoDTO.appKey,@"appKey",timestamp,@"timestamp",appInfoDTO.appType,@"appType",appInfoDTO.screenType,@"screenType",appInfoDTO.appVersionInt,@"versionNo",nil];
    
    
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
    
    signStr = [NSString stringWithFormat:@"%@%@",signStr,AppSecret];
    
    
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
    
    //AppInfoDTO *appInfoDTO  = [AppInfoDTO sharedInstance];
    
    NSMutableDictionary *necessaryParameters ;//= [[NSMutableDictionary alloc]initWithObjectsAndKeys:appInfoDTO.deviceType,@"deviceType",appInfoDTO.deviceToken,@"deviceSn",appInfoDTO.imei,@"imei",appInfoDTO.appVersion,@"appVersion",appInfoDTO.iosVersion,@"iosVersion",appInfoDTO.appKey,@"appKey",timestamp,@"timestamp",appInfoDTO.appType,@"appType",appInfoDTO.screenType,@"screenType",appInfoDTO.appVersionInt,@"versionNo", nil];
    
    
    [necessaryParameters addEntriesFromDictionary:parameter];
    
    
    //将字典转成字符串
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:necessaryParameters options:NSJSONWritingPrettyPrinted error:&parseError];
    
    
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}



//转化参数
+(NSMutableDictionary *)getParameterWithTimestamp:(NSString *)timestamp{
    
    //AppInfoDTO *appInfoDTO  = [AppInfoDTO sharedInstance];
    
    
    NSMutableDictionary *necessaryParameters ;//= [[NSMutableDictionary alloc]initWithObjectsAndKeys:appInfoDTO.deviceType,@"deviceType",appInfoDTO.deviceToken,@"deviceSn",appInfoDTO.imei,@"imei",appInfoDTO.appVersion,@"appVersion",appInfoDTO.iosVersion,@"iosVersion",appInfoDTO.appKey,@"appKey",timestamp,@"timestamp",appInfoDTO.appType,@"appType",appInfoDTO.screenType,@"screenType",appInfoDTO.appVersionInt,@"versionNo", nil];
    
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
    
    signStr = [NSString stringWithFormat:@"%@%@",signStr,AppSecret];
    
    
    return [[signStr MD5Hash]lowercaseString];
    
}







#pragma mark-接口
//3.1 登陆接口

#pragma mark- 3.1 登陆接口
+ (BCSHttpRequestStatus)sendHttpRequestForLoginWithMemberAccount:(NSString *)memberAccount password:(NSString *)password success:(void (^)(NSURLSessionDataTask *operation, id responseObject))success failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure;


{
    
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
    
    NSString *requestStr = [NSString stringWithFormat:@"%@%@?sign=%@",Host,Login,sign];
    
    [HttpManager requestWithRequestURL:requestStr parameter:parameter success:success failure:failure];
    
    return BCSHttpRequestStatusStable;
    
}
@end
