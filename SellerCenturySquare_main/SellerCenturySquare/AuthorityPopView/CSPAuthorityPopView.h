//
//  CSPAuthorityPopView.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/24/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetMerchantNotAuthTipDTO.h"

@protocol CSPAuthorityPopViewDelegate <NSObject>

- (void)showLevelRules;
- (void)prepareToUpgradeUserLevel;

@end

@interface CSPAuthorityPopView : UIView

@property (nonatomic, assign)id<CSPAuthorityPopViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *visibleLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLackIntegralLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayAutoGradeLabel;

@property (nonatomic, strong) GetMerchantNotAuthTipDTO* getMerchantNotAuthTipDTO;

- (void)setGoodsNotLevelTipDTO:(GetMerchantNotAuthTipDTO *)getMerchantNotAuthTipDTO;



@end
