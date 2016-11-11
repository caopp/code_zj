//
//  CSPGoodsInfoModelTableViewCell.h
//  BuyerCenturySquare
//
//  Created by 李春晓 on 15/7/13.
//  Copyright (c) 2015年 pactera. All rights reserved.
//  !样板

#import <UIKit/UIKit.h>
#import "CSPBaseTableViewCell.h"
#import "TTTAttributedLabel.h"
#define kModeStateChangedNotification @"ModeStateChangedNotification"
@interface CSPGoodsInfoModelTableViewCell : CSPBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIView *selectedBlackView;
@property (weak, nonatomic) IBOutlet UIButton *modeStateButton;
@property (weak, nonatomic) IBOutlet UILabel *priceL;


- (void)setModeState:(BOOL)modeState;
@end
