//
//  ExitChangeGoodsViewController.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/5/25.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BaseJSViewController.h"
#import "GetOrderDetailDTO.h"

@interface ExitChangeGoodsViewController : BaseJSViewController

@property (nonatomic, copy) NSString *orderCode;
@property (nonatomic ,strong) GetOrderDetailDTO *detailDto;
//采购单状态
@property (nonnull ,strong) NSNumber *orderStatus;


@end
