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
    
    //!语言国际化
    [self languageInternational];
    self.upgradeBtn.layer.cornerRadius = 3.0f;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeViewClcik)];
    [self addGestureRecognizer:tap];
    

}
-(void)removeViewClcik{

    [self removeFromSuperview];

}

//!语言国际化
- (void)languageInternational{

    // !"权限受限"
    self.alertTitleLabel.text = NSLocalizedString(@"authLimited", @"权限受限");
    
    // !可查看级别
    self.browAuthLevelLabel.text = NSLocalizedString(@"browAuthLevel", @"查看权限等级：");

    // !您的等级
    self.userLevelAlertLabel.text = NSLocalizedString(@"userLevel", @"您的等级：");
    
    // !立即升级
    [self.upgradeBtn setTitle:NSLocalizedString(@"upgrade", @"立即升级：") forState:UIControlStateNormal];
    
    
    //!等级规则
    [self.rankRuleBtn setTitle:NSLocalizedString(@"rankRule", @"等级规则") forState:UIControlStateNormal];
    
    
    
}
//立即升级
- (IBAction)upgradeButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(prepareToUpgradeUserLevel)]) {
        
        
        [self.delegate prepareToUpgradeUserLevel];
    }
    [self removeFromSuperview];

}

- (IBAction)levelRuleButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(showLevelRules)]) {
        [self.delegate showLevelRules];
    }

    [self removeFromSuperview];

}

- (IBAction)closeButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionWhenPopViewDimiss)]) {
        
        [self.delegate actionWhenPopViewDimiss];
    }
    
    [self removeFromSuperview];
}

- (void)setGoodsNotLevelTipDTO:(GoodsNotLevelTipDTO *)goodsNotLevelTipDTO{
    
    
    _goodsNotLevelTipDTO = goodsNotLevelTipDTO;
    self.visibleLevelLabel.text = [NSString stringWithFormat:@"V%@", goodsNotLevelTipDTO.readLevel.stringValue];
    self.userLevelLabel.text = [NSString stringWithFormat:@"V%@", goodsNotLevelTipDTO.currentLevel.stringValue];
    
    
    if (goodsNotLevelTipDTO.integralNum.doubleValue >= 0) {
       
        self.needGradeLabel.text = [NSString stringWithFormat:@"消费积分还差：%.2f",[goodsNotLevelTipDTO.integralNum doubleValue]];
//        self.scoreLabel.text = [NSString stringWithFormat:@" %.2f",[goodsNotLevelTipDTO.integralNum doubleValue]];
        
        
    }else{
        
        self.needGradeLabel.text = @"消费积分还差：下月核算积分后即可升级";

//        self.scoreLabel.text = @"下月核算积分后即可升级";
    
    }
    
    

}

-(void)setCSPauthority:(CSPAuthorityType)CSPauthority{
    
    switch (CSPauthority) {
        case CSPAuthorityCollection:
            self.levelTitle.text = NSLocalizedString(@"collectionAuthLevel", @"收藏权限等级:");
            break;
        case CSPAuthorityDownload:
            self.levelTitle.text = NSLocalizedString(@"downloadAuthLevel", @"下载权限等级:");
            break;
        case CSPAuthorityShare:
            self.levelTitle.text = NSLocalizedString(@"shareAuthLevel", @"分享权限等级:");
            break;
            
        default:
            break;
    }
}

@end
