//
//  GetOrderDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-8-3.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicDTO.h"

@interface OrderListAllDTO : BasicDTO

@property (nonatomic ,assign) NSInteger totalCount;
@property (nonatomic ,strong) NSMutableArray *orderListArr;
@property (nonatomic ,strong) NSNumber *channelType;


@end



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
 *  会员名称
 */
@property(nonatomic,copy)NSString *memberName;
/**
 *  小B昵称
 */
@property(nonatomic,copy)NSString *nickName;
/**
 *  小B会员手机
 */
@property(nonatomic,copy)NSString *memberPhone;
/**
 *  采购单号
 */
@property(nonatomic,copy)NSString *orderCode;
/**
 *  采购单状态(0-采购单取消;1-未付款;2-未发货;3-已发货;4-交易取消;5-已签收)
 */
@property(nonatomic,strong)NSNumber *status;
/**
 *  采购单总数量(类型:int)
 */
@property(nonatomic,strong)NSNumber *quantity;
/**
 *  采购单总金额(类型:double)
 */
@property(nonatomic,strong)NSNumber *originalTotalAmount;
/**
 * 应付金额/(类型:double)
 */
@property(nonatomic,strong)NSNumber *totalAmount;
/**
 *  实付金额
 */
@property (nonatomic ,strong)NSNumber *paidTotalAmount;
/**
 *  采购单类型(0-期货 ;1-现货 类型:int)
 */
@property(nonatomic,strong)NSNumber *type;

/**
 *  小B聊天帐号
 */
@property(nonatomic,strong)NSString *chatAccount;
//收获人名称
@property (nonatomic ,strong) NSString *consigneeName;
//收获人电话
@property (nonatomic ,strong) NSString *consigneePhone;

//退换货编号
@property (nonatomic ,strong)NSString *refundNo;

//退款金额
@property (nonatomic ,strong)NSNumber *refundFee;

//0-退货退款_处理中 1-退货退款_处理完成 2-仅退款_处理中 3-仅退款_处理完成 4-换货_处理中 5-换货_处理完成 6-已取消
@property (nonatomic ,strong)NSNumber *refundStatus;

//退换货申请时间
@property (nonatomic ,strong) NSString *refundCreateTime;

//退换货处理时间
@property (nonatomic ,strong) NSString *refundDealTime;


//no 表示未选中  yes选中
@property (nonatomic ,copy) NSString *markStatus;

//!频道 0 批发 1零售
@property (nonatomic ,strong) NSNumber *channelType;





/**
 *  采购单条目列表
 */
@property(nonatomic,strong)NSMutableArray *goodsList;

@end
