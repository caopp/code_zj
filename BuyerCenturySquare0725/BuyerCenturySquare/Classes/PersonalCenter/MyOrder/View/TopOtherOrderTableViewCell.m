//
//  TopOtherOrderTableViewCell.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/3/19.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "TopOtherOrderTableViewCell.h"

@implementation TopOtherOrderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
/**
 *  选择客服
 *
 *  @param sender
 */
- (IBAction)selectCustomerserviceClickBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(MyOrderParentClickCustomerService:)]) {
        [self.delegate MyOrderParentClickCustomerService:self.infoDto
         ];
    }
    
    if ([self.delegate respondsToSelector:@selector(MyOrderParentClickCustomerServiceDetail:)]) {
        [self.delegate MyOrderParentClickCustomerServiceDetail:self.orderDetailDto];
        
    }
   
}

/**
 *  选择商家
 *
 *  @param sender
 */
- (IBAction)selectMerChantClickBtn:(id)sender {

    if ([self.delegate respondsToSelector:@selector(MyOrderParentClickMerchantName:)]) {
        [self.delegate MyOrderParentClickMerchantName:self.detailMerchantNo];

    }
    
}

//补充前面15像素的空缺，不然会点击闪退。
- (IBAction)selectIntervalMerchantBtn:(id)sender {
    
    
    if ([self.delegate respondsToSelector:@selector(MyOrderParentClickMerchantName:)]) {
        [self.delegate MyOrderParentClickMerchantName:self.detailMerchantNo];
        
    }
}


- (void)setOrderDetailDto:(OrderDetailDTO *)orderDetailDto
{
    [super setOrderDetailDto:orderDetailDto];
//    
    if (orderDetailDto) {
        [self.merchantNameBtn setTitle:orderDetailDto.merchantName forState:UIControlStateNormal];

    }
    
}

//- (void)setInfoDto:(OrderInfoListDTO *)infoDto
//{
//    if (infoDto) {
//        [self.merchantNameBtn setTitle:infoDto.merchantName forState:UIControlStateNormal];
//
//    
//    }
//}
- (void)setOrderInfoDto:(OrderInfoListDTO *)orderInfoDto
{
    [super setOrderInfoDto:orderInfoDto];
    
    if (orderInfoDto) {
        self.infoDto = orderInfoDto;
        [self.merchantNameBtn setTitle:orderInfoDto.merchantName forState:UIControlStateNormal];
        
//        self.merchantNo = orderInfoDto.merchantNo;
        
    }
}



@end
