//
//  ECSession.m
//  CCPiPhoneSDK
//
//  Created by wang ming on 14-12-10.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECSession.h"

@implementation ECSession

- (void)dealloc {
    
    self.goodNo = nil;
    self.sessionId = nil;
    self.dateTime  = 0;
    self.type  = 0;
    self.text  = nil;
    self.unreadCount = 0;
    self.merchantName = nil;
    self.merchantNo = nil;
    self.sessionType = 0;
    self.goodColor = nil;
    self.goodPrice = nil;
    self.goodPic = nil;
    self.iconUrl = nil;
}
-(void)setSessionWithDic:(NSDictionary *)dictInfo{
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodNo"]]) {
                
                self.goodNo = [dictInfo objectForKey:@"goodNo"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"sessionId"]]) {
                
                self.sessionId = [dictInfo objectForKey:@"sessionId"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"dateTime"]]) {
                
                self.dateTime = [[dictInfo objectForKey:@"dateTime"] doubleValue];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"type"]]) {
                
                self.type = [[dictInfo objectForKey:@"type"] intValue];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"text"]]) {
                
                self.text = [dictInfo objectForKey:@"text"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"unreadCount"]]) {
                
                self.unreadCount = [[dictInfo objectForKey:@"unreadCount"] integerValue];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantName"]]) {
                
                self.merchantName = [dictInfo objectForKey:@"merchantName"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantNo"]]) {
                
                self.merchantNo = [dictInfo objectForKey:@"merchantNo"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"sessionType"]]) {
                
                self.sessionType = [dictInfo objectForKey:@"sessionType"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodColor"]]) {
                
                self.goodColor = [dictInfo objectForKey:@"goodColor"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodPrice"]]) {
                
                self.goodPrice = [dictInfo objectForKey:@"goodPrice"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"goodPic"]]) {
                
                self.goodPic = [dictInfo objectForKey:@"goodPic"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"iconUrl"]]) {
                
                self.iconUrl = [dictInfo objectForKey:@"iconUrl"];
            }
            
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

@end
