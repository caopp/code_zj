//
//  OrderListHeadView.h
//  CustomerCenturySquare
//
//  Created by 陈光 on 16/6/25.
//  Copyright © 2016年 zuojian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetOrderDTO.h"

@interface OrderListHeadView : UIView
//商家名称
@property (weak, nonatomic) IBOutlet UILabel *merchantNameLab;
//订单状态
@property (weak, nonatomic) IBOutlet UILabel *orderDealStatusLab;

//客服
- (IBAction)serviceBtn:(id)sender;

- (void)orderListOrderDto:(GetOrderDTO *)orderDto;
@end
