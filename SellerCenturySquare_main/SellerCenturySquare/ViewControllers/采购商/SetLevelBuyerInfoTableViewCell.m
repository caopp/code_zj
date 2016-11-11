//
//  SetLevelBuyerInfoTableViewCell.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/6.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "SetLevelBuyerInfoTableViewCell.h"
#import "UIColor+HexColor.h"
@implementation SetLevelBuyerInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLevel:(NSInteger)level{
    
    NSString *string = [NSString stringWithFormat:@"该会员平台等级已经达到V%zi 您可在此基础上，调高其在本店的等级。",level];
    
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc]initWithString:string];
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor colorWithHex:0xEB301F]};
    
    [attriString setAttributes:attributes range:NSMakeRange(11, 2)];
    
    _levelInfoL.attributedText =attriString;
}

@end
