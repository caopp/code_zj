//
//  CSPOrderSectionFooterView.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 9/9/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPOrderSectionFooterView.h"
#import "OrderGroupListDTO.h"
#import "CSPUtils.h"
#import "CustomButton.h"

@interface CSPOrderSectionFooterView ()

@property (weak, nonatomic) IBOutlet UILabel *goodsAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *postponeGoods;
@property (weak, nonatomic) IBOutlet CustomButton *payButtonClickeBtn;
@property (weak, nonatomic) IBOutlet CustomButton *confirmReceiveButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingSpaceConfirmReveiveButtonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingSpacePayButtonConstraint;

@end

@implementation CSPOrderSectionFooterView

static CGFloat kCommonTrailingSpace = 0.0f;
static CGFloat kInvisibleTrailingSpace = 480.0f;

- (void)awakeFromNib {
    self.backgroundView = [[UIView alloc]initWithFrame:self.bounds];
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    self.postponeGoods.layer.cornerRadius = 2;
    self.postponeGoods.layer.masksToBounds = YES;
    self.postponeGoods.layer.borderColor = [UIColor blackColor].CGColor;
    self.postponeGoods.layer.borderWidth = 1;
    
    self.payButtonClickeBtn.backgroundColor = [UIColor blackColor];
    self.confirmReceiveButton.backgroundColor = [UIColor blackColor];
    
    
}

#pragma mark -
#pragma mark Setter

- (void)setOrderMode:(CSPOrderMode)orderMode {
    _orderMode = orderMode;

    [self updateConstraintsForButtons];

    [self updatePriceDescription];
}

- (void)setOrderGroupInfo:(OrderGroup *)orderGroupInfo {
    _orderGroupInfo = orderGroupInfo;

    self.orderMode = orderGroupInfo.orderMode;

    self.goodsAmountLabel.text = [NSString stringWithFormat:@"共%ld件商品", (long)orderGroupInfo.quantity];

    NSMutableAttributedString* priceString = [[NSMutableAttributedString alloc]initWithString:@"￥" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}];

    CGFloat goodsPrice;
    switch (self.orderMode) {
        case CSPOrderModeToPay:
        case CSPOrderModeToDispatch:
        case CSPOrderModeToTakeDelivery:
        case CSPOrderModeOrderCanceled:
         goodsPrice   = orderGroupInfo.totalAmount;

            break;
        case CSPOrderModeDealCompleted:
        case CSPOrderModeDealCanceled:
            goodsPrice = orderGroupInfo.paidTotalAmount;
            
            break;
        default:
            break;
    }

    NSString* goodsPriceString = [CSPUtils isRoundNumber:goodsPrice] ? [NSString stringWithFormat:@"%ld", (long)goodsPrice] : [NSString stringWithFormat:@"%.02f", goodsPrice];

    NSAttributedString* priceValueString = [[NSAttributedString alloc]initWithString:goodsPriceString attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Tw Cen MT" size:24]}];

    [priceString appendAttributedString:priceValueString];

    self.priceLabel.attributedText = priceString;
}


#pragma mark -
#pragma mark Private Methods

- (void)updateConstraints {
    [super updateConstraints];

    [self updateConstraintsForButtons];
}

- (void)updateConstraintsForButtons {
    switch (self.orderMode) {
        case CSPOrderModeToPay:
            self.trailingSpaceConfirmReveiveButtonConstraint.constant = kInvisibleTrailingSpace;
            self.trailingSpacePayButtonConstraint.constant = kCommonTrailingSpace;
            break;
        case CSPOrderModeToDispatch:
            self.trailingSpacePayButtonConstraint.constant = kInvisibleTrailingSpace;
            self.trailingSpaceConfirmReveiveButtonConstraint.constant = kInvisibleTrailingSpace;
            break;
        case CSPOrderModeToTakeDelivery:
            self.trailingSpacePayButtonConstraint.constant = kInvisibleTrailingSpace;
            self.trailingSpaceConfirmReveiveButtonConstraint.constant = kCommonTrailingSpace;
            break;
        case CSPOrderModeDealCanceled:
        case CSPOrderModeDealCompleted:
        case CSPOrderModeOrderCanceled:
            self.trailingSpacePayButtonConstraint.constant = kInvisibleTrailingSpace;
            self.trailingSpaceConfirmReveiveButtonConstraint.constant = kInvisibleTrailingSpace;
            break;
        default:
            break;
    }
}

- (void)updatePriceDescription {
    switch (self.orderMode) {
        case CSPOrderModeToPay:
        case CSPOrderModeOrderCanceled:
            self.priceDescLabel.text = @"应付:";
            break;
        case CSPOrderModeToTakeDelivery:

        case CSPOrderModeToDispatch:
        case CSPOrderModeDealCompleted:
        case CSPOrderModeDealCanceled:
            self.priceDescLabel.text = @"实付:";
            break;
        default:
            break;
    }
}


//确认支付
- (IBAction)payButtonClicked:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(payButtonClickedForOrderGroup:)]) {
        [self.delegate payButtonClickedForOrderGroup:self.orderGroupInfo];
    }
}

//延迟收货
- (IBAction)postponeGoods:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(postponeGoods:)]) {
        [self.delegate postponeGoods:self.orderGroupInfo];
        
        
    }
    
    
    
}
//取消采购单

- (IBAction)cancelButtonClicked:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelUnpaidOrder:)]) {
        [self.delegate cancelUnpaidOrder:self.orderGroupInfo];
    }
    
    
}

//确认收货
- (IBAction)confirmReceiveButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(confirmTakeDeliveryForOrder:)]) {
        [self.delegate confirmTakeDeliveryForOrder:self.orderGroupInfo];
    }
}

+ (CGFloat)sectionFooterHeightWithOrderMode:(CSPOrderMode)orderMode {
    CGFloat sectionHeight = 0.0f;
    switch (orderMode) {
        case CSPOrderModeToPay:
        case CSPOrderModeToTakeDelivery:
            sectionHeight = 86.0f;
            break;
        case CSPOrderModeToDispatch:
        case CSPOrderModeDealCanceled:
        case CSPOrderModeDealCompleted:
        case CSPOrderModeOrderCanceled:
            sectionHeight = 67.0f;
            break;
        default:
            break;
    }
    return sectionHeight;
}

@end
