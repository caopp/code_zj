//
//  CSPSellerTableViewCell.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/6/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSPBaseTableViewCell.h"
#import "MerchantListDetailsDTO.h"

@interface CSPMerchantTableViewCell : CSPBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel* merchantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel* merchantNoLabel;
@property (weak, nonatomic) IBOutlet UILabel* categoryNameLabel;
@property (weak, nonatomic) IBOutlet UILabel* goodsNumLabel;
@property (weak, nonatomic) IBOutlet UILabel* closingTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *cornerView;
@property (weak, nonatomic) IBOutlet UILabel *cornerLabel;

// !歇业的毛玻璃这一层(换成view了)
@property (weak, nonatomic) IBOutlet UIView *blackAlphaView;

// !歇业中

@property (weak, nonatomic) IBOutlet UILabel *outBussinessLabel;

- (void)setupWithDictionary:(NSDictionary*)dictionary;
- (void)setupWithMerchantDetailsDTO:(MerchantListDetailsDTO*)merchantDetailsDTO;

@end
