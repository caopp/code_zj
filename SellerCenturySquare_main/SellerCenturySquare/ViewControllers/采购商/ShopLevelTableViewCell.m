//
//  ShopLevelTableViewCell.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/6.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "ShopLevelTableViewCell.h"
#import "MemberBlackDTO.h"
#import "MemberInviteDTO.h"
#import "MemberTradeDTO.h"

@implementation ShopLevelTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setGetMemberInfoDTO:(GetMemberInfoDTO *)getMemberInfoDTO{
    
    if (getMemberInfoDTO) {
    
        _shopLevelL.text = [NSString stringWithFormat:@"本店等级：V%@",getMemberInfoDTO.shopLevel];
    }
    
}

@end
