//
//  BankAndOhterPayController.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/1/16.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BaseViewController.h"
#import "BalanceChangeBto.h"
#import "WXApi.h"

@interface BankAndOhterPayController : BaseViewController

/**
 *  支付金额
 */
@property (nonatomic ,strong) NSNumber *payMoney;
/**
 *  支付金额所升得的等级
 */
@property (nonatomic ,strong) NSNumber *payLevel;

/**
 *  等级下的sku 。level
 */

@property (nonatomic ,assign) NSInteger skuLevel;

//预付货款获取升级列表
@property (nonatomic ,strong)BalanceChangeBto *balanceDto;



@end
