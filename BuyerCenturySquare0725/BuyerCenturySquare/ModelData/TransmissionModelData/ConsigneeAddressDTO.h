//
//  ConsigneeAddressDTO.h
//  BuyerCenturySquare
//
//  Created by clz on 15/7/16.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface ConsigneeAddressDTO : BasicDTO

/**
 *  收货人姓名
 */
@property(nonatomic,copy)NSString *consigneeName;

/**
 *  收货人电话
 */
@property(nonatomic,copy)NSString *consigneePhone;

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
 *  收货人详细地址
 */
@property(nonatomic,copy)NSString *detailAddress;

/**
 *  是否默认收货地址(0:默认1:非默认)
 */
@property(nonatomic,copy)NSString *defaultFlag;


////tokenId
//
@property(nonatomic,copy)NSString *tokenId;

//merberNo
@property(nonatomic,copy)NSString *merberNo;


@property(nonatomic,assign,readonly)BOOL IsLackParameter;

@property(nonatomic,copy)NSString *joinType;
@end
