//
//  TopOrderStateTableViewableViewCell.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/3/19.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "TopOrderStateTableViewableViewCell.h"

@implementation TopOrderStateTableViewableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOrderDto:(GetOrderDTO *)orderDto
{
    [super setOrderDto:orderDto];
    
    if (orderDto) {
        if (orderDto.type.integerValue == 0) {
            self.orderNameLab.text = @"【期货单】";
            self.orderNameLab.textColor = [UIColor colorWithHex:0xeb301f alpha:1];

        }else if (orderDto.type.integerValue == 1)
        {
            self.orderNameLab.text = @"【现货单】";
            self.orderNameLab.textColor = [UIColor colorWithHex:0x09bb07 alpha:1];
            
        }
        
        
        switch (orderDto.status.integerValue) {
            case 0:
                self.goodsStateLab.text = @"采购单取消";
    
                break;
                
            case 1:
                
                
                self.goodsStateLab.text = @"待付款";

                break;
                
            case 2:
            {
                if ([orderDto.refundStatus isKindOfClass:[NSNumber class]]) {
                    switch (orderDto.refundStatus.integerValue) {
                        case 0:
                            self.goodsStateLab.text = @"退货退款_处理中";
                            break;
                            
                        case 1:
                            self.goodsStateLab.text = @"退货退款_处理完成";
                            break;
                            
                        case 2:
                            self.goodsStateLab.text = @"仅退款_处理中";
                            break;
                            
                        case 3:
                            self.goodsStateLab.text = @"仅退款_处理完成";
                            break;
                            
                        case 4:
                            self.goodsStateLab.text = @"换货_处理中";
                            break;
                            
                        case 5:
                            self.goodsStateLab.text = @"换货_处理完成";
                            break;
                            
                        case 6:
                            self.goodsStateLab.text = @"已取消";
                            break;
                            
                            
                        default:
                            break;
                    }
                }
                else
                    self.goodsStateLab.text = @"待发货";

                
                break;
            }
  
            case 3:
                
            {
                if ([orderDto.refundStatus isKindOfClass:[NSNumber class]]) {
                    switch (orderDto.refundStatus.integerValue) {
                        case 0:
                            self.goodsStateLab.text = @"退货退款_处理中";
                            break;
                            
                        case 1:
                            self.goodsStateLab.text = @"退货退款_处理完成";
                            break;
                            
                        case 2:
                            self.goodsStateLab.text = @"仅退款_处理中";
                            break;
                            
                        case 3:
                            self.goodsStateLab.text = @"仅退款_处理完成";
                            break;
                            
                        case 4:
                            self.goodsStateLab.text = @"换货_处理中";
                            break;
                            
                        case 5:
                            self.goodsStateLab.text = @"换货_处理完成";
                            break;
                            
                        case 6:
                            self.goodsStateLab.text = @"已取消";
                            break;
                            
                            
                        default:
                            break;
                    }
                }
                else
                    self.goodsStateLab.text = @"待收货";
                
                
                break;
            }

//                self.goodsStateLab.text = @"待收货";
//                break;
            case 4:
                self.goodsStateLab.text = @"交易取消";
                
                break;
            case 5:
                self.goodsStateLab.text = @"交易完成";
                
                break;
                
            default:
                break;
        }
    }
    
    
}


@end
