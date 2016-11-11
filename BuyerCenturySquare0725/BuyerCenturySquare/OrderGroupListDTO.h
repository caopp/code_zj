//
//  OrderListDTO.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 9/9/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "BasicDTO.h"
#import "CSPOrderModeUtils.h"

@interface OrderGoods : BasicDTO


@property (nonatomic, strong)NSString* goodsNo;//商品编码
@property (nonatomic, strong)NSString* goodsName;//商品名称
@property (nonatomic, strong)NSString* color;//商品颜色
@property (nonatomic, strong)NSString* pictureUrl;//商品图片
@property (nonatomic, strong)NSString* cartType;//商品类型:0普通商品 , 1样板商品 2邮费专拍
@property (nonatomic, assign)CGFloat   price;//单价
@property (nonatomic, assign)NSInteger quantity;//数量
@property (nonatomic, strong)NSArray*  sizes;//尺码组合

- (CartGoodsType)cartGoodsType;

@end

@interface OrderGroup : BasicDTO
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
@property (nonatomic, strong)NSString* memberName;
/**
 *  采购单号
 */
@property (nonatomic, strong)NSString* orderCode;
/**
 *  采购单状态  0-采购单取消;1-待付款;2-待发货;3-待收货;4-交易取消;5-交易完成

 */
@property (nonatomic, assign)NSInteger status;
/**
 *  采购单总数量
 */
@property (nonatomic, assign)NSInteger quantity;
/**
 *  采购单总金额
 */
@property (nonatomic, assign)CGFloat originalTotalAmount;
/**
 *  应付款
 */
@property (nonatomic, assign)CGFloat totalAmount;
/**
 *  实付款
 */
@property (nonatomic ,assign)CGFloat paidTotalAmount;
/**
 *  采购单类型
 */
@property (nonatomic, assign)NSInteger type;
/**
 *  剩余延期次数
 */
@property (nonatomic, assign) NSInteger balanceQuantity;

@property (nonatomic, strong)NSString* memberPhone;
@property (nonatomic, strong)NSString* merchantName;
@property (nonatomic, strong)NSString* nickName;
@property (nonatomic, strong)NSMutableArray* goodsList;

- (CSPOrderMode)orderMode;

@end

@interface OrderGroupListDTO : BasicDTO

@property (nonatomic, strong)NSMutableArray* groupList;
@property (nonatomic, assign)NSInteger totalCount;

- (void)removeOrderGroup:(OrderGroup*)orderGroup;
- (BOOL)isLoadedAll;
- (NSInteger)nextPage;

@end
