//
//  CSPUtils.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/22/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPUtils.h"

@implementation CSPUtils

+ (long long)getTimeStampFromNSDate:(NSDate *)time {
    
    return ((long)[time timeIntervalSince1970]) * 1000;
}

+ (long long)getTimeStamp:(NSString *)time {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:time];
    
    return ((long)[date timeIntervalSince1970]) * 1000;
}

+ (NSString *)getTime:(long)timeStamp {
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeStamp / 1000]];
}

+ (BOOL)isRoundNumber:(float)value {
    float roundNumber = rint(value);
    if (value - roundNumber < 0.001) {
        return YES;
    }

    return NO;
}

@end
