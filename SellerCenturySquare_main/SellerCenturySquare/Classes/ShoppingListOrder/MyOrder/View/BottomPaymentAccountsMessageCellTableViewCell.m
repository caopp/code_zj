//
//  BottomPaymentAccountsMessageCellTableViewCell.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/3/21.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BottomPaymentAccountsMessageCellTableViewCell.h"

@implementation BottomPaymentAccountsMessageCellTableViewCell

- (void)awakeFromNib {
    
    self.changeOrderTotalBtn.layer.cornerRadius = 3.0f;
    self.changeOrderTotalBtn.layer.masksToBounds = YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)selectChangeOrderTotalBtn:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(myOrderParentChangeOrderPrice:cell:)]) {
    [self.delegate myOrderParentChangeOrderPrice:self.recordOrderDto cell:self];
    }
    
    
}
-  (void)setOrderDto:(GetOrderDTO *)orderDto
{
    [super setOrderDto:orderDto];
    
    self.recordOrderDto = orderDto;
    
    if (orderDto) {
        
        if (orderDto.channelType.integerValue == 0) {
            self.showTotalTypeLab.text = @"采购单总价:";

            self. changeOrderTotalBtn.hidden = NO;
        }else
        {
            self. changeOrderTotalBtn.hidden = YES;
            self.showTotalTypeLab.text = @"订单总价:";

        }
        
        
        
        //商品总数量
        self.goodsTotalNumbLab.text = [NSString stringWithFormat:@"共%ld件商品",(long)orderDto.quantity.integerValue];
        //订单总价
        self.orderTotalPriceLab.text = [NSString stringWithFormat:@"¥%.2f",orderDto.originalTotalAmount.doubleValue];
        
        //采购单实付/应付
        
        if (orderDto.status.integerValue == 0 || orderDto.status.integerValue == 1) {
            self.goodsPayPrice.text = [NSString stringWithFormat:@"¥%.2f",orderDto.totalAmount.doubleValue];
            self.OrderStateLab.text = @"应付:";
            
        }else if (orderDto.status.integerValue == 2||orderDto.status.integerValue == 3 || orderDto.status.integerValue == 4 || orderDto.status.integerValue == 5)
        {
            self.goodsPayPrice.text = [NSString stringWithFormat:@"¥%.2f",orderDto.paidTotalAmount.doubleValue];
            self.OrderStateLab.text = @"实付:";
            
        }
    }
}
@end
