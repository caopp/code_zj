//
//  CSPOrderModeControl.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 9/9/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMSegmentView.h"
#import "CSPOrderModeUtils.h"
#import "CSPOrderSegmentView.h"

@class OrderGroup;
@class OrderAddDTO;

@protocol CSPOrderModeControlDelegate <NSObject>

@optional

//跳转到采购单详情
- (void)selectedOrderGroup:(OrderGroup*)orderGroupInfo;

- (void)prepareToPayForOrder:(NSString*)orderCode;

//跳转到客服
- (void)enquiryWithMerchantName:(NSString*)merchantName andMerchantNo:(NSString*)merchantNo;

- (void)withoutAnyOrder;

//跳转到商家
- (void)CSPOrderModeJumpNextMerchanName:(NSString *)name merchanNo:(NSString *)No;


@end

@interface CSPOrderModeControl : NSObject <SMSegmentViewDelegate, UITableViewDataSource, UITableViewDelegate,OrderSegmentViewDelegate>

@property (nonatomic, assign)id<CSPOrderModeControlDelegate> delegate;

@property (nonatomic, weak) UITableView* tableView;
@property (nonatomic, weak) UIView* view;
@property (nonatomic ,strong)UIView *titleMessageView;


@property (nonatomic, assign)CSPOrderMode orderMode;//判断是哪个是tableView 真正的数据

//刷新采购单
- (void)refreshOrder;

- (id)initWithTableView:(UITableView*)tableView;

@end
