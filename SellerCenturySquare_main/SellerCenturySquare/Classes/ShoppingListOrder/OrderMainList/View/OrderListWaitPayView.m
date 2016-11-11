//
//  OrderListWaitPayView.m
//  CustomerCenturySquare
//
//  Created by 陈光 on 16/6/25.
//  Copyright © 2016年 zuojian. All rights reserved.
//

#import "OrderListWaitPayView.h"

@implementation OrderListWaitPayView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//客服
- (IBAction)selectServiceBtn:(id)sender {
    

}


//订单
- (IBAction)selectOrderBtn:(id)sender {
    self.orderBtn.selected = !self.orderBtn.selected;
    
    if (self.orderBtn.selected) {
        self.recordOrderDto.markStatus = @"yes";
        
    }else
    {
        self.recordOrderDto.markStatus = @"no";
    }
    
    if (self.blockOrderListWaitPaySelectOrder) {
        self.blockOrderListWaitPaySelectOrder ();
    }
}

- (void)orderListWaitPayOrderDto:(GetOrderDTO *)orderDto
{
    if (orderDto) {
        
        self.recordOrderDto = orderDto;
        self.merchantNameLab.text = [NSString stringWithFormat:@"%@",orderDto.memberName];
        if ([orderDto.markStatus isEqualToString:@"yes"]) {
            self.orderBtn.selected = YES;
            
        }else
        {
            self.orderBtn.selected = NO;
        }
        
        switch (orderDto.status.integerValue) {
            case 0:
                self.orderStatusLab.text = @"订单取消";
                
                break;
                
            case 1:
                
                
                self.orderStatusLab.text = @"待付款";
                
                break;
                
            case 2:
            {
                if ([orderDto.refundStatus isKindOfClass:[NSNumber class]]) {
                    switch (orderDto.refundStatus.integerValue) {
                        case 0:
                            self.orderStatusLab.text = @"退货退款_处理中";
                            break;
                            
                        case 1:
                            self.orderStatusLab.text = @"退货退款_处理完成";
                            break;
                            
                        case 2:
                            self.orderStatusLab.text = @"仅退款_处理中";
                            break;
                            
                        case 3:
                            self.orderStatusLab.text = @"仅退款_处理完成";
                            break;
                            
                        case 4:
                            self.orderStatusLab.text = @"换货_处理中";
                            break;
                            
                        case 5:
                            self.orderStatusLab.text = @"换货_处理完成";
                            break;
                            
                        case 6:
                            self.orderStatusLab.text = @"已取消";
                            break;
                            
                            
                        default:
                            break;
                    }
                }
                else
                    self.orderStatusLab.text = @"待发货";
                
                
                break;
            }
                
            case 3:
                
            {
                if ([orderDto.refundStatus isKindOfClass:[NSNumber class]]) {
                    switch (orderDto.refundStatus.integerValue) {
                        case 0:
                            self.orderStatusLab.text = @"退货退款_处理中";
                            break;
                            
                        case 1:
                            self.orderStatusLab.text = @"退货退款_处理完成";
                            break;
                            
                        case 2:
                            self.orderStatusLab.text = @"仅退款_处理中";
                            break;
                            
                        case 3:
                            self.orderStatusLab.text = @"仅退款_处理完成";
                            break;
                            
                        case 4:
                            self.orderStatusLab.text = @"换货_处理中";
                            break;
                            
                        case 5:
                            self.orderStatusLab.text = @"换货_处理完成";
                            break;
                            
                        case 6:
                            self.orderStatusLab.text = @"已取消";
                            break;
                            
                            
                        default:
                            break;
                    }
                }
                else
                    self.orderStatusLab.text = @"待收货";
                
                
                break;
            }
                
            case 4:
                self.orderStatusLab.text = @"交易取消";
                
                break;
            case 5:
                self.orderStatusLab.text = @"交易完成";
                
                break;
                
            default:
                break;
        }
    }
}

@end
