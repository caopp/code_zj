//
//  OrderDetailDTO.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 9/14/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "BasicDTO.h"
#import "CartListDTO.h"
#import "CSPOrderModeUtils.h"
#import "OrderAllListDTO.h"

@interface OrderDelivery : BasicDTO

@property (nonatomic, strong)NSString* orderCode;
@property (nonatomic, strong)NSString* picUrl;
@property (nonatomic, strong)NSString* createTime;

@end

@interface OrderGoodsItem : BasicDTO


@property (nonatomic, strong)NSString* goodsNo;
@property (nonatomic, strong)NSString* goodsName;
@property (nonatomic, strong)NSString* color;
@property (nonatomic, strong)NSString* picUrl;
@property (nonatomic, strong)NSString* cartType;
@property (nonatomic, assign)CGFloat price;
@property (nonatomic, assign)NSInteger quantity;
@property (nonatomic, strong)NSArray* sizes;

- (CartGoodsType)cartGoodsType;

@end

@interface OrderDetailDTO : BasicDTO

//@property (nonatomic, assign)NSInteger addressId;
@property (nonatomic ,strong)NSString *addressId;
@property (nonatomic, strong)NSString* consigneeName;
@property (nonatomic, strong)NSString* consigneePhone;
@property (nonatomic, strong)NSString *provinceNo;
@property (nonatomic, strong)NSString* provinceName;
@property (nonatomic, strong)NSString *cityNo;
@property (nonatomic, strong)NSString* cityName;
@property (nonatomic, strong)NSString* countyName;
@property (nonatomic, strong)NSString* detailAddress;
@property (nonatomic, strong)NSString* orderCode;

//!订单状态(0-订单取消;1-待付款;2-待发货;3-待收货;4-交易取消;5-交易完成)
@property (nonatomic, assign)NSInteger status;

@property (nonatomic, assign)NSInteger type;
@property (nonatomic, assign)NSInteger quantity;
@property (nonatomic, assign)double originalTotalAmount;
@property (nonatomic ,assign)double paidTotalAmount;

@property (nonatomic, strong)NSString* memberNo;
@property (nonatomic, strong)NSString* merchantNo;
@property (nonatomic, strong)NSString* merchantName;
@property (nonatomic, strong)NSString* createTime;
@property (nonatomic, strong)NSString* paymentTime;
@property (nonatomic, strong)NSString* deliveryTime;
//收货时间
@property (nonatomic, strong)NSString* receiveTime;
@property (nonatomic, strong)NSString* orderCancelTime;
@property (nonatomic, strong)NSString* dealCancelTime;
@property (nonatomic, assign)double totalAmount;
@property (nonatomic, strong)NSString *confirmRemainingTime;
@property (nonatomic ,assign)NSInteger balanceQuantity;
@property (nonatomic, strong)NSMutableArray* orderDeliveryList;

//退换货编号
@property (nonatomic ,strong)NSNumber *refundNo;

//退款金额
@property (nonatomic ,strong)NSNumber *refundFee;


//0-退货退款_处理中 1-退货退款_处理完成 2-仅退款_处理中 3-仅退款_处理完成 4-换货_处理中 5-换货_处理完成 6-已取消
@property (nonatomic ,strong)NSNumber *refundStatus;

//退换货申请时间
@property (nonatomic ,strong) NSString *refundCreateTime;

//退换货处理时间
@property (nonatomic ,strong) NSString *refundDealTime;


@property (nonatomic, strong)NSMutableArray* goodsList;


//原交易金额
@property (nonatomic ,strong) NSNumber *oldPaidTotalAmount;

/**
 *  运费
 */
@property (nonatomic ,strong) NSNumber *dFee;

//!运费模板名称
@property (nonatomic ,copy) NSString *freightTemplateName;

/**
 *  快递单图片列表
 */
@property (nonatomic ,strong) NSMutableArray *orderDelivery;

//自动收货时间，下单，付款，发货，
@property (nonatomic ,strong) NSMutableArray *mailTimesArr;

@property (nonatomic ,strong) NSMutableArray *mailEndTimesArr;




- (NSString*)convertOrderStatusToString;
- (CSPOrderMode)convertOrderStatusToValue;
- (NSString*)addressDescription;
- (NSArray*)deliveryStatusTimeList;

@end
