//
//  CSPMerchantOutOfBusinessView.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 8/14/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPMerchantOutOfBusinessView.h"

@implementation CSPMerchantOutOfBusinessView

// !设置歇业时间
- (void)setupWithMerchantDetail:(MerchantListDetailsDTO *)merchantDetail {

    NSDateFormatter* inputDateFormatter = [[NSDateFormatter alloc]init];
    inputDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate* startDate = [inputDateFormatter dateFromString:merchantDetail.closeStartTime];
    NSDate* endDate = [inputDateFormatter dateFromString:merchantDetail.closeEndTime];

    NSDateFormatter* outputDateFormatter = [[NSDateFormatter alloc]init];
    outputDateFormatter.dateFormat = @"yyyy/MM/dd HH点";
    outputDateFormatter.dateFormat = [NSString stringWithFormat:@"yyyy/MM/dd HH%@",NSLocalizedString(@"outTime", @"点")];
    
    
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@ ~ %@", [outputDateFormatter stringFromDate:startDate], [outputDateFormatter stringFromDate:endDate]];
    
    
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code

    self.outBussinessLabel.text = NSLocalizedString(@"outBussiness", @"歇业中");

    self.outTimeAlertLabel.text = NSLocalizedString(@"outTimeAlert", @"歇业时间");
    
    
}


@end
