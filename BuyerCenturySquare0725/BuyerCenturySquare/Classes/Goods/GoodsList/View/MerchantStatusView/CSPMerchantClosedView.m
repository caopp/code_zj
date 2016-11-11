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
    
    self.closedAlertLabel.text = NSLocalizedString(@"closedAlert", @"很抱歉, 您查看的商家已关闭!");
    
    self.choiceAlertLabel.text = NSLocalizedString(@"choiceAlert", @"您可以选择浏览其他商家或商品");
    
    [self.choiceGoodsBtn  setTitle:NSLocalizedString(@"choiceGoods", @"选购商品") forState:UIControlStateNormal];
    
    
    [self.reviewMerchantsButton setTitle:NSLocalizedString(@"browseMerchant", @"浏览商家") forState:UIControlStateNormal];
    
    
 
    
}

- (IBAction)reviewGoodsButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(reviewGoodsList)]) {
        [self.delegate reviewGoodsList];
    }
}

- (IBAction)reviewMerchantsButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(reviewMerchantList)]) {
        [self.delegate reviewMerchantList];
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
