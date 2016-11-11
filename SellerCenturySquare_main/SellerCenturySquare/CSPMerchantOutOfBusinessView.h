//
//  CSPMerchantOutOfBusinessView.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 8/14/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSPMerchantOutOfBusinessView : UIView

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (void)setupWithCloseStartTime:(NSString*)closeStartTime andCloseEndTime:(NSString*)closeEndTime;

@end