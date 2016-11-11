//
//  SetLevelNormalTableViewCell.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/6.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "SetLevelNormalTableViewCell.h"
#import "UIColor+HexColor.h"
@implementation SetLevelNormalTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDisplayLevel:(NSInteger)level{
    
    _levelL.text = [NSString stringWithFormat:@"本店等级：V%zi",level];
}

- (void)setRedState:(BOOL)red{
    
    if (red) {
        
        _levelL.textColor = [UIColor colorWithHex:0xEB301F];

    }else{
        
        _levelL.textColor = [UIColor colorWithHex:0x666666];
        
    }
}

- (IBAction)selectedButtonClicked:(id)sender {
    
    NSString *row = [NSString stringWithFormat:@"%zi",_index];
    
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:row,@"row", nil];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kSetLevelSelectedLevelStateNotification object:nil userInfo:dic];
    
}

- (void)setSelectState:(BOOL)selected{
        
    _selectButton.selected = selected;
    
    [self setRedState:selected];
}

@end
