//
//  MyUserDefault.h
//  SellerCenturySquare
//
//  Created by 陈光 on 15/11/10.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyUserDefault : NSObject

+ (void)setJudgeUserAccount:(NSString *)isMaster;
+(NSString *)JudgeUserAccount;

/**
 *  手机号码
 */
+(void)defaultSaveAppSetting_phone:(NSString*)phone;
+(NSString*)defaultLoadAppSetting_phone;
+(void)removePhone;

/**
 *  密码
 */
+(void)defaultSaveAppSetting_password:(NSString*)password;
+(NSString*)defaultLoadAppSetting_password;
+(void)removePassword;

//保存用户是否登录过
+(void)defaultSaveAppSetting_firstLogin:(NSString*)firstLogin;
+(NSString*)defaultLoadAppSetting_firstLogin;
+(void)removeFirstLogin;

//!加载本地版本号
+(void)defaultSetAppVersion:(NSString *)version;

+(NSString*)defaultLoad_oldVersion;
+(void)removeVersion;

//!是否有新上架商品
+(void)defaultSetUpGoods;

+(NSString*)defaultLoad_upGoods;
+(void)removeUpGoods;




/**
 *
 */
+(void)defaultSaveAppSetting_courierPhone:(NSString*)courierPhone;
+(NSString*)defaultLoadAppSetting_courierPhone;
+(void)removeCourierPhone;


//!存储当前 快递公司数据的版本
+(void)savePropValue:(NSString *)propValue;
+(NSString *)getPropValue;

//!3.0.2版本让用户第一次进入的时候强制登录，以后就不用强制登录了(为了解决 ismaster没有在主页获取到，去掉h5界面崩溃的问题)
+(void)saveMustLoginSign;

+(NSString *)getMustLoginSign;


//对省市区版本进行控制更新
+(void)defaultSaveAppSetting_cityVersion:(NSString*)cityVersion;
+(NSString*)defaultLoadAppSetting_cityVersion;
+(void)removeCityVersion;



@end
