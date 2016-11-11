//
//  ProfileEntity.h
//  ContactsSqliteDatabase
//
//  Created by mac on 14-6-19.
//  Copyright (c) 2014年 李春晓. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int16_t, CallType) {
    CallTypeFree,
    CallTypeDirect,
    CallTypeBack,
};


@interface ProfileEntity : NSObject

+(ProfileEntity*)shareInstance;
/*
 *需要上传或者网络获取,同时本地存储
 */
@property (nonatomic, copy) NSString * uid;                     //用户账号
@property (nonatomic, copy) NSString * upass;                     //密码
@property (nonatomic, copy) NSString * nickname;                //昵称
@property (nonatomic, copy) NSString * localAvatarImgUrl;               //本地头像路径
@property (nonatomic, copy) NSString * netAvatarImgUrl;               //网络头像路径
@property (nonatomic, copy) NSString * sign;                        //签名
@property (nonatomic, copy) NSString * email;                        //邮件
@property (nonatomic, copy) NSString * remainMoney;               //余额
@property (nonatomic, copy) NSString * earnMoney;                  //积分
@property (nonatomic, copy) NSString * skinImgUrl;                    //皮肤
@property (nonatomic, copy) NSString * displayed;                    //是否显号
/*
 *本机存储
 */
@property(nonatomic,assign)CallType wifiCallType;                   //Wifi下
@property(nonatomic,assign)CallType otherCallType;                  //3G下
@property(nonatomic,assign)CallType optNORCallType;                 //未注册用户
@property(nonatomic, copy) NSString *keytoneEnable;                //按键音
@property(nonatomic, copy) NSString *autoAnswerCallBack;              //回拨自动接听


@end
