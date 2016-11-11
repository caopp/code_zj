//
//  ReturnPriceTableViewCell.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/5/24.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "ReturnPriceTableViewCell.h"

@implementation ReturnPriceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.priceTextView.layer.borderWidth = 0.5;
    self.priceTextView.layer.borderColor = [UIColor colorWithHexValue:0x999999 alpha:1].CGColor;
    
    
    self.priceTextView.text = @"最多可退￥0";
    self.priceTextView.textColor = [UIColor colorWithHexValue:0x999999 alpha:1];

    
    self.priceTextView.tag = 300;
    
    
}
-(void)setPriceTextViewContent:(RefundApplyDTO *)applyDTO withMostAlert:(NSString *)mostAlertStr{

    //!填入了就写值，没有填就给提示
    if (applyDTO.refundFee && ![applyDTO.refundFee isEqual:@""]) {
        
        self.priceTextView.text = [NSString stringWithFormat:@"%@",applyDTO.refundFee];
        
//        [NSString stringWithFormat:@"%.2f",[applyDTO.refundFee doubleValue]];
    
    }else{
    
        self.priceTextView.text = mostAlertStr;
    
    }
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
