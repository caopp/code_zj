//
//  GetMemberApplyInfoDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//
// 3.41	采购商-资料接口（申请资料）

#import "BasicDTO.h"

@interface GetMemberApplyInfoDTO : BasicDTO

/**
 *  小B编码
 */
@property(nonatomic,copy)NSString *memberNo;
/**
 *  小B名称
 */
@property(nonatomic,copy)NSString *memberName;
/**
 *  小B联系电话
 */
@property(nonatomic,copy)NSString *mobilePhone;
/**
 *  性别
 */
@property(nonatomic,copy)NSString *sex;
/**
 *  座机
 */
@property(nonatomic,copy)NSString *memberTel;
/**
 *  身份证号码
 */
@property(nonatomic,copy)NSString *identityNo;
/**
 *  省份编码(类型:int)
 */
@property(nonatomic,strong)NSNumber *provinceNo;
/**
 *  省份名称
 */
@property(nonatomic,copy)NSString *provinceName;
/**
 *  城市编码(类型:int)
 */
@property(nonatomic,strong)NSNumber *cityNo;
/**
 *  城市名称
 */
@property(nonatomic,copy)NSString *cityName;
/**
 *  区县编码(类型:int)
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
 *  营业执照注册号
 */
@property(nonatomic,copy)NSString *businessLicenseNo;
/**
 *  营业执照图片路径
 */
@property(nonatomic,copy)NSString *businessLicenseUrl;

@end
