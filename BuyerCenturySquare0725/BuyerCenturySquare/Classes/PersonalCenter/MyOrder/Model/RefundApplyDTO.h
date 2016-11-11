//
//  RefundApplyDTO.h
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/5/25.
//  Copyright © 2016年 pactera. All rights reserved.
//  !退换货申请的dto

#import "BasicDTO.h"

@interface RefundApplyDTO : BasicDTO

//!订单编号
@property(nonatomic,strong)NSString * orderCode;

//!退换货类型：0-退货退款 1-仅退款 2-换货
@property(nonatomic,strong)NSNumber * refundType;

//!退换货原因  0-质量问题 1-尺码问题 2-少件/破损 3-卖家发错货 4-未按约定时间发货5-多拍/拍错/不想要6-快递/物流问题7-空包裹/少货8-其他
@property(nonatomic,strong)NSNumber * refundReason;

//!货物状态 0-未收到货 1-已收到货
@property(nonatomic,strong)NSNumber * goodsStatus;

//!退款金额
@property(nonatomic,strong)NSString * refundFee;

//!备注
@property(nonatomic,strong)NSString * remark;

//!凭证集合
@property(nonatomic,strong)NSString * pics;

//!退换货编号
@property(nonatomic,strong)NSString * refundNo;

//0-退货退款_处理中 1-退货退款_处理完成 2-仅退款_处理中 3-仅退款_处理完成 4-换货_处理中 5-换货_处理完成 6-已取消

@property (nonatomic ,strong) NSNumber *refundStatus;
@end
