//
//  OrderDetailHeaderView.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/30.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "OrderDetailHeaderView.h"
#import "CSPUtils.h"

static float oldPayViewHight = 18;//!退货退款、仅退款 处理完成状态下，“原交易金额”所在view的高度
static float headerViewHight = 171;//!黑色部分显示信息的高度

@implementation OrderDetailHeaderView


// Only override drawRect: if you perform custom drawing.
// Axn empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    
    //!削圆
    self.whiteCircleView.layer.cornerRadius = 63.0/2;
    self.whiteCircleView.layer.masksToBounds = YES;

    
    self.typeLabel.layer.cornerRadius = 2;
    self.typeLabel.layer.masksToBounds =  YES;
    
    self.addressLabel.textColor = [UIColor colorWithHex:0x666666 alpha:1];
    
    self.deliverWayLabel.textColor = [UIColor colorWithHex:0x666666 alpha:1];

    [self setBackgroundColor:[UIColor colorWithHex:0xefeff4 alpha:1]];

    //!隐藏客服按钮
//    self.customBtn.hidden = YES;
  
}
//!零售订单详情的初始化方法
-(void)configDataInRetail:(GetOrderDetailDTO *)detailDTO{

    self.isRetail = YES;
    
    [self configData:detailDTO];
    
    self.typeLabelWidth.constant = 0 ;//!无“期货”/“现货”之分
    
    self.customBtn.hidden = YES;


}

//!批发订单详情的初始化方法
-(void)configData:(GetOrderDetailDTO * )detailDTO{

    //!0-采购单取消;1-待付款;2-待发货;3-待收货;4-交易取消;5-交易完成
    int orderStatusInt = [detailDTO.status intValue];

    
    //!采购单取消、交易取消，顶部的颜色变成灰色
    if (detailDTO) {
        
        if (orderStatusInt == 0 || orderStatusInt == 4) {
            
            [self.priceView setBackgroundColor:[UIColor colorWithHex:0x999999 alpha:1]];
            [self.headerView setBackgroundColor:[UIColor colorWithHex:0x999999 alpha:1]];
            
        }else{
            
            [self.priceView setBackgroundColor:[UIColor blackColor]];
            [self.headerView setBackgroundColor:[UIColor blackColor]];
            
        }
        
    }
   
    
    //!顶部显示的状态
    [self showStatus:detailDTO];
    
    //!商品总数
    if ([CSPUtils isEmpty:detailDTO.quantity]) {
        
        self.goodsNumLabel.text = @"";
        
    }else{
        
        self.goodsNumLabel.text = [NSString stringWithFormat:@"%@",detailDTO.quantity];
        
        
    }
    
    //!设置共同的信息
    [self setCommonInfo:detailDTO];
    
    /*
     有三种情况：
     1、退货退款（处理完成） 、仅退款（处理完成）：实付、原交易金额（含运费）、退款
     2、待发货、待收货、交易完成 、交易取消 + 【换货 + 退货退款（处理中）+ 仅退款（处理中）】：实付（含运费）
     3、待付款、订单取消 ：应付（含运费）
     
     */
    
  

    //!订单提交退换货申请、并且没有取消申请
    if (![detailDTO.refundStatus isEqual:@""] && ![detailDTO.refundStatus isEqual:[NSNumber numberWithInt:6]]) {
    
        int refundStatus = [detailDTO.refundStatus intValue];
        //!1-退货退款_处理完成 3-仅退款_处理完成
        if (refundStatus == 1 || refundStatus == 3) {
            
            [self showRefundSuccessInfo:detailDTO];
            
            
            
        }else{
        
            [self showRealPay:detailDTO];
            
        }
        
        
    }else{
    
        if (orderStatusInt == 0 || orderStatusInt == 1) {//!待付款、订单取消
            
            [self showShouldPay:detailDTO];
            
        }else{
        
            [self showRealPay:detailDTO];

        }
    
    
    }
    
    //!判断是否显示 原交易金额这一行
    if ([self showOldPayView:detailDTO]) {
        
        self.oldTradeAndRefundViewHight.constant = oldPayViewHight;
        self.headerViewHight.constant = headerViewHight;

        
    }else{
        
        self.oldTradeAndRefundViewHight.constant = 0;
        self.headerViewHight.constant = headerViewHight - oldPayViewHight;
        
        self.oldTradeAndCarriageLabel.text = @"";
        self.refundLabel.text = @"";
        
        
        
    }
    
    
}
#pragma mark 显示状态
-(void)showStatus:(GetOrderDetailDTO * )detailDTO{

   
    //!0-退货退款_处理中 1-退货退款_处理完成 2-仅退款_处理中 3-仅退款_处理完成 4-换货_处理中 5-换货_处理完成 6-已取消
    NSDictionary * refundStatusDic = @{@"0":@"退货退款_处理中",
                                       @"1":@"退货退款_处理完成",
                                       @"2":@"仅退款_处理中",
                                       @"3":@"仅退款_处理完成",
                                       @"4":@"换货_处理中",
                                       @"5":@"换货_处理完成",
                                       @"6":@"已取消"};
   
    //!0-采购单取消;1-待付款;2-待发货;3-待收货;4-交易取消;5-交易完成
    NSMutableDictionary * normalStatusDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                            @"1":@"待付款",
                                                                                            @"2":@"待发货",
                                                                                            @"3":@"待收货",
                                                                                            @"4":@"交易取消",
                                                                                            @"5":@"交易完成"
                                                                                            }];
    
    
    if (_isRetail) {//!零售订单
        
        [normalStatusDic setObject:@"订单取消" forKey:@"0"];
 
    }else{//!批发订单
        
        [normalStatusDic setObject:@"采购单取消" forKey:@"0"];
    
    }
    
    //!申请了退货退款
    if (![detailDTO.refundStatus isEqual:@""]) {
        
        self.statueLabel.text = refundStatusDic[[NSString stringWithFormat:@"%@",detailDTO.refundStatus]];
     
        //!取消退换货申请 = 6
        if ([detailDTO.refundStatus intValue] != 6) {//!如果没有取消申请
            
            self.statusWidth.constant = 135;
            
            return;
        }
        
    }
    
    self.statusWidth.constant = 63;

    
   //!未申请退换货
    self.statueLabel.text = normalStatusDic[[NSString stringWithFormat:@"%@",detailDTO.status]];



}

#pragma mark 共同的信息
-(void)setCommonInfo:(GetOrderDetailDTO * )detailDTO{

    //!类型 0-期货 ;1-现货
    if ([detailDTO.type intValue] == 0) {
        
        self.typeLabel.text = @"期货单";
        [self.typeLabel setBackgroundColor:[UIColor colorWithHex:0xeb301f]];
        
    }else{
        
        self.typeLabel.text = @"现货单";
        [self.typeLabel setBackgroundColor:[UIColor colorWithHex:0x9bb07]];

        
    }
    //!采购单号
    if ([CSPUtils isEmpty:detailDTO.orderCode]) {
        
        self.orderNumLabel.text = @"";
        
    }else{
        
        if (_isRetail) {//!零售订单
           
            self.orderNumLabel.text = [NSString stringWithFormat:@"订单号:%@",detailDTO.orderCode];

            
        }else{//!批发订单
        
            self.orderNumLabel.text = [NSString stringWithFormat:@"采购单号:%@",detailDTO.orderCode];

        }
        
    }
    
    //!采购单总价
    if ([CSPUtils isEmpty:detailDTO.originalTotalAmount]) {
        
        self.allPriceLabel.text = @"";
        
    }else{
        
        if (_isRetail) {//!零售订单
            
            self.allPriceLabel.text = [NSString stringWithFormat:@"订单总价:￥%.2f",[detailDTO.originalTotalAmount doubleValue]];

            
        }else{//!批发订单
        
            self.allPriceLabel.text = [NSString stringWithFormat:@"采购单总价:￥%.2f",[detailDTO.originalTotalAmount doubleValue]];

        }

    }
    
    
    
    
    //!收货人
    if ([CSPUtils isEmpty:detailDTO.consigneeName]) {
        
        self.consigneeLabel.text = @"";
        
    }else{
        
        self.consigneeLabel.text = [NSString stringWithFormat:@"收货人:%@",detailDTO.consigneeName];
        
        
    }
    
    //!收货人电话号码
    self.phoneLabel.text = detailDTO.consigneePhone;
    
    //!详细地址
    self.addressLabel.text = [NSString stringWithFormat:@"收货地址:%@",detailDTO.detailAddress];
    
    //!计算收货地址的高度
    CGSize addressSize = [detailDTO.detailAddress boundingRectWithSize:CGSizeMake(self.frame.size.width - 15 - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size;
    
    self.addressHight.constant = addressSize.height;

    
    //!配送方式
    if ([detailDTO.freightTemplateName isEqualToString:@""]) {
        
        self.deliverWayLabel.text = @"配送方式：包邮";

        
    }else{
        
        self.deliverWayLabel.text = [NSString stringWithFormat:@"配送方式：%@",detailDTO.freightTemplateName];
    
    }
    

}

#pragma mark 金额显示

/*
 显示实付（含运费）
 待发货、待收货、交易完成 、交易取消 + 换货+退货退款（处理中）+ 仅退款（处理中）
 */
-(void)showRealPay:(GetOrderDetailDTO *)detailDTO{

    self.payLeftLaebl.text = @"实付:￥";
    //!实付
    self.shouldPayPriceLabel.text = [NSString stringWithFormat:@"%.2f",[detailDTO.paidTotalAmount doubleValue]];
    
    //!运费
    self.carriageLabel.text = [NSString stringWithFormat:@"含运费:￥%.2f",[detailDTO.dFee doubleValue]];

}
/*
 显示应付（含运费）
 待付款、订单取消
 */
-(void)showShouldPay:(GetOrderDetailDTO *)detailDTO{

    self.payLeftLaebl.text = @"应付:￥";

    //!应付
    self.shouldPayPriceLabel.text = [NSString stringWithFormat:@"%.2f",[detailDTO.totalAmount doubleValue]];

    //!运费
    self.carriageLabel.text = [NSString stringWithFormat:@"含运费:￥%.2f",[detailDTO.dFee doubleValue]];
    
    
}
/*
 显示 实付、原交易金额（含运费）、退款
 退货退款(处理完成) 、仅退款（处理完成）
 */
-(void)showRefundSuccessInfo:(GetOrderDetailDTO *)detailDTO{

    self.payLeftLaebl.text = @"实付:￥";
    //!实付
    self.shouldPayPriceLabel.text = [NSString stringWithFormat:@"%.2f",[detailDTO.paidTotalAmount doubleValue]];
    
    //!运费(现在运费要显示到 原交易金额后面)
    self.carriageLabel.text = @"";

    //!原交易金额（含运费）
    self.oldTradeAndCarriageLabel.text = [NSString stringWithFormat:@"原交易金额:￥%.2f(含运费:￥%.2f)",[detailDTO.oldPaidTotalAmount doubleValue],[detailDTO.dFee doubleValue]];
    
    //!退款
    self.refundLabel.text = [NSString stringWithFormat:@"退款:￥%.2f",[detailDTO.refundFee doubleValue]];
    
    
    
}

#pragma mark 判断是否显示 原交易金额这一行
-(BOOL)showOldPayView:(GetOrderDetailDTO *)detailDTO{
    
    //!订单提交退换货申请、并且没有取消申请
    if (![detailDTO.refundStatus isEqual:@""] && ![detailDTO.refundStatus isEqual:[NSNumber numberWithInt:6]]) {
        
        int refundStatus = [detailDTO.refundStatus intValue];
        //!1-退货退款_处理完成 3-仅退款_处理完成
        if (refundStatus == 1 || refundStatus == 3) {
            
            return YES;
            
        }
        
    }
    
    return NO;
    
    
}

//!客服按钮
- (IBAction)customServiceBtnClick:(id)sender {
    
    if (self.customBtnClickBlock) {
        
        self.customBtnClickBlock();
        
    }
    
    
}







@end
