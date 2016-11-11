//
//  MerchantShopDetailDTO.h
//  BuyerCenturySquare
//
//  Created by clz on 15/7/22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//  商家详情dto 

#import "BasicDTO.h"

@interface MerchantShopDetailDTO : BasicDTO
/**
 *  商家编码
 */
@property(nonatomic,copy)NSString *merchantNo;

/**
 *  商家名称
 */
@property(nonatomic,copy)NSString *merchantName;

/**
 *  分类名称
 */
@property(nonatomic,copy)NSString *categoryName;

/**
 *  分类编码
 */
@property(nonatomic,copy)NSString *categoryNo;

/**
 *  手机号
 */
@property(nonatomic,copy)NSString *mobilePhone;

/**
 *  微信
 */
@property(nonatomic,copy)NSString *wechatNo;

/**
 *  简介
 */

@property(nonatomic,copy)NSString *merchantDescription;

/**
 *  省份编码(类型：int)
 */
@property(nonatomic,strong)NSNumber *provinceNo;

/**
 *  省份名称
 */
@property(nonatomic,copy)NSString *provinceName;

/**
 *  城市编码(类型：int)
 */
@property(nonatomic,strong)NSNumber *cityNo;

/**
 *  城市名称
 */
@property(nonatomic,copy)NSString *cityName;

/**
 *  区县编码(类型：int)
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
 *  档口号
 */
@property(nonatomic,copy)NSString *stallNo;

/**
 * 店招图片路径
 */
@property(nonatomic,copy)NSString *pictureUrl;

/**
 *是否收藏：0是，1否
 */
@property(nonatomic,copy)NSString *isFavorite;



- (NSString*)addressDescription;

@end
