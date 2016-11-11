//
//  ApplyInfoDTO.h
//  BuyerCenturySquare
//
//  Created by clz on 15/7/10.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface ApplyInfoDTO : BasicDTO

/**
 *  姓名
 */
@property(nonatomic,copy)NSString *memberName;

/**
 *  手机号码（联系手机)
 */
@property(nonatomic,copy)NSString *mobilePhone;

/**
 *  省份编码
 */
@property(nonatomic,strong)NSNumber *provinceNo;

/**
 *  城市编码
 */
@property(nonatomic,strong)NSNumber *cityNo;

/**
 *  区县编码
 */
@property(nonatomic,strong)NSNumber *countyNo;

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
 *  加入类型(1:短信受邀2:在线申请)
 */
@property(nonatomic,copy)NSString *joinType;

/**
 *  座机
 */
@property(nonatomic,copy)NSString *telephone;

/**
 *  营业执照注册号
 */
@property(nonatomic,copy)NSString *businessLicenseNo;

/**
 *  营业状况
 */
@property(nonatomic,copy)NSString *businessDesc;

@property(nonatomic,copy)NSString *identityPicUrl;

@property(nonatomic,copy)NSString *businessLicenseUrl;



@end
