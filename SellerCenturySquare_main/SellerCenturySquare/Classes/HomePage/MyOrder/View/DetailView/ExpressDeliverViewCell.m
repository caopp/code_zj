//
//  ExpressDeliverViewCell.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/30.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "ExpressDeliverViewCell.h"

@implementation ExpressDeliverViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.timeLabel setTextColor:[UIColor colorWithHex:0x999999 alpha:1]];
    
    [self.seeLogLabel setTextColor:[UIColor colorWithHex:0x999999 alpha:1]];
    
    [self.filterLabel setBackgroundColor:[UIColor colorWithHex:0xc8c7cc alpha:1]];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//!num:数组中的第几个值
-(void)configData:(OrderDeliveryDTO *)deliverDTO withNum:(NSInteger)num{

    if (num == 0) {//!第一个显示发货信息的cell
        
        [self.timeLabel removeFromSuperview];
        
    }
    self.timeLabel.text = [NSString stringWithFormat:@"第%ld次发货时间：%@",(long)num +1,deliverDTO.createTime];
    
    self.companyLabel.text = [NSString stringWithFormat:@"快递公司：%@",deliverDTO.logisticName];
    
    self.noLabel.text = [NSString stringWithFormat:@"快递单号：%@",deliverDTO.logisticTrackNo];
    

}

@end
