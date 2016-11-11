//
//  ZJ_ManagerAddressCell.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 16/3/25.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "ZJ_ManagerAddressCell.h"

@implementation ZJ_ManagerAddressCell

- (void)awakeFromNib {
    
    self.lineLabel.backgroundColor = [UIColor colorWithHexValue:0xc8c7cc alpha:1];
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    self.nameLabel.textColor = [UIColor colorWithHexValue:0x999999 alpha:1];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
