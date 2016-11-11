//
//  ReturnApplyViewController.h
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/5/23.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderDetailDTO.h"//!订单的dto
#import "RefundApplyDTO.h"//!退换货申请的dto

@interface ReturnApplyViewController : BaseViewController

/*
 从订单详情、选择申请退换货类别类别进入：
 refundType、
 orderDetailInfo
 */

//!申请的类型：退换货类型：0-退货退款 1-仅退款 2-换货
@property(nonatomic,copy)NSString * refundType;


/*
 !从退换货详情过来需要传以下参数：
*/

//!订单详情的dto
@property (nonatomic,strong) OrderDetailDTO* orderDetailInfo;

//!申请详情的dto
@property(nonatomic,strong)RefundApplyDTO * applyDTO;

//!从申请详情过来的（需要掉修改接口）
@property(nonatomic,assign)BOOL isFromApplyDetail;



@end
