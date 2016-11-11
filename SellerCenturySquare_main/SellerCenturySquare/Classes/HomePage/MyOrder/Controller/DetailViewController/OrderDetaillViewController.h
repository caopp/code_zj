//
//  OrderDetaillViewController.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/30.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface OrderDetaillViewController : BaseViewController

/*
 1、待付款
 下单时间  +1行
 
 2、待发货
 下单时间
 付款时间  +1行
 
 3、待收货
 自动确认收货时间
 下单时间
 付款时间   +1行
 
 <发货时间 + 快递单/快递公司、单号>
 
 4、交易完成  +2行
 下单时间
 付款时间
 
 <发货时间 + 快递单/快递公司、单号>

 收货时间
 
 5、采购单取消  +1行
 下单时间
 采购单取消时间
 
 
 6、交易取消 +2行
 下单时间
 付款时间
 
 <发货时间 + 快递单/快递公司、单号>
 
 收货时间
 交易取消时间
 
 
 
 
 */
/*
 底部的栏：
 
 待付款、
 待发货、
 待收货、
 
 交易完成、交易冻结（查看退换详情）
 
 */


//!需要传入的参数：采购单id
@property(nonatomic,copy)NSString * orderCode;


//!拍照发货、录入快递单发货（待发货） 这些操作完成之后调用block，返回给采购单列表，用来修改采购单列表
/*

 orederCode:采购单号
 orderOldStatus：采购单原来的状态
 
 */
@property(nonatomic,copy)void(^deliverGoodsInWaitStatusBlock)(NSString * orederCode,NSString * orderOldStatus);


//!修改采购单总价（待付款）；
/*
 
 orederCode:采购单号
 orderOldStatus：采购单原来的状态
 修改后的订单总价
 
 */
@property(nonatomic,copy)void(^changeTotalCountBlock)(NSString * orederCode,NSString * orderOldStatus,NSString * totalCount);




@end
