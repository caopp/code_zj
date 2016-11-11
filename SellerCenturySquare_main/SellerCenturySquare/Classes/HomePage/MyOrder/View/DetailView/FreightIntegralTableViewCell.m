//
//  FreightIntegralTableViewCell.m
//  CustomerCenturySquare
//
//  Created by 左键视觉 on 16/6/24.
//  Copyright © 2016年 zuojian. All rights reserved.
//

#import "FreightIntegralTableViewCell.h"

@implementation FreightIntegralTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configData:(GetOrderDetailDTO *)orderDTO withScore:(BOOL)isScore{

    self.filterHightConst.constant = 0;//!不显示分割线

    //!显示积分
    if (isScore) {
        
        self.freightLeftLabel.text = @"使用积分抵扣";
        self.freightLabel.text = [NSString stringWithFormat:@"-￥%.2f",[orderDTO.integralAmount doubleValue]];
        
    }else{//!显示运费
    
        self.freightLeftLabel.text = @"运费";
        self.freightLabel.text = [NSString stringWithFormat:@"￥%.2f",[orderDTO.dFee doubleValue]];
        
        if ([orderDTO.integralAmount doubleValue]) {
            
            self.filterHightConst.constant = 0.5;//!显示积分则显示分割线

        }
    
    }
    
    

}


@end
