//
//  GetMemberInfoDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-17.
//  Copyright (c) 2015年 pactera. All rights reserved.
//
//  3.40	采购商-详情接口

#import "BasicDTO.h"

@interface GetMemberInfoDTO : BasicDTO
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
 *  平台等级
 */
@property(nonatomic,copy)NSString *tradeLevel;
/**
 *  店铺等级
 */
@property(nonatomic,copy)NSString *shopLevel;
/**
 *  销售总金额(类型 double)
 */
@property(nonatomic,strong)NSNumber *amount;
/**
 *  最近7天销售金额(类型 double)
 */
@property(nonatomic,strong)NSNumber *weekAmount;
/**
 *  上个月销售金额(类型 double)
 */
@property(nonatomic,strong)NSNumber *lastMonthAmount;
/**
 *  销售总数量(类型 int)
 */
@property(nonatomic,strong)NSNumber *orderNum;
/**
 *  最近7天销售数量(类型 int)
 */
@property(nonatomic,strong)NSNumber *weekOrderNum;
/**
 *  上月销售数量(类型 int)
 */
@property(nonatomic,strong)NSNumber *lastMonthOrderNum;
/**
 *  JID
 */
@property(nonatomic,strong)NSString *chatAccount;
/**
 *  昵称
 */
@property(nonatomic,strong)NSString *nickName;
/**
 *  是否已加入黑名单(YES:已加入黑名单 NO:正常)
 */
@property(nonatomic,assign)BOOL blackListFlag;
@end
