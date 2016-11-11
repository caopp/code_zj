//
//  MoneyConditionTableViewCell.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/4.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "MoneyConditionTableViewCell.h"
#import "MyShopStateDTO.h"
#import "UIColor+HexColor.h"
#import "GetMerchantInfoDTO.h"
@implementation MoneyConditionTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    GetMerchantInfoDTO *getMerchantInfoDTO = [GetMerchantInfoDTO sharedInstance];
    
    if (getMerchantInfoDTO.batchAmountLimit==nil) {
        
        getMerchantInfoDTO.batchAmountLimit = @0;
    }
    
    _moneyL.text = [NSString stringWithFormat:@"%@元",getMerchantInfoDTO.batchAmountLimit];
    
    if ([getMerchantInfoDTO.batchAmountFlag integerValue]==0) {
        
        _stateStr.text = @"已开启";
        _stateStr.textColor = [UIColor colorWithHex:0xEB301F];
        
    }else{
        
        _stateStr.text = @"关闭";
        _stateStr.textColor = [UIColor colorWithHex:0x666666];
        
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
