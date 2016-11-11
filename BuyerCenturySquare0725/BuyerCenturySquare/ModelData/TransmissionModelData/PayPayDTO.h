//
//  PayPayDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-8-11.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface PayPayDTO : BasicDTO
 
/**
 *  交易号
 */
@property(nonatomic,copy)NSString *tradeNo;
/**
 *  是否使余额
 */
@property(nonatomic,copy)NSString *useBalance;
/**
 *  余额支付金额（useBalance 为 true 时必填）
 */
@property(nonatomic,strong)NSNumber *balanceAmount;
/**
 *  支付密码
 */
@property(nonatomic,copy)NSString *password;

/**
 *  支付方式(AlipayQuick , WeChatMobile)
 */
@property(nonatomic,copy)NSString *payMethod;

/**
 *  支付金额
 */
@property(nonatomic,strong)NSNumber *payAmount;

@property(nonatomic,assign,readonly)BOOL IsLackParameter;

@end
