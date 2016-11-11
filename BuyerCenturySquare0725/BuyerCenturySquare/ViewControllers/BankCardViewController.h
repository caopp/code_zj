//
//  BankCardViewController.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/1/13.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BalanceChangeBto.h"
#import "CreditTransferDTO.h"
#import "MMPickerView.h"
#import "BaseViewController.h"
@interface BankCardViewController : BaseViewController
//预付货款获取升级列表
@property (nonatomic ,strong)BalanceChangeBto *balanceDto;
//应付金额
@property (nonatomic ,strong)NSNumber *payMoney;

/**
 *  sku对应的等级
 */
@property (nonatomic ,assign) NSInteger skuLevel;

//允许更改金额
@property (nonatomic ,assign) BOOL changeMoneyTF;

/**
 *  审核不通过传入的参数
 */
@property (nonatomic ,strong)CreditTransferDTO *creditDto;


@end
