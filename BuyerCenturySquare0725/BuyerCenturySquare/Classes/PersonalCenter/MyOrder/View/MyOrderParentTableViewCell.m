//
//  MyOrderParentTableViewCell.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/3/19.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "MyOrderParentTableViewCell.h"



@implementation MyOrderParentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setOrderInfoDto:(OrderInfoListDTO *)orderInfoDto
{
    if (orderInfoDto) {
        self.merchantNo = orderInfoDto.merchantNo;
        self.memberNo = orderInfoDto.memberNo;
        self.orderCode = orderInfoDto.orderCode;
        self.balanceQuantity = orderInfoDto.balanceQuantity;
        self.isSelect = orderInfoDto.isSelect;
        
        self.detailMerchantNo = orderInfoDto.merchantNo;
        
        
    }
}

- (void)setOrderDetailMessageDto:(OrderDetailMesssageDTO *)orderDetailMessageDto
{
    if (orderDetailMessageDto) {
        self.goodsNo = orderDetailMessageDto.goodsNo;

        
    }
}
- (void)setGoodsItemDto:(OrderGoodsItem *)goodsItemDto
{

}

- (void)setOrderDetailDto:(OrderDetailDTO *)orderDetailDto
{
    self.detailMerchantNo = orderDetailDto.merchantNo;
    
}

@end
