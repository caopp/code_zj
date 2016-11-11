//
//  SelectApplyTypeCell.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/5/23.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "SelectApplyTypeCell.h"

@implementation SelectApplyTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    //!分割线的颜色
    [self.returnAndRefundFilterLabel setBackgroundColor:[UIColor colorWithHexValue:0xc8c7cc alpha:1]];
    
    [self.refundFilterLabel setBackgroundColor:[UIColor colorWithHexValue:0xc8c7cc alpha:1]];
    
    //!类型的颜色
    [self.returnAndRefundLabel setTextColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
    [self.refundLabel setTextColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
    
    [self.exchangeLabel setTextColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
    

}

//!退货退款
- (IBAction)returnAndRefundBtClick:(id)sender {
    
    [self setLeftTextColor:@"0"];
    
}
//!仅退款

- (IBAction)refundBtnClick:(id)sender {
    
    [self setLeftTextColor:@"1"];

    
}

//!换货
- (IBAction)exchangeBtnClick:(id)sender {
    
    [self setLeftTextColor:@"2"];

    
}
-(void)setLeftTextColor:(NSString *)type{
    
    
    //!返回选择的类型
    if (self.changeSelectType) {
        
        self.changeSelectType(type);
        
    }

    
    if (self.orderDetailInfo.status == 2) {//!订单状态为“待发货” 则 只可以选择“仅退款”
        
        //!订单状态(0-订单取消;1-待付款;2-待发货;3-待收货;4-交易取消;5-交易完成)

        type = @"1";
        
    }
    
    self.returnAndRefundBtn.selected = NO;
    self.refundBtn.selected = NO;
    self.exchangeBtn.selected = NO;
    
    
    //!类型的颜色
    [self.returnAndRefundLabel setTextColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
    [self.refundLabel setTextColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
    
    [self.exchangeLabel setTextColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
    
    if ([type isEqualToString:@"0"]) {//!退货退款
        
        [self.returnAndRefundLabel setTextColor:[UIColor colorWithHexValue:0xeb301f alpha:1]];
        
        self.returnAndRefundBtn.selected = YES;

        
    }else if ([type isEqualToString:@"1"]){//!仅退款
        
        [self.refundLabel setTextColor:[UIColor colorWithHexValue:0xeb301f alpha:1]];
    
        self.refundBtn.selected = YES;

        
    }else{//!换货
    
        [self.exchangeLabel setTextColor:[UIColor colorWithHexValue:0xeb301f alpha:1]];
    
        self.exchangeBtn.selected = YES;

    }
    

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
