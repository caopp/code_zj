//
//  OrderTopView.m
//  SellerCenturySquare
//
//  Created by clz on 15/8/18.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "OrderTopView.h"

@implementation OrderTopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing cod
}
*/

- (void)awakeFromNib{
    self.bottomView.backgroundColor = HEX_COLOR(0xeefeff4FF);
}

- (void)setAllOrderAmount:(NSInteger)orderAmount {
    [self.allOrderNumButton setTitle:[NSString stringWithFormat:@"全部采购单", (long)orderAmount] forState:UIControlStateNormal];
}

- (IBAction)waitPaymentButtonClick:(id)sender{
    self.waitPaymentButtonBlock();
}

- (IBAction)waitDeliverGoodsButtonClick:(id)sender{
    self.waitDeliverGoodsButtonBlock();
}

- (IBAction)waitGoodsReceiptButtonClick:(id)sender{
    self.waitGoodsReceiptButtonBlock();
}

- (IBAction)contactCustomerServiceClick:(id)sender {
    
    if (self.contactCustomerServiceBlock) {
        
        self.contactCustomerServiceBlock();

    }
}

- (IBAction)allOrderButtonClick:(id)sender {
    self.allOrderButtonBlock();
}
@end
