//
//  CSPGoodsCollectionViewCell.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/10/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Commodity;

@interface CSPGoodsCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *swearImageView;
@property (weak, nonatomic) IBOutlet UILabel *swearTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *minAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateDateLabel;
@property (weak, nonatomic) IBOutlet UIView *blurView;
@property (weak, nonatomic) IBOutlet UILabel *visibleLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayNumLabel;
@property (weak, nonatomic) IBOutlet UIView *cornerView;
@property (weak, nonatomic) IBOutlet UILabel *dayNumUnitLabel;

@property (weak, nonatomic) Commodity* commodityInfo;

@end
