//
//  ExpressSingleTableViewCell.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/3/31.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "ExpressSingleTableViewCell.h"

@interface ExpressSingleTableViewCell ()
/**
 *  发货时间
 */
@property (weak, nonatomic) IBOutlet UILabel *deliveryTimeLab;
/**
 *  快递公司
 */
@property (weak, nonatomic) IBOutlet UILabel *CourierNameLab;

/**
 *  快递号
 */
@property (weak, nonatomic) IBOutlet UILabel *CourierOrderNumb;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deliveryTimeLabTop;

@end

@implementation ExpressSingleTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)setOrderDeliverDto:(OrderDeliveryDTO *)orderDeliverDto
{
    if (orderDeliverDto) {
        

        if (self.number == 1) {
            self.deliveryTimeLabTop.constant = -10;
            self.deliveryTimeLab.hidden = YES;
            
        }else{
        self.deliveryTimeLab.text = [NSString stringWithFormat:@"第%ld次发货时间: %@",(long)self.number,orderDeliverDto.createTime];
        }
        
        self.CourierNameLab.text = orderDeliverDto.logisticName;
        self.CourierOrderNumb.text = orderDeliverDto.logisticTrackNo;
    }
}

@end
