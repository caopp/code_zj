//
//  ChatHistory.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-23.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "ChatHistoryModel.h"

@implementation ChatHistory

-(BOOL)getParameterIsLack
{
    if (self.from == nil || self.to == nil || self.time == nil ){
        
        return YES;
    }
    
    return NO;
}
-(BOOL)IsLackParameter
{
    return  [self getParameterIsLack];
}
@end
