//
//  PaymentDetailController.h
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/1/13.
//  Copyright © 2016年 pactera. All rights reserved.
//  转账记录查询

#import "BaseViewController.h"

@interface PaymentDetailController : BaseViewController

//!审核编号
@property(nonatomic,copy)NSString * auditNo;

//!点击返回按钮的时候，如果是从列表进入，则返回上一层，其他情况返回 个人中心主页
@property(nonatomic,assign)BOOL isFromList;


@end
