//
//  UserInfoDTO.h
//  BuyerCenturySquare
//
//  Created by clz on 15/7/16.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface UserInfoDTO : BasicDTO

/**
 *  昵称
 */
@property(nonatomic,copy)NSString *nickName;

/**
 *  姓名
 */
@property(nonatomic,copy)NSString *memberName;

/**
 *  性别
 */
@property(nonatomic,copy)NSString *sex;

/**
 *  手机号码
 */
@property(nonatomic,copy)NSString *mobilePhone;

/**
 *  座机
 */
@property(nonatomic,copy)NSString *telephone;

/**
 *  微信
 */
@property(nonatomic,copy)NSString *wechatNo;

/**
 *  省份编码(类型:int)
 */
@property(nonatomic,strong)NSNumber *provinceNo;

/**
 *  城市编码(类型:int)
 */
@property(nonatomic,strong)NSNumber *cityNo;

/**
 *  区县编码(类型:int)
 */
@property(nonatomic,strong)NSNumber *countyNo;

/**
 *  详细地址
 */
@property(nonatomic,copy)NSString *detailAddress;

/**
 *  邮编
 */
@property(nonatomic,copy)NSString *postalCode;

/**
 *  头像
 */
@property(nonatomic,copy)NSString *iconUrl;

@property(nonatomic,assign,readonly)BOOL IsLackParameter;
@end
