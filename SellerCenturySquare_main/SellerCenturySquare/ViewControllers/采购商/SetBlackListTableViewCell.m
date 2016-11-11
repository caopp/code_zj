//
//  SetBlackListTableViewCell.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/7.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "SetBlackListTableViewCell.h"

@implementation SetBlackListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMemberName:(NSString *)memberName{
    
    _nameL.text = memberName;
}

- (void)setIsInBlackList:(BOOL)isInBlackList{
    
    if (isInBlackList) {
        
        _stateL.text = @"已加入黑名单";
        _noticeL.text = @"移出黑名单后，将恢复此采购商，查阅、下载、购买本店商品的功能。";
    }else{
        
        _stateL.text = @"未加入黑名单";
        _noticeL.text = @"加入黑名单后，此采购商将不可见本店的所有内容，不可查阅、下载、购买本店的所有商品。";
    }
}

@end
