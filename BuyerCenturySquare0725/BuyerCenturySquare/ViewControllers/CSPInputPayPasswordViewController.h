//
//  CSPInputPayPasswordViewController.h
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/6/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderAddDTO.h"
#import "GetPayBalanceDTO.h"

@interface CSPInputPayPasswordViewController : BaseViewController

@property (nonatomic, strong)OrderAddDTO *orderAddDTO;

@property (nonatomic, strong)GetPayBalanceDTO *payBalanceDTO;

@property (nonatomic, assign)CSPPayType payType;

//标记是从购物车进来的
@property (nonatomic,assign) BOOL isGoods;

@end
