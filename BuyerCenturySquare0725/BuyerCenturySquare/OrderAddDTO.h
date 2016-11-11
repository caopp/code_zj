//
//  OrderAddDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-7-14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@class TradeDataDTO;
@interface OrderAddDTO : BasicDTO



@property (nonatomic ,strong) NSMutableArray *canPayOrdersArr;

@property (nonatomic ,strong) NSMutableArray *cannotPayOrdersArr;

@property (nonatomic ,strong) TradeDataDTO *tradeDto;


/**
 *交易总金额(类型为Double)
 */
@property(nonatomic,strong)NSNumber* totalAmount;
/**
 *交易单号
 */
@property(nonatomic,copy)NSString* tradeNo;

@end


@interface TradeDataDTO :BasicDTO

/**
 *  交易总金额
 */
@property (nonatomic ,strong) NSNumber *totalAmount;

/**
 *  交易单号
 */
@property (nonatomic ,strong) NSString *tradeNo;


@end


//可以支付采购单列表


@interface CanPayOrdersDTO : BasicDTO
/**
 *  交易总金额
 */
@property (nonatomic ,strong) NSString *merchantName;

/**
 *  交易单号
 */
@property (nonatomic ,strong) NSString *orderCode;

/**
 *  采购单类型0-期货 ;1-现货
 */
@property (nonatomic ,strong) NSNumber *orderType;

/**
 *  采购单金额
 */
@property (nonatomic ,strong) NSNumber *totalAmount;

/**
 *  采购单类型（期货，现货）
 */
@property (nonatomic ,strong) NSString *typeTitle;




@end

//不可以支付采购单列表
@interface CannotPayOrdersDTO : BasicDTO


/**
 *  名称
 */
@property (nonatomic ,strong) NSString *merchantName;

/**
 *  交易单号
 */
@property (nonatomic ,strong) NSString *orderCode;

/**
 *  采购单类型0-期货 ;1-现货
 */
@property (nonatomic ,strong) NSNumber *orderType;

/**
 *  采购单金额
 */
@property (nonatomic ,strong) NSNumber *totalAmount;

/**
 *  采购单类型（期货，现货）
 */
@property (nonatomic ,strong) NSString *typeTitle;



@end
