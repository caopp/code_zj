//
//  GetOrderListDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GetOrderDTO : BasicDTO
/**
 *  快递地址(类型:int)
 */
@property(nonatomic,strong)NSNumber *addressId;
/**
 *  会员编号
 */
@property(nonatomic,copy)NSString *memberNo;
/**
 *  商家编号
 */
@property(nonatomic,copy)NSString *merchantNo;
/**
 *  商家名称
 */
@property(nonatomic,copy)NSString *merchantName;
/**
 *  采购单号
 */
@property(nonatomic,copy)NSString *orderCode;
/**
 *  采购单状态(0-采购单取消;1-未付款;2-未发货;3-已发货;4-交易取消;5-已签收)(int)
 */
@property(nonatomic,strong)NSNumber *status;
/**
 *  采购单总数量（int）
 */
@property(nonatomic,strong)NSNumber *quantity;
/**
 *  采购单总金额(类型:double)
 */
@property(nonatomic,strong)NSNumber *originalTotalAmount;
/**
 *  应付款/实付款(类型:double)
 */
@property(nonatomic,strong)NSNumber *totalAmount;
/**
 *  采购单类型(0-期货 ;1-现货)
 */
@property(nonatomic,strong)NSNumber *type;
/**
 *  剩余延期次数(类型：int)
 */
@property(nonatomic,strong)NSNumber *balanceQuantity;
/**
 *  采购单条目列表
 */
@property(nonatomic,strong)NSMutableArray *orderGoodsItemsList;

@end


@interface GetOrderListDTO : BasicDTO

/**
 *  获取采购单列表信息(OrderDTO)
 */
@property(nonatomic,strong)NSMutableArray *getOrderDTOList;

@end
