//
//  CSPGoodsInfoModelTableViewCell.m
//  BuyerCenturySquare
//
//  Created by 李春晓 on 15/7/13.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPGoodsInfoModelTableViewCell.h"

@implementation CSPGoodsInfoModelTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModeState:(BOOL)modeState{
    
    _selectedBlackView.hidden = !modeState;
    _modeStateButton.selected = modeState;
}

- (IBAction)modeStateButtonClicked:(id)sender {

    [[NSNotificationCenter defaultCenter]postNotificationName:kModeStateChangedNotification object:nil];
}
@end
