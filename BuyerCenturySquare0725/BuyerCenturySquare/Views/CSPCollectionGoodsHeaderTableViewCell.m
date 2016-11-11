
//
//  CSPCollectionGoodsHeaderTableViewCell.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/17/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPCollectionGoodsHeaderTableViewCell.h"

@implementation CSPCollectionGoodsHeaderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)merchantNameButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(merchantNamePressedForSection:)]) {
        [self.delegate merchantNamePressedForSection:self.section];
    }
}

@end
