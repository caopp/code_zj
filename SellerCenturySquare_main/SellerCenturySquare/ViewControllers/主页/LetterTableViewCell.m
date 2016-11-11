//
//  LetterTableViewCell.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/3.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "LetterTableViewCell.h"

@implementation LetterTableViewCell

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
