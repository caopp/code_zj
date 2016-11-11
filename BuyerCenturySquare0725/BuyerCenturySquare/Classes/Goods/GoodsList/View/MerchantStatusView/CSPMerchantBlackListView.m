//
//  CSPMerchantBlackListView.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 8/14/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//  !黑名单 无权访问的view

#import "CSPMerchantBlackListView.h"

@implementation CSPMerchantBlackListView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code

    self.noRightLabel.text = NSLocalizedString(@"noRight", @"很抱歉，您无权访问本店");

}


@end
