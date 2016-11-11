//
//  CSPReplenishmentSectionHeaderView.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 9/11/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CSPReplenishmentSectionHeaderView;

@protocol CSPReplenishmentSectionHeaderViewDelegate <NSObject>

@optional
- (void)sectionHeaderSelected:(BOOL)selected sectionForIndex:(NSInteger)index;
- (void)sectionHeaderView:(CSPReplenishmentSectionHeaderView*)sectionHeaderView merchantNamePressedForIndex:(NSInteger)index;

@end

@class ReplenishmentMerchant;

@interface CSPReplenishmentSectionHeaderView : UITableViewHeaderFooterView

@property(nonatomic, assign)id<CSPReplenishmentSectionHeaderViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIButton *merchantNameButton;

@property (nonatomic, assign)NSInteger index;
@property (weak, nonatomic) ReplenishmentMerchant* merchantInfo;

+ (CGFloat)sectionHeaderHeight;

@end
