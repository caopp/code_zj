//
//  CSPGoodsInfoSubSizePicTableViewCell.h
//  BuyerCenturySquare
//
//  Created by 李春晓 on 15/7/13.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSPBaseTableViewCell.h"

#define kObjectiveAndRefrenceButtonClickedNotification @"ObjectiveAndRefrenceButtonClickedNotification"
@interface CSPGoodsInfoSubSizePicTableViewCell : CSPBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIView *objBackView;
@property (weak, nonatomic) IBOutlet UIView *refBackView;

@property (weak, nonatomic) IBOutlet UILabel *objL;
@property (weak, nonatomic) IBOutlet UILabel *refL;

- (void)objectiveState:(BOOL)objective;
- (void)setReferenceButtonNum:(NSInteger)num;
@end
