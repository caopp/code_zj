//
//  FreightTemplateCell.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/2.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "FreightTemplateCell.h"
#import "UIColor+UIColor.h"

@implementation FreightTemplateCell
//设置默认版本
- (IBAction)didClickPatientiaButtonAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(setDefaultBtn:)]) {
        [self.delegate setDefaultBtn:self.patientiaButton];
    }
}
//查看行为
- (IBAction)didClickLookButtonAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(lookSettingPatientiaTemplateAction:)]) {
        [self.delegate lookSettingPatientiaTemplateAction:self.lookButton];
    }
}


//删除行为
- (IBAction)didClickDeleteButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(deletePatientiaTemplateAction:templateCell:)]) {
        [self.delegate deletePatientiaTemplateAction:self.deleteButton templateCell:self];
    }
    
}

- (void)awakeFromNib {
    
    [self.deleteButton setTitleColor:[UIColor colorWithHexValue:0x999999 alpha:1] forState:(UIControlStateNormal)];
    [self.lookButton setTitleColor:[UIColor colorWithHexValue:0x999999 alpha:1] forState:(UIControlStateNormal)];
    [self.templateName setTextColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
    
    self.dividerLabel.backgroundColor = [UIColor colorWithHexValue:0xc8c7cc alpha:1];
    
    [self.patientiaLabel setTextColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
    
    [self.backgrondView setBackgroundColor:[UIColor colorWithHexValue:0xefeff4 alpha:1]];
    self.noDeletedLabel.textColor = [UIColor colorWithHexValue:0x999999 alpha:1];
    
    
    [self.templateName setTextColor:[UIColor colorWithHexValue:0x000000 alpha:1]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

  
}

@end
