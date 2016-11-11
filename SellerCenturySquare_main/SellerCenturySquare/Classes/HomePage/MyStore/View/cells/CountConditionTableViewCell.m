//
//  CountConditionTableViewCell.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/4.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CountConditionTableViewCell.h"
#import "UIColor+HexColor.h"
#import "MyShopStateDTO.h"
#import "GetMerchantInfoDTO.h"

@implementation CountConditionTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    GetMerchantInfoDTO *getMerchantInfoDTO = [GetMerchantInfoDTO sharedInstance];
    
    if (getMerchantInfoDTO.batchNumLimit==nil) {
        
        getMerchantInfoDTO.batchNumLimit = @0;
    }
    
    _countL.text = [NSString stringWithFormat:@"%@件",getMerchantInfoDTO.batchNumLimit];
    
    if ([getMerchantInfoDTO.batchNumFlag integerValue]==0) {
        
        _stateL.text = @"已开启";
        _stateL.textColor = [UIColor colorWithHex:0xEB301F];
    }else{
        
        _stateL.text = @"关闭";
        _stateL.textColor = [UIColor colorWithHex:0x666666];
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
