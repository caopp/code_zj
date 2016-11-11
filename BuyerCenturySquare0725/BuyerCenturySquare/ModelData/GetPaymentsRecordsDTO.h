//
//  GetPaymentsRecordsDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-9-6.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface PaymentsRecordsDTO : BasicDTO
/**
 *  消费金额(类型:double)
 */
@property(nonatomic,strong)NSNumber *amount;
/**
 *  创建时间
 */
@property(nonatomic,copy)NSString *createTime;
/**
 *  外部交易号(topup - 对应支付宝网关交易号 pay-对应内部采购单号)
 */
@property(nonatomic,copy)NSString *outBizNo;

/**
 *  收支表id(类型:int)
 */
@property(nonatomic,strong)NSNumber *recordId;

/**
 *  业务类型(topup:充值 pay:消费)
 */
@property(nonatomic,copy)NSString *businessType;

@end


@interface GetPaymentsRecordsDTO : BasicDTO
/**
 *  当前可用余额(类型:double)
 */
@property(nonatomic,strong)NSNumber *balance;
/**
 *  总数量(类型:int)
 */
@property(nonatomic,strong)NSNumber *totalCount;
/**
 *  数组包含了收支列表条目 DTO
 */
@property(nonatomic,strong)NSMutableArray *paymentsRecordsDTOList;

@end
