//
//  AllFreightTemplateCell.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/6/16.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "AllFreightTemplateCell.h"
#import "UIColor+UIColor.h"

@implementation AllFreightTemplateCell

- (void)awakeFromNib {
    
    self.ToViewButton.layer.cornerRadius = 2;
    self.ToViewButton.layer.masksToBounds = YES;
    self.ToViewButton.layer.borderWidth = 1;
    self.ToViewButton.layer.borderColor = [UIColor colorWithHexValue:0x666666 alpha:1].CGColor;
    [self.ToViewButton setTitleColor:[UIColor colorWithHexValue:0x000000 alpha:1] forState:(UIControlStateNormal)];
    [self.ToViewButton setTitle:@"查看" forState:(UIControlStateNormal)];
    
    self.deleteButton.layer.cornerRadius = 2;
    self.deleteButton.layer.masksToBounds = YES;
    self.deleteButton.layer.borderWidth = 1;
    self.deleteButton.layer.borderColor = [UIColor colorWithHexValue:0x666666 alpha:1].CGColor;
    [self.deleteButton setTitleColor:[UIColor colorWithHexValue:0x000000 alpha:1] forState:(UIControlStateNormal)];
    [self.deleteButton setTitle:@"删除" forState:(UIControlStateNormal)];
    
    self.lineLabel.backgroundColor = [UIColor colorWithHexValue:0xc8c7cc alpha:1];

    [self.freightTemplateName setTextColor:[UIColor colorWithHexValue:0x000000 alpha:1]];
    
    [self.PackageMailLabel setTextColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//查看
- (IBAction)didClickToViewButtonAction:(id)sender {
  
    if ([self.delegate respondsToSelector:@selector(toViewFreightTemplateButton:)]) {
        [self.delegate toViewFreightTemplateButton:self.ToViewButton];
    
    }
}

//删除
- (IBAction)didClickDeleteButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(deleteFreightTemplateButton:templateCell:)]) {
        [self.delegate deleteFreightTemplateButton:self.deleteButton templateCell:self];
    }
}
@end
