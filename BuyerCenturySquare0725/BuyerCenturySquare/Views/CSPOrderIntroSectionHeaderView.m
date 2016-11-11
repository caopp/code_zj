//
//  CSPOrderIntroSectionHeaderView.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 9/14/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPOrderIntroSectionHeaderView.h"
#import "CSPUtils.h"

@implementation CSPOrderIntroSectionHeaderView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.orderStatusLabel.layer.cornerRadius = 35.0f;
        self.orderStatusLabel.layer.masksToBounds = YES;
    }

    return self;
}

- (void)awakeFromNib {
    self.orderStatusLabel.layer.cornerRadius = 35.0f;
    self.orderStatusLabel.layer.masksToBounds = YES;
    self.orderStatusLabel.adjustsFontSizeToFitWidth = YES;

    self.orderTypeLabel.layer.cornerRadius = 2.0f;
    self.orderTypeLabel.layer.masksToBounds = YES;
}

- (void)setOrderDetailInfo:(OrderDetailDTO *)orderDetailInfo {

    _orderDetailInfo = orderDetailInfo;
    self.orderStatusLabel.text = [orderDetailInfo convertOrderStatusToString];

    self.totalQuantityLabel.text = [NSString stringWithFormat:@"x%ld", (long)orderDetailInfo.quantity];

    self.orderCodeLabel.text = [NSString stringWithFormat:@"采购单号: %@", orderDetailInfo.orderCode];

    CSPOrderMode orderMode = orderDetailInfo.convertOrderStatusToValue;
    [self setTotalPriceDescriptionWithOrderMode:orderMode];
    [self setBackgroundColorWithOrderMode:orderMode];

    [self setOrderTypeContentAndBackgroundColor];
}

- (void)setBackgroundColorWithOrderMode:(CSPOrderMode)orderMode {
    if (orderMode == CSPOrderModeOrderCanceled || orderMode == CSPOrderModeDealCanceled) {
        self.userBackgroundView.backgroundColor = HEX_COLOR(0x999999FF);
        self.orderStatusLabel.textColor = HEX_COLOR(0x999999FF);
        _totalQuantityLabel.textColor = HEX_COLOR(0x999999FF);
    } else {
        self.userBackgroundView.backgroundColor = [UIColor blackColor];
        self.orderStatusLabel.textColor = [UIColor blackColor];
        _totalQuantityLabel.textColor = [UIColor blackColor];
        
    }
}

- (void)setTotalPriceDescriptionWithOrderMode:(CSPOrderMode)orderMode {
    if (orderMode == CSPOrderModeOrderCanceled || orderMode == CSPOrderModeToPay) {
        NSMutableAttributedString* priceString = [[NSMutableAttributedString alloc]initWithString:@"应付 " attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11]}];

        NSAttributedString* priceIconString = [[NSAttributedString alloc]initWithString:@"￥" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];

        NSAttributedString* priceValueString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.02f", self.orderDetailInfo.totalAmount] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Tw Cen MT" size:22]}];

        [priceString appendAttributedString:priceIconString];
        [priceString appendAttributedString:priceValueString];

        self.totalPriceLabel.attributedText = priceString;
    } else {
        NSMutableAttributedString* priceString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"应付: %.02f   实付 ", self.orderDetailInfo.totalAmount] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11]}];

        NSAttributedString* priceIconString = [[NSAttributedString alloc]initWithString:@"￥" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];

        CGFloat goodsPrice = self.orderDetailInfo.paidTotalAmount;
        NSString* goodsPriceString = [CSPUtils isRoundNumber:goodsPrice] ? [NSString stringWithFormat:@"%ld", (long)goodsPrice] : [NSString stringWithFormat:@"%.02f", goodsPrice];

        NSAttributedString* priceValueString = [[NSAttributedString alloc]initWithString:goodsPriceString attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Tw Cen MT" size:22]}];

        [priceString appendAttributedString:priceIconString];
        [priceString appendAttributedString:priceValueString];

        self.totalPriceLabel.attributedText = priceString;
    }
}

- (void)setOrderTypeContentAndBackgroundColor {
    if (self.orderDetailInfo.type == 1) {
        self.orderTypeLabel.text = @"现货单";
        self.orderTypeLabel.backgroundColor = HEX_COLOR(0x5677FCFF);
    } else {
        self.orderTypeLabel.text = @"期货单";
        self.orderTypeLabel.backgroundColor = HEX_COLOR(0x673AB7FF);
    }

}


@end
