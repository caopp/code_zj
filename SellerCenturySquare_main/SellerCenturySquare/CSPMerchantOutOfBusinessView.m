//
//  CSPMerchantOutOfBusinessView.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 8/14/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPMerchantOutOfBusinessView.h"

@implementation CSPMerchantOutOfBusinessView

- (void)setupWithCloseStartTime:(NSString*)closeStartTime andCloseEndTime:(NSString*)closeEndTime {

    NSDateFormatter* inputDateFormatter = [[NSDateFormatter alloc]init];
    inputDateFormatter.dateFormat = @"yyyy-MM-dd HH";
    NSDate* startDate = [inputDateFormatter dateFromString:closeStartTime];
    NSDate* endDate = [inputDateFormatter dateFromString:closeEndTime];

    NSDateFormatter* outputDateFormatter = [[NSDateFormatter alloc]init];
    outputDateFormatter.dateFormat = @"yyyy/MM/dd HH点";

    self.timeLabel.text = [NSString stringWithFormat:@"%@ ~ %@", [outputDateFormatter stringFromDate:startDate], [outputDateFormatter stringFromDate:endDate]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
