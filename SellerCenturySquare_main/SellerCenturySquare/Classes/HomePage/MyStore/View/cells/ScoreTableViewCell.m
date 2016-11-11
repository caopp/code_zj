//
//  ScoreTableViewCell.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/4.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "ScoreTableViewCell.h"
#import "UIColor+UIColor.h"
@implementation ScoreTableViewCell

- (void)awakeFromNib {
//     self.lineLabel.backgroundColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setScore:(NSString*)score{
    
    NSString *scoreStr = [NSString stringWithFormat:@"本月营业额积分：%@",score];
    
    _textL.text = scoreStr;
}

@end
