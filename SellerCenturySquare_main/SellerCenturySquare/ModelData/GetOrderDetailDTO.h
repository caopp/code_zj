//
//  GetOrderDetailDTO.h
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-8-3.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"
#import "orderGoodsItemDTO.h"

@interface OrderDeliveryDTO : BasicDTO

/**
 *  采购单编号
 */
@property(nonatomic,copy)NSString *orderCode;
/**
 *  快递单图片地址
 */
@property(nonatomic,copy)NSString *deliveryReceiptImage;
/**
 *  创建时间
 */
@property(nonatomic,copy)NSString *createTime;

//!发货类型：1拍照发货，2快递单号发货
@property(nonatomic,strong)NSNumber *type;

//!快递公司代码
@property(nonatomic,copy)NSString  * logisticCode;

//!快递单号
@property(nonatomic,copy)NSString  * logisticTrackNo;

//!快弟公司名称
@property(nonatomic,copy)NSString  * logisticName;


@end

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
 *  采购单状态（类型:int)(0-采购单取消;1-待付款;2-未发货;3-待收货;4-交易取消;5-已签收)
 */
@property(nonatomic,strong)NSNumber *status;
/**
 *  采购单类型(0-期货 ;1-现货)
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
 *  应付款(类型:double)
 */
@property(nonatomic,strong)NSNumber *totalAmount;

//实付金额
@property (nonatomic, strong) NSNumber *paidTotalAmount;
/**
 *  小B呢称
 */
@property(nonatomic,copy)NSString *nickName;
/**
 * 小B聊天帐号
 */
@property(nonatomic,copy)NSString *chatAccount;
/**
 * 自动确认收货剩余时间
 */
@property(nonatomic,copy)NSString *confirmRemainingTime;

/**
 *运费
 */
@property(nonatomic,strong)NSNumber * dFee;


/**
 *  快递单图片列表
 */
@property(nonatomic,strong)NSMutableArray *orderDeliveryDTOList;

/**
 *  商品信息列表
 */
@property(nonatomic,strong)NSMutableArray *goodsList;


/**
 *  原交易金额(类型:double)
 */
@property(nonatomic,strong)NSNumber *oldPaidTotalAmount;

/**
 *  退换货编号
 */
@property(nonatomic,strong)NSString  *refundNo;

/**
 *  退款金额(类型:double)
 */
@property(nonatomic,strong)NSNumber *refundFee;

/**
 *  0-退货退款_处理中 1-退货退款_处理完成 2-仅退款_处理中 3-仅退款_处理完成 4-换货_处理中 5-换货_处理完成 6-已取消
 */
@property(nonatomic,strong)NSNumber *refundStatus;


/**
 *  退换货申请时间
 */

@property(nonatomic,strong)NSString *refundCreateTime;

/**
 *  退换货处理时间
 */

@property(nonatomic,strong)NSString *refundDealTime;


//!配送方式/运费模板的名称
@property(nonatomic,strong)NSString *freightTemplateName;

//!积分抵扣金额
@property(nonatomic,strong)NSNumber * integralAmount;

//!抵扣积分数量
@property(nonatomic,strong)NSNumber * useIntegralNum;


@end
