//
//  LoginDTO.m
//  SellerCenturySquare
//
//  Created by jian.zhou on 15-7-17.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "LoginDTO.h"

@implementation LoginDTO


/**
 *  单例模式
 */
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
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantNo"]]) {
                
                self.merchantNo = [dictInfo objectForKey:@"merchantNo"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"tokenId"]]) {
                
                self.tokenId = [dictInfo objectForKey:@"tokenId"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"merchantAccount"]]) {
                
                self.merchantAccount = [dictInfo objectForKey:@"merchantAccount"];
            }
            
            if ([self checkLegitimacyForData:[dictInfo objectForKey:@"firstLogin"]]) {
                
                self.firstLogin = [dictInfo objectForKey:@"firstLogin"];
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

- (BOOL)loginParameterIsLack
{
    if (self.merchantNo == nil || self.tokenId == nil || self.merchantAccount == nil || self.firstLogin == nil){
        
        return YES;
    }
    
    return NO;
}

@end
