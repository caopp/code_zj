//
//  RecommendTableViewCell.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/3.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "RecommendTableViewCell.h"

@implementation RecommendTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [_recomBadge changeViewToBadgeWithString:@"1" withScale:0.7];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

