//
//  GetPayPayDTO.h
//  BuyerCenturySquare
//
//  Created by jian.zhou on 15-8-11.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BasicDTO.h"

@interface GetPayPayDTO : BasicDTO

/**
 *  支付结果
 */

@property(nonatomic,assign)BOOL payStatus;
/**
 *  在线支付方式
 */
@property(nonatomic,copy)NSString* payMethod;

/**
 *  AlipayQuick  签名数据
 */
@property(nonatomic,copy)NSString* AlipayQuickSignData;

/**
 *  WeChatMobile  签名数据
 */
@property(nonatomic,strong)NSDictionary* WeChatMobileSignData;

@end
