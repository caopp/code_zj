//
//  ChatTableViewCell.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/3.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "ChatTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation ChatTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [_chatBadge changeViewToBadgeWithString:@"1" withScale:0.7];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setEcSession:(ECSession *)ecSession{
 
    _ecSession = ecSession;
    
    if (_ecSession.sessionType == 1) {
        
        NSString *goodNo = _ecSession.goodNo;
        
        NSArray *goodNoArray = [goodNo componentsSeparatedByString:@"_"];
    
        if (goodNoArray) {
            _titleL.text = [NSString stringWithFormat:@"货号：%@",[goodNoArray firstObject]];
        }
        
        _nameL.hidden = NO;
        _nameL.text = [NSString stringWithFormat:@"询单人：%@",_ecSession.merchantName];
        
        [_AvatarImageView sd_setImageWithURL:[NSURL URLWithString:_ecSession.goodPic]];
        
    }else{
        
        _nameL.hidden = YES;
        
        _titleL.text = [NSString stringWithFormat:@"%@",_ecSession.merchantName];
        
        if (_ecSession.iconUrl == nil || [_ecSession.iconUrl isEqualToString:@""] || _ecSession.iconUrl.length == 0) {
         
            [_AvatarImageView setImage:[UIImage imageNamed:@"04_商家中心_消息中心_客服对话"]];
        }else {
            
            _AvatarImageView.layer.cornerRadius = _AvatarImageView.frame.size.height / 2;
            _AvatarImageView.layer.masksToBounds = YES;
            
            [_AvatarImageView sd_setImageWithURL:[NSURL URLWithString:_ecSession.iconUrl] placeholderImage:[UIImage imageNamed:@"04_商家中心_消息中心_客服对话"]];
        }
    }
    
    _detailInfoL.text = [NSString stringWithFormat:@"%@",_ecSession.text];
    NSString *unCount = [NSString stringWithFormat:@"%zi",_ecSession.unreadCount];
    
    [_chatBadge changeViewToBadgeWithString:unCount withScale:0.7];

}

@end
