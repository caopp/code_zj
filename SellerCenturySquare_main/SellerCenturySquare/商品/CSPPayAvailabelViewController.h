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


@interface CSPPayAvailabelViewController : BaseViewController
{
    BOOL isAvailable_;
}
@property (nonatomic, strong)NSString *orderCode;

@property (nonatomic, strong)OrderAddDTO *orderAddDTO;

@property (nonatomic, assign)BOOL isAvailable;




@end
