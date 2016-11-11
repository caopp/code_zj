//
//  OrderAllListDTO.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/3/21.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface OrderAllListDTO : BasicDTO

/**
 *  商品所有信息
 */
@property (nonatomic, strong)NSMutableArray* orderInfoListArr;
/**
 *  所有采购单数量
 */
@property (nonatomic, strong)NSNumber* totalCount;

@end

@interface OrderInfoListDTO : BasicDTO

/**
 *  快递地址Id
 */
@property (nonatomic, assign)NSInteger addressId;
/**
 *  会员编号
 */
@property (nonatomic, strong)NSString* memberNo;
/**
 *  商家编号
 */
@property (nonatomic, strong)NSString* merchantNo;
/**
 *  商家名称
 */
@property (nonatomic, strong)NSString* merchantName;
/**
 *  采购单号
 */
@property (nonatomic, strong)NSString* orderCode;
/**
 *  采购单状态  0-采购单取消;1-待付款;2-待发货;3-待收货;4-交易取消;5-交易完成
 
 */
@property (nonatomic, strong)NSNumber* status;
/**
 *  采购单总数量
 */
@property (nonatomic, strong)NSNumber* quantity;
/**
 *  采购单总金额
 */
@property (nonatomic, strong)NSNumber* originalTotalAmount;
/**
 *  应付款
 */
@property (nonatomic, strong)NSNumber* totalAmount;
/**
 *  实付款
 */
@property (nonatomic ,strong)NSNumber* paidTotalAmount;
/**
 *  采购单类型
 */
@property (nonatomic, strong)NSNumber* type;
/**
 *  剩余延期次数
 */
@property (nonatomic, strong) NSNumber* balanceQuantity;

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





/**
 *  商品List
 */
@property (nonatomic, strong)NSMutableArray* goodsList;




@property (nonatomic ,strong) NSString *isSelect;

@end



@interface OrderDetailMesssageDTO : BasicDTO

/**
 *  商品编码
 */
@property (nonatomic, strong)NSString* goodsNo;
/**
 *  商品名称
 */
@property (nonatomic, strong)NSString* goodsName;
/**
 *  商品名称
 */
@property (nonatomic, strong)NSString* color;
/**
 *  商品图片
 */
@property (nonatomic, strong)NSString* picUrl;
/**
 *  商品类型:0普通商品 , 1样板商品 2邮费专拍
 */
@property (nonatomic, strong)NSString* cartType;
/**
 *  商品类型:0普通商品 , 1样板商品 2邮费专拍
 */
@property (nonatomic, strong)NSNumber*   price;
/**
 *  数量
 */
@property (nonatomic, strong)NSNumber* quantity;
/**
 *  尺码组合
 */
@property (nonatomic, strong)NSArray*  sizes;




@end