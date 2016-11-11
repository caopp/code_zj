//
//  CSPOrderSectionFooterView.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 9/9/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSPOrderModeUtils.h"

@class OrderGroup;

@protocol CSPOrderSectionFooterViewActionDelegate <NSObject>

@optional
//支付按钮
- (void)payButtonClickedForOrderGroup:(OrderGroup*)orderGroupInfo;
//取消采购单
- (void)cancelUnpaidOrder:(OrderGroup*)orderGroupInfo;
//延期处理
- (void)postponeGoods:(OrderGroup *)orderGroupInfo;

//确认收货
- (void)confirmTakeDeliveryForOrder:(OrderGroup*)orderGroupInfo;

@end

@interface CSPOrderSectionFooterView : UITableViewHeaderFooterView

@property (nonatomic, assign)id<CSPOrderSectionFooterViewActionDelegate> delegate;

@property (nonatomic, assign, readonly) CSPOrderMode orderMode;
@property (nonatomic, weak) OrderGroup* orderGroupInfo;

+ (CGFloat)sectionFooterHeightWithOrderMode:(CSPOrderMode)orderMode;

@end
