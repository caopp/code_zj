//
//  CarriageFreeTableViewCell.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/6/17.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "CarriageFreeTableViewCell.h"

@implementation CarriageFreeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.setCarriageFressBtn setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
    
    [self.freeLabel setTextColor:[UIColor colorWithHex:0x999999]];
    
    [self.filterLabel setBackgroundColor:[UIColor colorWithHex:0xc8c7cc alpha:1]];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)carriageFreeClick:(id)sender {
    
   self.setCarriageFressBtn.selected = !self.setCarriageFressBtn.selected;
   
    //!是否包邮：0不包邮,1包邮
    if (self.setCarriageFressBtn.selected) {
        
        editGoodsInfoDTO.freeDelivery = [NSNumber numberWithInt:1];
        
    }else{
        
        editGoodsInfoDTO.freeDelivery = [NSNumber numberWithInt:0];

    }

    
}

-(void)configInfo:(GetGoodsInfoListDTO *)goodsInfoDTO{

    editGoodsInfoDTO = goodsInfoDTO;
    
    //!是否包邮：0不包邮,1包邮
    if ([editGoodsInfoDTO.freeDelivery intValue] == 0) {
        
        self.setCarriageFressBtn.selected = NO;
    
    }else{
    
        self.setCarriageFressBtn.selected = YES;
    }


}


@end
