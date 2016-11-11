//
//  CSPReplenishmentSectionHeaderView.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 9/11/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPReplenishmentSectionHeaderView.h"
#import "ReplenishmentByMerchantDTO.h"

@implementation CSPReplenishmentSectionHeaderView

- (void)setMerchantInfo:(ReplenishmentMerchant *)merchantInfo {
    _merchantInfo = merchantInfo;

    self.selectButton.selected = _merchantInfo.selected;

    [self.merchantNameButton setTitle:_merchantInfo.merchantName forState:UIControlStateNormal];
}


- (IBAction)selectButtonClicked:(UIButton*)sender {
    
    sender.selected = !sender.selected;
    self.merchantInfo.selected = sender.selected;

    if (self.delegate && [self.delegate respondsToSelector:@selector(sectionHeaderSelected:sectionForIndex:)]) {
        
        [self.delegate sectionHeaderSelected:sender.selected sectionForIndex:self.index];
    }
}

- (IBAction)merchantNameButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sectionHeaderView:merchantNamePressedForIndex:)]) {
        [self.delegate sectionHeaderView:self merchantNamePressedForIndex:self.index];
    }
}

+ (CGFloat)sectionHeaderHeight {
    return 30.0f;
}

@end
