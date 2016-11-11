//
//  ExitChangeGoodsViewController.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/5/25.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BaseJSViewController.h"
#import "OrderDetailDTO.h"

@interface ExitChangeGoodsViewController : BaseJSViewController

@property (nonatomic, copy) NSString *orderCode;
@property (nonatomic ,strong) OrderDetailDTO *detailDto;


@end
