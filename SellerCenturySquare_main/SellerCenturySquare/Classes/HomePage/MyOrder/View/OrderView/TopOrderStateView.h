//
//  TopOrderStateView.h
//  SellerCenturySquare
//
//  Created by 陈光 on 16/4/25.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetMerchantMainDTO.h"
@interface TopOrderStateView : UIView
//waitDeliverView
@property (nonatomic ,strong) GetMerchantMainDTO *merchantMainDto;
@property (nonatomic ,copy) void (^blockwaitPay)();
@property (nonatomic ,copy) void (^blockwaitDeliver)();
@property (nonatomic ,copy) void (^blockwaitReceipt)();
@property (nonatomic ,copy) void (^blockAllOrderState)();


@end
