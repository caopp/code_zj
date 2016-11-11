//
//  CSPAuthorityPopView.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/24/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//  !权限提醒的view

#import <UIKit/UIKit.h>
#import "GoodsNotLevelTipDTO.h"
#import "CustomButton.h"

@protocol CSPAuthorityPopViewDelegate <NSObject>

@optional
- (void)showLevelRules;
- (void)prepareToUpgradeUserLevel;
- (void)actionWhenPopViewDimiss;

@end

@interface CSPAuthorityPopView : UIView

@property (nonatomic, assign)id<CSPAuthorityPopViewDelegate> delegate;

// !"权限受限"

@property (weak, nonatomic) IBOutlet UILabel *alertTitleLabel;

// !"查看权限等级"
@property (weak, nonatomic) IBOutlet UILabel *browAuthLevelLabel;

// !"您的等级"
@property (weak, nonatomic) IBOutlet UILabel *userLevelAlertLabel;

// !"立即升级"
@property (weak, nonatomic) IBOutlet UIButton *upgradeBtn;

// !"消费积分还差"
@property (weak, nonatomic) IBOutlet UILabel *needGradeLabel;

// !"等级规则"
@property (weak, nonatomic) IBOutlet CustomButton *rankRuleBtn;

@property (weak, nonatomic) IBOutlet UILabel *levelTitle;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *visibleLevelLabel;

@property (weak, nonatomic) IBOutlet UILabel *userLevelLabel;



@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (nonatomic, strong) GoodsNotLevelTipDTO* goodsNotLevelTipDTO;
@property (nonatomic, assign) CSPAuthorityType CSPauthority;

@end
