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
    self.orderCancelBtn.layer.borderWidth = 0.5f;
    self.orderCancelBtn.layer.borderColor = [UIColor colorWithHexValue:0x000000 alpha:1].CGColor;
    self.orderCancelBtn.layer.masksToBounds = YES;
    self.orderCancelBtn.layer.cornerRadius =3;
    
}

/**
 *  取消采购单
 *
 *  @param sender
 */
- (IBAction)selectCancelOrderBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(MyOrderParentClickCancelGoodsOrderMemberNo:orderCode:)]) {
    [self.delegate MyOrderParentClickCancelGoodsOrderMemberNo:self.memberNo orderCode:self.orderCode];      
    }
  
    
}

/**
 *  付款
 *
 *  @param sender 
 */
- (IBAction)selectPaymentClickBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(MyOrderParentClickPaymentGoodOrderCodes:)]) {
        [self.delegate MyOrderParentClickPaymentGoodOrderCodes:self.orderCode];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOrderInfoDto:(OrderInfoListDTO *)orderInfoDto
{
    [super setOrderInfoDto:orderInfoDto];
    if (orderInfoDto) {
        if (orderInfoDto.status.integerValue==0||orderInfoDto.status.integerValue==1) {
            
            self.OrderStateLab.text = @"应付:";
//            self.goodsTotalPriceLab.text = [NSString stringWithFormat:@"%.2f",orderInfoDto.totalAmount.doubleValue];
//            NSMutableAttributedString* priceString = [[NSMutableAttributedString alloc]initWithString:@"¥ " attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:10]}];
            NSMutableAttributedString* priceString = [[NSMutableAttributedString alloc]initWithString:@"¥ " attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10]}];

            
            NSString *goodsPriceString = [NSString stringWithFormat:@"%.2f",orderInfoDto.paidTotalAmount.doubleValue];
//            NSAttributedString* priceValueString = [[NSAttributedString alloc]initWithString:goodsPriceString attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:16]}];
            NSAttributedString* priceValueString = [[NSAttributedString alloc]initWithString:goodsPriceString attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}];

            [priceString appendAttributedString:priceValueString];
            
            
            
            self.goodsTotalPriceLab.attributedText = priceString;

            
            
        }else{
            self.OrderStateLab.text = @"实付:";
            
//            NSMutableAttributedString* priceString = [[NSMutableAttributedString alloc]initWithString:@"¥ " attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:10]}];
            NSMutableAttributedString* priceString = [[NSMutableAttributedString alloc]initWithString:@"¥ " attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10]}];

            
            
            NSString *goodsPriceString = [NSString stringWithFormat:@"%.2f",orderInfoDto.paidTotalAmount.doubleValue];
//            NSAttributedString* priceValueString = [[NSAttributedString alloc]initWithString:goodsPriceString attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:16]}];
            NSAttributedString* priceValueString = [[NSAttributedString alloc]initWithString:goodsPriceString attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}];

            [priceString appendAttributedString:priceValueString];

            self.goodsTotalPriceLab.attributedText = priceValueString;

//            self.goodsTotalPriceLab.text = [NSString stringWithFormat:@"%.2f",orderInfoDto.paidTotalAmount.doubleValue];
            
        }
        self.goodsTotalNumbLab.text = [NSString stringWithFormat:@"共%ld件商品", (long)orderInfoDto.quantity.integerValue ];
        
        
    }
}
- (void)setOrderDetailMessageDto:(OrderDetailMesssageDTO *)orderDetailMessageDto
{
    if (orderDetailMessageDto) {
        self.goodsNo = orderDetailMessageDto.goodsNo;
        
    }
}

@end
