//
//  BeginViewCell.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/14.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BeginViewCell.h"

@implementation BeginViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.beginLabel setTextColor:[UIColor colorWithHex:0x666666 alpha:1]];
    
    self.bottomFilterLabelHight.constant = 0.5;
    [self.bottomFilterLabel setBackgroundColor:[UIColor colorWithHex:0xc8c7cc alpha:1]];
    
    
}

-(void)configInfo:(GetGoodsInfoListDTO *)goodsInfoDTO{

    editGoodsInfoDTO = goodsInfoDTO;

    if ([goodsInfoDTO.batchNumLimit intValue] == 0) {
        
        goodsInfoDTO.batchNumLimit = [NSNumber numberWithInt:1];
        
    }
    
    self.beiginTextField.text = [NSString stringWithFormat:@"%@",goodsInfoDTO.batchNumLimit];
    
    
    
    [self.beiginTextField sizeToFit];
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
