//
//  AddViewCell.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/5/24.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "AddViewCell.h"

@implementation AddViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    self.addTextView.layer.borderWidth = 0.5;
    self.addTextView.layer.borderColor = [UIColor colorWithHexValue:0x999999 alpha:1].CGColor;
    
    [self.addTextView setTextColor:[UIColor colorWithHexValue:0x999999 alpha:1]];

    self.addTextView.text = @"最多200字";
    
    self.addTextView.tag = 400;
    
}
-(void)setAddTextViewContent:(RefundApplyDTO *)applyDTO withMostAlert:(NSString *)mostAlertStr{

    //!填入了就写值，没有填就给提示
    if (applyDTO.remark && ![applyDTO.remark isEqual:@""]) {
        
        self.addTextView.text = applyDTO.remark;
        
    }else{
        
        self.addTextView.text = mostAlertStr;
        
    }

    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
