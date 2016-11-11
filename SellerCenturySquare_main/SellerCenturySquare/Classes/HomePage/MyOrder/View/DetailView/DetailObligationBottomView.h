//
//  DetailObligationBottomView.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/31.
//  Copyright © 2016年 pactera. All rights reserved.
// !待付款

#import <UIKit/UIKit.h>

@interface DetailObligationBottomView : UIView

//!修改价钱
@property(nonatomic,copy)void (^changePriceBlock)();


@end
