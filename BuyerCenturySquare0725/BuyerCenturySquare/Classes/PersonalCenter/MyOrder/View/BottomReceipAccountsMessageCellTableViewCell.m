//
//  BottomReceipAccountsMessageCellTableViewCell.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/3/21.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BottomReceipAccountsMessageCellTableViewCell.h"

@implementation BottomReceipAccountsMessageCellTableViewCell

- (void)awakeFromNib {
    self.cancelOrderBtn.layer.borderWidth = 0.5f;
    self.cancelOrderBtn.layer.borderColor = [UIColor colorWithHexValue:0x000000 alpha:1].CGColor;
    self.cancelOrderBtn.layer.masksToBounds = YES;
    self.cancelOrderBtn.layer.cornerRadius =3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *  确认收货
 *
 *  @param sender
 */
- (IBAction)selectCancelOrderClickBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(MyOrderParentClickDelayGoodsOrderCode:balanceQuantity:)]) {
        [self.delegate MyOrderParentClickDelayGoodsOrderCode:self.orderCode balanceQuantity:self.balanceQuantity];
    }
 

}

/**
 *  延期收货
 *
 *  @param sender
 */
- (IBAction)selectconfirmGoodsClickBtn:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(MyOrderParentClickConfirmOrderCode:)]) {
        [self.delegate MyOrderParentClickConfirmOrderCode:self.orderCode];
        
    }
    
}

- (void)setOrderInfoDto:(OrderInfoListDTO *)orderInfoDto
{
    [super setOrderInfoDto:orderInfoDto];
    
    if (orderInfoDto) {
        if (orderInfoDto.status.integerValue==0||orderInfoDto.status.integerValue==1) {
            
            self.orderStateLab.text = @"应付:";
//            self.goodsTotalPriceLab.text = [NSString stringWithFormat:@"%.2f",orderInfoDto.totalAmount.doubleValue];
//            NSMutableAttributedString* priceString = [[NSMutableAttributedString alloc]initWithString:@"¥ " attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:10]}];
            NSMutableAttributedString* priceString = [[NSMutableAttributedString alloc]initWithString:@"¥ " attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10]}];
            
            NSString *goodsPriceString = [NSString stringWithFormat:@"%.2f",orderInfoDto.paidTotalAmount.doubleValue];
//            NSAttributedString* priceValueString = [[NSAttributedString alloc]initWithString:goodsPriceString attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:16]}];
            NSAttributedString* priceValueString = [[NSAttributedString alloc]initWithString:goodsPriceString attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}];

            [priceString appendAttributedString:priceValueString];
            
            self.goodsTotalPriceLab.attributedText = priceString;

            
        }else{
            self.orderStateLab.text = @"实付:";
//            self.goodsTotalPriceLab.text = [NSString stringWithFormat:@"%.2f",orderInfoDto.paidTotalAmount.doubleValue];
//            NSMutableAttributedString* priceString = [[NSMutableAttributedString alloc]initWithString:@"¥ " attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:10]}];
            
            NSMutableAttributedString* priceString = [[NSMutableAttributedString alloc]initWithString:@"¥ " attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10]}];

            
            NSString *goodsPriceString = [NSString stringWithFormat:@"%.2f",orderInfoDto.paidTotalAmount.doubleValue];
//            NSAttributedString* priceValueString = [[NSAttributedString alloc]initWithString:goodsPriceString attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:16]}];
            NSAttributedString* priceValueString = [[NSAttributedString alloc]initWithString:goodsPriceString attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}];

            [priceString appendAttributedString:priceValueString];
            
            self.goodsTotalPriceLab.attributedText = priceString;

        }    
        self.goodsTotalNumbLab.text = [NSString stringWithFormat:@"共%ld件商品",(long)orderInfoDto.quantity.integerValue]
        ;
        
        
        
        
        
        
    }
}
@end
