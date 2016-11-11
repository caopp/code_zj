//
//  UpdateMerchantInfoModel.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface UpdateMerchantInfoModel : BasicDTO

/**
 *  店铺负责人
 */
@property(nonatomic,copy)NSString* shopkeeper;
/**
 *  身份证
 */
@property(nonatomic,copy)NSString* identityNo;

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
 *  合同编号
 */
@property(nonatomic,copy)NSString *contractNo;
/**
 *  性别1:男 2:女
 */
@property(nonatomic,copy)NSString *sex;
/**
 *  联系手机
 */
@property(nonatomic,copy)NSString *mobilePhone;
/**
 *  联系座机
 */
@property(nonatomic,copy)NSString *telephone;
/**
 *  简介
 */
@property(nonatomic,copy)NSString *Description;

/**
 *商家头像
 */
@property(nonatomic,copy)NSString * iconUrl;



@property(nonatomic,assign,readonly)BOOL IsLackParameter;

@end




