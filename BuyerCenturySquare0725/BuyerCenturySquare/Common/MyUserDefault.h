//
//  MyUserDefault.h
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 15/11/6.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyUserDefault : NSObject

#pragma mark ------登录--------（储存，退出时就进行删除）
/**
 *  登录账号
 */
+(void)defaultSaveAppSetting_loginPhone:(NSString*)loginPhone;
+(NSString*)defaultLoadAppSetting_loginPhone;
+(void)removeLoginPhone;
/**
 *  登录密码
 */
+(void)defaultSaveAppSetting_loginPassword:(NSString*)loginPassword;
+(NSString*)defaultLoadAppSetting_loginPassword;
+(void)removeLoginPassword;





#pragma mark ------申请资料----

/**
 *  tokenID
 */
+(void)defaultSaveAppSetting_token:(NSString*)token;
+(NSString*)defaultLoadAppSetting_token;
+(void)removeToken;



//保存merchantNo
+(void)defaultSaveAppSetting_merchantNo:(NSString*)merchantNo;
+(NSString*)defaultLoadAppSetting_merchantNo;
+(void)removeMerchantNo;




/**
 *  姓名
 */
+(void)defaultSaveAppSetting_name:(NSString*)name;
+(NSString*)defaultLoadAppSetting_name;
+(void)removeName;

/**
 *  手机号码
 */
+(void)defaultSaveAppSetting_phone:(NSString*)phone;
+(NSString*)defaultLoadAppSetting_phone;
+(void)removePhone;

/**
 *  省市区
 */
+(void)defaultSaveAppSetting_area:(NSString*)area;
+(NSString*)defaultLoadAppSetting_area;
+(void)removeArea;

/**
 *  座机电话
 */
+(void)defaultSaveAppSetting_telephone:(NSString*)telephone;
+(NSString*)defaultLoadAppSetting_telephone;
+(void)removeTelephone;


/**
 *  省的id
 */
+(void)defaultSaveAppSetting_stateId:(NSNumber*)stateId;
+(NSNumber*)defaultLoadAppSetting_stateId;
+(void)removesTateId;

/**
 *  城市的id
 */
+(void)defaultSaveAppSetting_cityId:(NSNumber*)cityId;
+(NSNumber*)defaultLoadAppSetting_cityId;
+(void)removeCityId;

/**
 *  区域的id
 */
+(void)defaultSaveAppSetting_districtId:(NSNumber*)districtId;
+(NSNumber*)defaultLoadAppSetting_districtId;
+(void)removeDistrictId;



/**
 *  省市区详细地址
 */
+(void)defaultSaveAppSetting_areaDetail:(NSString *)areaDetail;
+(NSString*)defaultLoadAppSetting_areaDetail;
+(void)removeAreaDetail;

#pragma mark 判断用户是否从登陆界面过来的，是则刷新商家列表
+(void)defaultSave_logined;
+(NSString*)defaultLoadLogined;
+(void)removeLogined;




//!加载本地版本号
+(void)defaultSetAppVersion:(NSString *)version;

+(NSString*)defaultLoad_oldVersion;
+(void)removeVersion;


//判断字符串是否为空
+(BOOL)isBlankString:(NSString *)string;


//判断ID不能是否为空
+(BOOL)isBlankNum:(NSNumber*)num;


//保存网点名字
+(void)defaultSaveAppSetting_storename:(NSString*)storename;
+(NSString*)defaultLoadAppSetting_storename;
+(void)removestorename;



//验证码保存网店名字
+(void)defaultSaveAppSetting_codeStorename:(NSString*)codeStorename;
+(NSString*)defaultLoadAppSetting_codeStorename;
+(void)removeCodeStorename;




//验证码保存网店名字
+(void)defaultSaveAppSetting_codeStore:(NSString*)codeStore;
+(NSString*)defaultLoadAppSetting_codeStore;
+(void)removeCodeStore;

//! 点击tabbar按钮进入的 全部商品列表
+(void)defaultSaveIntoAllGoods;
+(NSString*)defaultLoadIntoAllGoods;
+(void)removeIntoAllGoods;

//!登录的时候判断是否是苹果审核账号
+(void)saveIsAppleAcount;
+(NSString*)loadIsAppleAccount;
+(void)removeIsAppleAccount;


/**
 *
 */
+(void)defaultSaveAppSetting_courierPhone:(NSString*)courierPhone;
+(NSString*)defaultLoadAppSetting_courierPhone;
+(void)removeCourierPhone;
//对省市区版本进行控制更新
+(void)defaultSaveAppSetting_cityVersion:(NSString*)cityVersion;
+(NSString*)defaultLoadAppSetting_cityVersion;
+(void)removeCityVersion;

//对省市区版本进行控制更新
+(void)defaultSaveAppSetting_cityVersion:(NSString*)cityVersion;
+(NSString*)defaultLoadAppSetting_cityVersion;
+(void)removeCityVersion;


//!根据后台接口进行判断
+(void)saveRegistFlagAcount:(NSString *)registFlag;
+(NSString*)loadRegistFlagAccount;
+(void)removeRegistFlagAccount;


//!根据后台接口进行判断
+(void)saveH5RegistFlagAcount:(NSString *)registFlag;
+(NSString*)loadH5RegistFlagAccount;
+(void)removeH5RegistFlagAccount;


//!根据后台接口进行判断
+(void)saveRegistFlagAcount:(NSString *)registFlag;
+(NSString*)loadRegistFlagAccount;
+(void)removeRegistFlagAccount;


//!根据后台接口进行判断
+(void)saveH5RegistFlagAcount:(NSString *)registFlag;
+(NSString*)loadH5RegistFlagAccount;
+(void)removeH5RegistFlagAccount;

@end
