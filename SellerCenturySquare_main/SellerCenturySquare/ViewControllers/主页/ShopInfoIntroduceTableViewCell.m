//
//  ShopInfoIntroduceTableViewCell.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/10.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "ShopInfoIntroduceTableViewCell.h"

@implementation ShopInfoIntroduceTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _introduceTV.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
