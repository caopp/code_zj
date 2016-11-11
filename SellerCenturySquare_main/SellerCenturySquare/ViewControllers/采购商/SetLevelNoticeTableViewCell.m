//
//  SetLevelNoticeTableViewCell.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/6.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "SetLevelNoticeTableViewCell.h"

@implementation SetLevelNoticeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setNoticeInfo:(NSInteger)level{
    
    if (_isBlackListNotice) {
        
        _noticeL.text = [NSString stringWithFormat:@"您的等级为V%zi，达到V5后，可进行采购商的黑名单设置",level];
    }else{
        
        _noticeL.text = [NSString stringWithFormat:@"您的等级为V%zi，达到V5后，可拥有调整采购商本店等级的权限",level];
    }
}

- (IBAction)checkShopPrivilege:(id)sender {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kCheckShopAuthorityNotification object:nil];
}


@end
