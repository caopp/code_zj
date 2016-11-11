//
//  CSPColorSizeTableViewCell.h
//  BuyerCenturySquare
//
//  Created by caopenpen on 16/3/15.
//  Copyright © 2016年 pactera. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CSPBaseTableViewCell.h"
#import "CSPAmountControlView.h"
#define kGoodsCountChangedNotification @"GoodsCountChangedNotification"
#define kGoodsColorChangedNotification @"GoodsColorChangedNotification"
@interface CSPColorSizeTableViewCell : CSPBaseTableViewCell<CSPSkuControlViewDelegate>
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *segments;
@property (nonatomic ,assign)NSInteger total;
@property (strong, nonatomic) IBOutletCollection(CSPSkuControlView) NSArray *skuControlViews;
@property (strong, nonatomic) IBOutlet UIView *alphView;
@property (nonatomic ,strong)NSMutableArray *skuList;
@property (nonatomic,strong) NSMutableArray *colorList;
@property(nonatomic,assign)NSInteger select_itm;
@property (strong, nonatomic) IBOutlet UILabel *minLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *colorScroll;

- (void)setModeState:(BOOL)modeState;
@end
