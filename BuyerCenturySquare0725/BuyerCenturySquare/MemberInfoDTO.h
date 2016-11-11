//
//  MemberInfoDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface MemberInfoDTO : BasicDTO

/**
 *  昵称
 */
@property(nonatomic,copy)NSString* nickName;

/**
 *  小B编码
 */
@property(nonatomic,copy)NSString* memberNo;
/**
 * 姓名
 */
@property(nonatomic,copy)NSString* memberName;
/**
 *  性别
 */
@property(nonatomic,copy)NSString* sex;

/**
 *  手机号码
 */
@property(nonatomic,copy)NSString* mobilePhone;

/**
 *  座机
 */
@property(nonatomic,copy)NSString* telephone;
/**
 *  微信
 */
@property(nonatomic,copy)NSString* wechatNo;
/**
 *  省份编码(类型为int)
 */
@property(nonatomic,strong)NSNumber* provinceNo;

/**
 *  省份名称
 */
@property(nonatomic,copy)NSString *provinceName;

/**
 *  城市编码(类型为int)
 */
@property(nonatomic,strong)NSNumber* cityNo;

/**
 *  城市名称
 */
@property(nonatomic,copy)NSString *cityName;

/**
 *  区县编码(类型为int)
 */
@property(nonatomic,strong)NSNumber* countyNo;

/**
 *  区县名称
 */
@property(nonatomic,copy)NSString *countyName;

/**
 *  详细地址
 */
@property(nonatomic,copy)NSString* detailAddress;
/**
 *  邮编
 */
@property(nonatomic,copy)NSString* postalCode;
/**
 *  平台等级(类型为int)
 */
@property(nonatomic,strong)NSNumber* memberLevel;

/**
 *  头像url
 */
@property(nonatomic,copy)NSString *iconUrl;

@property(nonatomic,assign,readonly)BOOL IsLackParameter;

@property(nonatomic,strong)NSString *applyid;
+ (instancetype)sharedInstance;

@end
