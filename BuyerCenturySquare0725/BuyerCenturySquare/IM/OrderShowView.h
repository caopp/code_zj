//
//  OrderShowView.h
//  BuyerCenturySquare
//
//  Created by caopenpen on 16/3/31.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderImgView.h"
#import "ECMessage.h"
@interface OrderShowView : UIView
@property (strong, nonatomic) IBOutlet UILabel *goodNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
@property (strong, nonatomic) IBOutletCollection(OrderImgView) NSArray *OrderImgArray;
-(void)showOrderWithDic:(NSDictionary *)dicOrder;
-(void)showOrderWithMessage:(ECMessage *)message;
@end
