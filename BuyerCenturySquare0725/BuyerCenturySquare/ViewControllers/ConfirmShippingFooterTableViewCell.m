//
//  ConfirmShippingFooterTableViewCell.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/4/2.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "ConfirmShippingFooterTableViewCell.h"
@interface ConfirmShippingFooterTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *freightOederLab;
@property (weak, nonatomic) IBOutlet UILabel *orderTotalPrice;


@end

@implementation ConfirmShippingFooterTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setCartConfirDto:(CartConfirmMerchant *)cartConfirDto
{
    if (cartConfirDto) {
        //运费
        self.freightOederLab.text = [NSString stringWithFormat:@"%.2f)",cartConfirDto.delieveryFee.doubleValue];
        //小计
        self.orderTotalPrice.text = [NSString stringWithFormat:@"%.2f",cartConfirDto.orderTotalPrice.doubleValue];
        
        
    }
}
@end
