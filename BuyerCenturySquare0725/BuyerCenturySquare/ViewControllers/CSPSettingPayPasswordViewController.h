//
//  CSPSettingPayPasswordViewController.h
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/6/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderAddDTO.h"
#import "GetPayBalanceDTO.h"

@interface CSPSettingPayPasswordViewController : BaseViewController


@property (nonatomic, strong)OrderAddDTO *orderAddDTO;
@property (nonatomic, assign)CSPPayType payType;
@property (nonatomic, strong)GetPayBalanceDTO *payBalanceDTO;


//标记是用购物车进来的
@property (nonatomic ,assign) BOOL isGoods;

@property(nonatomic ,assign) BOOL isChangePassWord;


@end
