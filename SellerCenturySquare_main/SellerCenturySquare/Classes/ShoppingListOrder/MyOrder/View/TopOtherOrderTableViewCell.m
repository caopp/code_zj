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
//myOrderParentSelectSerViceOrder
    if ([self.delegate respondsToSelector:@selector(myOrderParentSelectSerViceOrder:)]) {
        [self.delegate myOrderParentSelectSerViceOrder:self.recordOrderDto];
        
    }
}

/**
 *  选择商家
 *
 *  @param sender
 */
- (IBAction)selectMerChantClickBtn:(id)sender {

    
}

//补充前面15像素的空缺，不然会点击闪退。
- (IBAction)selectIntervalMerchantBtn:(id)sender {
    
}

- (void)setOrderDto:(GetOrderDTO *)orderDto
{
    [super setOrderDto:orderDto];
    self.recordOrderDto = orderDto;
    if (orderDto) {
        
        CGFloat nameWidth =     [self  accordingContentFont:orderDto.consigneeName].width;
        self.merchantNameBtnWidth.constant = nameWidth+3;
        
        
    [self.merchantNameBtn setTitle:orderDto.consigneeName forState:UIControlStateNormal];
        [self.merchantIphoneBtn setTitle:orderDto.consigneePhone forState:UIControlStateNormal];
        
        
    }
}


//计算字体
- (CGSize)accordingContentFont:(NSString *)str
{
    
    CGSize size;
    size=[str boundingRectWithSize:CGSizeMake(200, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:15]} context:nil].size;
    
    return size;
    
}




@end
