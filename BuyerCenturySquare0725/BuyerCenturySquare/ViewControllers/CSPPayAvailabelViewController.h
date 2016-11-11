//
//  CSPPayAvailabelViewController.h
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/6/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderAddDTO.h"
#import "WXApi.h"

typedef void (^blockPaystatus)(BOOL isSuccess) ;
@interface CSPPayAvailabelViewController : BaseViewController
{
    BOOL isAvailable_;
}
//@property (nonatomic, strong)NSString *orderCode;

@property (nonatomic, strong)OrderAddDTO *orderAddDTO;

//如果是从采购车界面进来的
@property (nonatomic ,assign) BOOL isGoods;



@property (nonatomic, assign)BOOL isAvailable;

@property (nonatomic ,assign) BOOL isHomePage;

@property (nonatomic ,strong) blockPaystatus payStatus;


@property(nonatomic,strong)NSDictionary *dic;



@end
