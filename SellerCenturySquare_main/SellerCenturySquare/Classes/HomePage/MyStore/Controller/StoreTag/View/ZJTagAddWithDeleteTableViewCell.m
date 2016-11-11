//
//  ZJTagAddWithDeleteTableViewCell.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/14.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "ZJTagAddWithDeleteTableViewCell.h"
#import "UIColor+UIColor.h"

@implementation ZJTagAddWithDeleteTableViewCell

- (void)awakeFromNib {
    [self.deleteButton setTitleColor:[UIColor colorWithHexValue:0x000000 alpha:1] forState:(UIControlStateNormal)];
    
    [self.deleteButton setBackgroundColor:[UIColor colorWithHexValue:0xf0f0f0 alpha:1]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (IBAction)didClickDeleteBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(deleteTagBtnActionBtnTag:)]) {
        [self.delegate deleteTagBtnActionBtnTag:self.index_row];
    }
}




- (IBAction)didtextField:(UITextField *)sender {
    
    if ([self.delegate respondsToSelector:@selector(textField:)]) {
        
        [self.delegate textField:_index_row];
    }
}


@end
