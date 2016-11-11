//
//  CSPPersonCenterShopTableViewCell.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/10/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPPersonCenterShopTableViewCell.h"

@implementation CSPPersonCenterShopTableViewCell

- (void)awakeFromNib {
    self.badgeimageView.layer.cornerRadius = 22.5f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
