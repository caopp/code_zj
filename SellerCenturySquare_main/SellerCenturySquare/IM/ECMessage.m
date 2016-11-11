//
//  ECMessage.m
//  BuyerCenturySquare
//
//  Created by 王剑粟 on 15/9/14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "ECMessage.h"

@implementation ECMessage


-(void)dealloc {
    
    self.ID = 0;
    self.SID  = nil;
    self.receiver  = nil;    self.sender  = 0;

    self.dateTime = 0;
    self.type  = 0;
    self.text = nil;
    self.localPath = nil;
    self.URL = nil;
    self.goodNo = nil;
    self.isSender = 0;
    self.goodColor = nil;
    self.goodPrice = nil;
    self.goodPic = nil;
    self.goodSku = nil;
    self.searchGoodNo = nil;}

@end
