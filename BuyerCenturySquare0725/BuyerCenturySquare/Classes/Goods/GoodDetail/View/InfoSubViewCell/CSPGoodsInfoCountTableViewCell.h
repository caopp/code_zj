//
//  CSPGoodsInfoCountTableViewCell.h
//  BuyerCenturySquare
//
//  Created by 李春晓 on 15/7/13.
//  Copyright (c) 2015年 pactera. All rights reserved.
//  已选数量 及起批数量

#import <UIKit/UIKit.h>
#import "CSPBaseTableViewCell.h"

@interface CSPGoodsInfoCountTableViewCell : CSPBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIView *alphaView;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *selectLabels;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *lineViews;

@property (weak, nonatomic) IBOutlet UIView *selectedBlackView;
@property (weak, nonatomic) IBOutlet UILabel *startNumL;
@property (weak, nonatomic) IBOutlet UILabel *countNumL;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;

@property (nonatomic,strong)NSMutableArray *selectNums;

- (void)setModeState:(BOOL)modeState;
- (void)setStartNum:(NSNumber*)num;
@end
