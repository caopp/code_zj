//
//  UpAndDownViewCell.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/14.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "UpAndDownViewCell.h"

@implementation UpAndDownViewCell

- (void)awakeFromNib {
    // Initialization code
    
    
    [self.statusLabel setTextColor:[UIColor colorWithHex:0x666666 alpha:1]];
    
    [self.statusDetailLabel setTextColor:[UIColor colorWithHex:0x666666 alpha:1]];
    
    [self.upAndDownBtn setBackgroundColor:[UIColor colorWithHex:0xeb301f alpha:1]];
    
    [self.upAndDownBtn setTitleColor:[UIColor colorWithHex:0xffffff alpha:1] forState:UIControlStateNormal];
    
    
    self.upAndDownBtn.layer.masksToBounds = YES;
    self.upAndDownBtn.layer.cornerRadius = 2;
    
    
}

-(void)configInfo:(GetGoodsInfoListDTO *)goodsInfoDTO{

    editGoodsInfoDTO = goodsInfoDTO;

//    1:新发布  2:在售  3:下架
    NSString *statusStr = @"";
    NSString *btnStr = @"";
    
    if ([goodsInfoDTO.goodsStatus intValue] == 1) {
        
        statusStr = @"新发布未上架";
        btnStr = @"上架";

        
    }else if ([goodsInfoDTO.goodsStatus intValue] == 2){
    
        statusStr = @"在售";
        btnStr = @"下架";
        
    }else if ([goodsInfoDTO.goodsStatus intValue] == 3){
    
        statusStr = @"已下架";
        btnStr = @"上架";

    }

    self.statusDetailLabel.text = statusStr;
    [self.upAndDownBtn setTitle:btnStr forState:UIControlStateNormal];
    
}


- (IBAction)upAndDownBtnClick:(id)sender {

    //!判断，如果商家是歇业或者关闭状态的话，不可以上架商品
    //    1:新发布  2:在售  3:下架
    NSString *statusStr = @"";
    NSString *btnStr = @"";
    
    if ([editGoodsInfoDTO.goodsStatus intValue] == 1) {//!新发布未上架---》在售（下架）
        
        statusStr = @"在售";
        
        editGoodsInfoDTO.goodsStatus = [NSNumber numberWithInt:2];
        
        btnStr = @"下架";
        
        
    }else if ([editGoodsInfoDTO.goodsStatus intValue] == 2){//!在售--》已下架（上架）
        
        statusStr = @"已下架";
        
        editGoodsInfoDTO.goodsStatus = [NSNumber numberWithInt:3];
        
        btnStr = @"上架";
        
    }else if ([editGoodsInfoDTO.goodsStatus intValue] == 3){//!已下架---》在售（下架）
        
        statusStr = @"在售";
        
        editGoodsInfoDTO.goodsStatus = [NSNumber numberWithInt:2];

        btnStr = @"下架";
        
    }

    self.statusDetailLabel.text = statusStr;
    [self.upAndDownBtn setTitle:btnStr forState:UIControlStateNormal];
    


}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
