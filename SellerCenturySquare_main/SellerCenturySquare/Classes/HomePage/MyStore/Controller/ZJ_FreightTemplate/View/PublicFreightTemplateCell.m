//
//  PublicFreightTemplateCell.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/6/16.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "PublicFreightTemplateCell.h"
#import "UIColor+UIColor.h"

@implementation PublicFreightTemplateCell

- (void)awakeFromNib {
    
    [self.selectFreightTemplateName setTextColor:[UIColor colorWithHexValue:0x666666 alpha:1]];
    [self.lineLabel setBackgroundColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
    
    [self.selectedLabel setTextColor:[UIColor blackColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//选中代理方法
- (IBAction)selectedButtonAction:(id)sender {
    
    self.selectButton.selected =! self.selectButton.selected;
    
    if ([self.delegate respondsToSelector:@selector(setDefaultBtn:)]) {
        [self.delegate setDefaultBtn:self.selectButton];
    }
}
@end
