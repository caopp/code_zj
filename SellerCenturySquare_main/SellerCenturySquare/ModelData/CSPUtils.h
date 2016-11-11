//
//  CSPUtils.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/22/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSPUtils : NSObject

//将时间转化成时间戳 传入的时间格式为NSDate
+ (long long)getTimeStampFromNSDate:(NSDate *)time;

//将时间转化成时间戳 传入的时间格式为yyyy-MM-dd HH:mm:ss
+ (long long)getTimeStamp:(NSString *)time;

//将时间戳转化成时间
+ (NSString *)getTime:(long)timeStamp;

+ (BOOL)isRoundNumber:(float)value;

@end
