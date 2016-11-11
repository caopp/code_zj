//
//  ReturnViewController.h
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/5/23.
//  Copyright © 2016年 pactera. All rights reserved.
//  !退换货选择列表

#import "BaseViewController.h"
#import "OrderDetailDTO.h"

@interface ReturnViewController : BaseViewController

//!订单信息的dto
@property (nonatomic,strong) OrderDetailDTO* orderDetailInfo;



@end
