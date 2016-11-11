//
//  SearchMemberTableViewCell.m
//  SellerCenturySquare
//
//  Created by caopenpen on 16/7/8.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "SearchMemberTableViewCell.h"

@implementation SearchMemberTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _goodsImgView.layer.masksToBounds = YES;
    _goodsImgView.layer.cornerRadius = 21.0f;
}
-(void)loadDTO:(GoodsShareDTO *)dto{
    [_goodsImgView sd_setImageWithURL:[NSURL URLWithString:dto.iconUrl] placeholderImage:[UIImage imageNamed:@"10_商品询单对话_个人"]];
    _userNameLabel.text = dto.userName;
    NSString *strCount = [NSString stringWithFormat:@"分享商品次数 %@",dto.sharedGoodsNum];
    _shareCountLabel.attributedText = [self createStringWithString:strCount withRange:NSMakeRange(7, [strCount length]-7)];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
