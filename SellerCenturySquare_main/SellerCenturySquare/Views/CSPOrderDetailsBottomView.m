//
//  CSPOrderDetailsBottomView.m
//  SellerCenturySquare
//
//  Created by clz on 15/8/19.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPOrderDetailsBottomView.h"

@implementation CSPOrderDetailsBottomView

- (void)awakeFromNib{
    self.tipBackgroundView.backgroundColor = HEX_COLOR(0xf0f0f0FF);
    self.tipLabel.textColor = HEX_COLOR(0x666666FF);
    [self.takephoneButton setBackgroundColor:HEX_COLOR(0x673ab7FF)];
    [self.takephoneButton setTitleColor:HEX_COLOR(0xffffffFF) forState:UIControlStateNormal];
    [self.cancelButton setBackgroundColor:HEX_COLOR(0x000000FF)];

}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
        return self;
    }else{
        return nil;
    }
}

- (IBAction)takephoneButtonClick:(id)sender {
    
}

- (IBAction)cancelButtonClick:(id)sender {
}

//取消交易
- (IBAction)cancelDeliverGoodsButtonClick:(id)sender {
    self.cancelDeliverGoodsButtonBlock();
}

//拍照发货
- (IBAction)takephoneDeliverGoodsButtonClick:(id)sender {
    self.takephoneDeliverGoodsButtonBlock();
}

//修改采购单总价格
- (IBAction)changeOrderTotalPrice:(id)sender {
    
    self.changeOrderTotalPrice();
    
}


- (IBAction)cancelTradingClick:(id)sender{
    
}
@end
