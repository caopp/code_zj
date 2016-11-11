//
//  CSPBaseTableViewCell.m
//  SellerCenturySquare
//
//  Created by clz on 15/8/18.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPBaseTableViewCell.h"

@implementation CSPBaseTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(NSMutableAttributedString *)createStringWithString:(NSString *)strMode withRange:(NSRange)range{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strMode];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xfd4f57] range:range];
    return str;
    
}
@end
