//
//  CSPMerchantClosedView.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 8/14/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPMerchantClosedView.h"

@implementation CSPMerchantClosedView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    
    self.reviewMerchantsButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.reviewMerchantsButton.layer.borderWidth = 1.0f;
    
    self.closedAlertLabel.text = @"很抱歉, 您查看的商家已失效!";
    
    self.choiceAlertLabel.text = @"您可以选择以下操作";
    
    [self.choiceGoodsBtn  setTitle:@"返回上一页" forState:UIControlStateNormal];
    self.choiceGoodsBtn.layer.cornerRadius = 2.0f;
    self.choiceGoodsBtn.layer.masksToBounds = YES;
  
}
- (IBAction)backSubView:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(backSubViewController)]) {
        [self.delegate backSubViewController];
    }
}
//查看下架商品列表
- (IBAction)reviewGoodsButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(reviewGoodsList)]) {
        [self.delegate reviewGoodsList];
    }
}
//浏览其它商品
- (IBAction)reviewMerchantsButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(reviewOtherList)]) {
        [self.delegate reviewOtherList];
    }
}

- (void)setType:(MerchantClosedViewType)type {
    _type = type;
    
    switch (type) {
        case MerchantClosedViewTypeMerchantClosed:
            self.tipLabel.text = @"很抱歉, 您查看的商家已关闭!";
            break;
        case MerchantClosedViewTypeGoodsInvalid:
            self.tipLabel.text = @"很抱歉, 您查看的商品已失效!";
            break;
        default:
            break;
    }
}
@end
