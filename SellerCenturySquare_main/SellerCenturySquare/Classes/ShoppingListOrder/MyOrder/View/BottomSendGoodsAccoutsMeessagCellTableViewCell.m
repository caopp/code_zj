//
//  BottomSendGoodsAccoutsMeessagCellTableViewCell.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/3/21.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BottomSendGoodsAccoutsMeessagCellTableViewCell.h"

@implementation BottomSendGoodsAccoutsMeessagCellTableViewCell

- (void)awakeFromNib {
//    self.cencelOrderBtn.layer.borderWidth = 0.5f;
//    self.cencelOrderBtn.layer.borderColor = [UIColor colorWithHex:0x000000 alpha:1].CGColor;
//    self.cencelOrderBtn.layer.masksToBounds = YES;
//    self.cencelOrderBtn.layer.cornerRadius =3;
    
    self.photoExpressOrderBtn.layer.cornerRadius = 3.0f;
    self.photoExpressOrderBtn.layer.masksToBounds = YES;
    self.entryExpressOrderBtn.layer.cornerRadius = 3.0f;
    self.entryExpressOrderBtn.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)selectPhotoExpressOrderBtn:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(myOrderParentSelectShootExpressSingle:getOrderdto:)]) {
    [self.delegate myOrderParentSelectShootExpressSingle:self getOrderdto:self.recrodGetOrderDto];
    }
    
    
    
}
- (IBAction)selectEntryExpressOrderBtn:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(myOrderParentSelectEntryExpressSingle:getOrderdto:)]) {
        [self.delegate myOrderParentSelectEntryExpressSingle:self getOrderdto:self.recrodGetOrderDto];
        
    }
}
- (void)setOrderDto:(GetOrderDTO *)orderDto
{
    if (orderDto) {
        self.recrodGetOrderDto = orderDto;
        
        //商品总数量
        self.goodsTotalNumbLab.text = [NSString stringWithFormat:@"共%ld件商品",(long)orderDto.quantity.integerValue];
        //订单总价
        self.orderTotalPriceLab.text = [NSString stringWithFormat:@"¥%.2f",orderDto.originalTotalAmount.doubleValue];
        
        if (orderDto.channelType.integerValue == 0) {
            self.showTotalPriceTypeLab.text = @"采购单总价";
        }else
        {
            self.showTotalPriceTypeLab.text = @"订单总价";
        }
        
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
