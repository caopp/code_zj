//
//  OrderListHeadView.m
//  CustomerCenturySquare
//
//  Created by 陈光 on 16/6/25.
//  Copyright © 2016年 zuojian. All rights reserved.
//

#import "OrderListHeadView.h"

@implementation OrderListHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)serviceBtn:(id)sender {
    
    
}

- (void)orderListOrderDto:(GetOrderDTO *)orderDto
{
    if (orderDto) {
        self.merchantNameLab.text = [NSString stringWithFormat:@"%@  %@",orderDto.consigneeName,orderDto.consigneePhone];
        
        switch (orderDto.status.integerValue) {
            case 0:
                self.orderDealStatusLab.text = @"订单取消";
                
                break;
                
            case 1:
                
                
                self.orderDealStatusLab.text = @"待付款";
                
                break;
                
            case 2:
            {
                if ([orderDto.refundStatus isKindOfClass:[NSNumber class]]) {
                    switch (orderDto.refundStatus.integerValue) {
                        case 0:
                            self.orderDealStatusLab.text = @"退货退款_处理中";
                            break;
                            
                        case 1:
                            self.orderDealStatusLab.text = @"退货退款_处理完成";
                            break;
                            
                        case 2:
                            self.orderDealStatusLab.text = @"仅退款_处理中";
                            break;
                            
                        case 3:
                            self.orderDealStatusLab.text = @"仅退款_处理完成";
                            break;
                            
                        case 4:
                            self.orderDealStatusLab.text = @"换货_处理中";
                            break;
                            
                        case 5:
                            self.orderDealStatusLab.text = @"换货_处理完成";
                            break;
                            
                        case 6:
                            self.orderDealStatusLab.text = @"已取消";
                            break;
                            
                            
                        default:
                            break;
                    }
                }
                else
                    self.orderDealStatusLab.text = @"待发货";
                
                
                break;
            }
                
            case 3:
                
            {
                if ([orderDto.refundStatus isKindOfClass:[NSNumber class]]) {
                    switch (orderDto.refundStatus.integerValue) {
                        case 0:
                            self.orderDealStatusLab.text = @"退货退款_处理中";
                            break;
                            
                        case 1:
                            self.orderDealStatusLab.text = @"退货退款_处理完成";
                            break;
                            
                        case 2:
                            self.orderDealStatusLab.text = @"仅退款_处理中";
                            break;
                            
                        case 3:
                            self.orderDealStatusLab.text = @"仅退款_处理完成";
                            break;
                            
                        case 4:
                            self.orderDealStatusLab.text = @"换货_处理中";
                            break;
                            
                        case 5:
                            self.orderDealStatusLab.text = @"换货_处理完成";
                            break;
                            
                        case 6:
                            self.orderDealStatusLab.text = @"已取消";
                            break;
                            
                            
                        default:
                            break;
                    }
                }
                else
                    self.orderDealStatusLab.text = @"待收货";
                
                
                break;
            }
                
                //                self.goodsStateLab.text = @"待收货";
                //                break;
            case 4:
                self.orderDealStatusLab.text = @"交易取消";
                
                break;
            case 5:
                self.orderDealStatusLab.text = @"交易完成";
                
                break;
                
            default:
                break;
        }
    }
}
@end
