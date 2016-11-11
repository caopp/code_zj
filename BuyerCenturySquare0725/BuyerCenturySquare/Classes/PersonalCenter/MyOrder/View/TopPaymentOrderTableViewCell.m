//
//  TopPaymentOrderTableViewCell.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/3/19.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "TopPaymentOrderTableViewCell.h"

@implementation TopPaymentOrderTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setOrderInfoDto:(OrderInfoListDTO *)orderInfoDto
{
    [super setOrderInfoDto:orderInfoDto];
    
        
        
        if (orderInfoDto) {
            if (orderInfoDto.type.integerValue == 0) {
                self.orderNameLab.text = @"【现货单】";
                self.orderNameLab.textColor = [UIColor colorWithHexValue:0x5677fc alpha:1];
                
            }else
            {
                self.orderNameLab.text = @"【期货单】";
                self.orderNameLab.textColor = [UIColor colorWithHexValue:0x683bb7 alpha:1];
            }

        //        0-采购单取消;1-待付款;2-待发货;3-待收货;4-交易取消;5-交易完成
        switch (orderInfoDto.status.integerValue) {
            case 0:
                self.goodsStateLab.text = @"采购单取消";
                
                break;
            case 1:
                self.goodsStateLab.text = @"待付款";
                
                break;
                
            case 2:
                self.goodsStateLab.text = @"待发货";
                
                break;
                
            case 3:
                self.goodsStateLab.text = @"待收货";
                
                break;
                
            case 4:
                self.goodsStateLab.text = @"交易取消";
                
                break;
            case 5:
                self.goodsStateLab.text = @"交易完成";
                
                break;
                
                
                
            default:
                break;
        }

    }
}


@end
