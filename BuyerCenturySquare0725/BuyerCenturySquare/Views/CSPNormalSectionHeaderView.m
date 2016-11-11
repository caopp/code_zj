//
//  CSPNormalSectionHeaderView.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 9/14/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPNormalSectionHeaderView.h"
#import "OrderDetailDTO.h"

@implementation CSPNormalSectionHeaderView

- (void)setOrderDetailInfo:(OrderDetailDTO*)orderDetailInfo {
    _orderDetailInfo = orderDetailInfo;

    [self.merchantButton setTitle:_orderDetailInfo.merchantName forState:UIControlStateNormal];
}

- (IBAction)merchantNameButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sectionHeaderView:reviewMerchantGoodsWithMerchantNo:)]) {
        [self.delegate sectionHeaderView:self reviewMerchantGoodsWithMerchantNo:self.orderDetailInfo.merchantNo];
    }
}

- (IBAction)enquiryButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sectionHeaderView:enquiryWithMerchantName:andMerchantNo:)]) {
        [self.delegate sectionHeaderView:self enquiryWithMerchantName:self.orderDetailInfo.merchantName andMerchantNo:self.orderDetailInfo.merchantNo];
    }

}

@end
