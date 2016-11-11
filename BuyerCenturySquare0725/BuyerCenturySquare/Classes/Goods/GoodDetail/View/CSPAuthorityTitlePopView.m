//
//  CSPAuthorityTitlePopView.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 9/2/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPAuthorityTitlePopView.h"

@implementation CSPAuthorityTitlePopView

- (void)awakeFromNib
{
    self.backgroundView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.backgroundView.layer.shadowOffset = CGSizeMake(2, 2);
    self.backgroundView.layer.masksToBounds = YES;
    self.backgroundView.layer.cornerRadius = 5.0f;
    
    self.buyTimesButton.layer.cornerRadius = 2;
    self.buyTimesButton.layer.masksToBounds = YES;
    
    [self.buyTimesButton setTitle:NSLocalizedString(@"buyTimes", @"购买下载次数") forState:UIControlStateNormal];
    
    
}

- (IBAction)cancelButtonClicked:(id)sender {
    
    if (_delegate&&[_delegate respondsToSelector:@selector(actionWhenPopViewDimiss)]) {
        
        [_delegate actionWhenPopViewDimiss];
    }
    
    [self removeFromSuperview];
}


- (IBAction)buyTimesButtonClicked:(id)sender {
    
    if (_delegate&&[_delegate respondsToSelector:@selector(gotoBuyDownloadTimes)]) {
        
        [_delegate gotoBuyDownloadTimes];
    }
    
    [self removeFromSuperview];
    
}


@end
