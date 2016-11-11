//
//  BalanceChangeBto.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/1/7.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface BalanceChangeBto : BasicDTO

@property (nonatomic ,strong)NSNumber *level;

@property (nonatomic ,strong) NSMutableDictionary *balancDic;
@property (nonatomic ,strong) NSMutableArray *prepayListArr;

@end

@interface BalanceBTO : BasicDTO

//可用金额
@property (nonatomic ,strong) NSNumber *availableAmount;

//冻结金额
@property (nonatomic ,strong) NSNumber *freezeAmount;

//会员编码
@property (nonatomic ,strong) NSNumber *memberNo;


/**
 *  会员类型:0小B 1大B
 */
@property (nonatomic ,strong) NSNumber *memberType;

//总金额
@property (nonatomic ,strong) NSNumber *totalAmount;

@end

@interface PrepayList : BasicDTO

//升级等级
@property (nonatomic ,strong) NSNumber *level;

//充值金额
@property (nonatomic ,strong) NSNumber *advancePayment;

//商品编码
@property (nonatomic ,strong) NSNumber *goodsNo;

//Sku编码
@property (nonatomic ,strong) NSNumber *skuNo;


@end