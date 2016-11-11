//
//  PayDetailCell.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/1/14.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "PayDetailCell.h"

@implementation PayDetailCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.leftTitleLabel setTextColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
    [self.detailTextLabel setTextColor:[UIColor colorWithHexValue:0x666666 alpha:1]];
    
    [self.filterLabel setBackgroundColor:[UIColor colorWithHexValue:0xe2e2e2 alpha:1]];
    
    
}

-(void)configInfo:(NSString *)leftStr withDetailInfo:(NSString *)detailStr{

    [self.leftTitleLabel setText:leftStr];
    

    [self.detailLabel setText:detailStr];
    
    
}

-(void)configInfo:(NSMutableAttributedString *)leftStr{

    [self.leftTitleLabel setAttributedText:leftStr];
    
    
    [self.detailLabel setText:@""];
    

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
