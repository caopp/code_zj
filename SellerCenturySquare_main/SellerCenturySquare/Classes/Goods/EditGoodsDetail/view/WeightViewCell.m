//
//  WeightViewCell.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/15.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "WeightViewCell.h"

@implementation WeightViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.weightLabel setTextColor:[UIColor colorWithHex:0x666666 alpha:1]];
    
    [self.kgLabel setTextColor:[UIColor colorWithHex:0x666666 alpha:1]];
    
    
    //!分割线
    [self.bottomFilterLabel setBackgroundColor:[UIColor colorWithHex:0xc8c7cc alpha:1]];
    self.bottomFilterLabelHight.constant = 0.5;
    
}

-(void)configData:(GetGoodsInfoListDTO *)goodDTO{

    //!记录下来
    goodsInfoDTO = goodDTO;
    
    if (goodDTO.goodsWeight) {
        
        self.weightTextField.text = [NSString stringWithFormat:@"%@",goodDTO.goodsWeight];


    }else{
    
        self.weightTextField.text = @"";
    }


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
