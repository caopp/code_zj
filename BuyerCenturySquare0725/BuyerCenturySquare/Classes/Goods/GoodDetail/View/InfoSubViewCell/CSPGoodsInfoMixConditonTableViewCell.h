//
//  CSPGoodsInfoMixConditonTableViewCell.h
//  BuyerCenturySquare
//
//  Created by 李春晓 on 15/7/13.
//  Copyright (c) 2015年 pactera. All rights reserved.
//  !混批条件

#import <UIKit/UIKit.h>
#import "CSPBaseTableViewCell.h"

@interface CSPGoodsInfoMixConditonTableViewCell : CSPBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIView *alphaView;
@property (weak, nonatomic) IBOutlet UILabel *titleL;

@property (weak, nonatomic) IBOutlet UILabel *mixL;

- (void)setModeState:(BOOL)modeState;
- (void)updateMix:(NSNumber*)num price:(NSNumber*)price;
- (void)updateBatchMsg:(NSString*)batchMsg;
@end
