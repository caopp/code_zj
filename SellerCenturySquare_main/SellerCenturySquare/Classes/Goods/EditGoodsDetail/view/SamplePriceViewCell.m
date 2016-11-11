//
//  SamplePriceViewCell.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/14.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "SamplePriceViewCell.h"

@implementation SamplePriceViewCell

- (void)awakeFromNib {
    // Initialization code
    
    
    [self.sampleLabel setTextColor:[UIColor colorWithHex:0x666666 alpha:1]];
    
    [self.detailLabel setTextColor:[UIColor colorWithHex:0x999999 alpha:1]];
    
    
    [self.sampleSelectBtn setImage:[UIImage imageNamed:@"03_商家商品详情页_未选中"] forState:UIControlStateNormal];
    
    [self.sampleSelectBtn setImage:[UIImage imageNamed:@"goodEdit_Select"] forState:UIControlStateSelected];

    
    //!分割线
    [self.bottomFilterLabel setBackgroundColor:[UIColor colorWithHex:0xc8c7cc alpha:1]];
    self.bottomFilterHight.constant = 0.5;
    
}

-(void)configData:(GetGoodsInfoListDTO *)goodsInfoDTO{

    editGoodsInfoDTO = goodsInfoDTO;

    if ([goodsInfoDTO.sampleFlag isEqualToString:@"1"]) {//!有选样板价格
        
        self.samplePriceTextField.text = [NSString stringWithFormat:@"%@",goodsInfoDTO.samplePrice];

        self.sampleSelectBtn.selected = YES;
        
    }else{
    
        self.samplePriceTextField.text = [NSString stringWithFormat:@"%@",goodsInfoDTO.samplePrice];
    
        self.sampleSelectBtn.selected = NO;

    }
    


}


- (IBAction)sampleSelectBtnClick:(id)sender {
    
    self.sampleSelectBtn.selected = !self.sampleSelectBtn.selected;
    
    //!选中
    if (self.sampleSelectBtn.selected) {
        
        editGoodsInfoDTO.sampleFlag = @"1";
    }else{
    
        editGoodsInfoDTO.sampleFlag = @"2";
    }
    
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
