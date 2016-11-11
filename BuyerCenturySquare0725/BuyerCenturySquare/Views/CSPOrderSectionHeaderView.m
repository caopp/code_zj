//
//  CSPConfirmOrderSectionHeaderView.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 9/4/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPOrderSectionHeaderView.h"
#import "CartListConfirmDTO.h"
#import "OrderGroupListDTO.h"

@implementation CSPOrderSectionHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.orderTypeLabel.textColor = HEX_COLOR(0x09bb07);
    }
    return self;
}

- (void)awakeFromNib {
    self.backgroundView = [[UIView alloc]initWithFrame:self.bounds];
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    
    self.merchantNameLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMerchanName)];
    [self.merchantNameLabel addGestureRecognizer:tap];
    
}

- (void)setOrderMode:(CSPOrderMode)orderMode {
    _orderMode = orderMode;

    [self updateStatusDescription];
}

- (void)setOrderGroupInfo:(OrderGroup *)orderGroupInfo {
    _orderGroupInfo = orderGroupInfo;

    self.orderMode = orderGroupInfo.orderMode;

    if (_orderGroupInfo.type == 1) {
//        self.orderTypeLabel.attributedText = [[NSAttributedString alloc]initWithString:@"【现货单】" attributes:@{NSForegroundColorAttributeName: HEX_COLOR(0x09bb07)}];
        
        self.orderTypeLabel.text = @"【现货单】";
        self.orderTypeLabel.textColor = [UIColor colorWithHexValue:0x09bb07 alpha:1];

    } else {
//        self.orderTypeLabel.attributedText = [[NSAttributedString alloc]initWithString:@"【期货单】" attributes:@{NSForegroundColorAttributeName: HEX_COLOR(0xfd4f57)}];
        self.orderTypeLabel.text = @"【期货单】";
        self.orderTypeLabel.textColor = [UIColor colorWithHexValue:0xfd4f57 alpha:1];

    }

    self.merchantNameLabel.text = orderGroupInfo.merchantName;
}

- (void)updateStatusDescription {
    switch (self.orderMode) {
        case CSPOrderModeToPay:
            self.orderStatusLabel.text = @"待付款";
            break;
        case CSPOrderModeToDispatch:
            self.orderStatusLabel.text = @"待发货";
            break;
        case CSPOrderModeToTakeDelivery:
            self.orderStatusLabel.text = @"待收货";
            break;
        case CSPOrderModeOrderCanceled:
            self.orderStatusLabel.text = @"采购单取消";
            break;
        case CSPOrderModeDealCompleted:
            self.orderStatusLabel.text = @"交易完成";
            break;
        case CSPOrderModeDealCanceled:
            self.orderStatusLabel.text = @"交易取消";
            break;
        default:
            break;
    }

    [self.orderStatusLabel setHidden:NO];
}

//点击客服
- (IBAction)enquiryButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sectionHeaderView:enquiryWithMerchantName:andMerchantNo:)]) {
        if (_cartConfirmMerchantInfo) {
            [self.delegate sectionHeaderView:self enquiryWithMerchantName:_cartConfirmMerchantInfo.merchantName andMerchantNo:_cartConfirmMerchantInfo.merchantNo];
        } else {
            [self.delegate sectionHeaderView:self enquiryWithMerchantName:_orderGroupInfo.merchantName andMerchantNo:_orderGroupInfo.merchantNo];
        }
    }
}

//点击商家名称
- (void)clickMerchanName
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(CSPOrderSectionHeaderView: merchanName: merchantNo:)]) {
        
        
        if (_cartConfirmMerchantInfo) {
            
            [self.delegate CSPOrderSectionHeaderView:self merchanName:_cartConfirmMerchantInfo.merchantName merchantNo:_cartConfirmMerchantInfo.merchantNo];
            
//            [self.delegate sectionHeaderView:self enquiryWithMerchantName:_cartConfirmMerchantInfo.merchantName andMerchantNo:_cartConfirmMerchantInfo.merchantNo];
        } else {
            [self.delegate CSPOrderSectionHeaderView:self merchanName:_orderGroupInfo.merchantName merchantNo:_orderGroupInfo.merchantNo];
//            [self.delegate sectionHeaderView:self enquiryWithMerchantName:_orderGroupInfo.merchantName andMerchantNo:_orderGroupInfo.merchantNo];
        }
    }
}

- (void)setCartConfirmMerchantInfo:(CartConfirmMerchant *)cartConfirmMerchantInfo {
     if (cartConfirmMerchantInfo.groupSkuType == CartConfirmGroupSkuTypeOfSpot) {
         
//         HEX_COLOR(0x09bb07)
         self.orderTypeLabel.text = @"【现货单】";
         self.orderTypeLabel.textColor = [UIColor colorWithHexValue:0x09bb07 alpha:1];
//        self.orderTypeLabel.attributedText = [[NSAttributedString alloc]initWithString:@"【现货单】" attributes:@{NSForegroundColorAttributeName: HEX_COLOR(0x09bb07)}];
    } else {
//        self.orderTypeLabel.attributedText = [[NSAttributedString alloc]initWithString:@"【期货单】" attributes:@{NSForegroundColorAttributeName: HEX_COLOR(0xfd4f57)}];
        
        self.orderTypeLabel.text = @"【期货单】";
        self.orderTypeLabel.textColor = [UIColor colorWithHexValue:0xfd4f57 alpha:1];
    }

    self.merchantNameLabel.text = cartConfirmMerchantInfo.merchantName;

    [self.orderStatusLabel setHidden:YES];
    [self.enquiryButton setHidden:YES];
}


+ (CGFloat)sectionHeaderHeight {
    return 73.0f;
}

@end
