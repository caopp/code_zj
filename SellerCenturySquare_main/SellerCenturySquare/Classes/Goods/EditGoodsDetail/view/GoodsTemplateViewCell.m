//
//  GoodsTemplateViewCell.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/23.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "GoodsTemplateViewCell.h"

@implementation GoodsTemplateViewCell

- (void)awakeFromNib {
    
    [self.templateNameLabel setTextColor:[UIColor colorWithHex:0x000000 alpha:1]];
    self.backgroundColor = [UIColor whiteColor];
    self.lineLabel.backgroundColor = [UIColor colorWithHex:0xe2e2e2 alpha:1];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}
- (IBAction)selectedButtonAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(selectedBtn:)]) {
        
        [self.delegate selectedBtn:self.selectedButton];
    }
    
}

@end
