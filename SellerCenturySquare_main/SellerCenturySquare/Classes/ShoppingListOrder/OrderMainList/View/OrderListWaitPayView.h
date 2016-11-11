//
//  OrderListWaitPayView.h
//  CustomerCenturySquare
//
//  Created by 陈光 on 16/6/25.
//  Copyright © 2016年 zuojian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetOrderDTO.h"

@interface OrderListWaitPayView : UIView
@property (nonatomic ,strong) void (^blockOrderListWaitPaySelectOrder)();


//订单选中/未选中
@property (weak, nonatomic) IBOutlet UIButton *orderBtn;

//商家名称
@property (weak, nonatomic) IBOutlet UILabel *merchantNameLab;

//订单状态
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLab;

@property (nonatomic ,strong) GetOrderDTO *recordOrderDto;

//客服
- (IBAction)selectServiceBtn:(id)sender;
//订单选中/未选中
- (IBAction)selectOrderBtn:(id)sender;
- (void)orderListWaitPayOrderDto:(GetOrderDTO *)orderDto;

@end
