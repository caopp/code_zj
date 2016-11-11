//
//  BottomOtherAccountMessageTableViewCell.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/3/21.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BottomOtherAccountMessageTableViewCell.h"

@implementation BottomOtherAccountMessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
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
            
            self.orderStateLab.text = @"应付:";
//            NSMutableAttributedString* priceString = [[NSMutableAttributedString alloc]initWithString:@"¥ " attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:10]}];
            NSMutableAttributedString* priceString = [[NSMutableAttributedString alloc]initWithString:@"¥ " attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10]}];
            
            NSString *goodsPriceString = [NSString stringWithFormat:@"%.2f",orderInfoDto.paidTotalAmount.doubleValue];
//            NSAttributedString* priceValueString = [[NSAttributedString alloc]initWithString:goodsPriceString attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:16]}];
            NSAttributedString* priceValueString = [[NSAttributedString alloc]initWithString:goodsPriceString attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}];

            [priceString appendAttributedString:priceValueString];
            
            self.self.goodsTotalPriceNumb.attributedText = priceString;

//            self.goodsTotalPriceNumb.text = [NSString stringWithFormat:@"%.2f",orderInfoDto.totalAmount.doubleValue];
            
            
        }else{
            self.orderStateLab.text = @"实付:";
//            self.goodsTotalPriceNumb.text = [NSString stringWithFormat:@"%.2f",orderInfoDto.paidTotalAmount.doubleValue];
//            NSMutableAttributedString* priceString = [[NSMutableAttributedString alloc]initWithString:@"¥ " attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:10]}];
            NSMutableAttributedString* priceString = [[NSMutableAttributedString alloc]initWithString:@"¥ " attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10]}];
            
            NSString *goodsPriceString = [NSString stringWithFormat:@"%.2f",orderInfoDto.paidTotalAmount.doubleValue];
            
//            NSAttributedString* priceValueString = [[NSAttributedString alloc]initWithString:goodsPriceString attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:16]}];
            NSAttributedString* priceValueString = [[NSAttributedString alloc]initWithString:goodsPriceString attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}];

            [priceString appendAttributedString:priceValueString];
            
            self.goodsTotalPriceNumb.attributedText = priceString;

            
        }
        
        self.goodsTotalNumbLab.text = [NSString stringWithFormat:@"共%ld件商品",(long)orderInfoDto.quantity.integerValue];
       
    }
}

@end
