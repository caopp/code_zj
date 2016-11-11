//
//  CountListTableViewCell.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/6.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CountListTableViewCell.h"

@implementation CountListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setGetMemberInfoDTO:(GetMemberInfoDTO *)getMemberInfoDTO{
    
    if (getMemberInfoDTO) {
        
        _amountL.text = [NSString stringWithFormat:@"¥%@",getMemberInfoDTO.amount];
        _weekAmountL.text = [NSString stringWithFormat:@"¥%@",getMemberInfoDTO.weekAmount];
        _lastMonthAmountL.text = [NSString stringWithFormat:@"¥%@",getMemberInfoDTO.lastMonthAmount];
        
        _orderNumL.text = [NSString stringWithFormat:@"%@",getMemberInfoDTO.orderNum];
        _lastMonthOrderNumL.text = [NSString stringWithFormat:@"%@",getMemberInfoDTO.lastMonthOrderNum];
        _weekOrderNumL.text = [NSString stringWithFormat:@"%@",getMemberInfoDTO.weekOrderNum];
        
        _amountL.adjustsFontSizeToFitWidth = YES;
        _weekAmountL.adjustsFontSizeToFitWidth = YES;
        _lastMonthAmountL.adjustsFontSizeToFitWidth = YES;
        _orderNumL.adjustsFontSizeToFitWidth = YES;
        _lastMonthOrderNumL.adjustsFontSizeToFitWidth = YES;
        _weekAmountL.adjustsFontSizeToFitWidth = YES;
    }
}
@end
