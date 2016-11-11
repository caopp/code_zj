//
//  CSPMerchantOutOfBusinessView.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 8/14/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//  !商家歇业 

#import <UIKit/UIKit.h>
#import "MerchantListDetailsDTO.h"

@interface CSPMerchantOutOfBusinessView : UIView

// !歇业中
@property (weak, nonatomic) IBOutlet UILabel *outBussinessLabel;
// !歇业时间
@property (weak, nonatomic) IBOutlet UILabel *outTimeAlertLabel;
// !具体的歇业时间显示
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (void)setupWithMerchantDetail:(MerchantListDetailsDTO*)merchantDetail;

@end
