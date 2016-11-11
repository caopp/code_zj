//
//  MyOrderPromptTableViewCell.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/4/8.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "MyOrderPromptTableViewCell.h"

@implementation MyOrderPromptTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCannnotDto:(CannotPayOrdersDTO *)cannnotDto
{
    if (cannnotDto) {
        if (cannnotDto.orderType.intValue == 0) {
            self.orderStateLab.text = @"【期货单】";
            self.orderStateLab.textColor = [UIColor colorWithHexValue:0x673ab7 alpha:1];
        }
        if (cannnotDto.orderType.intValue == 1) {
            
            self.orderStateLab.textColor = [UIColor colorWithHexValue:0x5677fc alpha:1];
            self.orderStateLab.text = @"【期货单】";
        }
        self.merchantNameLab.text = [NSString stringWithFormat:@"-%@",cannnotDto.merchantName];
        self.orderPayMoneyLab.text = [NSString stringWithFormat:@"%.2f",cannnotDto.totalAmount.doubleValue];
    }
}

- (void)setCanDto:(CanPayOrdersDTO *)canDto
{
    
    if (canDto) {
        if (canDto.orderType.intValue == 0) {
            self.orderStateLab.text = @"【期货单】";
            self.orderStateLab.textColor = [UIColor colorWithHexValue:0x673ab7 alpha:1];
        }
        if (canDto.orderType.intValue == 1) {
            
            self.orderStateLab.textColor = [UIColor colorWithHexValue:0x5677fc alpha:1];
            self.orderStateLab.text = @"【期货单】";
        }
        self.merchantNameLab.text = [NSString stringWithFormat:@"-%@",canDto.merchantName];
        self.orderPayMoneyLab.text = [NSString stringWithFormat:@"%.2f",canDto.totalAmount.doubleValue];
    }
}

@end
