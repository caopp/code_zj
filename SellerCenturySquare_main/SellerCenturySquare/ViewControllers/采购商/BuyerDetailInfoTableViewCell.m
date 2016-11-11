//
//  BuyerDetailInfoTableViewCell.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/6.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BuyerDetailInfoTableViewCell.h"
#import "MemberTradeDTO.h"
#import "MemberInviteDTO.h"
#import "MemberBlackDTO.h"

@implementation BuyerDetailInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMemberDTO:(id)memberDTO{
    
}

- (void)setGetMemberInfoDTO:(GetMemberInfoDTO *)getMemberInfoDTO{
    
    if (getMemberInfoDTO) {
        
        _tradeLevelL.text = [NSString stringWithFormat:@"平台等级：V%@",getMemberInfoDTO.tradeLevel];
        _addressL.text = [NSString stringWithFormat:@"%@%@%@",getMemberInfoDTO.provinceName,getMemberInfoDTO.cityName,getMemberInfoDTO.detailAddress];
        
        _nameL.text = getMemberInfoDTO.memberName;
        _telephoneL.text = [NSString stringWithFormat:@"手机：%@",getMemberInfoDTO.mobilePhone];
    }
}

@end
