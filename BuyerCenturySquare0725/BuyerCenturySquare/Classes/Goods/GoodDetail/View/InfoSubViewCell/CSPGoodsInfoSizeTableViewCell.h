 //
//  CSPGoodsInfoSizeTableViewCell.h
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/7/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//  !尺码

#import <UIKit/UIKit.h>
#import "CSPBaseTableViewCell.h"
#import "CSPAmountControlView.h"
#import "CSPOrderModeUtils.h"
#import "SkuListDTO.h"
#import "GetGoodsReplenishmentByMerchantListDTO.h"

#define kGoodsCountChangedNotification @"GoodsCountChangedNotification"

@interface CSPGoodsInfoSizeTableViewCell : CSPBaseTableViewCell<CSPSkuControlViewDelegate>
@property (nonatomic ,strong)NSMutableArray *skuList;
@property (weak, nonatomic) IBOutlet UIView *alphaView;
@property (nonatomic ,assign)NSInteger total;

@property (strong, nonatomic) IBOutletCollection(CSPSkuControlView) NSArray *skuControlViews;

- (void)setModeState:(BOOL)modeState;
@end
