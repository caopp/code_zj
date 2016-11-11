//
//  UserApplyInfo.h
//  BuyerCenturySquare
//
//  Created by clz on 15/7/22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface UserApplyInfo : BasicDTO

/**
 *  会员编码
 */
@property(nonatomic,copy)NSString *memberNo;

/**
 *  手机号码
 */
@property(nonatomic,copy)NSString *mobilePhone;

/**
 *  座机
 */
@property(nonatomic,copy)NSString *telephone;

/**
 *  省份编码
 */
@property(nonatomic,strong)NSNumber *provinceNo;

/**
 *  省份名称
 */
@property(nonatomic,copy)NSString *provinceName;

/**
 *  城市编码
 */
@property(nonatomic,strong)NSNumber *cityNo;

/**
 *  城市名称
 */
@property(nonatomic,copy)NSString *cityName;

/**
 *  区县编码
 */
@property(nonatomic,strong)NSNumber *countyNo;

/**
 *  区县名称
 */
@property(nonatomic,copy)NSString *countyName;

/**
 *  详细地址
 */
@property(nonatomic,copy)NSString *detailAddress;

/**
 *  性别(1:男2:女)
 */
@property(nonatomic,copy)NSString *sex;

/**
 *  身份证号码
 */
@property(nonatomic,copy)NSString *identityNo;

/**
 *  身份证图片路径
 */
@property(nonatomic,copy)NSString *identityPicUrl;

/**
 *  申请时间
 */
@property(nonatomic,copy)NSString *createDate;

/**
 *  营业执照注册号
 */
@property(nonatomic,copy)NSString *businessLicenseNo;

/**
 *  营业执照图片路径
 */
@property(nonatomic,copy)NSString *businessLicenseUrl;

/**
 *  营业状况
 */
@property(nonatomic,copy)NSString *businessDesc;

/**
 *  申请状态
 */
@property(nonatomic,copy)NSString *applyStatus;

/**
 *  姓名
 */
@property(nonatomic,copy)NSString *memberName;

@end
