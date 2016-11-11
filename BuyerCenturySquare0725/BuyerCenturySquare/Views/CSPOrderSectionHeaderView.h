//
//  CSPConfirmOrderSectionHeaderView.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 9/4/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSPOrderModeUtils.h"

@class CSPOrderSectionHeaderView;

@protocol CSPOrderSectionHeaderViewDelegate <NSObject>

//点击客服
- (void)sectionHeaderView:(CSPOrderSectionHeaderView*)sectionHeaderView enquiryWithMerchantName:(NSString*)merchantName andMerchantNo:(NSString*)merchantNo;
//点击商家名称
- (void)CSPOrderSectionHeaderView:(CSPOrderSectionHeaderView *)sectionHeaderView merchanName:(NSString *)merchant merchantNo:(NSString *)merchantNo;


@end


@class CartConfirmMerchant;
@class OrderGroup;

@interface CSPOrderSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic, assign)id <CSPOrderSectionHeaderViewDelegate> delegate;

@property (nonatomic, weak) IBOutlet UILabel* merchantNameLabel;
@property (nonatomic, weak) IBOutlet UILabel* orderTypeLabel;
@property (nonatomic, weak) IBOutlet UILabel* orderStatusLabel;
@property (nonatomic, weak) IBOutlet UIButton* enquiryButton;

@property (nonatomic, weak) CartConfirmMerchant* cartConfirmMerchantInfo;
@property (nonatomic, weak) OrderGroup* orderGroupInfo;

@property (nonatomic, assign, readonly)CSPOrderMode orderMode;

+ (CGFloat)sectionHeaderHeight;

@end
