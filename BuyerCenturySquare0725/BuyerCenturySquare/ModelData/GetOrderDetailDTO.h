//
//  GetOrderDetailDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-8-20.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GetOrderDetailDTO : BasicDTO

/**
 *  快递地址ID(类型:int)
 */
@property(nonatomic,strong)NSNumber *addressId;
/**
 *  收货人姓名
 */
@property(nonatomic,copy)NSString *consigneeName;
/**
 *  收货人电话
 */
@property(nonatomic,copy)NSString *consigneePhone;
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
 *  采购单号
 */
@property(nonatomic,copy)NSString *orderCode;
/**
 *  采购单状态（类型:int)
 */
@property(nonatomic,strong)NSNumber *status;
/**
 *  采购单类型(0-期货 ;1-现货:int)
 */
@property(nonatomic,strong)NSNumber *type;
/**
 *  采购单数量（类型:int)
 */
@property(nonatomic,strong)NSNumber *quantity;
/**
 * 采购单金额（类型:double)
 */
@property(nonatomic,strong)NSNumber *originalTotalAmount;
/**
 *  小B会员编号
 */
@property(nonatomic,copy)NSString *memberNo;
/**
 *  商家编号
 */
@property(nonatomic,copy)NSString *merchantNo;
/**
 *  下单时间
 */
@property(nonatomic,copy)NSString *createTime;
/**
 *  付款时间
 */
@property(nonatomic,copy)NSString *paymentTime;
/**
 *  发货时间
 */
@property(nonatomic,copy)NSString *deliveryTime;
/**
 *  收货时间
 */
@property(nonatomic,copy)NSString *receiveTime;
/**
 *  采购单取消时间
 */
@property(nonatomic,copy)NSString *orderCancelTime;
/**
 *  交易取消时间
 */
@property(nonatomic,copy)NSString *dealCancelTime;
/**
 *  采购单自增ID(类型:double)
 */
@property(nonatomic,strong)NSNumber *totalAmount;
/**
 *  自动确认收货剩余时间（格式：2天10小时）
 */
@property(nonatomic,copy)NSString *confirmRemainingTime;
/**
 *  剩余延期次数(类型:int)
 */
@property(nonatomic,strong)NSNumber *balanceQuantity;
/**
 *  快递单图片列表
 */
@property(nonatomic,strong)NSMutableArray *orderDeliveryList;

/**
 *  商品信息列表
 */
@property(nonatomic,strong)NSMutableArray *orderGoodsItemsList;

@end
