//
//  GetMerchantInfoDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-22.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

//3.7	大B商家信息接口
#import "BasicDTO.h"

@interface GetMerchantInfoDTO : BasicDTO

/**
 *  商家编码
 */
@property(nonatomic,copy)NSString *merchantNo;
/**
 *  商家名称
 */
@property(nonatomic,copy)NSString *merchantName;
/**
 *  商家平台等级(类型:int)
 */
@property(nonatomic,strong)NSNumber *level;
/**
 *  商家图片路径
 */
@property(nonatomic,copy)NSString *pictureUrl;
/**
 *  营业状态(0/YES:营业1/NO:歇业)
 */
@property(nonatomic,assign)BOOL operateStatus;
/**
 *  商家状态(0:开启1:关闭)
 */
@property(nonatomic,copy)NSString *merchantStatus;
/**
 *  歇业开始时间
 */
@property(nonatomic,copy)NSString *closeStartTime;
/**
 *  歇业结束时间
 */
@property(nonatomic,copy)NSString *closeEndTime;
/**
 *  起批数量限制开启状态(0:开启1:关闭)
 */
@property(nonatomic,copy)NSString *batchAmountFlag;
/**
 *  起批数量限制开启状态(0:开启1:关闭)
 */
@property(nonatomic,copy)NSString *batchNumFlag;
/**
 *  起批金额 (类型:Double)
 */
@property(nonatomic,strong)NSNumber *batchAmountLimit;
/**
 *  起批数量 (类型:int)
 */
@property(nonatomic,strong)NSNumber *batchNumLimit;
/**
 *  当月积分 (类型:Double)
 */
@property(nonatomic,strong)NSNumber *monthIntegralNum;
/**
 *  联系手机
 */
@property(nonatomic,copy)NSString *mobilePhone;
/**
 *  联系座机
 */
@property(nonatomic,copy)NSString *telephone;
/**
 *  微信号
 */
@property(nonatomic,copy)NSString *wechatNo;
/**
 *  档口号
 */
@property(nonatomic,copy)NSString *stallNo;
/**
 *  简介
 */
@property(nonatomic,copy)NSString *Description;
/**
 *  剩余下载次数(类型:int)
 */
@property(nonatomic,strong)NSNumber *downloadNum;
/**
 *  店铺负责人
 */
@property(nonatomic,copy)NSString *shopkeeper;
/**
 *  身份证
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
 *  合同编号
 */
@property(nonatomic,copy)NSString *contractNo;
/**
 *  性别1:男 2:女
 */
@property(nonatomic,copy)NSString *sex;
/**
 * 是否主账户(0/YES:主账户 1/NO:子账户)
 */
@property(nonatomic,assign)BOOL isMaster;
/**
 * 图片七日内下载限制(0/YES:开启 1/NO:关闭)
 */
@property(nonatomic,assign)BOOL downloadLimit7;

/**
 *商家头像
 */
@property(nonatomic,copy)NSString * iconUrl;

/**
 *主营分类名称
 */
@property(nonatomic,copy)NSString * categoryName;

/**
 *主营分类编码
 */
@property(nonatomic,copy)NSString * categoryNo;


//待付款订单数-C端
@property(nonatomic,copy)NSNumber *notPayCOrderNum;
//待发货订单数-C端
@property(nonatomic,copy)NSNumber *unshippedCNum;
//待收货订单数-C端
@property(nonatomic,copy)NSNumber *untakeOrderCNum;
//退换货数量-C端
@property(nonatomic,copy)NSNumber *refundOrderCNum;


+ (instancetype)sharedInstance;

- (NSString*)convertToCompleteAddress;
@end
