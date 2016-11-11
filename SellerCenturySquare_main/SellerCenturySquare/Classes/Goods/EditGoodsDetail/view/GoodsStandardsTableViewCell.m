//
//  GoodsStandardsTableViewCell.m
//  SellerCenturySquare
//
//  Created by 陈光 on 16/3/18.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "GoodsStandardsTableViewCell.h"
#import "BrandCustomTextField.h"

@implementation GoodsStandardsTableViewCell

- (void)awakeFromNib {
    self.inputTextfield.layer.borderColor = [UIColor colorWithHex:0xe2e2e2].CGColor;
    self.inputTextfield.layer.borderWidth = 1;
    self.inputTextfield.delegate = self;
    
    
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(GoodsStandardsChangeContent:currentCell:)]) {
    [self.delegate  GoodsStandardsChangeContent:textField.text currentCell:self];        
    }

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(GoodsStandardCurrentCell:)]) {
        
        [self.delegate GoodsStandardCurrentCell:self];
        
        
    }
    return YES;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
