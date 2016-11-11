//
//  BottomOrderCancelPayCancelMessageTableViewCell.m
//  SellerCenturySquare
//
//  Created by 陈光 on 16/7/19.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BottomOrderCancelPayCancelMessageTableViewCell.h"

@implementation BottomOrderCancelPayCancelMessageTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setOrderDto:(GetOrderDTO *)orderDto
{
    [super setOrderDto:orderDto];
    if (orderDto) {
        //商品总数量
        self.goodsTotalNumbLab.text = [NSString stringWithFormat:@"共%ld件商品",(long)orderDto.quantity.integerValue];
        
        //采购单实付/应付
        
        if (orderDto.status.integerValue == 0 || orderDto.status.integerValue == 1) {
            self.goodsPayPrice.text = [NSString stringWithFormat:@"¥%.2f",orderDto.totalAmount.doubleValue];
            self.orderStateLab.text = @"应付:";
            
        }else if (orderDto.status.integerValue == 2||orderDto.status.integerValue == 3 || orderDto.status.integerValue == 4 || orderDto.status.integerValue == 5)
        {
            self.goodsPayPrice.text = [NSString stringWithFormat:@"¥%.2f",orderDto.paidTotalAmount.doubleValue];
            self.orderStateLab.text = @"实付:";
            
        }
    }
}

@end
