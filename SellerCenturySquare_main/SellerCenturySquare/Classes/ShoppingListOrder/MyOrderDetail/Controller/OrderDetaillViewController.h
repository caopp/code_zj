//
//  OrderDetaillViewController.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/30.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "OrderDetailHeaderView.h"//!采购单的headerview

#import "OrderDeatiGoodsViewCell.h"//!普通商品的cell
#import "OrderDetailSampleCell.h"//!样板商品的cell
#import "DeliverAlertViewCell.h"
#import "PhotoDeliverViewCell.h"
#import "ExpressDeliverViewCell.h"
#import "GetOrderDetailDTO.h"

//!底部bottom的view
#import "DetailObligationBottomView.h"//!待付款
#import "DetailWaitCommitBottomView.h"//!待发货
#import "DetailWaitTakeBottomView.h"//!待收货
#import "RefundDeailBottomView.h"//!退换货

@interface OrderDetaillViewController : BaseViewController
{
    UITableView * _tableView;

    OrderDetailHeaderView * headerView;//!headerview

    GetOrderDetailDTO * detailDTO;//!采购单详情的数据

    //采购单状态（类型:int)(0-采购单取消;1-待付款;2-未发货;3-待收货;4-交易取消;5-已签收)
    NSNumber * orderStatus;//!采购单详情的状态
    
    //!发货信息段的行数
    NSInteger returnRow;
    
    //!底部的view
    DetailObligationBottomView * obligationBottomView;//!待付款底部的view
    
    DetailWaitCommitBottomView *  waitCommitBottomView;//!待发货
    
    DetailWaitTakeBottomView * waitTakeBottomView;//!待收货
    
    RefundDeailBottomView * refundDeailBottomView;//!退换货


}
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


#pragma mark 提供给子类调用的方法
//进入客服
-(void)customService;

//! 退换货申请的判断
//!判断是否提交退换货申请，没有取消申请，并且有发货信息行要显示（则tableView行数+1）
-(BOOL)isApplyRefundWitTakeInfo;


//!判断是否提交退换货申请，并且没有取消申请
-(BOOL)isApplyRefund;

//!商品信息cell isFromRetail:是否是零售
-(UITableViewCell *)goodsTableViewCell:(NSIndexPath *)indexPath isFremRetail:(BOOL)isFromRetail;

//!提醒信息、发货信息cell
-(UITableViewCell *)alertTableViewCell:(NSIndexPath *)indexPath;

//!发货信息段显示的信息
-(NSString *)sectionTwoFirstCellText;

//!待收货、显示的发货提示信息
-(NSMutableAttributedString *)waitTakeAlertText;

//!4-交易取消; 5-已签收 时 第二段最后一行的 信息
-(NSString *)sectionTwoLastText;

//!提交申请的时间显示
-(NSString *)showApplyTime;


//!提示信息行的高度
-(CGFloat)alertCellHight:(NSIndexPath *)indexPath;

//!商品cell的高度
-(CGFloat)goodsCellHight:(NSIndexPath *)indexPath;

//!收货地址headerView的高度
-(CGFloat)addressHeaderViewHight;

//!发货信息段的行数
-(NSInteger)alertRowNum;

//!请求数据回来之后，创建底部发bottom
-(void)makeBottom;

//!批发是：采购单取消时间  零售是：订单取消时间
-(NSString *)getCanacelStr;


@end
