//
//  SalePlaceTableViewCell.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/6/17.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "SalePlaceTableViewCell.h"

@implementation SalePlaceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    [self.alerLabel setTextColor:[UIColor colorWithHex:0x666666]];
    
}


- (IBAction)placeSelectClick:(id)sender {
    
    self.salePlaceBtn.selected = !self.salePlaceBtn.selected;
    
    if (!_goodsInfoDTO.channelComponArray) {
        
        _goodsInfoDTO.channelComponArray = [NSMutableArray arrayWithCapacity:0];
        
    }
    
    //!零售  0 批发 1零售
    if (self.isRetail) {
    
        if (self.salePlaceBtn.selected) {
        
            if (![_goodsInfoDTO.channelComponArray containsObject:@"1"]) {
                
                [_goodsInfoDTO.channelComponArray addObject:@"1"];
            }
            
        }else{
        
            [_goodsInfoDTO.channelComponArray removeObject:@"1"];

        }
        
    }else{//!批发
    
        if (self.salePlaceBtn.selected) {
            
            if (![_goodsInfoDTO.channelComponArray containsObject:@"0"]) {
                
                [_goodsInfoDTO.channelComponArray addObject:@"0"];
            }
            
        }else{
            
            [_goodsInfoDTO.channelComponArray removeObject:@"0"];
            
        }
    
    }
    
    
}


-(void)configData:(GetGoodsInfoListDTO *)goodsInfoDTO withIsRetail:(BOOL)isRetail{


    _goodsInfoDTO = goodsInfoDTO;
    
    self.isRetail = isRetail;
    
    //!是零售
    if (self.isRetail) {
        
        [self.salePlaceBtn setTitle:@" 零售" forState:UIControlStateNormal];
        [self.salePlaceBtn setTitle:@" 零售" forState:UIControlStateSelected];
        [self.alerLabel setText:@"勾选后，此商品即可在零\n售渠道销售。[inslife]"];

        //! 0 批发 1零售
        if ([_goodsInfoDTO.channelComponArray containsObject:@"1"]) {
            
            self.salePlaceBtn.selected = YES;
            
        }else{
            
            self.salePlaceBtn.selected = NO;

        }
        
        
    }else{
        
        [self.salePlaceBtn setTitle:@" 批发" forState:UIControlStateNormal];
        [self.salePlaceBtn setTitle:@" 批发" forState:UIControlStateSelected];
        [self.alerLabel setText:@"勾选后，此商品即可在\n批发渠道销售。[叮咚欧品]"];

        //! 0 批发 1零售
        if ([_goodsInfoDTO.channelComponArray containsObject:@"0"]) {
            
            self.salePlaceBtn.selected = YES;
            
        }else{
            
            self.salePlaceBtn.selected = NO;
            
        }
        
    }
    
    
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
