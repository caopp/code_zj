//
//  PayMulitiConfirmPayDTO.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/3/25.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BasicDTO.h"
/**
 *  合并采购单请求DTO
 */
@interface PayMulitiConfirmPayDTO : BasicDTO

/**
 *  交易总金额
 */
@property (nonatomic ,strong) NSNumber *totalAmount;
/**
 *  交易单号
 */
@property (nonatomic ,strong) NSString *tradeNo;

@end
