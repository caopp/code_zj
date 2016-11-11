//
//  IMReferralTableViewCell.m
//  BuyerCenturySquare
//
//  Created by 王剑粟 on 15/8/31.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "IMReferralTableViewCell.h"

@implementation IMReferralTableViewCell

- (IBAction)btnClick:(id)sender {
    
    if (self.delegate) {
        [self.delegate IMReferralBtnClick:_strGoodNo];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
