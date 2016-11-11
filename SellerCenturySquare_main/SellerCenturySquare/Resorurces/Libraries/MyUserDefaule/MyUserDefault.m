//
//  MyUserDefault.m
//  SellerCenturySquare
//
//  Created by 陈光 on 15/11/10.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "MyUserDefault.h"

@implementation MyUserDefault

+ (void)setJudgeUserAccount:(NSString *)isMaster
{
    NSUserDefaults *defaultJudge = [NSUserDefaults  standardUserDefaults];
    [defaultJudge setObject:isMaster forKey:@"isMaster"];
    
}
+ (NSString *)JudgeUserAccount
{
    
     NSUserDefaults *defaultJudge = [NSUserDefaults  standardUserDefaults];
    
  
    return  [defaultJudge objectForKey:@"isMaster"];
    

}



#pragma mark ======用户登录中保存账号和密码======

/**
 *  手机号码
 */
+(void)defaultSaveAppSetting_phone:(NSString*)phone
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:phone forKey:@"phone"];
    [defaults synchronize];
    
}
+(NSString*)defaultLoadAppSetting_phone
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return  [defaults objectForKey:@"phone"];
    
}
+(void)removePhone
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"phone"];
    [defaults synchronize];
    
}
/**
 *  密码
 */
+(void)defaultSaveAppSetting_password:(NSString*)password
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:password forKey:@"password"];
    [defaults synchronize];
}
+(NSString*)defaultLoadAppSetting_password
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return  [defaults objectForKey:@"password"];
}
+(void)removePassword
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"password"];
    [defaults synchronize];
}

#pragma mark ----标记是否第一次登录----
+(void)defaultSaveAppSetting_firstLogin:(NSString*)firstLogin
{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:firstLogin forKey:@"firstLogin"];
    [defaults synchronize];
    
}
+(NSString*)defaultLoadAppSetting_firstLogin
{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return  [defaults objectForKey:@"firstLogin"];
}
+(void)removeFirstLogin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"firstLogin"];
    [defaults synchronize];

}

//!加载本地版本号
+(void)defaultSetAppVersion:(NSString *)version{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:version forKey:@"version"];
    [defaults synchronize];

    

}

+(NSString*)defaultLoad_oldVersion{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return  [defaults objectForKey:@"version"];
    

}
+(void)removeVersion{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"version"];
    [defaults synchronize];
    
}




//!是否有新上架商品
+(void)defaultSetUpGoods{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"upGoods" forKey:@"upGoods"];
    [defaults synchronize];

    
}

+(NSString*)defaultLoad_upGoods{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return  [defaults objectForKey:@"upGoods"];
 

}
+(void)removeUpGoods{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"upGoods"];
    [defaults synchronize];
}




/**
 *
 */
+(void)defaultSaveAppSetting_courierPhone:(NSString*)courierPhone
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:courierPhone forKey:@"courierPhone"];
    [defaults synchronize];
}
+(NSString*)defaultLoadAppSetting_courierPhone
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return  [defaults objectForKey:@"courierPhone"];
}
+(void)removeCourierPhone
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"courierPhone"];
    [defaults synchronize];
}
#pragma mark 存储当前 快递公司数据的版本
+(void)savePropValue:(NSString *)propValue{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:propValue forKey:@"propValue"];
    [defaults synchronize];

}
+(NSString *)getPropValue{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return  [defaults objectForKey:@"propValue"];

}

//!3.0.2版本让用户第一次进入的时候强制登录，以后就不用强制登录了(为了解决 ismaster没有在主页获取到，去掉h5界面崩溃的问题)
+(void)saveMustLoginSign{
   
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"3.0.2mustLoginSign" forKey:@"3.0.2mustLoginSign"];
    [defaults synchronize];
    
}

+(NSString *)getMustLoginSign{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return  [defaults objectForKey:@"3.0.2mustLoginSign"];

}
//对省市区版本进行控制更新
+(void)defaultSaveAppSetting_cityVersion:(NSString*)cityVersion
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:cityVersion forKey:@"propValue"];
    [defaults synchronize];
    
}
+(NSString*)defaultLoadAppSetting_cityVersion
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return  [defaults objectForKey:@"propValue"];
}
+(void)removeCityVersion
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"propValue"];
    [defaults synchronize];
}


@end
