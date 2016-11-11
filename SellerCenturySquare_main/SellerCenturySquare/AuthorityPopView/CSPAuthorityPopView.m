//
//  CSPAuthorityPopView.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/24/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPAuthorityPopView.h"

@implementation CSPAuthorityPopView

- (void)awakeFromNib {
    self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.contentView.layer.shadowOffset = CGSizeMake(2, 2);
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 5.0f;
    
   
    
}


- (IBAction)upgradeButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(prepareToUpgradeUserLevel)]) {
        [self.delegate prepareToUpgradeUserLevel];
    }
}

- (IBAction)levelRuleButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(showLevelRules)]) {
        [self.delegate showLevelRules];
    }
}

- (IBAction)closeButtonClicked:(id)sender {
    [self removeFromSuperview];
}

- (void)setGoodsNotLevelTipDTO:(GetMerchantNotAuthTipDTO *)getMerchantNotAuthTipDTO {
    
    
    _getMerchantNotAuthTipDTO = getMerchantNotAuthTipDTO;
    self.visibleLevelLabel.text = [NSString stringWithFormat:@"V%@", getMerchantNotAuthTipDTO.readLevel.stringValue];
    self.userLevelLabel.text = [NSString stringWithFormat:@"V%@", getMerchantNotAuthTipDTO.currentLevel.stringValue];
    
//    NSMutableAttributedString* integralString = [[NSMutableAttributedString alloc]initWithString:@"￥" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10]}];

    
    NSAttributedString* integralValueString = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.2f", [getMerchantNotAuthTipDTO.integralNum doubleValue]] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Tw Cen MT" size:12]}];

    //[integralString appendAttributedString:integralValueString];
    self.scoreLabel.attributedText = integralValueString;
}

@end
