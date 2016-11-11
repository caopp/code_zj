//
//  ListDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface ConsigneeDTO : BasicDTO

/**
 *  收获地址id(类型：int)
 */
@property(nonatomic,strong)NSNumber* Id;

/**
 *  小B编码
 */
@property(nonatomic,strong)NSString *memberNo;

/**
 *  收货人
 */
@property(nonatomic,copy)NSString* consigneeName;

/**
 *  收货人电话
 */
@property(nonatomic,copy)NSString* consigneePhone;

/**
 *  省份编码(类型为int)
 */
@property(nonatomic,strong)NSNumber* provinceNo;

/**
 *  省份名称
 */
@property(nonatomic,copy)NSString* provinceName;

/**
 *  城市编码(类型为int)
 */
@property(nonatomic,strong)NSNumber* cityNo;

/**
 *  城市名称
 */
@property(nonatomic,copy)NSString* cityName;

/**
 *  区县编码(类型为int)
 */
@property(nonatomic,strong)NSNumber* countyNo;

/**
 *  区县名称
 */
@property(nonatomic,copy)NSString* countyName;

/**
 *  邮编地址
 */
//@property(nonatomic,copy)NSString* postalCode;

/**s
 *  详细地址
 */
@property(nonatomic,copy)NSString* detailAddress;

/**
 *  是否默认标识0:默认1:非默认
 */
@property(nonatomic,copy)NSString* defaultFlag;

@property(nonatomic,assign,readonly)BOOL IsLackParameter;

- (NSString*)addressDescription;

@end
