//
//  MessageTableViewCell.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 15/12/15.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self updateBadge:@"0"];
}

- (void)updateBadge:(NSString *)string{
    
    NSString *num = [NSString stringWithFormat:@"%zi",[string integerValue]];
    
    if ([string integerValue]==0) {
        
        _letterBadge.hidden = YES;
    }else{
        
        _letterBadge.hidden = NO;
        [_letterBadge changeViewToBadgeWithString:num withScale:0.7];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
