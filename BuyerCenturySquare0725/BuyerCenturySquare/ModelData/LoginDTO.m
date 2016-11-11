//
//  LoginDTO.m
//  BuyerCenturySquare
//
//  Created by clz on 15/7/9.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "LoginDTO.h"

@implementation LoginDTO

static LoginDTO *loginInstance = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        
        loginInstance = [[self alloc] init];
    });
    return loginInstance;
}

- (void)setDictFrom:(NSDictionary *)dictInfo{
    
    @try {
        if (self && dictInfo) {
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"tokenId"]]) {
                
                self.tokenId = [dictInfo objectForKey:@"tokenId"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"memberNo"]]) {
                
                self.memberNo = [dictInfo objectForKey:@"memberNo"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"status"]]) {
                
                self.status = [dictInfo objectForKey:@"status"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"refuseContent"]]) {
                
                self.refuseContent = [dictInfo objectForKey:@"refuseContent"];
                
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"loginFlag"]]) {
                
                self.loginFlag = [dictInfo objectForKey:@"loginFlag"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"joinType"]]) {
                
                self.joinType = [dictInfo objectForKey:@"joinType"];
            }
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"isChangeDevice"]]) {
                
                self.isChangeDevice = [dictInfo objectForKey:@"isChangeDevice"];
            }
            
                       
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

- (NSInteger)convertStatusToInteger {
    
    NSInteger status = 0;
    if ([self.status isEqualToString:@"1"]) {
        status = 1;
    } else if ([self.status isEqualToString:@"2"]) {
        status = 2;
    } else if ([self.status isEqualToString:@"3"]) {
        status = 3;
    } else if ([self.status isEqualToString:@"4"]) {
        
        status = 4;
    
    } else if ([self.status isEqualToString:@"5"]) {
        status = 5;
    } else {
        status = 5;
    }
    
    return status;
}

@end
