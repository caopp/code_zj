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
    self.sessionType = 0;
    self.goodColor = nil;
    self.goodPrice = nil;
    self.goodPic = nil;
    self.iconUrl = nil;
    self.iconLocalUrl = nil;
}
@end
